package com.busmanager.model;

import java.sql.Date;

public class Vehicle {
    private int id;
    private String licensePlate;
    private String brand;
    private int seatCount;
    private Date inspectionExpiry;
    private String status;

    public Vehicle() {}

    public Vehicle(int id, String licensePlate, String brand, int seatCount, Date inspectionExpiry, String status) {
        this.id = id;
        this.licensePlate = licensePlate;
        this.brand = brand;
        this.seatCount = seatCount;
        this.inspectionExpiry = inspectionExpiry;
        this.status = status;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getLicensePlate() { return licensePlate; }
    public void setLicensePlate(String licensePlate) { this.licensePlate = licensePlate; }
    public String getBrand() { return brand; }
    public void setBrand(String brand) { this.brand = brand; }
    public int getSeatCount() { return seatCount; }
    public void setSeatCount(int seatCount) { this.seatCount = seatCount; }
    public Date getInspectionExpiry() { return inspectionExpiry; }
    public void setInspectionExpiry(Date inspectionExpiry) { this.inspectionExpiry = inspectionExpiry; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
