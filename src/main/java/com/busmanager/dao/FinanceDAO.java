package com.busmanager.dao;

import com.busmanager.config.DBConnection;
import com.busmanager.model.Expense;
import com.busmanager.model.Revenue;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FinanceDAO {
    public List<Revenue> findAllRevenues() {
        List<Revenue> list = new ArrayList<>();
        String sql = """
            SELECT r.*, t.trip_code, t.route_name
            FROM revenues r
            JOIN trips t ON r.trip_id = t.id
            ORDER BY r.id DESC
        """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Revenue r = new Revenue();
                r.setId(rs.getInt("id"));
                r.setTripId(rs.getInt("trip_id"));
                r.setTripCode(rs.getString("trip_code"));
                r.setRouteName(rs.getString("route_name"));
                r.setTicketRevenue(rs.getLong("ticket_revenue"));
                r.setCargoRevenue(rs.getLong("cargo_revenue"));
                r.setRecordedDate(rs.getDate("recorded_date"));
                list.add(r);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Expense> findAllExpenses() {
        List<Expense> list = new ArrayList<>();
        String sql = """
            SELECT e.*, v.license_plate
            FROM expenses e
            JOIN vehicles v ON e.vehicle_id = v.id
            ORDER BY e.id DESC
        """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Expense e = new Expense();
                e.setId(rs.getInt("id"));
                e.setVehicleId(rs.getInt("vehicle_id"));
                e.setLicensePlate(rs.getString("license_plate"));
                e.setExpenseType(rs.getString("expense_type"));
                e.setAmount(rs.getLong("amount"));
                e.setExpenseDate(rs.getDate("expense_date"));
                e.setNote(rs.getString("note"));
                list.add(e);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void insertRevenue(Revenue r) {
        String sql = "INSERT INTO revenues(trip_id, ticket_revenue, cargo_revenue, recorded_date) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, r.getTripId());
            ps.setLong(2, r.getTicketRevenue());
            ps.setLong(3, r.getCargoRevenue());
            ps.setDate(4, r.getRecordedDate());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void insertExpense(Expense exp) {
        String sql = "INSERT INTO expenses(vehicle_id, expense_type, amount, expense_date, note) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, exp.getVehicleId());
            ps.setString(2, exp.getExpenseType());
            ps.setLong(3, exp.getAmount());
            ps.setDate(4, exp.getExpenseDate());
            ps.setString(5, exp.getNote());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
