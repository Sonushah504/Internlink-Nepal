package com.internlink.servlet.admin;

import com.internlink.dao.CompanyDAO;
import com.internlink.util.SessionUtil;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * AdminVerifyCompanyServlet - Admin verifies or revokes a company.
 * URL: /admin/verifyCompany  (POST)
 */
@WebServlet("/admin/verifyCompany")
public class AdminVerifyCompanyServlet extends HttpServlet {

    private final CompanyDAO companyDAO = new CompanyDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        if (!SessionUtil.isLoggedIn(req) || !"ADMIN".equals(SessionUtil.getRole(req))) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        try {
            int    companyId = Integer.parseInt(req.getParameter("companyId"));
            String action    = req.getParameter("action");
            companyDAO.setVerified(companyId, "VERIFY".equals(action));
        } catch (Exception e) {
            e.printStackTrace();
        }
        resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
    }
}
