package com.internlink.dao;

import com.internlink.model.Company;
import com.internlink.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;


public class CompanyDAO {

    public Company findByUserId(int userId) throws SQLException {
        String sql = "SELECT c.*, u.email FROM companies c JOIN users u ON u.id = c.user_id WHERE c.user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

    public Company findById(int id) throws SQLException {
        String sql = "SELECT c.*, u.email FROM companies c JOIN users u ON u.id = c.user_id WHERE c.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

    public List<Company> findAll() throws SQLException {
        String sql = "SELECT c.*, u.email FROM companies c JOIN users u ON u.id = c.user_id ORDER BY c.company_name";
        List<Company> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    public List<Company> findVerified() throws SQLException {
        String sql = "SELECT c.*, u.email FROM companies c JOIN users u ON u.id = c.user_id WHERE c.is_verified = 1 ORDER BY c.company_name";
        List<Company> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    public int create(Company co) throws SQLException {
        String sql = "INSERT INTO companies (user_id, company_name, industry, description, website, phone, address, city, latitude, longitude, logo_path, employee_count, founded_year) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, co.getUserId());
            ps.setString(2, co.getCompanyName());
            ps.setString(3, co.getIndustry());
            ps.setString(4, co.getDescription());
            ps.setString(5, co.getWebsite());
            ps.setString(6, co.getPhone());
            ps.setString(7, co.getAddress());
            ps.setString(8, co.getCity());
            ps.setDouble(9, co.getLatitude());
            ps.setDouble(10, co.getLongitude());
            ps.setString(11, co.getLogoPath());
            ps.setString(12, co.getEmployeeCount());
            ps.setInt(13, co.getFoundedYear());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return -1;
    }

    public void update(Company co) throws SQLException {
        String sql = "UPDATE companies SET company_name=?, industry=?, description=?, website=?, phone=?, address=?, city=?, latitude=?, longitude=?, logo_path=?, employee_count=?, founded_year=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, co.getCompanyName());
            ps.setString(2, co.getIndustry());
            ps.setString(3, co.getDescription());
            ps.setString(4, co.getWebsite());
            ps.setString(5, co.getPhone());
            ps.setString(6, co.getAddress());
            ps.setString(7, co.getCity());
            ps.setDouble(8, co.getLatitude());
            ps.setDouble(9, co.getLongitude());
            ps.setString(10, co.getLogoPath());
            ps.setString(11, co.getEmployeeCount());
            ps.setInt(12, co.getFoundedYear());
            ps.setInt(13, co.getId());
            ps.executeUpdate();
        }
    }

    public void setVerified(int id, boolean verified) throws SQLException {
        String sql = "UPDATE companies SET is_verified = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, verified);
            ps.setInt(2, id);
            ps.executeUpdate();
        }
    }

    private Company mapRow(ResultSet rs) throws SQLException {
        Company c = new Company();
        c.setId(rs.getInt("id"));
        c.setUserId(rs.getInt("user_id"));
        c.setCompanyName(rs.getString("company_name"));
        c.setIndustry(rs.getString("industry"));
        c.setDescription(rs.getString("description"));
        c.setWebsite(rs.getString("website"));
        c.setPhone(rs.getString("phone"));
        c.setAddress(rs.getString("address"));
        c.setCity(rs.getString("city"));
        c.setLatitude(rs.getDouble("latitude"));
        c.setLongitude(rs.getDouble("longitude"));
        c.setLogoPath(rs.getString("logo_path"));
        c.setVerified(rs.getBoolean("is_verified"));
        c.setEmployeeCount(rs.getString("employee_count"));
        c.setFoundedYear(rs.getInt("founded_year"));
        c.setEmail(rs.getString("email"));
        return c;
    }
}
