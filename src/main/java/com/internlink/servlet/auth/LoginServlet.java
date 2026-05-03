package com.internlink.servlet.auth;

import com.internlink.dao.StudentProfileDAO;
import com.internlink.dao.UserDAO;
import com.internlink.model.StudentProfile;
import com.internlink.model.User;
import com.internlink.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;


@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final String REMEMBER_ROLE_COOKIE = "iln_remember_role";

    private final UserDAO userDAO = new UserDAO();
    private final StudentProfileDAO studentProfileDAO = new StudentProfileDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String role = req.getParameter("role");
        if (role != null && !role.isBlank()) {
            req.setAttribute("selectedRole", role.trim().toUpperCase());
        } else {
            String remembered = readRememberedRole(req);
            if (remembered != null) {
                req.setAttribute("selectedRole", remembered);
                req.setAttribute("rememberMe", Boolean.TRUE);
            }
        }
        if (SessionUtil.isLoggedIn(req)) {
            User currentUser = SessionUtil.getUser(req);
            if (currentUser != null) {
                req.setAttribute("success", "You are already signed in as " + currentUser.getEmail() + ". Sign in again below to switch accounts.");
            }
        }
        req.getRequestDispatcher("/pages/auth/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String email    = req.getParameter("email");
        String password = req.getParameter("password");
        String expectedRole = req.getParameter("role");
        boolean rememberMe = "on".equalsIgnoreCase(req.getParameter("rememberMe"))
                || "true".equalsIgnoreCase(req.getParameter("rememberMe"));
        email = email == null ? "" : email.trim().toLowerCase();
        expectedRole = expectedRole == null ? "" : expectedRole.trim().toUpperCase();

        try {
            User user = userDAO.authenticate(email, password);
            if (user == null) {
                String error = email.contains("@")
                    ? "Invalid email or password."
                    : "Use your registered email address to sign in. Admin demo email: admin@internlink.com.np";
                req.setAttribute("error", error);
                req.setAttribute("rememberMe", rememberMe);
                req.getRequestDispatcher("/pages/auth/login.jsp").forward(req, resp);
                return;
            }
            if (!expectedRole.isBlank() && !expectedRole.equals(user.getRole())) {
                req.setAttribute("error", "This account is registered as " + user.getRole() + ", not " + expectedRole + ".");
                req.setAttribute("selectedRole", expectedRole);
                req.setAttribute("enteredEmail", email);
                req.setAttribute("rememberMe", rememberMe);
                req.getRequestDispatcher("/pages/auth/login.jsp").forward(req, resp);
                return;
            }
            enrichSessionPhoto(user);
            SessionUtil.invalidate(req);
            SessionUtil.setUser(req, user);
            if (rememberMe && !expectedRole.isBlank()) {
                applyRememberRoleCookie(req, resp, expectedRole);
            } else {
                clearRememberRoleCookie(req, resp);
            }
            redirectByRole(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", "Server error. Please try again.");
            req.setAttribute("selectedRole", expectedRole);
            req.setAttribute("enteredEmail", email);
            req.setAttribute("rememberMe", rememberMe);
            req.getRequestDispatcher("/pages/auth/login.jsp").forward(req, resp);
        }
    }

    private static String readRememberedRole(HttpServletRequest req) {
        Cookie[] cookies = req.getCookies();
        if (cookies == null) {
            return null;
        }
        for (Cookie c : cookies) {
            if (REMEMBER_ROLE_COOKIE.equals(c.getName())) {
                String v = c.getValue();
                if (v == null || v.isBlank()) {
                    return null;
                }
                v = v.trim().toUpperCase();
                if ("STUDENT".equals(v) || "COMPANY".equals(v) || "ADMIN".equals(v)) {
                    return v;
                }
            }
        }
        return null;
    }

    private static void applyRememberRoleCookie(HttpServletRequest req, HttpServletResponse resp, String role) {
        Cookie c = new Cookie(REMEMBER_ROLE_COOKIE, role);
        String path = req.getContextPath();
        if (path == null || path.isEmpty()) {
            path = "/";
        }
        c.setPath(path);
        c.setMaxAge(60 * 60 * 24 * 400);
        c.setHttpOnly(true);
        if (req.isSecure()) {
            c.setSecure(true);
        }
        resp.addCookie(c);
    }

    private static void clearRememberRoleCookie(HttpServletRequest req, HttpServletResponse resp) {
        Cookie c = new Cookie(REMEMBER_ROLE_COOKIE, "");
        String path = req.getContextPath();
        if (path == null || path.isEmpty()) {
            path = "/";
        }
        c.setPath(path);
        c.setMaxAge(0);
        resp.addCookie(c);
    }

    private void enrichSessionPhoto(User user) {
        if (user == null || user.getProfilePhoto() != null || !"STUDENT".equals(user.getRole())) {
            return;
        }
        try {
            StudentProfile profile = studentProfileDAO.findByUserId(user.getId());
            if (profile != null) {
                user.setProfilePhoto(profile.getProfilePhoto());
            }
        } catch (Exception ignored) {
        }
    }

    private void redirectByRole(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        redirectByRoleStatic(req, resp);
    }

    public static void redirectByRoleStatic(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String role = SessionUtil.getRole(req);
        if (role == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        switch (role) {
            case "ADMIN"   -> resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            case "COMPANY" -> resp.sendRedirect(req.getContextPath() + "/company/dashboard");
            default        -> resp.sendRedirect(req.getContextPath() + "/student/dashboard");
        }
    }
}
