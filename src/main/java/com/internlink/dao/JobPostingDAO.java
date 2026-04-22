package com.internlink.dao;

import com.internlink.model.JobPosting;
import com.internlink.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;


public class JobPostingDAO {

    public List<JobPosting> findAllActive() throws SQLException {
        List<JobPosting> current = fetchList(baseQuery(true) + " ORDER BY jp.created_at DESC");
        return current.isEmpty() ? fetchList(baseQuery(false) + " ORDER BY jp.created_at DESC") : current;
    }

    public List<JobPosting> findByCompanyId(int companyId) throws SQLException {
        String sql = """
            SELECT jp.*, c.company_name, c.logo_path AS company_logo, c.city AS company_city
            FROM job_postings jp
            JOIN companies c ON c.id = jp.company_id
            WHERE jp.company_id = ?
            ORDER BY jp.created_at DESC
            """;
        List<JobPosting> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, companyId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        }
        return list;
    }

    public JobPosting findById(int id) throws SQLException {
        String sql = """
            SELECT jp.*, c.company_name, c.logo_path AS company_logo, c.city AS company_city
            FROM job_postings jp JOIN companies c ON c.id = jp.company_id
            WHERE jp.id = ?
            """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

    public List<JobPosting> search(String keyword, String jobType, String expType) throws SQLException {
        List<JobPosting> current = searchInternal(keyword, jobType, expType, true);
        return current.isEmpty() ? searchInternal(keyword, jobType, expType, false) : current;
    }

    private List<JobPosting> searchInternal(String keyword, String jobType, String expType, boolean onlyCurrent) throws SQLException {
        StringBuilder sb = new StringBuilder(baseQuery(onlyCurrent));
        List<Object> params = new ArrayList<>();
        if (keyword != null && !keyword.isBlank()) {
            sb.append(" AND (LOWER(jp.title) LIKE ? OR LOWER(jp.skills_required) LIKE ? OR LOWER(c.company_name) LIKE ?)");
            String k = "%" + keyword.trim().toLowerCase() + "%";
            params.add(k); params.add(k); params.add(k);
        }
        if (jobType != null && !jobType.isBlank()) {
            sb.append(" AND jp.job_type = ?");
            params.add(jobType);
        }
        if (expType != null && !expType.isBlank()) {
            sb.append(" AND (jp.experience_required = ? OR jp.experience_required = 'ANY')");
            params.add(expType);
        }
        sb.append(" ORDER BY jp.created_at DESC");

        List<JobPosting> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sb.toString())) {
            for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        }
        return list;
    }

    public int create(JobPosting jp) throws SQLException {
        String sql = """
            INSERT INTO job_postings (company_id, title, description, requirements, skills_required,
            job_type, experience_required, min_cgpa, location, salary_range, deadline)
            VALUES (?,?,?,?,?,?,?,?,?,?,?)
            """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, jp.getCompanyId());
            ps.setString(2, jp.getTitle());
            ps.setString(3, jp.getDescription());
            ps.setString(4, jp.getRequirements());
            ps.setString(5, jp.getSkillsRequired());
            ps.setString(6, jp.getJobType());
            ps.setString(7, jp.getExperienceRequired());
            ps.setDouble(8, jp.getMinCgpa());
            ps.setString(9, jp.getLocation());
            ps.setString(10, jp.getSalaryRange());
            ps.setDate(11, Date.valueOf(jp.getDeadline()));
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return -1;
    }

    /** Recommend jobs matching any skill keyword (comma-separated skills string). */
    public List<JobPosting> searchBySkills(String skills, int limit) throws SQLException {
        if (skills == null || skills.isBlank()) return findAllActive().stream().limit(limit).toList();
        List<JobPosting> current = searchBySkillsInternal(skills, limit, true);
        return current.isEmpty() ? searchBySkillsInternal(skills, limit, false) : current;
    }

    private List<JobPosting> searchBySkillsInternal(String skills, int limit, boolean onlyCurrent) throws SQLException {
        String[] parts = skills.split(",");
        StringBuilder sb = new StringBuilder(baseQuery(onlyCurrent));
        sb.append(" AND (");
        List<String> params = new ArrayList<>();
        for (String part : parts) {
            sb.append("LOWER(jp.skills_required) LIKE ? OR LOWER(jp.title) LIKE ? OR ");
            String match = "%" + part.trim().toLowerCase() + "%";
            params.add(match);
            params.add(match);
        }
        sb.replace(sb.length() - 4, sb.length(), ") ORDER BY jp.created_at DESC LIMIT " + limit);

        List<JobPosting> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sb.toString())) {
            for (int i = 0; i < params.size(); i++) ps.setString(i + 1, params.get(i));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        }
        return list;
    }

    private String baseQuery(boolean onlyCurrent) {
        return """
            SELECT jp.*, c.company_name, c.logo_path AS company_logo, c.city AS company_city
            FROM job_postings jp
            JOIN companies c ON c.id = jp.company_id
            WHERE jp.is_active = 1
            """ + (onlyCurrent ? " AND (jp.deadline IS NULL OR jp.deadline >= CURDATE())" : "") + "\n";
    }

    public void toggleActive(int id, boolean active) throws SQLException {
        String sql = "UPDATE job_postings SET is_active = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, active);
            ps.setInt(2, id);
            ps.executeUpdate();
        }
    }

    public int countByCompany(int companyId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM job_postings WHERE company_id = ? AND is_active = 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, companyId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    public int countByCompanyAndType(int companyId, String type) throws SQLException {
        String sql = "SELECT COUNT(*) FROM job_postings WHERE company_id = ? AND is_active = 1 AND job_type = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, companyId);
            ps.setString(2, type);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    private List<JobPosting> fetchList(String sql) throws SQLException {
        List<JobPosting> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    private JobPosting mapRow(ResultSet rs) throws SQLException {
        JobPosting jp = new JobPosting();
        jp.setId(rs.getInt("id"));
        jp.setCompanyId(rs.getInt("company_id"));
        jp.setTitle(rs.getString("title"));
        jp.setDescription(rs.getString("description"));
        jp.setRequirements(rs.getString("requirements"));
        jp.setSkillsRequired(rs.getString("skills_required"));
        jp.setJobType(rs.getString("job_type"));
        jp.setExperienceRequired(rs.getString("experience_required"));
        jp.setMinCgpa(rs.getDouble("min_cgpa"));
        jp.setLocation(rs.getString("location"));
        jp.setSalaryRange(rs.getString("salary_range"));
        Date d = rs.getDate("deadline");
        if (d != null) jp.setDeadline(d.toLocalDate());
        jp.setActive(rs.getBoolean("is_active"));
        jp.setCompanyName(rs.getString("company_name"));
        jp.setCompanyLogo(rs.getString("company_logo"));
        jp.setCompanyCity(rs.getString("company_city"));
        return jp;
    }
}
