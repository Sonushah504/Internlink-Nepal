package com.internlink.servlet.student;

import com.internlink.dao.ApplicationDAO;
import com.internlink.dao.JobPostingDAO;
import com.internlink.dao.StudentPostDAO;
import com.internlink.dao.StudentProfileDAO;
import com.internlink.model.StudentProfile;
import com.internlink.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * StudentDashboardServlet - URL: /student/dashboard
 */
@WebServlet("/student/dashboard")
public class StudentDashboardServlet extends HttpServlet {

    private final StudentProfileDAO studentProfileDAO = new StudentProfileDAO();
    private final ApplicationDAO    applicationDAO    = new ApplicationDAO();
    private final JobPostingDAO     jobPostingDAO     = new JobPostingDAO();
    private final StudentPostDAO    postDAO           = new StudentPostDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!SessionUtil.isLoggedIn(req) || !"STUDENT".equals(SessionUtil.getRole(req))) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int userId = SessionUtil.getUserId(req);

        try {
            StudentProfile profile = studentProfileDAO.findByUserId(userId);
            if (profile == null) {
                resp.sendRedirect(req.getContextPath() + "/student/profile");
                return;
            }

            var applications  = applicationDAO.findByStudentId(profile.getId());
            var recommended   = jobPostingDAO.searchBySkills(profile.getSkills(), 5);

            long pending      = applications.stream().filter(a -> "PENDING".equals(a.getStatus()) || "REVIEWING".equals(a.getStatus())).count();
            long shortlisted  = applications.stream().filter(a -> "SHORTLISTED".equals(a.getStatus())).count();
            long selected     = applications.stream().filter(a -> "SELECTED".equals(a.getStatus())).count();

            req.setAttribute("profile",      profile);
            req.setAttribute("applications", applications);
            req.setAttribute("recommended",  recommended);
            req.setAttribute("pending",      pending);
            req.setAttribute("shortlisted",  shortlisted);
            req.setAttribute("selected",     selected);
            req.setAttribute("relatedProfiles", studentProfileDAO.findRelatedProfiles(userId, profile.getProgram(), profile.getUniversity(), profile.getExperienceType(), 6));
            req.setAttribute("posts", postDAO.findAll());

            req.getRequestDispatcher("/pages/student/dashboard.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException("Error loading student dashboard", e);
        }
    }
}
