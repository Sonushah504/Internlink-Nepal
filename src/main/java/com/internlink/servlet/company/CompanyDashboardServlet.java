package com.internlink.servlet.company;

import com.internlink.dao.ApplicationDAO;
import com.internlink.dao.CompanyDAO;
import com.internlink.dao.JobPostingDAO;
import com.internlink.model.Application;
import com.internlink.model.Company;
import com.internlink.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

/**
 * CompanyDashboardServlet - Loads data for the company dashboard.
 * URL: /company/dashboard
 */
@WebServlet("/company/dashboard")
public class CompanyDashboardServlet extends HttpServlet {

    private final CompanyDAO     companyDAO     = new CompanyDAO();
    private final JobPostingDAO  jobPostingDAO  = new JobPostingDAO();
    private final ApplicationDAO applicationDAO = new ApplicationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Auth guard
        if (!SessionUtil.isLoggedIn(req) || !"COMPANY".equals(SessionUtil.getRole(req))) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int userId = SessionUtil.getUserId(req);

        try {
            Company company = companyDAO.findByUserId(userId);
            if (company == null) {
                resp.sendRedirect(req.getContextPath() + "/company/profile");
                return;
            }

            int companyId = company.getId();

            // Stats
            int totalJobs       = jobPostingDAO.countByCompany(companyId);
            int totalApplicants = applicationDAO.countByCompanyAndStatus(companyId, "PENDING")
                                + applicationDAO.countByCompanyAndStatus(companyId, "REVIEWING")
                                + applicationDAO.countByCompanyAndStatus(companyId, "SHORTLISTED")
                                + applicationDAO.countByCompanyAndStatus(companyId, "SELECTED")
                                + applicationDAO.countByCompanyAndStatus(companyId, "REJECTED");
            int shortlisted     = applicationDAO.countByCompanyAndStatus(companyId, "SHORTLISTED");
            int selected        = applicationDAO.countByCompanyAndStatus(companyId, "SELECTED");

            // Experience breakdown
            int fresherCount     = applicationDAO.countByExperienceType(companyId, "FRESHER");
            int internCount      = applicationDAO.countByExperienceType(companyId, "INTERN");
            int experiencedCount = applicationDAO.countByExperienceType(companyId, "EXPERIENCED");
            int internshipJobs   = jobPostingDAO.countByCompanyAndType(companyId, "INTERNSHIP");
            int fullTimeJobs     = jobPostingDAO.countByCompanyAndType(companyId, "FULL_TIME");
            int partTimeJobs     = jobPostingDAO.countByCompanyAndType(companyId, "PART_TIME");
            int remoteJobs       = jobPostingDAO.countByCompanyAndType(companyId, "REMOTE");

            // All applications with filter support
            String filterExp = req.getParameter("expFilter");
            String filterStatus = req.getParameter("statusFilter");
            List<Application> applications = applicationDAO.findByCompanyId(companyId);

            // Apply in-memory filters
            if (filterExp != null && !filterExp.isBlank()) {
                applications = applications.stream()
                    .filter(a -> filterExp.equalsIgnoreCase(a.getStudentExperienceType()))
                    .toList();
            }
            if (filterStatus != null && !filterStatus.isBlank()) {
                applications = applications.stream()
                    .filter(a -> filterStatus.equalsIgnoreCase(a.getStatus()))
                    .toList();
            }

            req.setAttribute("company",          company);
            req.setAttribute("totalJobs",         totalJobs);
            req.setAttribute("totalApplicants",   totalApplicants);
            req.setAttribute("shortlisted",       shortlisted);
            req.setAttribute("selected",          selected);
            req.setAttribute("fresherCount",      fresherCount);
            req.setAttribute("internCount",       internCount);
            req.setAttribute("experiencedCount",  experiencedCount);
            req.setAttribute("internshipJobs",    internshipJobs);
            req.setAttribute("fullTimeJobs",      fullTimeJobs);
            req.setAttribute("partTimeJobs",      partTimeJobs);
            req.setAttribute("remoteJobs",        remoteJobs);
            req.setAttribute("applications",      applications);
            req.setAttribute("filterExp",         filterExp);
            req.setAttribute("filterStatus",      filterStatus);
            req.setAttribute("cultureVideoPath",  resolveCultureVideo(req, companyId));

            req.getRequestDispatcher("/pages/company/dashboard.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException("Error loading company dashboard", e);
        }
    }

    private String resolveCultureVideo(HttpServletRequest req, int companyId) {
        String[] extensions = {".mp4", ".webm", ".ogg"};
        for (String extension : extensions) {
            Path path = Paths.get(req.getServletContext().getRealPath("/uploads/company-videos/company-" + companyId + extension));
            if (Files.exists(path)) {
                return "uploads/company-videos/company-" + companyId + extension;
            }
        }
        return null;
    }
}
