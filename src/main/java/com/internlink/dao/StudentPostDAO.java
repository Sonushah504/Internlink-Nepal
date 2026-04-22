package com.internlink.dao;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import com.internlink.model.StudentPost;
import jakarta.servlet.ServletContext;

import java.io.IOException;
import java.io.Reader;
import java.io.Writer;
import java.lang.reflect.Type;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

public class StudentPostDAO {
    private static final Type LIST_TYPE = new TypeToken<List<StudentPost>>() {}.getType();
    private final Gson gson = new GsonBuilder()
            .registerTypeAdapter(LocalDateTime.class, new com.internlink.util.LocalDateTimeAdapter())
            .setPrettyPrinting()
            .create();

    // Store posts in external data directory to persist across redeploys
    private Path dataFilePath(ServletContext context) {
        try {
            return com.internlink.util.StorageUtil.dataFile("student-posts.json");
        } catch (Exception e) {
            // fallback to web-inf path
            return Paths.get(context.getRealPath("/WEB-INF/data/student-posts.json"));
        }
    }

    public List<StudentPost> findAll(ServletContext context) throws IOException {
        List<StudentPost> posts = readPosts(context);
        posts.sort(Comparator.comparing(StudentPost::getCreatedAt, Comparator.nullsLast(Comparator.reverseOrder())));
        return posts;
    }

    public void save(ServletContext context, StudentPost post) throws IOException {
        List<StudentPost> posts = readPosts(context);
        if (post.getCreatedAt() == null) {
            post.setCreatedAt(LocalDateTime.now());
        }
        posts.add(0, post);
        writePosts(context, posts);
    }

    private List<StudentPost> readPosts(ServletContext context) throws IOException {
        Path file = dataFile(context);
        if (!Files.exists(file)) {
            return new ArrayList<>();
        }
        try (Reader reader = Files.newBufferedReader(file)) {
            List<StudentPost> posts = gson.fromJson(reader, LIST_TYPE);
            return posts == null ? new ArrayList<>() : new ArrayList<>(posts);
        }
    }

    private void writePosts(ServletContext context, List<StudentPost> posts) throws IOException {
        Path file = dataFile(context);
        Files.createDirectories(file.getParent());
        try (Writer writer = Files.newBufferedWriter(file)) {
            gson.toJson(posts, LIST_TYPE, writer);
        }
    }

    private Path dataFile(ServletContext context) {
        return dataFilePath(context);
    }

    // Update existing posts when a student's profile photo changes
    public void updateProfilePhotoForStudent(int studentId, String newPhoto) throws IOException {
        // load posts from external storage, update matching studentId, and save
        Path file = com.internlink.util.StorageUtil.dataFile("student-posts.json");
        List<StudentPost> posts = new ArrayList<>();
        if (Files.exists(file)) {
            try (java.io.Reader reader = Files.newBufferedReader(file)) {
                List<StudentPost> tmp = gson.fromJson(reader, LIST_TYPE);
                if (tmp != null) posts.addAll(tmp);
            } catch (Exception ignored) {}
        }
        boolean changed = false;
        for (StudentPost p : posts) {
            if (p.getStudentId() == studentId) { p.setStudentProfilePhoto(newPhoto); changed = true; }
        }
        if (changed) {
            Files.createDirectories(file.getParent());
            try (java.io.Writer writer = Files.newBufferedWriter(file)) {
                gson.toJson(posts, LIST_TYPE, writer);
            } catch (Exception ignored) {}
        }
    }
}
