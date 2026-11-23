package com.busmanager.model;

import java.sql.Timestamp;

public class Trip {
    private int id;
    private String tripCode;
    private String routeName;
    private int vehicleId;
    private String licensePlate;
    private int seatCount;
    private int driverId;
    private String driverName;
    private Integer assistantId;
    private String assistantName;
    private Timestamp departureTime;
    private int passengerCount;
    private String status;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getTripCode() { return tripCode; }
    public void setTripCode(String tripCode) { this.tripCode = tripCode; }
    public String getRouteName() { return routeName; }
    public void setRouteName(String routeName) { this.routeName = routeName; }
    public int getVehicleId() { return vehicleId; }
    public void setVehicleId(int vehicleId) { this.vehicleId = vehicleId; }
    public String getLicensePlate() { return licensePlate; }
    public void setLicensePlate(String licensePlate) { this.licensePlate = licensePlate; }
    public int getSeatCount() { return seatCount; }
    public void setSeatCount(int seatCount) { this.seatCount = seatCount; }
    public int getDriverId() { return driverId; }
    public void setDriverId(int driverId) { this.driverId = driverId; }
    public String getDriverName() { return driverName; }
    public void setDriverName(String driverName) { this.driverName = driverName; }
    public Integer getAssistantId() { return assistantId; }
    public void setAssistantId(Integer assistantId) { this.assistantId = assistantId; }
    public String getAssistantName() { return assistantName; }
    public void setAssistantName(String assistantName) { this.assistantName = assistantName; }
    public Timestamp getDepartureTime() { return departureTime; }
    public void setDepartureTime(Timestamp departureTime) { this.departureTime = departureTime; }
    public int getPassengerCount() { return passengerCount; }
    public void setPassengerCount(int passengerCount) { this.passengerCount = passengerCount; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
