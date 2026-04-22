package com.internlink.servlet;

import com.internlink.dao.CompanyDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/companies")
public class CompaniesServlet extends HttpServlet {

    private final CompanyDAO companyDAO = new CompanyDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            req.setAttribute("companies", companyDAO.findVerified());
            req.getRequestDispatcher("/pages/companies.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException("Unable to load companies", e);
        }
    }
}
