package com.internlink.servlet.student;

import com.internlink.dao.StudentProfileDAO;
import com.internlink.model.StudentProfile;
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
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@WebServlet("/student/profile")
@MultipartConfig(maxFileSize = 5 * 1024 * 1024, maxRequestSize = 6 * 1024 * 1024)
public class StudentProfileServlet extends HttpServlet {

    private final StudentProfileDAO profileDAO = new StudentProfileDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            StudentProfile profile = profileDAO.findByUserId(SessionUtil.getUserId(req));
            req.setAttribute("profile", profile);
            if (profile != null) {
                req.setAttribute("relatedProfiles", profileDAO.findRelatedProfiles(profile.getUserId(), profile.getProgram(), profile.getUniversity(), profile.getExperienceType(), 6));
            }
            req.getRequestDispatcher("/pages/student/profile.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException("Unable to load student profile", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            StudentProfile profile = profileDAO.findByUserId(SessionUtil.getUserId(req));
            if (profile == null) {
                profile = new StudentProfile();
                profile.setUserId(SessionUtil.getUserId(req));
                profileDAO.create(bindProfile(req, profile));
            } else {
                profileDAO.update(bindProfile(req, profile));
            }
            resp.sendRedirect(req.getContextPath() + "/student/profile?success=1");
        } catch (Exception e) {
            throw new ServletException("Unable to save student profile", e);
        }
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

            String submitted = Paths.get(photo.getSubmittedFileName()).getFileName().toString();
            String extension = "";
            int dot = submitted.lastIndexOf('.');
            if (dot >= 0) {
                extension = submitted.substring(dot);
            }

            // Store uploads outside the WAR so redeploys do not delete files
            String filename = UUID.randomUUID() + extension;
            try {
                Path target = com.internlink.util.StorageUtil.uploadsPath("profile", filename);
                Files.copy(photo.getInputStream(), target, StandardCopyOption.REPLACE_EXISTING);
                return com.internlink.util.StorageUtil.webPath("profile", filename);
            } catch (Exception e) {
                Path uploadDir = Paths.get(req.getServletContext().getRealPath("/uploads/profile"));
                Files.createDirectories(uploadDir);
                Path target = uploadDir.resolve(filename);
                Files.copy(photo.getInputStream(), target, StandardCopyOption.REPLACE_EXISTING);
                return "uploads/profile/" + filename;
            }
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
