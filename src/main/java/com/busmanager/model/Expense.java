package com.busmanager.model;

import java.sql.Date;

public class Expense {
    private int id;
    private int vehicleId;
    private String licensePlate;
    private String expenseType;
    private long amount;
    private Date expenseDate;
    private String note;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getVehicleId() { return vehicleId; }
    public void setVehicleId(int vehicleId) { this.vehicleId = vehicleId; }
    public String getLicensePlate() { return licensePlate; }
    public void setLicensePlate(String licensePlate) { this.licensePlate = licensePlate; }
    public String getExpenseType() { return expenseType; }
    public void setExpenseType(String expenseType) { this.expenseType = expenseType; }
    public long getAmount() { return amount; }
    public void setAmount(long amount) { this.amount = amount; }
    public Date getExpenseDate() { return expenseDate; }
    public void setExpenseDate(Date expenseDate) { this.expenseDate = expenseDate; }
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
}
