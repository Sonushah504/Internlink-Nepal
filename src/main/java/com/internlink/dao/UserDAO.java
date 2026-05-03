package com.internlink.dao;

import com.internlink.model.User;
import com.internlink.util.DBConnection;
import com.internlink.util.PasswordUtil;

import java.sql.*;


public class UserDAO {

    private static volatile Boolean hasProfilePhoto;
    private static volatile Boolean hasAuthProvider;

    public User findByEmail(String email) throws SQLException {
        String sql = buildSelect() + " WHERE LOWER(email) = LOWER(?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

    public User findById(int id) throws SQLException {
        String sql = buildSelect() + " WHERE id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

    public int create(String email, String plainPassword, String role) throws SQLException {
        if (hasAuthProviderColumn()) {
            boolean hp = hasProfilePhotoColumn();
            String sql = hp
                    ? "INSERT INTO users (email, password_hash, role, profile_photo, auth_provider) VALUES (?, ?, ?, ?, 'LOCAL')"
                    : "INSERT INTO users (email, password_hash, role, auth_provider) VALUES (?, ?, ?, 'LOCAL')";
            try (Connection c = DBConnection.getConnection();
                 PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, email);
                ps.setString(2, PasswordUtil.hash(plainPassword));
                ps.setString(3, role);
                if (hp) {
                    ps.setString(4, null);
                }
                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) return rs.getInt(1);
                }
            }
        } else {
            boolean hp = hasProfilePhotoColumn();
            String sql = hp
                    ? "INSERT INTO users (email, password_hash, role, profile_photo) VALUES (?, ?, ?, ?)"
                    : "INSERT INTO users (email, password_hash, role) VALUES (?, ?, ?)";
            try (Connection c = DBConnection.getConnection();
                 PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, email);
                ps.setString(2, PasswordUtil.hash(plainPassword));
                ps.setString(3, role);
                if (hp) {
                    ps.setString(4, null);
                }
                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) return rs.getInt(1);
                }
            }
        }
        return -1;
    }

    /**
     * OAuth sign-up: no password until user sets one via forgot-password flow.
     */
    public int createOAuthUser(String email, String role, String provider, String profilePhotoPath) throws SQLException {
        if (!hasAuthProviderColumn()) {
            throw new SQLException("Database missing auth_provider column. Run the latest schema migration.");
        }
        boolean hp = hasProfilePhotoColumn();
        String sql = hp
                ? "INSERT INTO users (email, password_hash, role, profile_photo, auth_provider) VALUES (?, ?, ?, ?, ?)"
                : "INSERT INTO users (email, password_hash, role, auth_provider) VALUES (?, ?, ?, ?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, email);
            ps.setNull(2, Types.VARCHAR);
            ps.setString(3, role);
            if (hp) {
                ps.setString(4, profilePhotoPath);
                ps.setString(5, provider);
            } else {
                ps.setString(4, provider);
            }
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return -1;
    }

    public void updatePasswordHash(int userId, String plainPassword) throws SQLException {
        String sql = "UPDATE users SET password_hash = ? WHERE id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, PasswordUtil.hash(plainPassword));
            ps.setInt(2, userId);
            ps.executeUpdate();
        }
    }

    public User authenticate(String email, String plainPassword) throws SQLException {
        User user = findByEmail(email);
        if (user == null) return null;
        if (!user.isActive()) return null;
        if (!PasswordUtil.verify(plainPassword, user.getPasswordHash())) return null;
        return user;
    }

    public boolean emailExists(String email) throws SQLException {
        String sql = "SELECT 1 FROM users WHERE LOWER(email) = LOWER(?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public void updateProfilePhoto(int userId, String profilePhotoPath) throws SQLException {
        if (!hasProfilePhotoColumn()) {
            return;
        }
        String sql = "UPDATE users SET profile_photo = ? WHERE id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, profilePhotoPath);
            ps.setInt(2, userId);
            ps.executeUpdate();
        }
    }

    private String buildSelect() throws SQLException {
        StringBuilder sb = new StringBuilder("SELECT id, email, password_hash, role");
        if (hasProfilePhotoColumn()) {
            sb.append(", profile_photo");
        }
        sb.append(", is_active");
        if (hasAuthProviderColumn()) {
            sb.append(", auth_provider");
        }
        sb.append(" FROM users");
        return sb.toString();
    }

    private User mapRow(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getInt("id"));
        u.setEmail(rs.getString("email"));
        u.setPasswordHash(rs.getString("password_hash"));
        u.setRole(rs.getString("role"));
        if (hasProfilePhotoColumn()) {
            try {
                u.setProfilePhoto(rs.getString("profile_photo"));
            } catch (SQLException ignored) {
                u.setProfilePhoto(null);
            }
        }
        u.setActive(rs.getBoolean("is_active"));
        if (hasAuthProviderColumn()) {
            try {
                u.setAuthProvider(rs.getString("auth_provider"));
            } catch (SQLException ignored) {
                u.setAuthProvider("LOCAL");
            }
        } else {
            u.setAuthProvider("LOCAL");
        }
        return u;
    }

    private boolean hasProfilePhotoColumn() throws SQLException {
        if (hasProfilePhoto != null) return hasProfilePhoto;
        synchronized (UserDAO.class) {
            if (hasProfilePhoto != null) return hasProfilePhoto;
            try (Connection c = DBConnection.getConnection();
                 ResultSet rs = c.getMetaData().getColumns(c.getCatalog(), null, "users", "profile_photo")) {
                hasProfilePhoto = rs.next();
            }
        }
        return hasProfilePhoto;
    }

    private boolean hasAuthProviderColumn() throws SQLException {
        if (hasAuthProvider != null) return hasAuthProvider;
        synchronized (UserDAO.class) {
            if (hasAuthProvider != null) return hasAuthProvider;
            try (Connection c = DBConnection.getConnection();
                 ResultSet rs = c.getMetaData().getColumns(c.getCatalog(), null, "users", "auth_provider")) {
                hasAuthProvider = rs.next();
            }
        }
        return hasAuthProvider;
    }
}
