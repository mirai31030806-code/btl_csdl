package com.busmanager.controller;

import com.busmanager.dao.*;
import com.busmanager.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet({"", "/dashboard"})
public class DashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        VehicleDAO vehicleDAO = new VehicleDAO();
        TripDAO tripDAO = new TripDAO();
        FinanceDAO financeDAO = new FinanceDAO();

        List<Vehicle> vehicles = vehicleDAO.findAll("");
        List<Trip> trips = tripDAO.findAll("ALL");
        List<Revenue> revenues = financeDAO.findAllRevenues();
        List<Expense> expenses = financeDAO.findAllExpenses();

        long totalRevenue = revenues.stream().mapToLong(Revenue::getTotal).sum();
        long totalExpense = expenses.stream().mapToLong(Expense::getAmount).sum();
        long netProfit = totalRevenue - totalExpense;
        long readyVehicles = vehicles.stream().filter(v -> "Sẵn sàng".equals(v.getStatus())).count();

        req.setAttribute("totalRevenue", totalRevenue);
        req.setAttribute("totalExpense", totalExpense);
        req.setAttribute("netProfit", netProfit);
        req.setAttribute("totalTrips", trips.size());
        req.setAttribute("readyVehicles", readyVehicles);
        req.setAttribute("totalVehicles", vehicles.size());
        req.setAttribute("vehicles", vehicles);
        req.setAttribute("recentTrips", trips.stream().limit(5).toList());

        req.getRequestDispatcher("/dashboard.jsp").forward(req, resp);
    }
}
