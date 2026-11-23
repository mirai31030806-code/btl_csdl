package com.busmanager.model;

public class Employee {
    private int id;
    private String fullName;
    private String role;
    private String phone;
    private String licenseType;
    private int tripCount;

    public Employee() {}

    public Employee(int id, String fullName, String role, String phone, String licenseType, int tripCount) {
        this.id = id;
        this.fullName = fullName;
        this.role = role;
        this.phone = phone;
        this.licenseType = licenseType;
        this.tripCount = tripCount;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getLicenseType() { return licenseType; }
    public void setLicenseType(String licenseType) { this.licenseType = licenseType; }
    public int getTripCount() { return tripCount; }
    public void setTripCount(int tripCount) { this.tripCount = tripCount; }
}
