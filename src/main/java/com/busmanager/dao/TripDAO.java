package com.busmanager.dao;

import com.busmanager.config.DBConnection;
import com.busmanager.model.Trip;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TripDAO {
    public List<Trip> findAll(String statusFilter) {
        List<Trip> list = new ArrayList<>();
        String sql = """
            SELECT t.*, v.license_plate, v.seat_count,
                   d.full_name AS driver_name, a.full_name AS assistant_name
            FROM trips t
            JOIN vehicles v ON t.vehicle_id = v.id
            JOIN employees d ON t.driver_id = d.id
            LEFT JOIN employees a ON t.assistant_id = a.id
            WHERE (? = 'ALL' OR ? = '' OR t.status = ?)
            ORDER BY t.id DESC
        """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String sf = statusFilter == null ? "ALL" : statusFilter;
            ps.setString(1, sf);
            ps.setString(2, sf);
            ps.setString(3, sf);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Trip t = new Trip();
                t.setId(rs.getInt("id"));
                t.setTripCode(rs.getString("trip_code"));
                t.setRouteName(rs.getString("route_name"));
                t.setVehicleId(rs.getInt("vehicle_id"));
                t.setLicensePlate(rs.getString("license_plate"));
                t.setSeatCount(rs.getInt("seat_count"));
                t.setDriverId(rs.getInt("driver_id"));
                t.setDriverName(rs.getString("driver_name"));
                int aid = rs.getInt("assistant_id");
                t.setAssistantId(rs.wasNull() ? null : aid);
                t.setAssistantName(rs.getString("assistant_name"));
                t.setDepartureTime(rs.getTimestamp("departure_time"));
                t.setPassengerCount(rs.getInt("passenger_count"));
                t.setStatus(rs.getString("status"));
                list.add(t);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void insert(Trip t, int routeId) {
        String sql = "INSERT INTO trips(trip_code, route_id, route_name, vehicle_id, driver_id, assistant_id, departure_time, passenger_count, ticket_price, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        String assignmentSql = "INSERT INTO assignments(trip_id, role, employee_id) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, t.getTripCode());
                ps.setInt(2, routeId);
                ps.setString(3, t.getRouteName());
                ps.setInt(4, t.getVehicleId());
                ps.setInt(5, t.getDriverId());
                if (t.getAssistantId() == null) ps.setNull(6, Types.INTEGER);
                else ps.setInt(6, t.getAssistantId());
                ps.setTimestamp(7, t.getDepartureTime());
                ps.setInt(8, t.getPassengerCount());
                ps.setLong(9, routePrice(conn, routeId));
                ps.setString(10, t.getStatus());
                ps.executeUpdate();
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (!keys.next()) throw new SQLException("Không lấy được mã chuyến xe mới");
                    int tripId = keys.getInt(1);
                    try (PreparedStatement ap = conn.prepareStatement(assignmentSql)) {
                        ap.setInt(1, tripId); ap.setString(2, "Tài xế"); ap.setInt(3, t.getDriverId()); ap.executeUpdate();
                        if (t.getAssistantId() != null) {
                            ap.setInt(1, tripId); ap.setString(2, "Phụ xe"); ap.setInt(3, t.getAssistantId()); ap.executeUpdate();
                        }
                    }
                }
                conn.commit();
            } catch (SQLException e) { conn.rollback(); throw e; }
            finally { conn.setAutoCommit(true); }
        } catch (SQLException e) {
            throw new IllegalStateException("Không thể tạo chuyến xe và phân công nhân viên", e);
        }
    }

    private long routePrice(Connection conn, int routeId) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement("SELECT ticket_price FROM routes WHERE id=?")) {
            ps.setInt(1, routeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) throw new SQLException("Tuyến xe không tồn tại");
                return rs.getLong(1);
            }
        }
    }

    public void updateTrip(int id, String status, int passengerCount) {
        String sql = "UPDATE trips SET status = ?, passenger_count = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, passengerCount);
            ps.setInt(3, id);
            ps.executeUpdate();

            if ("Hoàn thành".equals(status)) {
                String getVehSql = "SELECT vehicle_id FROM trips WHERE id = ?";
                try (PreparedStatement psVeh = conn.prepareStatement(getVehSql)) {
                    psVeh.setInt(1, id);
                    ResultSet rs = psVeh.executeQuery();
                    if (rs.next()) {
                        new VehicleDAO().updateStatus(rs.getInt("vehicle_id"), "Sẵn sàng");
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
