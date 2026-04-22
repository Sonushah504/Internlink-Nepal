package com.internlink.servlet;

import com.internlink.dao.JobPostingDAO;
import com.internlink.model.JobPosting;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/jobs")
public class BrowseJobsServlet extends HttpServlet {

    private final JobPostingDAO jobDAO = new JobPostingDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String q = req.getParameter("q");
        String type = req.getParameter("type");
        String exp = req.getParameter("exp");
        String idParam = req.getParameter("id");

        try {
            List<JobPosting> jobs = jobDAO.search(q, type, exp);
            JobPosting selectedJob = null;
            if (idParam != null && !idParam.isBlank()) {
                selectedJob = jobDAO.findById(Integer.parseInt(idParam));
            }
            if (selectedJob == null && !jobs.isEmpty() && q != null && !q.isBlank()) {
                selectedJob = jobs.get(0);
            }

            req.setAttribute("jobs", jobs);
            req.setAttribute("selectedJob", selectedJob);
            req.setAttribute("q", q);
            req.setAttribute("type", type);
            req.setAttribute("exp", exp);
            req.getRequestDispatcher("/pages/jobs.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException("Unable to load jobs", e);
        }
    }
}
