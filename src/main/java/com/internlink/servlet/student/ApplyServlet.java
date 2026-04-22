package com.internlink.servlet.student;

import com.internlink.dao.ApplicationDAO;
import com.internlink.dao.StudentProfileDAO;
import com.internlink.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/student/apply")
public class ApplyServlet extends HttpServlet {

    private final ApplicationDAO applicationDAO = new ApplicationDAO();
    private final StudentProfileDAO profileDAO = new StudentProfileDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!SessionUtil.isLoggedIn(req) || !"STUDENT".equals(SessionUtil.getRole(req))) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        try {
            int jobId = Integer.parseInt(req.getParameter("jobId"));
            var profile = profileDAO.findByUserId(SessionUtil.getUserId(req));
            if (profile == null) {
                resp.sendRedirect(req.getContextPath() + "/student/profile");
                return;
            }
            boolean ok = applicationDAO.apply(profile.getId(), jobId, null);
            if (ok) {
                resp.sendRedirect(req.getContextPath() + "/student/dashboard?applied=1");
            } else {
                // already applied or failed
                resp.sendRedirect(req.getContextPath() + "/student/dashboard?error=already_applied");
            }
        } catch (Exception e) {
            // log and redirect with error instead of throwing 500
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/student/dashboard?error=server_error");
        }
    }
}
