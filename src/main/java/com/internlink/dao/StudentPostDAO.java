package com.internlink.dao;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import com.internlink.model.StudentPost;
import com.internlink.util.DBConnection;
import com.internlink.util.LocalDateTimeAdapter;
import com.internlink.util.StorageUtil;

import java.io.IOException;
import java.io.Reader;
import java.io.Writer;
import java.lang.reflect.Type;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.UUID;

public class StudentPostDAO {
    private static final String POSTS_FILE = "student-posts.json";
    private static final Type POSTS_TYPE = new TypeToken<List<StudentPost>>() {}.getType();
    private final Gson gson = new GsonBuilder()
            .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeAdapter())
            .setPrettyPrinting()
            .create();

    public List<StudentPost> findAll() throws SQLException {
        if (!hasUserPostsTable()) {
            return findAllFromFile();
        }

        String sql = """
            SELECT up.id, up.user_id, up.file_type, up.file_path, up.caption, up.created_at,
                   sp.id AS student_id, sp.full_name, sp.program, sp.university,
                   %s AS student_profile_photo
            FROM user_posts up
            JOIN users u ON u.id = up.user_id
            JOIN student_profiles sp ON sp.user_id = up.user_id
            ORDER BY up.created_at DESC
            """.formatted(resolvedProfilePhotoSql());

        List<StudentPost> posts = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                posts.add(mapRow(rs));
            }
        }
        return posts;
    }

    public void save(StudentPost post) throws SQLException {
        if (!hasUserPostsTable()) {
            saveToFile(post);
            return;
        }
        String sql = "INSERT INTO user_posts (user_id, file_type, file_path, caption, created_at) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, post.getUserId());
            ps.setString(2, post.getMediaType());
            ps.setString(3, post.getMediaPath());
            ps.setString(4, post.getContent());
            ps.setTimestamp(5, Timestamp.valueOf(post.getCreatedAt()));
            ps.executeUpdate();
        }
    }

    private StudentPost mapRow(ResultSet rs) throws SQLException {
        StudentPost post = new StudentPost();
        post.setId(String.valueOf(rs.getLong("id")));
        post.setUserId(rs.getInt("user_id"));
        post.setStudentId(rs.getInt("student_id"));
        post.setStudentName(rs.getString("full_name"));
        post.setStudentProgram(rs.getString("program"));
        post.setStudentUniversity(rs.getString("university"));
        post.setStudentProfilePhoto(rs.getString("student_profile_photo"));
        post.setContent(rs.getString("caption"));
        post.setMediaType(rs.getString("file_type"));
        post.setMediaPath(rs.getString("file_path"));
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            post.setCreatedAt(createdAt.toLocalDateTime());
        }
        return post;
    }

    private String resolvedProfilePhotoSql() throws SQLException {
        return hasUserProfilePhotoColumn() ? "COALESCE(u.profile_photo, sp.profile_photo)" : "sp.profile_photo";
    }

    private boolean hasUserProfilePhotoColumn() throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             ResultSet rs = conn.getMetaData().getColumns(conn.getCatalog(), null, "users", "profile_photo")) {
            return rs.next();
        }
    }

    private boolean hasUserPostsTable() throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             ResultSet rs = conn.getMetaData().getTables(conn.getCatalog(), null, "user_posts", null)) {
            return rs.next();
        }
    }

    private List<StudentPost> findAllFromFile() throws SQLException {
        try {
            Path file = StorageUtil.dataFile(POSTS_FILE);
            if (!Files.exists(file) || Files.size(file) == 0) {
                return new ArrayList<>();
            }

            try (Reader reader = Files.newBufferedReader(file, StandardCharsets.UTF_8)) {
                List<StudentPost> posts = gson.fromJson(reader, POSTS_TYPE);
                if (posts == null) {
                    return new ArrayList<>();
                }
                posts.sort(Comparator.comparing(StudentPost::getCreatedAt, Comparator.nullsLast(Comparator.naturalOrder())).reversed());
                return posts;
            }
        } catch (IOException e) {
            throw new SQLException("Unable to read student posts from local storage", e);
        }
    }

    private void saveToFile(StudentPost post) throws SQLException {
        try {
            List<StudentPost> posts = findAllFromFile();
            if (post.getId() == null || post.getId().isBlank()) {
                post.setId(UUID.randomUUID().toString());
            }
            if (post.getCreatedAt() == null) {
                post.setCreatedAt(LocalDateTime.now());
            }
            posts.add(0, post);

            Path file = StorageUtil.dataFile(POSTS_FILE);
            try (Writer writer = Files.newBufferedWriter(file, StandardCharsets.UTF_8)) {
                gson.toJson(posts, POSTS_TYPE, writer);
            }
        } catch (IOException e) {
            throw new SQLException("Unable to save student post to local storage", e);
        }
    }
}
