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

@WebServlet("/notifications/open")
public class NotificationOpenServlet extends HttpServlet {

    private final NotificationDAO notificationDAO = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Integer userId = SessionUtil.getUserId(req);
        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            int notificationId = Integer.parseInt(req.getParameter("id"));
            Notification notification = notificationDAO.findByIdForUser(notificationId, userId);
            if (notification == null) {
                resp.sendRedirect(req.getContextPath() + "/notifications");
                return;
            }

            notificationDAO.markRead(notificationId, userId);
            String targetPath = notification.getTargetPath();
            if (targetPath != null && !targetPath.isBlank()) {
                resp.sendRedirect(req.getContextPath() + targetPath);
                return;
            }
            resp.sendRedirect(req.getContextPath() + "/notifications");
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/notifications");
        } catch (Exception e) {
            throw new ServletException("Unable to open notification", e);
        }
    }
}
