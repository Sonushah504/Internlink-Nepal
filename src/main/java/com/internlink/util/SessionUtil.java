package com.internlink.util;

import com.internlink.model.User;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

/**
 * SessionUtil - Centralizes session attribute handling.
 */
public class SessionUtil {

    public static final String SESSION_USER     = "loggedInUser";
    public static final String SESSION_ROLE     = "userRole";
    public static final String SESSION_USER_ID  = "userId";

    public static void setUser(HttpServletRequest req, User user) {
        HttpSession session = req.getSession(true);
        session.setAttribute(SESSION_USER,    user);
        session.setAttribute(SESSION_ROLE,    user.getRole());
        session.setAttribute(SESSION_USER_ID, user.getId());
    }

    public static User getUser(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) return null;
        return (User) session.getAttribute(SESSION_USER);
    }

    public static String getRole(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) return null;
        return (String) session.getAttribute(SESSION_ROLE);
    }

    public static Integer getUserId(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) return null;
        return (Integer) session.getAttribute(SESSION_USER_ID);
    }

    public static boolean isLoggedIn(HttpServletRequest req) {
        return getUser(req) != null;
    }

    public static void invalidate(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session != null) session.invalidate();
    }
}
