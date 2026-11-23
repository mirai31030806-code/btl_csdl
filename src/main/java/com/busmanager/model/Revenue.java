package com.busmanager.model;

import java.sql.Date;

public class Revenue {
    private int id;
    private int tripId;
    private String tripCode;
    private String routeName;
    private long ticketRevenue;
    private long cargoRevenue;
    private Date recordedDate;

    public long getTotal() {
        return ticketRevenue + cargoRevenue;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getTripId() { return tripId; }
    public void setTripId(int tripId) { this.tripId = tripId; }
    public String getTripCode() { return tripCode; }
    public void setTripCode(String tripCode) { this.tripCode = tripCode; }
    public String getRouteName() { return routeName; }
    public void setRouteName(String routeName) { this.routeName = routeName; }
    public long getTicketRevenue() { return ticketRevenue; }
    public void setTicketRevenue(long ticketRevenue) { this.ticketRevenue = ticketRevenue; }
    public long getCargoRevenue() { return cargoRevenue; }
    public void setCargoRevenue(long cargoRevenue) { this.cargoRevenue = cargoRevenue; }
    public Date getRecordedDate() { return recordedDate; }
    public void setRecordedDate(Date recordedDate) { this.recordedDate = recordedDate; }
}
