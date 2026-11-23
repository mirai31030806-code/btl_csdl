package com.busmanager.dao;

import com.busmanager.config.DBConnection;
import com.busmanager.model.Route;
import java.sql.*;
import java.util.*;

public class RouteDAO {
    public List<Route> findAll() {
        List<Route> routes = new ArrayList<>();
        String sql = "SELECT * FROM routes ORDER BY id";
        try (Connection c = DBConnection.getConnection(); PreparedStatement p = c.prepareStatement(sql); ResultSet r = p.executeQuery()) {
            while (r.next()) {
                Route x = new Route();
                x.setId(r.getInt("id")); x.setRouteCode(r.getString("route_code"));
                x.setStartPoint(r.getString("start_point")); x.setEndPoint(r.getString("end_point"));
                x.setDistanceKm(r.getBigDecimal("distance_km")); x.setComplexityLevel(r.getInt("complexity_level"));
                x.setTicketPrice(r.getLong("ticket_price")); routes.add(x);
            }
        } catch (SQLException e) { throw new IllegalStateException("Không thể tải danh sách tuyến xe", e); }
        return routes;
    }

    public Route findById(int id) {
        String sql = "SELECT * FROM routes WHERE id=?";
        try (Connection c = DBConnection.getConnection(); PreparedStatement p = c.prepareStatement(sql)) {
            p.setInt(1, id);
            try (ResultSet r = p.executeQuery()) {
                if (!r.next()) return null;
                Route x = new Route(); x.setId(r.getInt("id")); x.setRouteCode(r.getString("route_code"));
                x.setStartPoint(r.getString("start_point")); x.setEndPoint(r.getString("end_point"));
                x.setDistanceKm(r.getBigDecimal("distance_km")); x.setComplexityLevel(r.getInt("complexity_level"));
                x.setTicketPrice(r.getLong("ticket_price")); return x;
            }
        } catch (SQLException e) { throw new IllegalStateException("Không thể tìm tuyến xe", e); }
    }

    public void insert(Route x) {
        String sql = "INSERT INTO routes(route_code,start_point,end_point,distance_km,complexity_level,ticket_price) VALUES(?,?,?,?,?,?)";
        try (Connection c = DBConnection.getConnection(); PreparedStatement p = c.prepareStatement(sql)) {
            p.setString(1,x.getRouteCode()); p.setString(2,x.getStartPoint()); p.setString(3,x.getEndPoint());
            p.setBigDecimal(4,x.getDistanceKm()); p.setInt(5,x.getComplexityLevel()); p.setLong(6,x.getTicketPrice()); p.executeUpdate();
        } catch (SQLException e) { throw new IllegalStateException("Không thể thêm tuyến xe. Kiểm tra mã tuyến có bị trùng không.", e); }
    }

    public void delete(int id) {
        try (Connection c = DBConnection.getConnection(); PreparedStatement p = c.prepareStatement("DELETE FROM routes WHERE id=?")) {
            p.setInt(1,id); p.executeUpdate();
        } catch (SQLException e) { throw new IllegalStateException("Không thể xóa tuyến đang được sử dụng bởi chuyến xe", e); }
    }
}
