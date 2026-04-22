package com.internlink.servlet.admin;

import com.internlink.dao.*;
import com.internlink.model.Company;
import com.internlink.model.JobPosting;
import com.internlink.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;


@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private final CompanyDAO        companyDAO = new CompanyDAO();
    private final StudentProfileDAO profileDAO = new StudentProfileDAO();
    private final JobPostingDAO     jobDAO     = new JobPostingDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!SessionUtil.isLoggedIn(req) || !"ADMIN".equals(SessionUtil.getRole(req))) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            List<Company>    companies   = companyDAO.findAll();
            List<JobPosting> jobs        = jobDAO.findAllActive();

            int totalStudents    = profileDAO.countByExperienceType("FRESHER")
                                 + profileDAO.countByExperienceType("INTERN")
                                 + profileDAO.countByExperienceType("EXPERIENCED");
            int totalFreshers    = profileDAO.countByExperienceType("FRESHER");
            int totalInterns     = profileDAO.countByExperienceType("INTERN");
            int totalExperienced = profileDAO.countByExperienceType("EXPERIENCED");
            int totalCompanies   = companies.size();
            int verifiedCos      = (int) companies.stream().filter(Company::isVerified).count();
            int pendingCos       = totalCompanies - verifiedCos;

            req.setAttribute("companies",       companies);
            req.setAttribute("jobs",            jobs);
            req.setAttribute("totalStudents",   totalStudents);
            req.setAttribute("totalFreshers",   totalFreshers);
            req.setAttribute("totalInterns",    totalInterns);
            req.setAttribute("totalExperienced",totalExperienced);
            req.setAttribute("totalCompanies",  totalCompanies);
            req.setAttribute("verifiedCos",     verifiedCos);
            req.setAttribute("pendingCos",      pendingCos);
            req.setAttribute("totalJobs",       jobs.size());

            req.getRequestDispatcher("/pages/admin/dashboard.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException("Admin dashboard error", e);
        }
    }
}
