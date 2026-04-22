package com.internlink.servlet.admin;

import com.internlink.dao.StudentProfileDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/students")
public class AdminStudentsServlet extends HttpServlet {

    private final StudentProfileDAO profileDAO = new StudentProfileDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            req.setAttribute("students", profileDAO.findAll());
            req.getRequestDispatcher("/pages/admin/students.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException("Unable to load students", e);
        }
    }
}
