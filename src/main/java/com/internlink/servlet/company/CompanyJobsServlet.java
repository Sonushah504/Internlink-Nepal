package com.internlink.servlet.company;

import com.internlink.dao.CompanyDAO;
import com.internlink.dao.JobPostingDAO;
import com.internlink.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/company/jobs")
public class CompanyJobsServlet extends HttpServlet {

    private final CompanyDAO companyDAO = new CompanyDAO();
    private final JobPostingDAO jobDAO = new JobPostingDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            var company = companyDAO.findByUserId(SessionUtil.getUserId(req));
            req.setAttribute("company", company);
            req.setAttribute("jobs", company == null ? java.util.List.of() : jobDAO.findByCompanyId(company.getId()));
            req.getRequestDispatcher("/pages/company/jobs.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException("Unable to load company jobs", e);
        }
    }
}
