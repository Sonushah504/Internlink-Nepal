package com.internlink.dao;

import com.internlink.model.StudentProfile;
import com.internlink.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;


public class StudentProfileDAO {

    public StudentProfile findByUserId(int userId) throws SQLException {
        String sql = "SELECT sp.*, u.email, " + resolvedProfilePhotoSql() + " AS resolved_profile_photo FROM student_profiles sp JOIN users u ON u.id = sp.user_id WHERE sp.user_id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

    public StudentProfile findById(int id) throws SQLException {
        String sql = "SELECT sp.*, u.email, " + resolvedProfilePhotoSql() + " AS resolved_profile_photo FROM student_profiles sp JOIN users u ON u.id = sp.user_id WHERE sp.id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

    public List<StudentProfile> findAll() throws SQLException {
        String sql = "SELECT sp.*, u.email, " + resolvedProfilePhotoSql() + " AS resolved_profile_photo FROM student_profiles sp JOIN users u ON u.id = sp.user_id ORDER BY sp.full_name";
        List<StudentProfile> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    public List<StudentProfile> findByExperienceType(String type) throws SQLException {
        String sql = "SELECT sp.*, u.email, " + resolvedProfilePhotoSql() + " AS resolved_profile_photo FROM student_profiles sp JOIN users u ON u.id = sp.user_id WHERE sp.experience_type = ? ORDER BY sp.full_name";
        List<StudentProfile> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, type);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        }
        return list;
    }

    public List<StudentProfile> findRelatedProfiles(int currentUserId, String program, String university, String experienceType, int limit) throws SQLException {
        String sql = """
            SELECT sp.*, u.email, %s AS resolved_profile_photo FROM student_profiles sp
            JOIN users u ON u.id = sp.user_id
            WHERE sp.user_id <> ?
              AND (
                    (sp.program IS NOT NULL AND sp.program = ?)
                 OR (sp.university IS NOT NULL AND sp.university = ?)
                 OR (sp.experience_type IS NOT NULL AND sp.experience_type = ?)
              )
            ORDER BY sp.profile_score DESC, sp.full_name
            LIMIT ?
            """.formatted(resolvedProfilePhotoSql());
        List<StudentProfile> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, currentUserId);
            ps.setString(2, program);
            ps.setString(3, university);
            ps.setString(4, experienceType);
            ps.setInt(5, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        }
        return list;
    }

    public int create(StudentProfile sp) throws SQLException {
        String sql = "INSERT INTO student_profiles (user_id, full_name, phone, address, university, program, semester, cgpa, skills, github_url, linkedin_url, profile_photo, experience_type, profile_score, bio) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1,    sp.getUserId());
            ps.setString(2, sp.getFullName());
            ps.setString(3, sp.getPhone());
            ps.setString(4, sp.getAddress());
            ps.setString(5, sp.getUniversity());
            ps.setString(6, sp.getProgram());
            ps.setInt(7,    sp.getSemester());
            ps.setDouble(8, sp.getCgpa());
            ps.setString(9, sp.getSkills());
            ps.setString(10, sp.getGithubUrl());
            ps.setString(11, sp.getLinkedinUrl());
            ps.setString(12, sp.getProfilePhoto());
            ps.setString(13, sp.getExperienceType());
            ps.setInt(14, sp.getProfileScore());
            ps.setString(15, sp.getBio());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return -1;
    }

    public void update(StudentProfile sp) throws SQLException {
        String sql = "UPDATE student_profiles SET full_name=?, phone=?, address=?, university=?, program=?, semester=?, cgpa=?, skills=?, github_url=?, linkedin_url=?, experience_type=?, bio=?, profile_score=?, profile_photo=? WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, sp.getFullName());
            ps.setString(2, sp.getPhone());
            ps.setString(3, sp.getAddress());
            ps.setString(4, sp.getUniversity());
            ps.setString(5, sp.getProgram());
            ps.setInt(6,    sp.getSemester());
            ps.setDouble(7, sp.getCgpa());
            ps.setString(8, sp.getSkills());
            ps.setString(9, sp.getGithubUrl());
            ps.setString(10, sp.getLinkedinUrl());
            ps.setString(11, sp.getExperienceType());
            ps.setString(12, sp.getBio());
            ps.setInt(13,   sp.getProfileScore());
            ps.setString(14, sp.getProfilePhoto());
            ps.setInt(15,   sp.getId());
            ps.executeUpdate();
        }
    }

    public int countByExperienceType(String type) throws SQLException {
        String sql = "SELECT COUNT(*) FROM student_profiles WHERE experience_type = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, type);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    private StudentProfile mapRow(ResultSet rs) throws SQLException {
        StudentProfile sp = new StudentProfile();
        sp.setId(rs.getInt("id"));
        sp.setUserId(rs.getInt("user_id"));
        sp.setFullName(rs.getString("full_name"));
        sp.setPhone(rs.getString("phone"));
        sp.setAddress(rs.getString("address"));
        sp.setUniversity(rs.getString("university"));
        sp.setProgram(rs.getString("program"));
        sp.setSemester(rs.getInt("semester"));
        sp.setCgpa(rs.getDouble("cgpa"));
        sp.setSkills(rs.getString("skills"));
        sp.setGithubUrl(rs.getString("github_url"));
        sp.setLinkedinUrl(rs.getString("linkedin_url"));
        sp.setCvPath(rs.getString("cv_path"));
        sp.setProfilePhoto(rs.getString("resolved_profile_photo"));
        sp.setExperienceType(rs.getString("experience_type"));
        sp.setProfileScore(rs.getInt("profile_score"));
        sp.setBio(rs.getString("bio"));
        sp.setEmail(rs.getString("email"));
        return sp;
    }

    private String resolvedProfilePhotoSql() throws SQLException {
        return hasUserProfilePhotoColumn() ? "COALESCE(u.profile_photo, sp.profile_photo)" : "sp.profile_photo";
    }

    private boolean hasUserProfilePhotoColumn() throws SQLException {
        try (Connection c = DBConnection.getConnection();
             ResultSet rs = c.getMetaData().getColumns(c.getCatalog(), null, "users", "profile_photo")) {
            return rs.next();
        }
    }
}
