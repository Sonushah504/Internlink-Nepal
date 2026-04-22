package com.internlink.model;

import java.time.LocalDateTime;

public class StudentPost {
    private String id;
    private int userId;
    private int studentId;
    private String studentName;
    private String studentProgram;
    private String studentUniversity;
    private String studentProfilePhoto;
    private String content;
    private String mediaType;
    private String mediaPath;
    private LocalDateTime createdAt;

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }
    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }
    public String getStudentProgram() { return studentProgram; }
    public void setStudentProgram(String studentProgram) { this.studentProgram = studentProgram; }
    public String getStudentUniversity() { return studentUniversity; }
    public void setStudentUniversity(String studentUniversity) { this.studentUniversity = studentUniversity; }
    public String getStudentProfilePhoto() { return studentProfilePhoto; }
    public void setStudentProfilePhoto(String studentProfilePhoto) { this.studentProfilePhoto = studentProfilePhoto; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public String getMediaType() { return mediaType; }
    public void setMediaType(String mediaType) { this.mediaType = mediaType; }
    public String getMediaPath() { return mediaPath; }
    public void setMediaPath(String mediaPath) { this.mediaPath = mediaPath; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
