package com.internlink.servlet.profiles;

import com.internlink.dao.ApplicationDAO;
import com.internlink.dao.CompanyDAO;
import com.internlink.dao.JobPostingDAO;
import com.internlink.model.Company;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

@WebServlet("/profiles/company")
public class PublicCompanyProfileServlet extends HttpServlet {

    private final CompanyDAO companyDAO = new CompanyDAO();
    private final JobPostingDAO jobDAO = new JobPostingDAO();
    private final ApplicationDAO applicationDAO = new ApplicationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            String id = req.getParameter("id");
            if (id == null || id.isBlank()) {
                resp.sendRedirect(req.getContextPath() + "/companies");
                return;
            }
            Company company = companyDAO.findById(Integer.parseInt(id));
            if (company == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            int companyId = company.getId();
            int fresherCount     = applicationDAO.countByExperienceType(companyId, "FRESHER");
            int internCount      = applicationDAO.countByExperienceType(companyId, "INTERN");
            int experiencedCount = applicationDAO.countByExperienceType(companyId, "EXPERIENCED");
            int internshipJobs   = jobDAO.countByCompanyAndType(companyId, "INTERNSHIP");
            int fullTimeJobs     = jobDAO.countByCompanyAndType(companyId, "FULL_TIME");

            req.setAttribute("company", company);
            req.setAttribute("jobs", jobDAO.findByCompanyId(companyId));
            req.setAttribute("cultureVideoPath", resolveCultureVideo(req, companyId));
            req.setAttribute("fresherCount",     fresherCount);
            req.setAttribute("internCount",      internCount);
            req.setAttribute("experiencedCount", experiencedCount);
            req.setAttribute("internshipJobs",   internshipJobs);
            req.setAttribute("fullTimeJobs",     fullTimeJobs);
            req.getRequestDispatcher("/pages/profiles/company.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException("Unable to load public company profile", e);
        }
    }

    private String resolveCultureVideo(HttpServletRequest req, int companyId) {
        String[] extensions = {".mp4", ".webm", ".ogg"};
        for (String extension : extensions) {
            Path path;
            try {
                path = com.internlink.util.StorageUtil.resolveUpload("uploads/company-videos/company-" + companyId + extension);
            } catch (Exception e) {
                return null;
            }
            if (Files.exists(path)) {
                return "uploads/company-videos/company-" + companyId + extension;
            }
        }
        return null;
    }
}
