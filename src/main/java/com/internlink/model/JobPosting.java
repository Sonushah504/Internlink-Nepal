package com.internlink.model;

import java.time.LocalDate;
import java.time.LocalDateTime;


public class JobPosting {
    private int           id;
    private int           companyId;
    private String        title;
    private String        description;
    private String        requirements;
    private String        skillsRequired;
    private String        jobType;          // INTERNSHIP | PART_TIME | FULL_TIME | REMOTE
    private String        experienceRequired; // FRESHER | INTERN | EXPERIENCED | ANY
    private double        minCgpa;
    private String        location;
    private String        salaryRange;
    private LocalDate     deadline;
    private boolean       isActive;
    private LocalDateTime createdAt;

    // Joined fields
    private String companyName;
    private String companyLogo;
    private String companyCity;

    public JobPosting() {}


    public int getId()                              { return id; }
    public void setId(int id)                       { this.id = id; }

    public int getCompanyId()                       { return companyId; }
    public void setCompanyId(int companyId)         { this.companyId = companyId; }

    public String getTitle()                        { return title; }
    public void setTitle(String title)              { this.title = title; }

    public String getDescription()                  { return description; }
    public void setDescription(String d)            { this.description = d; }

    public String getRequirements()                 { return requirements; }
    public void setRequirements(String r)           { this.requirements = r; }

    public String getSkillsRequired()               { return skillsRequired; }
    public void setSkillsRequired(String s)         { this.skillsRequired = s; }

    public String getJobType()                      { return jobType; }
    public void setJobType(String jobType)          { this.jobType = jobType; }

    public String getExperienceRequired()           { return experienceRequired; }
    public void setExperienceRequired(String e)     { this.experienceRequired = e; }

    public double getMinCgpa()                      { return minCgpa; }
    public void setMinCgpa(double minCgpa)          { this.minCgpa = minCgpa; }

    public String getLocation()                     { return location; }
    public void setLocation(String location)        { this.location = location; }

    public String getSalaryRange()                  { return salaryRange; }
    public void setSalaryRange(String salaryRange)  { this.salaryRange = salaryRange; }

    public LocalDate getDeadline()                  { return deadline; }
    public void setDeadline(LocalDate deadline)     { this.deadline = deadline; }

    public boolean isActive()                       { return isActive; }
    public void setActive(boolean active)           { isActive = active; }

    public LocalDateTime getCreatedAt()             { return createdAt; }
    public void setCreatedAt(LocalDateTime t)       { this.createdAt = t; }

    public String getCompanyName()                  { return companyName; }
    public void setCompanyName(String n)            { this.companyName = n; }

    public String getCompanyLogo()                  { return companyLogo; }
    public void setCompanyLogo(String l)            { this.companyLogo = l; }

    public String getCompanyCity()                  { return companyCity; }
    public void setCompanyCity(String c)            { this.companyCity = c; }
}
