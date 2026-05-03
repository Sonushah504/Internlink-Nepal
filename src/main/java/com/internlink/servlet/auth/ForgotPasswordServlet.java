package com.internlink.servlet.auth;

import com.internlink.dao.PasswordResetDAO;
import com.internlink.dao.UserDAO;
import com.internlink.model.User;
import com.internlink.util.EmailService;
import com.internlink.util.InternlinkConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.security.SecureRandom;
import java.sql.Timestamp;
import java.time.Instant;
import java.time.temporal.ChronoUnit;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    public static final String SESS_FORGOT_UID = "forgotPwdUserId";
    public static final String SESS_FORGOT_EMAIL = "forgotPwdEmail";

    private final UserDAO userDAO = new UserDAO();
    private final PasswordResetDAO resetDAO = new PasswordResetDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String step = req.getParameter("step");
        if ("verify".equals(step)) {
            HttpSession session = req.getSession(false);
            if (session == null || session.getAttribute(SESS_FORGOT_UID) == null) {
                resp.sendRedirect(req.getContextPath() + "/forgot-password");
                return;
            }
            req.getRequestDispatcher("/pages/auth/forgot-password-verify.jsp").forward(req, resp);
            return;
        }
        req.getRequestDispatcher("/pages/auth/forgot-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("send".equals(action)) {
            handleSend(req, resp);
            return;
        }
        if ("reset".equals(action)) {
            handleReset(req, resp);
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/forgot-password");
    }

    private void handleSend(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        email = email == null ? "" : email.trim().toLowerCase();

        try {
            if (!resetDAO.tableExists()) {
                req.setAttribute("error", "Password reset is not available: run the latest database migration (password_reset_otps table).");
                req.getRequestDispatcher("/pages/auth/forgot-password.jsp").forward(req, resp);
                return;
            }

            User user = userDAO.findByEmail(email);
            if (user == null || !user.isActive()) {
                // Do not reveal whether the address is registered
                req.setAttribute("success",
                        "If that email is registered with InternLink Nepal, you will receive a verification code shortly.");
                req.getRequestDispatcher("/pages/auth/forgot-password.jsp").forward(req, resp);
                return;
            }

            if (!InternlinkConfig.isMailConfigured()) {
                req.setAttribute("error", "Email delivery is not configured. Ask your administrator to set mail.smtp.* in internlink.properties.");
                req.getRequestDispatcher("/pages/auth/forgot-password.jsp").forward(req, resp);
                return;
            }

            String otp = String.format("%06d", new SecureRandom().nextInt(1_000_000));
            Timestamp exp = Timestamp.from(Instant.now().plus(15, ChronoUnit.MINUTES));
            resetDAO.insertOtp(user.getId(), otp, exp);

            String provider = user.getAuthProvider() != null ? user.getAuthProvider() : "LOCAL";
            String delivery = switch (provider) {
                case "GOOGLE" -> "This message is sent to the email used with your Google sign-in on InternLink Nepal.";
                case "FACEBOOK" -> "This message is sent to the email linked to your Facebook sign-in on InternLink Nepal.";
                default -> "This message is sent to your registered email address for InternLink Nepal.";
            };

            try {
                EmailService.sendPasswordResetOtp(email, otp, delivery);
            } catch (Exception ex) {
                req.setAttribute("error", "We could not send the email. Check SMTP settings: " + ex.getMessage());
                req.getRequestDispatcher("/pages/auth/forgot-password.jsp").forward(req, resp);
                return;
            }

            HttpSession session = req.getSession(true);
            session.setAttribute(SESS_FORGOT_UID, user.getId());
            session.setAttribute(SESS_FORGOT_EMAIL, email);

            resp.sendRedirect(req.getContextPath() + "/forgot-password?step=verify");
        } catch (Exception e) {
            req.setAttribute("error", "Something went wrong. Please try again.");
            req.getRequestDispatcher("/pages/auth/forgot-password.jsp").forward(req, resp);
        }
    }

    private void handleReset(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/forgot-password");
            return;
        }
        Integer userId = (Integer) session.getAttribute(SESS_FORGOT_UID);
        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/forgot-password");
            return;
        }

        String otp = req.getParameter("otp");
        String pw = req.getParameter("newPassword");
        String pw2 = req.getParameter("confirmPassword");

        if (otp == null || pw == null || pw2 == null || !pw.equals(pw2)) {
            req.setAttribute("error", "Passwords must match and OTP is required.");
            req.getRequestDispatcher("/pages/auth/forgot-password-verify.jsp").forward(req, resp);
            return;
        }
        if (pw.length() < 6) {
            req.setAttribute("error", "Password must be at least 6 characters.");
            req.getRequestDispatcher("/pages/auth/forgot-password-verify.jsp").forward(req, resp);
            return;
        }

        try {
            if (!resetDAO.verifyAndConsume(userId, otp.trim())) {
                req.setAttribute("error", "Invalid or expired verification code.");
                req.getRequestDispatcher("/pages/auth/forgot-password-verify.jsp").forward(req, resp);
                return;
            }
            userDAO.updatePasswordHash(userId, pw);
            session.removeAttribute(SESS_FORGOT_UID);
            session.removeAttribute(SESS_FORGOT_EMAIL);

            req.setAttribute("success", "Your password has been updated. Sign in with your new password.");
            req.getRequestDispatcher("/pages/auth/login.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", "Could not reset password. Try again.");
            req.getRequestDispatcher("/pages/auth/forgot-password-verify.jsp").forward(req, resp);
        }
    }
}
