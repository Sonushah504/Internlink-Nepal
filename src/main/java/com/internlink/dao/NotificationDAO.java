package com.internlink.dao;

import com.internlink.model.Notification;
import com.internlink.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO {

    private static volatile boolean schemaEnsured;

    public int countUnread(int userId) throws SQLException {
        ensureSchema();
        String sql = "SELECT COUNT(*) FROM notifications WHERE user_id = ? AND is_read = 0";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) { if (rs.next()) return rs.getInt(1); }
        }
        return 0;
    }

    public List<Notification> findRecent(int userId, int limit) throws SQLException {
        ensureSchema();
        String sql = "SELECT * FROM notifications WHERE user_id = ? ORDER BY created_at DESC LIMIT ?";
        return fetchList(sql, userId, limit);
    }

    public List<Notification> findUnreadRecent(int userId, int limit) throws SQLException {
        ensureSchema();
        String sql = "SELECT * FROM notifications WHERE user_id = ? AND is_read = 0 ORDER BY created_at DESC LIMIT ?";
        return fetchList(sql, userId, limit);
    }

    public Notification findByIdForUser(int notificationId, int userId) throws SQLException {
        ensureSchema();
        String sql = "SELECT * FROM notifications WHERE id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, notificationId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

    public void markRead(int notificationId, int userId) throws SQLException {
        ensureSchema();
        String sql = "UPDATE notifications SET is_read = 1 WHERE id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, notificationId);
            ps.setInt(2, userId);
            ps.executeUpdate();
        }
    }

    public void markAllRead(int userId) throws SQLException {
        ensureSchema();
        String sql = "UPDATE notifications SET is_read = 1 WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        }
    }

    public void createForAllUsers(String title, String message) throws SQLException {
        createForAllUsers(title, message, null);
    }

    public void createForAllUsers(String title, String message, String targetPath) throws SQLException {
        ensureSchema();
        String sql = "INSERT INTO notifications (user_id, title, message, target_path) SELECT id, ?, ?, ? FROM users WHERE role IN ('STUDENT','ADMIN')";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, title);
            ps.setString(2, message);
            ps.setString(3, targetPath);
            ps.executeUpdate();
        }
    }

    public int createForUser(int userId, String title, String message) throws SQLException {
        return createForUser(userId, title, message, null);
    }

    public int createForUser(int userId, String title, String message, String targetPath) throws SQLException {
        ensureSchema();
        String sql = "INSERT INTO notifications (user_id, title, message, target_path) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.setString(2, title);
            ps.setString(3, message);
            ps.setString(4, targetPath);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) { if (rs.next()) return rs.getInt(1); }
        }
        return -1;
    }

    private List<Notification> fetchList(String sql, int userId, int limit) throws SQLException {
        List<Notification> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        }
        return list;
    }

    private void ensureSchema() throws SQLException {
        if (schemaEnsured) return;
        synchronized (NotificationDAO.class) {
            if (schemaEnsured) return;
            try (Connection conn = DBConnection.getConnection()) {
                DatabaseMetaData metaData = conn.getMetaData();
                try (ResultSet rs = metaData.getColumns(conn.getCatalog(), null, "notifications", "target_path")) {
                    if (!rs.next()) {
                        try (Statement st = conn.createStatement()) {
                            st.executeUpdate("ALTER TABLE notifications ADD COLUMN target_path VARCHAR(500) NULL AFTER message");
                        }
                    }
                }
                try (Statement st = conn.createStatement()) {
                    st.executeUpdate("""
                        UPDATE notifications n
                        JOIN companies c ON n.message LIKE CONCAT(c.company_name, ' posted a new %')
                        SET n.target_path = CONCAT('/profiles/company?id=', c.id)
                        WHERE n.target_path IS NULL
                        """);
                }
            }
            schemaEnsured = true;
        }
    }

    private Notification mapRow(ResultSet rs) throws SQLException {
        Notification n = new Notification();
        n.setId(rs.getInt("id"));
        n.setUserId(rs.getInt("user_id"));
        n.setTitle(rs.getString("title"));
        n.setMessage(rs.getString("message"));
        n.setTargetPath(rs.getString("target_path"));
        n.setRead(rs.getBoolean("is_read"));
        Timestamp t = rs.getTimestamp("created_at");
        if (t != null) n.setCreatedAt(t.toLocalDateTime());
        return n;
    }
}
