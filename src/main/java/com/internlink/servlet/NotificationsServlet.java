package com.internlink.servlet;

import com.internlink.dao.NotificationDAO;
import com.internlink.model.Notification;
import com.internlink.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/notifications", "/notifications/page"})
public class NotificationsServlet extends HttpServlet {

    private final NotificationDAO ndao = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Integer userId = SessionUtil.getUserId(req);
        if (userId == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }
        try {
            List<Notification> notes = ndao.findRecent(userId, 50);
            req.setAttribute("notifications", notes);
            req.getRequestDispatcher("/pages/notifications.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException("Unable to load notifications", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Integer userId = SessionUtil.getUserId(req);
        if (userId == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }
        String action = req.getParameter("action");
        try {
            if ("markAllRead".equals(action)) ndao.markAllRead(userId);
            String referer = req.getHeader("Referer");
            if (referer != null && !referer.isBlank()) {
                resp.sendRedirect(referer);
            } else {
                resp.sendRedirect(req.getContextPath() + "/notifications");
            }
        } catch (Exception e) {
            throw new ServletException("Unable to update notifications", e);
        }
    }
}
