package com.internlink.servlet.student;

import com.internlink.dao.StudentProfileDAO;
import com.internlink.dao.UserDAO;
import com.internlink.model.StudentProfile;
import com.internlink.model.User;
import com.internlink.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@WebServlet(name="/studentProfile",urlPatterns = "/student/profile")
@MultipartConfig(maxFileSize = 5 * 1024 * 1024, maxRequestSize = 6 * 1024 * 1024)
public class StudentProfileServlet extends HttpServlet {

    private final StudentProfileDAO profileDAO = new StudentProfileDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            StudentProfile profile = profileDAO.findByUserId(SessionUtil.getUserId(req));
            if (profile == null) {
                profile = new StudentProfile();
            } else {
                req.setAttribute("relatedProfiles", profileDAO.findRelatedProfiles(profile.getUserId(), profile.getProgram(), profile.getUniversity(), profile.getExperienceType(), 6));
            }
            req.setAttribute("profile", profile);
            req.getRequestDispatcher("/pages/student/profile.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException("Unable to load student profile", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int userId = SessionUtil.getUserId(req);
            StudentProfile existingProfile = profileDAO.findByUserId(userId);

            if ("1".equals(req.getParameter("dashboardProfile"))) {
                if (existingProfile == null) {
                    resp.sendRedirect(req.getContextPath() + "/student/profile");
                    return;
                }
                StudentProfile merged = mergeDashboardFields(req, existingProfile);
                merged.setProfileScore(calculateProfileScore(merged));
                profileDAO.update(merged);
                resp.sendRedirect(req.getContextPath() + "/student/dashboard?profileSaved=1");
                return;
            }

            StudentProfile profile = bindProfile(req, existingProfile == null ? new StudentProfile() : existingProfile);
            profile.setUserId(userId);

            if (existingProfile == null) {
                profileDAO.create(profile);
            } else {
                profileDAO.update(profile);
            }

            userDAO.updateProfilePhoto(userId, profile.getProfilePhoto());
            User sessionUser = SessionUtil.getUser(req);
            if (sessionUser != null) {
                sessionUser.setProfilePhoto(profile.getProfilePhoto());
                SessionUtil.setUser(req, sessionUser);
            }

            resp.sendRedirect(req.getContextPath() + "/student/profile?success=1");
        } catch (Exception e) {
            throw new ServletException("Unable to save student profile", e);
        }
    }

    private StudentProfile mergeDashboardFields(HttpServletRequest req, StudentProfile profile) {
        profile.setUniversity(req.getParameter("university"));
        profile.setProgram(req.getParameter("program"));
        profile.setSemester(parseInt(req.getParameter("semester")));
        profile.setCgpa(parseDouble(req.getParameter("cgpa")));
        profile.setExperienceType(req.getParameter("experienceType"));
        return profile;
    }

    private StudentProfile bindProfile(HttpServletRequest req, StudentProfile profile) {
        profile.setFullName(req.getParameter("fullName"));
        profile.setPhone(req.getParameter("phone"));
        profile.setAddress(req.getParameter("address"));
        profile.setUniversity(req.getParameter("university"));
        profile.setProgram(req.getParameter("program"));
        profile.setSemester(parseInt(req.getParameter("semester")));
        profile.setCgpa(parseDouble(req.getParameter("cgpa")));
        profile.setSkills(req.getParameter("skills"));
        profile.setGithubUrl(req.getParameter("githubUrl"));
        profile.setLinkedinUrl(req.getParameter("linkedinUrl"));
        profile.setExperienceType(req.getParameter("experienceType"));
        profile.setBio(req.getParameter("bio"));
        profile.setProfilePhoto(storeProfilePhoto(req, profile.getProfilePhoto()));
        profile.setProfileScore(calculateProfileScore(profile));
        return profile;
    }

    private String storeProfilePhoto(HttpServletRequest req, String currentPath) {
        try {
            Part photo = req.getPart("profilePhoto");
            if (photo == null || photo.getSize() == 0) {
                return currentPath;
            }

            String submitted = Path.of(photo.getSubmittedFileName()).getFileName().toString();
            String extension = "";
            int dot = submitted.lastIndexOf('.');
            if (dot >= 0) {
                extension = submitted.substring(dot);
            }

            String filename = UUID.randomUUID() + extension;
            Path target = com.internlink.util.StorageUtil.uploadsPath("profile_photos", filename);
            Files.copy(photo.getInputStream(), target, StandardCopyOption.REPLACE_EXISTING);
            return com.internlink.util.StorageUtil.webPath("profile_photos", filename);
        } catch (Exception e) {
            return currentPath;
        }
    }

    private int calculateProfileScore(StudentProfile profile) {
        int score = 0;
        if (filled(profile.getFullName())) score += 15;
        if (filled(profile.getPhone())) score += 10;
        if (filled(profile.getAddress())) score += 10;
        if (filled(profile.getUniversity())) score += 10;
        if (filled(profile.getProgram())) score += 10;
        if (profile.getSemester() > 0) score += 5;
        if (profile.getCgpa() > 0) score += 10;
        if (filled(profile.getSkills())) score += 10;
        if (filled(profile.getGithubUrl())) score += 10;
        if (filled(profile.getLinkedinUrl())) score += 5;
        if (filled(profile.getExperienceType())) score += 5;
        if (filled(profile.getBio())) score += 10;
        return Math.min(score, 100);
    }

    private boolean filled(String value) {
        return value != null && !value.isBlank();
    }

    private int parseInt(String value) {
        return value == null || value.isBlank() ? 0 : Integer.parseInt(value);
    }

    private double parseDouble(String value) {
        return value == null || value.isBlank() ? 0 : Double.parseDouble(value);
    }
}
