package com.internlink.model;

import java.time.LocalDateTime;

public class Application {
    private int           id;
    private int           studentId;
    private int           jobId;
    private String        coverLetter;
    private String        status;  // PENDING | REVIEWING | SHORTLISTED | SELECTED | REJECTED
    private LocalDateTime appliedAt;
    private LocalDateTime updatedAt;
    private String        companyNotes;

    // Joined fields
    private String studentName;
    private String studentEmail;
    private String studentCgpa;
    private String studentSkills;
    private String studentExperienceType;
    private String studentCvPath;
    private String studentProfilePhoto;
    private String jobTitle;
    private String companyName;

    public Application() {}


    public int getId()                                  { return id; }
    public void setId(int id)                           { this.id = id; }

    public int getStudentId()                           { return studentId; }
    public void setStudentId(int studentId)             { this.studentId = studentId; }

    public int getJobId()                               { return jobId; }
    public void setJobId(int jobId)                     { this.jobId = jobId; }

    public String getCoverLetter()                      { return coverLetter; }
    public void setCoverLetter(String coverLetter)      { this.coverLetter = coverLetter; }

    public String getStatus()                           { return status; }
    public void setStatus(String status)                { this.status = status; }

    public LocalDateTime getAppliedAt()                 { return appliedAt; }
    public void setAppliedAt(LocalDateTime appliedAt)   { this.appliedAt = appliedAt; }

    public LocalDateTime getUpdatedAt()                 { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt)   { this.updatedAt = updatedAt; }

    public String getCompanyNotes()                     { return companyNotes; }
    public void setCompanyNotes(String companyNotes)    { this.companyNotes = companyNotes; }

    public String getStudentName()                      { return studentName; }
    public void setStudentName(String n)                { this.studentName = n; }

    public String getStudentEmail()                     { return studentEmail; }
    public void setStudentEmail(String e)               { this.studentEmail = e; }

    public String getStudentCgpa()                      { return studentCgpa; }
    public void setStudentCgpa(String c)                { this.studentCgpa = c; }

    public String getStudentSkills()                    { return studentSkills; }
    public void setStudentSkills(String s)              { this.studentSkills = s; }

    public String getStudentExperienceType()            { return studentExperienceType; }
    public void setStudentExperienceType(String t)      { this.studentExperienceType = t; }

    public String getStudentCvPath()                    { return studentCvPath; }
    public void setStudentCvPath(String cvPath)         { this.studentCvPath = cvPath; }

    public String getStudentProfilePhoto()              { return studentProfilePhoto; }
    public void setStudentProfilePhoto(String p)        { this.studentProfilePhoto = p; }
    public String getStudentProfilePhotoUrl()           { return com.internlink.util.ProfilePhotoUtil.getProfilePhotoUrl(studentProfilePhoto); }

    public String getJobTitle()                         { return jobTitle; }
    public void setJobTitle(String jobTitle)            { this.jobTitle = jobTitle; }

    public String getCompanyName()                      { return companyName; }
    public void setCompanyName(String companyName)      { this.companyName = companyName; }
}
