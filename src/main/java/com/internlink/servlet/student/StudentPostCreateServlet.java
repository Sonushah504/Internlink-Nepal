package com.internlink.servlet.student;

import com.internlink.dao.StudentPostDAO;
import com.internlink.dao.StudentProfileDAO;
import com.internlink.model.StudentPost;
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
import java.nio.file.StandardCopyOption;
import java.time.LocalDateTime;
import java.util.UUID;

@WebServlet("/student/posts/create")
@MultipartConfig(maxFileSize = 25 * 1024 * 1024, maxRequestSize = 30 * 1024 * 1024)
public class StudentPostCreateServlet extends HttpServlet {

    private final StudentProfileDAO profileDAO = new StudentProfileDAO();
    private final StudentPostDAO postDAO = new StudentPostDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            StudentProfile profile = profileDAO.findByUserId(SessionUtil.getUserId(req));
            if (profile == null) {
                resp.sendRedirect(req.getContextPath() + "/student/profile");
                return;
            }

            String content = req.getParameter("content");
            Part media = req.getPart("media");
            if ((content == null || content.isBlank()) && (media == null || media.getSize() == 0)) {
                resp.sendRedirect(req.getContextPath() + "/student/dashboard");
                return;
            }

            StudentPost post = new StudentPost();
            post.setUserId(profile.getUserId());
            post.setStudentId(profile.getId());
            post.setStudentName(profile.getFullName());
            post.setStudentProgram(profile.getProgram());
            post.setStudentUniversity(profile.getUniversity());
            post.setStudentProfilePhoto(profile.getProfilePhoto());
            post.setContent(content);
            post.setCreatedAt(LocalDateTime.now());

            if (media != null && media.getSize() > 0) {
                String submitted = Path.of(media.getSubmittedFileName()).getFileName().toString();
                String extension = submitted.contains(".") ? submitted.substring(submitted.lastIndexOf('.')) : "";
                String mediaType = media.getContentType() != null && media.getContentType().startsWith("video") ? "VIDEO" : "PHOTO";
                String uploadFolder = "VIDEO".equals(mediaType) ? "posts/videos" : "posts/photos";
                String filename = UUID.randomUUID() + extension;
                Path target = com.internlink.util.StorageUtil.uploadsPath(uploadFolder, filename);
                Files.copy(media.getInputStream(), target, StandardCopyOption.REPLACE_EXISTING);
                post.setMediaType(mediaType);
                post.setMediaPath(com.internlink.util.StorageUtil.webPath(uploadFolder, filename));
            } else {
                post.setMediaType("TEXT");
            }

            postDAO.save(post);
            resp.sendRedirect(req.getContextPath() + "/student/dashboard");
        } catch (Exception e) {
            throw new ServletException("Unable to create student post", e);
        }
    }
}
