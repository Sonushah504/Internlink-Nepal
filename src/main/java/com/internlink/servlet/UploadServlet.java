package com.internlink.servlet;

import com.internlink.util.StorageUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;

@WebServlet("/uploads/*")
public class UploadServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        if (pathInfo == null || pathInfo.isBlank() || pathInfo.contains("..")) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        Path file = StorageUtil.resolveUpload("uploads" + pathInfo);
        if (!Files.exists(file) || !Files.isRegularFile(file)) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String contentType = Files.probeContentType(file);
        resp.setContentType(contentType != null ? contentType : "application/octet-stream");
        resp.setContentLengthLong(Files.size(file));

        try (InputStream in = Files.newInputStream(file)) {
            in.transferTo(resp.getOutputStream());
        }
    }
}
