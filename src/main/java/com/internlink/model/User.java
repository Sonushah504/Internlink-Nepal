package com.internlink.model;

import java.time.LocalDateTime;

/**
 * User - Base model for all platform users.
 */
public class User {
    private int           id;
    private String        email;
    private String        passwordHash;
    private String        role;          // STUDENT | COMPANY | ADMIN
    private boolean       isActive;
    private LocalDateTime createdAt;

    public User() {}

    public User(int id, String email, String role) {
        this.id    = id;
        this.email = email;
        this.role  = role;
    }

    // ── Getters & Setters ─────────────────────────────────────────────────────

    public int getId()                          { return id; }
    public void setId(int id)                   { this.id = id; }

    public String getEmail()                    { return email; }
    public void setEmail(String email)          { this.email = email; }

    public String getPasswordHash()             { return passwordHash; }
    public void setPasswordHash(String h)       { this.passwordHash = h; }

    public String getRole()                     { return role; }
    public void setRole(String role)            { this.role = role; }

    public boolean isActive()                   { return isActive; }
    public void setActive(boolean active)       { isActive = active; }

    public LocalDateTime getCreatedAt()         { return createdAt; }
    public void setCreatedAt(LocalDateTime t)   { this.createdAt = t; }
}
