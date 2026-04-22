package com.internlink.servlet.student;

import com.internlink.dao.StudentProfileDAO;
import com.internlink.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/student/portfolio")
public class StudentPortfolioServlet extends HttpServlet {

    private final StudentProfileDAO profileDAO = new StudentProfileDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            req.setAttribute("profile", profileDAO.findByUserId(SessionUtil.getUserId(req)));
            req.getRequestDispatcher("/pages/student/portfolio.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException("Unable to load portfolio", e);
        }
    }
}
