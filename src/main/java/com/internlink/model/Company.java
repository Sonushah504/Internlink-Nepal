package com.internlink.model;

import java.time.LocalDateTime;

public class Company {
    private int           id;
    private int           userId;
    private String        companyName;
    private String        industry;
    private String        description;
    private String        website;
    private String        phone;
    private String        address;
    private String        city;
    private double        latitude;
    private double        longitude;
    private String        logoPath;
    private boolean       isVerified;
    private String        employeeCount;
    private int           foundedYear;
    private LocalDateTime createdAt;
    private String        email; // joined from users table

    public Company() {}



    public int getId()                              { return id; }
    public void setId(int id)                       { this.id = id; }

    public int getUserId()                          { return userId; }
    public void setUserId(int userId)               { this.userId = userId; }

    public String getCompanyName()                  { return companyName; }
    public void setCompanyName(String n)            { this.companyName = n; }

    public String getIndustry()                     { return industry; }
    public void setIndustry(String industry)        { this.industry = industry; }

    public String getDescription()                  { return description; }
    public void setDescription(String d)            { this.description = d; }

    public String getWebsite()                      { return website; }
    public void setWebsite(String website)          { this.website = website; }

    public String getPhone()                        { return phone; }
    public void setPhone(String phone)              { this.phone = phone; }

    public String getAddress()                      { return address; }
    public void setAddress(String address)          { this.address = address; }

    public String getCity()                         { return city; }
    public void setCity(String city)                { this.city = city; }

    public double getLatitude()                     { return latitude; }
    public void setLatitude(double latitude)        { this.latitude = latitude; }

    public double getLongitude()                    { return longitude; }
    public void setLongitude(double longitude)      { this.longitude = longitude; }

    public String getLogoPath()                     { return logoPath; }
    public void setLogoPath(String logoPath)        { this.logoPath = logoPath; }

    public boolean isVerified()                     { return isVerified; }
    public void setVerified(boolean verified)       { isVerified = verified; }

    public String getEmployeeCount()                { return employeeCount; }
    public void setEmployeeCount(String e)          { this.employeeCount = e; }

    public int getFoundedYear()                     { return foundedYear; }
    public void setFoundedYear(int foundedYear)     { this.foundedYear = foundedYear; }

    public LocalDateTime getCreatedAt()             { return createdAt; }
    public void setCreatedAt(LocalDateTime t)       { this.createdAt = t; }

    public String getEmail()                        { return email; }
    public void setEmail(String email)              { this.email = email; }
}
