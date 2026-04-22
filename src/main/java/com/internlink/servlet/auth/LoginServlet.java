package com.internlink.servlet.auth;

import com.internlink.dao.UserDAO;
import com.internlink.model.User;
import com.internlink.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;


@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String role = req.getParameter("role");
        if (role != null && !role.isBlank()) {
            req.setAttribute("selectedRole", role.trim().toUpperCase());
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
        email = email == null ? "" : email.trim().toLowerCase();
        expectedRole = expectedRole == null ? "" : expectedRole.trim().toUpperCase();

        try {
            User user = userDAO.authenticate(email, password);
            if (user == null) {
                String error = email.contains("@")
                    ? "Invalid email or password."
                    : "Use your registered email address to sign in. Admin demo email: admin@internlink.com.np";
                req.setAttribute("error", error);
                req.getRequestDispatcher("/pages/auth/login.jsp").forward(req, resp);
                return;
            }
            if (!expectedRole.isBlank() && !expectedRole.equals(user.getRole())) {
                req.setAttribute("error", "This account is registered as " + user.getRole() + ", not " + expectedRole + ".");
                req.setAttribute("selectedRole", expectedRole);
                req.setAttribute("enteredEmail", email);
                req.getRequestDispatcher("/pages/auth/login.jsp").forward(req, resp);
                return;
            }
            SessionUtil.invalidate(req);
            SessionUtil.setUser(req, user);
            redirectByRole(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", "Server error. Please try again.");
            req.setAttribute("selectedRole", expectedRole);
            req.setAttribute("enteredEmail", email);
            req.getRequestDispatcher("/pages/auth/login.jsp").forward(req, resp);
        }
    }

    private void redirectByRole(HttpServletRequest req, HttpServletResponse resp) throws IOException {
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
