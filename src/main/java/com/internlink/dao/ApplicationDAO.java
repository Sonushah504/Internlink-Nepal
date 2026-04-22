package com.internlink.dao;

import com.internlink.model.Application;
import com.internlink.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ApplicationDAO {
    public List<Application> findByCompanyId(int companyId) throws SQLException {
        String sql = """
            SELECT a.*, sp.full_name, sp.cgpa, sp.skills, sp.experience_type, sp.cv_path, sp.profile_photo,
                   u.email AS student_email, jp.title AS job_title
            FROM applications a
            JOIN student_profiles sp ON sp.id = a.student_id
            JOIN users u ON u.id = sp.user_id
            JOIN job_postings jp ON jp.id = a.job_id
            WHERE jp.company_id = ?
            ORDER BY a.applied_at DESC
            """;
        return fetchList(sql, companyId);
    }

    public List<Application> findByJobId(int jobId) throws SQLException {
        String sql = """
            SELECT a.*, sp.full_name, sp.cgpa, sp.skills, sp.experience_type, sp.cv_path, sp.profile_photo,
                   u.email AS student_email, jp.title AS job_title
            FROM applications a
            JOIN student_profiles sp ON sp.id = a.student_id
            JOIN users u ON u.id = sp.user_id
            JOIN job_postings jp ON jp.id = a.job_id
            WHERE a.job_id = ?
            ORDER BY a.applied_at DESC
            """;
        return fetchList(sql, jobId);
    }

    public List<Application> findByStudentId(int studentId) throws SQLException {
        String sql = """
            SELECT a.*, sp.full_name, sp.cgpa, sp.skills, sp.experience_type, sp.cv_path, sp.profile_photo,
                   u.email AS student_email, jp.title AS job_title, c.company_name
            FROM applications a
            JOIN student_profiles sp ON sp.id = a.student_id
            JOIN users u ON u.id = sp.user_id
            JOIN job_postings jp ON jp.id = a.job_id
            JOIN companies c ON c.id = jp.company_id
            WHERE a.student_id = ?
            ORDER BY a.applied_at DESC
            """;
        return fetchList(sql, studentId);
    }

    public boolean apply(int studentId, int jobId, String coverLetter) throws SQLException {
        String sql = "INSERT INTO applications (student_id, job_id, cover_letter) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, jobId);
            ps.setString(3, coverLetter);
            return ps.executeUpdate() > 0;
        } catch (SQLIntegrityConstraintViolationException ie) {
            // duplicate application or constraint violation
            return false;
        }
    }

    public boolean updateStatus(int appId, String status, String notes) throws SQLException {
        String sql = "UPDATE applications SET status = ?, company_notes = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, notes);
            ps.setInt(3, appId);
            return ps.executeUpdate() > 0;
        }
    }

    public int countByCompanyAndStatus(int companyId, String status) throws SQLException {
        String sql = """
            SELECT COUNT(*) FROM applications a
            JOIN job_postings jp ON jp.id = a.job_id
            WHERE jp.company_id = ? AND a.status = ?
            """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, companyId);
            ps.setString(2, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    public int countByExperienceType(int companyId, String expType) throws SQLException {
        String sql = """
            SELECT COUNT(*) FROM applications a
            JOIN job_postings jp ON jp.id = a.job_id
            JOIN student_profiles sp ON sp.id = a.student_id
            WHERE jp.company_id = ? AND sp.experience_type = ?
            """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, companyId);
            ps.setString(2, expType);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    private List<Application> fetchList(String sql, int param) throws SQLException {
        List<Application> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, param);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        }
        return list;
    }

    private Application mapRow(ResultSet rs) throws SQLException {
        Application a = new Application();
        a.setId(rs.getInt("id"));
        a.setStudentId(rs.getInt("student_id"));
        a.setJobId(rs.getInt("job_id"));
        a.setCoverLetter(rs.getString("cover_letter"));
        a.setStatus(rs.getString("status"));
        a.setAppliedAt(rs.getTimestamp("applied_at").toLocalDateTime());
        a.setCompanyNotes(rs.getString("company_notes"));
        a.setStudentName(rs.getString("full_name"));
        a.setStudentEmail(rs.getString("student_email"));
        a.setStudentCgpa(String.valueOf(rs.getDouble("cgpa")));
        a.setStudentSkills(rs.getString("skills"));
        a.setStudentExperienceType(rs.getString("experience_type"));
        a.setStudentCvPath(rs.getString("cv_path"));
        try { a.setStudentProfilePhoto(rs.getString("profile_photo")); } catch (Exception ignored) {}
        a.setJobTitle(rs.getString("job_title"));
        try { a.setCompanyName(rs.getString("company_name")); } catch (Exception ignored) {}
        return a;
    }
}
