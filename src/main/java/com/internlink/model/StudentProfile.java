package com.internlink.model;


public class StudentProfile {
    private int    id;
    private int    userId;
    private String fullName;
    private String phone;
    private String address;
    private String university;
    private String program;
    private int    semester;
    private double cgpa;
    private String skills;
    private String githubUrl;
    private String linkedinUrl;
    private String cvPath;
    private String profilePhoto;
    private String experienceType; // FRESHER | INTERN | EXPERIENCED
    private int    profileScore;
    private String bio;
    private String email; // joined from users table

    public StudentProfile() {}


    public int getId()                              { return id; }
    public void setId(int id)                       { this.id = id; }

    public int getUserId()                          { return userId; }
    public void setUserId(int userId)               { this.userId = userId; }

    public String getFullName()                     { return fullName; }
    public void setFullName(String fullName)        { this.fullName = fullName; }

    public String getPhone()                        { return phone; }
    public void setPhone(String phone)              { this.phone = phone; }

    public String getAddress()                      { return address; }
    public void setAddress(String address)          { this.address = address; }

    public String getUniversity()                   { return university; }
    public void setUniversity(String university)    { this.university = university; }

    public String getProgram()                      { return program; }
    public void setProgram(String program)          { this.program = program; }

    public int getSemester()                        { return semester; }
    public void setSemester(int semester)           { this.semester = semester; }

    public double getCgpa()                         { return cgpa; }
    public void setCgpa(double cgpa)                { this.cgpa = cgpa; }

    public String getSkills()                       { return skills; }
    public void setSkills(String skills)            { this.skills = skills; }

    public String getGithubUrl()                    { return githubUrl; }
    public void setGithubUrl(String githubUrl)      { this.githubUrl = githubUrl; }

    public String getLinkedinUrl()                  { return linkedinUrl; }
    public void setLinkedinUrl(String linkedinUrl)  { this.linkedinUrl = linkedinUrl; }

    public String getCvPath()                       { return cvPath; }
    public void setCvPath(String cvPath)            { this.cvPath = cvPath; }

    public String getProfilePhoto()                 { return profilePhoto; }
    public void setProfilePhoto(String p)           { this.profilePhoto = p; }
    public String getProfilePhotoUrl()              { return com.internlink.util.ProfilePhotoUtil.getProfilePhotoUrl(profilePhoto); }

    public String getExperienceType()               { return experienceType; }
    public void setExperienceType(String t)         { this.experienceType = t; }

    public int getProfileScore()                    { return profileScore; }
    public void setProfileScore(int profileScore)   { this.profileScore = profileScore; }

    public String getBio()                          { return bio; }
    public void setBio(String bio)                  { this.bio = bio; }

    public String getEmail()                        { return email; }
    public void setEmail(String email)              { this.email = email; }
}
