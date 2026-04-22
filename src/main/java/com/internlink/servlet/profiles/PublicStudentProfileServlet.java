package com.internlink.servlet.profiles;

import com.internlink.dao.ApplicationDAO;
import com.internlink.dao.StudentProfileDAO;
import com.internlink.model.StudentProfile;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/profiles/student")
public class PublicStudentProfileServlet extends HttpServlet {

    private final StudentProfileDAO profileDAO = new StudentProfileDAO();
    private final ApplicationDAO applicationDAO = new ApplicationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            String id = req.getParameter("id");
            if (id == null || id.isBlank()) {
                resp.sendRedirect(req.getContextPath() + "/");
                return;
            }

            StudentProfile profile = profileDAO.findById(Integer.parseInt(id));
            if (profile == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            req.setAttribute("profile", profile);
            req.setAttribute("applications", applicationDAO.findByStudentId(profile.getId()));
            req.setAttribute("relatedProfiles", profileDAO.findRelatedProfiles(profile.getUserId(), profile.getProgram(), profile.getUniversity(), profile.getExperienceType(), 6));
            req.getRequestDispatcher("/pages/profiles/student.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException("Unable to load public student profile", e);
        }
    }
}
