package com.internlink.servlet.company;

import com.internlink.dao.ApplicationDAO;
import com.internlink.util.SessionUtil;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * UpdateStatusServlet - Company updates an application status.
 * URL: /company/updateStatus  (POST)
 */
@WebServlet("/company/updateStatus")
public class UpdateStatusServlet extends HttpServlet {

    private final ApplicationDAO applicationDAO = new ApplicationDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        if (!SessionUtil.isLoggedIn(req) || !"COMPANY".equals(SessionUtil.getRole(req))) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        try {
            int    appId  = Integer.parseInt(req.getParameter("appId"));
            String status = req.getParameter("status");
            String notes  = req.getParameter("notes");
            applicationDAO.updateStatus(appId, status, notes);
        } catch (Exception e) {
            e.printStackTrace();
        }
        resp.sendRedirect(req.getContextPath() + "/company/dashboard");
    }
}
