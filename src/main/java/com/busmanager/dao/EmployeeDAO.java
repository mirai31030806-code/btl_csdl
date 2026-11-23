package com.busmanager.dao;

import com.busmanager.config.DBConnection;
import com.busmanager.model.Employee;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EmployeeDAO {
    public List<Employee> findAll(String roleFilter) {
        List<Employee> list = new ArrayList<>();
        String sql = """
            SELECT e.*,
                   (SELECT COUNT(*) FROM trips t WHERE t.driver_id = e.id OR t.assistant_id = e.id) AS trip_count
            FROM employees e
            WHERE (? = 'ALL' OR ? = '' OR e.role = ?)
            ORDER BY e.id ASC
        """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String rf = roleFilter == null ? "ALL" : roleFilter;
            ps.setString(1, rf);
            ps.setString(2, rf);
            ps.setString(3, rf);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Employee(
                    rs.getInt("id"),
                    rs.getString("full_name"),
                    rs.getString("role"),
                    rs.getString("phone"),
                    rs.getString("license_type"),
                    rs.getInt("trip_count")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void insert(Employee emp) {
        String sql = "INSERT INTO employees(full_name, role, phone, license_type) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, emp.getFullName());
            ps.setString(2, emp.getRole());
            ps.setString(3, emp.getPhone());
            ps.setString(4, emp.getLicenseType());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
