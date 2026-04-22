package com.internlink.servlet.student;

import com.internlink.dao.ApplicationDAO;
import com.internlink.dao.StudentProfileDAO;
import com.internlink.model.StudentProfile;
import com.internlink.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/student/applications")
public class StudentApplicationsServlet extends HttpServlet {

    private final StudentProfileDAO profileDAO = new StudentProfileDAO();
    private final ApplicationDAO applicationDAO = new ApplicationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            StudentProfile profile = profileDAO.findByUserId(SessionUtil.getUserId(req));
            req.setAttribute("profile", profile);
            req.setAttribute("applications", profile == null ? java.util.List.of() : applicationDAO.findByStudentId(profile.getId()));
            req.getRequestDispatcher("/pages/student/applications.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException("Unable to load student applications", e);
        }
    }
}
