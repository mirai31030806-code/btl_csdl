package com.busmanager.dao;

import com.busmanager.config.DBConnection;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class ReportDAO {

    public List<Map<String, Object>> getSalaryByMonth(int year, int month) throws SQLException {
        String sql =
            "SELECT e.id, e.full_name, a.role, COUNT(t.id) AS trip_count, " +
            "SUM(" +
            "  CASE WHEN a.role IN ('Tài xế', 'Lái xe') THEN 300000 ELSE 150000 END * " +
            "  CASE r.complexity_level WHEN 1 THEN 1.0 WHEN 2 THEN 1.2 WHEN 3 THEN 1.5 ELSE 1.0 END" +
            ") AS total_salary " +
            "FROM employees e " +
            "JOIN assignments a ON e.id = a.employee_id " +
            "JOIN trips t ON a.trip_id = t.id " +
            "JOIN routes r ON t.route_id = r.id " +
            "WHERE YEAR(t.departure_time) = ? AND MONTH(t.departure_time) = ? " +
            "GROUP BY e.id, e.full_name, a.role " +
            "ORDER BY total_salary DESC";

        List<Map<String, Object>> result = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, year);
            ps.setInt(2, month);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new LinkedHashMap<>();
                    row.put("employeeId", rs.getInt("id"));
                    row.put("fullName", rs.getString("full_name"));
                    row.put("role", rs.getString("role"));
                    row.put("tripCount", rs.getInt("trip_count"));
                    row.put("totalSalary", rs.getLong("total_salary"));
                    result.add(row);
                }
            }
        }
        return result;
    }

    public List<Map<String, Object>> getVehicleRevenueByDateRange(Date startDate, Date endDate) throws SQLException {
        String sql =
            "SELECT v.id, v.license_plate, v.brand, COUNT(t.id) AS trip_count, " +
            "COALESCE(SUM(t.passenger_count), 0) AS total_passengers, " +
            "COALESCE(SUM(t.passenger_count * t.ticket_price), 0) AS total_revenue " +
            "FROM vehicles v " +
            "JOIN trips t ON v.id = t.vehicle_id " +
            "WHERE DATE(t.departure_time) >= ? AND DATE(t.departure_time) <= ? " +
            "GROUP BY v.id, v.license_plate, v.brand " +
            "ORDER BY total_revenue DESC";

        List<Map<String, Object>> result = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, startDate);
            ps.setDate(2, endDate);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new LinkedHashMap<>();
                    row.put("vehicleId", rs.getInt("id"));
                    row.put("licensePlate", rs.getString("license_plate"));
                    row.put("brand", rs.getString("brand"));
                    row.put("tripCount", rs.getInt("trip_count"));
                    row.put("totalPassengers", rs.getInt("total_passengers"));
                    row.put("totalRevenue", rs.getLong("total_revenue"));
                    result.add(row);
                }
            }
        }
        return result;
    }

    public List<Map<String, Object>> getMaintenanceSchedule() throws SQLException {
        String sql =
            "SELECT v.id, v.license_plate, v.brand, v.last_maintenance, " +
            "COALESCE(SUM(r.distance_km * CASE r.complexity_level WHEN 1 THEN 1.0 WHEN 2 THEN 1.2 WHEN 3 THEN 1.5 ELSE 1.0 END), 0) AS converted_km, " +
            "DATE_ADD(" +
            "  COALESCE(v.last_maintenance, CURDATE()), " +
            "  INTERVAL GREATEST(0, 360 - FLOOR(COALESCE(SUM(r.distance_km * CASE r.complexity_level WHEN 1 THEN 1.0 WHEN 2 THEN 1.2 WHEN 3 THEN 1.5 ELSE 1.0 END), 0) / 100)) DAY" +
            ") AS next_maintenance_date " +
            "FROM vehicles v " +
            "LEFT JOIN trips t ON v.id = t.vehicle_id " +
            "  AND (v.last_maintenance IS NULL OR DATE(t.departure_time) > v.last_maintenance) " +
            "  AND DATE(t.departure_time) <= CURDATE() " +
            "LEFT JOIN routes r ON t.route_id = r.id " +
            "GROUP BY v.id, v.license_plate, v.brand, v.last_maintenance " +
            "ORDER BY next_maintenance_date ASC";

        List<Map<String, Object>> result = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            java.sql.Date today = new java.sql.Date(System.currentTimeMillis());
            while (rs.next()) {
                Date nextDate = rs.getDate("next_maintenance_date");
                boolean overdue = nextDate != null && nextDate.before(today);
                Map<String, Object> row = new LinkedHashMap<>();
                row.put("vehicleId", rs.getInt("id"));
                row.put("licensePlate", rs.getString("license_plate"));
                row.put("brand", rs.getString("brand"));
                row.put("lastMaintenance", rs.getDate("last_maintenance"));
                row.put("convertedKm", rs.getDouble("converted_km"));
                row.put("nextMaintenanceDate", nextDate);
                row.put("statusLabel", overdue ? "Quá hạn bảo dưỡng" : "Chưa đến hạn bảo dưỡng");
                result.add(row);
            }
        }
        return result;
    }

    public Map<String, Integer> getRecordCounts() throws SQLException {
        String sql =
            "SELECT 'vehicles' AS tbl, COUNT(*) AS cnt FROM vehicles " +
            "UNION ALL SELECT 'routes', COUNT(*) FROM routes " +
            "UNION ALL SELECT 'employees', COUNT(*) FROM employees " +
            "UNION ALL SELECT 'trips', COUNT(*) FROM trips " +
            "UNION ALL SELECT 'assignments', COUNT(*) FROM assignments";

        Map<String, Integer> counts = new LinkedHashMap<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                counts.put(rs.getString("tbl"), rs.getInt("cnt"));
            }
        }
        return counts;
    }
}
