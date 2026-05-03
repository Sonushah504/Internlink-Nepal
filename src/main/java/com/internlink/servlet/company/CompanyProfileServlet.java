package com.internlink.servlet.company;

import com.internlink.dao.CompanyDAO;
import com.internlink.model.Company;
import com.internlink.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@WebServlet("/company/profile")
@MultipartConfig(maxFileSize = 50 * 1024 * 1024, maxRequestSize = 55 * 1024 * 1024)
public class CompanyProfileServlet extends HttpServlet {

    private final CompanyDAO companyDAO = new CompanyDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            Company company = companyDAO.findByUserId(SessionUtil.getUserId(req));
            req.setAttribute("company", company);
            req.setAttribute("cultureVideoPath", company == null ? null : resolveCultureVideo(req, company.getId()));
            req.getRequestDispatcher("/pages/company/profile.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException("Unable to load company profile", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            Company company = companyDAO.findByUserId(SessionUtil.getUserId(req));
            if (company == null) {
                company = new Company();
                company.setUserId(SessionUtil.getUserId(req));
                companyDAO.create(bindCompany(req, company));
                company = companyDAO.findByUserId(SessionUtil.getUserId(req));
            } else {
                companyDAO.update(bindCompany(req, company));
            }
            storeCultureVideo(req, company.getId());
            resp.sendRedirect(req.getContextPath() + "/company/profile?success=1");
        } catch (Exception e) {
            throw new ServletException("Unable to save company profile", e);
        }
    }

    private Company bindCompany(HttpServletRequest req, Company company) {
        company.setCompanyName(req.getParameter("companyName"));
        company.setIndustry(req.getParameter("industry"));
        company.setDescription(req.getParameter("description"));
        company.setWebsite(req.getParameter("website"));
        company.setPhone(req.getParameter("phone"));
        company.setAddress(req.getParameter("address"));
        company.setCity(req.getParameter("city"));
        company.setEmployeeCount(req.getParameter("employeeCount"));
        company.setFoundedYear(parseInt(req.getParameter("foundedYear")));
        company.setLatitude(parseDouble(req.getParameter("latitude")));
        company.setLongitude(parseDouble(req.getParameter("longitude")));
        company.setLogoPath(storeCompanyLogo(req, company.getLogoPath()));
        return company;
    }

    private int parseInt(String value) {
        return value == null || value.isBlank() ? 0 : Integer.parseInt(value);
    }

    private double parseDouble(String value) {
        return value == null || value.isBlank() ? 0 : Double.parseDouble(value);
    }

    private void storeCultureVideo(HttpServletRequest req, int companyId) {
        try {
            Part video = req.getPart("cultureVideo");
            if (video == null || video.getSize() == 0) {
                return;
            }
            String contentType = video.getContentType();
            String extension = ".mp4";
            if ("video/webm".equals(contentType)) extension = ".webm";
            if ("video/ogg".equals(contentType)) extension = ".ogg";

            Path target = com.internlink.util.StorageUtil.uploadsPath("company-videos", "company-" + companyId + extension);
            Files.copy(video.getInputStream(), target, StandardCopyOption.REPLACE_EXISTING);
        } catch (Exception ignored) {
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

    private String storeCompanyLogo(HttpServletRequest req, String currentPath) {
        try {
            Part logo = req.getPart("companyLogo");
            if (logo == null || logo.getSize() == 0) {
                return currentPath;
            }

            String submitted = Path.of(logo.getSubmittedFileName()).getFileName().toString();
            String extension = "";
            int dot = submitted.lastIndexOf('.');
            if (dot >= 0) {
                extension = submitted.substring(dot);
            }

            String filename = UUID.randomUUID() + extension;
            Path target = com.internlink.util.StorageUtil.uploadsPath("company_logos", filename);
            Files.copy(logo.getInputStream(), target, StandardCopyOption.REPLACE_EXISTING);
            return com.internlink.util.StorageUtil.webPath("company_logos", filename);
        } catch (Exception e) {
            return currentPath;
        }
    }
}
