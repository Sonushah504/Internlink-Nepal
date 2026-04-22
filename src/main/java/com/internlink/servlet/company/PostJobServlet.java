package com.internlink.servlet.company;

import com.internlink.dao.CompanyDAO;
import com.internlink.dao.JobPostingDAO;
import com.internlink.model.Company;
import com.internlink.model.JobPosting;
import com.internlink.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.time.LocalDate;

/**
 * PostJobServlet - GET shows the form, POST saves a new job posting.
 * URL: /company/postJob
 */
@WebServlet("/company/postJob")
public class PostJobServlet extends HttpServlet {

    private final CompanyDAO    companyDAO = new CompanyDAO();
    private final JobPostingDAO jobDAO     = new JobPostingDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/pages/company/postJob.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int userId = SessionUtil.getUserId(req);
        try {
            Company co = companyDAO.findByUserId(userId);
            if (co == null) { resp.sendRedirect(req.getContextPath() + "/company/dashboard"); return; }

            JobPosting jp = new JobPosting();
            jp.setCompanyId(co.getId());
            jp.setTitle(req.getParameter("title"));
            jp.setDescription(req.getParameter("description"));
            jp.setRequirements(req.getParameter("requirements"));
            jp.setSkillsRequired(req.getParameter("skillsRequired"));
            jp.setJobType(req.getParameter("jobType"));
            jp.setExperienceRequired(req.getParameter("experienceRequired"));
            String cgpa = req.getParameter("minCgpa");
            jp.setMinCgpa(cgpa != null && !cgpa.isBlank() ? Double.parseDouble(cgpa) : 0);
            jp.setLocation(req.getParameter("location"));
            jp.setSalaryRange(req.getParameter("salaryRange"));
            jp.setDeadline(LocalDate.parse(req.getParameter("deadline")));

            int jobId = jobDAO.create(jp);
            try {
                // notify students and admins about new job
                String title = "New job posted: " + jp.getTitle();
                String message = co.getCompanyName() + " posted a new " + jp.getJobType() + " position.";
                String targetPath = "/profiles/company?id=" + co.getId();
                new com.internlink.dao.NotificationDAO().createForAllUsers(title, message, targetPath);
            } catch (Exception ignored) {}

            resp.sendRedirect(req.getContextPath() + "/company/dashboard?success=Job+posted+successfully");
        } catch (Exception e) {
            req.setAttribute("error", "Failed to post job: " + e.getMessage());
            req.getRequestDispatcher("/pages/company/postJob.jsp").forward(req, resp);
        }
    }
}
