package com.busmanager.dao;

import com.busmanager.config.DBConnection;
import com.busmanager.model.Vehicle;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VehicleDAO {
    public List<Vehicle> findAll(String keyword) {
        List<Vehicle> list = new ArrayList<>();
        String sql = "SELECT * FROM vehicles WHERE (? = '' OR license_plate LIKE ? OR brand LIKE ?) ORDER BY id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String q = keyword == null ? "" : keyword.trim();
            ps.setString(1, q);
            ps.setString(2, "%" + q + "%");
            ps.setString(3, "%" + q + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Vehicle(
                    rs.getInt("id"),
                    rs.getString("license_plate"),
                    rs.getString("brand"),
                    rs.getInt("seat_count"),
                    rs.getDate("inspection_expiry"),
                    rs.getString("status")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void insert(Vehicle v) {
        String sql = "INSERT INTO vehicles(license_plate, brand, seat_count, inspection_expiry, status) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, v.getLicensePlate());
            ps.setString(2, v.getBrand());
            ps.setInt(3, v.getSeatCount());
            ps.setDate(4, v.getInspectionExpiry());
            ps.setString(5, v.getStatus());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void cycleStatus(int id) {
        String selectSql = "SELECT status FROM vehicles WHERE id = ?";
        String updateSql = "UPDATE vehicles SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement psSelect = conn.prepareStatement(selectSql)) {
            psSelect.setInt(1, id);
            ResultSet rs = psSelect.executeQuery();
            if (rs.next()) {
                String current = rs.getString("status");
                String next = switch (current) {
                    case "Sẵn sàng" -> "Đang chạy";
                    case "Đang chạy" -> "Bảo dưỡng";
                    default -> "Sẵn sàng";
                };
                try (PreparedStatement psUpdate = conn.prepareStatement(updateSql)) {
                    psUpdate.setString(1, next);
                    psUpdate.setInt(2, id);
                    psUpdate.executeUpdate();
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateStatus(int id, String status) {
        String sql = "UPDATE vehicles SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
