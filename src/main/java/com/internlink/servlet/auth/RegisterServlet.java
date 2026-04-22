package com.internlink.servlet.auth;

import com.internlink.dao.CompanyDAO;
import com.internlink.dao.StudentProfileDAO;
import com.internlink.dao.UserDAO;
import com.internlink.model.Company;
import com.internlink.model.StudentProfile;
import com.internlink.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * RegisterServlet - Handles new user registration for both STUDENT and COMPANY roles.
 * URL: /register
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final UserDAO           userDAO     = new UserDAO();
    private final StudentProfileDAO profileDAO  = new StudentProfileDAO();
    private final CompanyDAO        companyDAO  = new CompanyDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (SessionUtil.isLoggedIn(req)) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }
        req.getRequestDispatcher("/pages/auth/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String role     = req.getParameter("role");      // STUDENT or COMPANY
        String email    = req.getParameter("email");
        String password = req.getParameter("password");
        String confirm  = req.getParameter("confirmPassword");

        // Basic validation
        if (!password.equals(confirm)) {
            req.setAttribute("error", "Passwords do not match.");
            req.getRequestDispatcher("/pages/auth/register.jsp").forward(req, resp);
            return;
        }

        try {
            if (userDAO.emailExists(email)) {
                req.setAttribute("error", "An account with this email already exists.");
                req.getRequestDispatcher("/pages/auth/register.jsp").forward(req, resp);
                return;
            }

            int userId = userDAO.create(email, password, role);
            if (userId == -1) throw new Exception("Failed to create user account.");

            if ("STUDENT".equals(role)) {
                StudentProfile sp = new StudentProfile();
                sp.setUserId(userId);
                sp.setFullName(req.getParameter("fullName"));
                sp.setPhone(req.getParameter("phone"));
                sp.setUniversity(req.getParameter("university"));
                sp.setProgram(req.getParameter("program"));
                sp.setSemester(Integer.parseInt(req.getParameter("semester")));
                sp.setCgpa(Double.parseDouble(req.getParameter("cgpa")));
                sp.setSkills(req.getParameter("skills"));
                sp.setExperienceType("FRESHER");
                sp.setBio(req.getParameter("bio"));
                profileDAO.create(sp);

            } else if ("COMPANY".equals(role)) {
                Company co = new Company();
                co.setUserId(userId);
                co.setCompanyName(req.getParameter("companyName"));
                co.setIndustry(req.getParameter("industry"));
                co.setDescription(req.getParameter("description"));
                co.setWebsite(req.getParameter("website"));
                co.setPhone(req.getParameter("phone"));
                co.setAddress(req.getParameter("address"));
                co.setCity(req.getParameter("city"));
                String lat = req.getParameter("latitude");
                String lng = req.getParameter("longitude");
                co.setLatitude(lat != null && !lat.isBlank() ? Double.parseDouble(lat) : 0);
                co.setLongitude(lng != null && !lng.isBlank() ? Double.parseDouble(lng) : 0);
                co.setEmployeeCount(req.getParameter("employeeCount"));
                String fy = req.getParameter("foundedYear");
                co.setFoundedYear(fy != null && !fy.isBlank() ? Integer.parseInt(fy) : 0);
                companyDAO.create(co);
            }

            req.setAttribute("success", "Account created successfully! Please login.");
            req.getRequestDispatcher("/pages/auth/login.jsp").forward(req, resp);

        } catch (Exception e) {
            req.setAttribute("error", "Registration failed: " + e.getMessage());
            req.getRequestDispatcher("/pages/auth/register.jsp").forward(req, resp);
        }
    }
}
