package com.internlink.servlet.admin;

import com.internlink.dao.JobPostingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/jobs")
public class AdminJobsServlet extends HttpServlet {

    private final JobPostingDAO jobDAO = new JobPostingDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            req.setAttribute("jobs", jobDAO.findAllActive());
            req.getRequestDispatcher("/pages/admin/jobs.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException("Unable to load jobs", e);
        }
    }
}
