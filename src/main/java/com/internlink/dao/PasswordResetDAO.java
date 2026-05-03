package com.internlink.dao;

import com.internlink.util.DBConnection;

import java.sql.*;

public class PasswordResetDAO {

    public void deleteExpired() throws SQLException {
        String sql = "DELETE FROM password_reset_otps WHERE expires_at < NOW()";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.executeUpdate();
        }
    }

    public void deleteAllForUser(int userId) throws SQLException {
        String sql = "DELETE FROM password_reset_otps WHERE user_id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        }
    }

    public void insertOtp(int userId, String otpCode, Timestamp expiresAt) throws SQLException {
        deleteExpired();
        deleteAllForUser(userId);
        String sql = "INSERT INTO password_reset_otps (user_id, otp_code, expires_at) VALUES (?,?,?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, otpCode);
            ps.setTimestamp(3, expiresAt);
            ps.executeUpdate();
        }
    }

    /**
     * @return true if OTP matched and was consumed.
     */
    public boolean verifyAndConsume(int userId, String otpCode) throws SQLException {
        deleteExpired();
        String sql = "DELETE FROM password_reset_otps WHERE user_id = ? AND otp_code = ? AND expires_at >= NOW()";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, otpCode.trim());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean tableExists() throws SQLException {
        try (Connection c = DBConnection.getConnection();
             ResultSet rs = c.getMetaData().getTables(c.getCatalog(), null, "password_reset_otps", null)) {
            return rs.next();
        }
    }
}
