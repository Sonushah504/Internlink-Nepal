package com.internlink.servlet;

import com.internlink.dao.CompanyDAO;
import com.internlink.dao.JobPostingDAO;
import com.internlink.model.Company;
import com.internlink.model.JobPosting;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;


@WebServlet("")
public class HomeServlet extends HttpServlet {

    private final JobPostingDAO jobDAO     = new JobPostingDAO();
    private final CompanyDAO    companyDAO = new CompanyDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            List<JobPosting> latestJobs    = jobDAO.findAllActive().stream().limit(6).toList();
            List<Company>    companies     = companyDAO.findVerified().stream().limit(6).toList();
            req.setAttribute("latestJobs", latestJobs);
            req.setAttribute("companies",  companies);
        } catch (Exception e) {
            // Show page without DB data on error
        }
        req.getRequestDispatcher("/pages/home.jsp").forward(req, resp);
    }
}
