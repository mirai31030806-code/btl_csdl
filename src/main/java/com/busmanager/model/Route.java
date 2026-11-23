package com.busmanager.model;

import java.math.BigDecimal;

public class Route {
    private int id;
    private String routeCode;
    private String startPoint;
    private String endPoint;
    private BigDecimal distanceKm;
    private int complexityLevel;
    private long ticketPrice;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getRouteCode() { return routeCode; }
    public void setRouteCode(String routeCode) { this.routeCode = routeCode; }
    public String getStartPoint() { return startPoint; }
    public void setStartPoint(String startPoint) { this.startPoint = startPoint; }
    public String getEndPoint() { return endPoint; }
    public void setEndPoint(String endPoint) { this.endPoint = endPoint; }
    public BigDecimal getDistanceKm() { return distanceKm; }
    public void setDistanceKm(BigDecimal distanceKm) { this.distanceKm = distanceKm; }
    public int getComplexityLevel() { return complexityLevel; }
    public void setComplexityLevel(int complexityLevel) { this.complexityLevel = complexityLevel; }
    public long getTicketPrice() { return ticketPrice; }
    public void setTicketPrice(long ticketPrice) { this.ticketPrice = ticketPrice; }
    public String getRouteName() { return startPoint + " - " + endPoint; }
}
