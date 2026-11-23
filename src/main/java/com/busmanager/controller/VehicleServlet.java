package com.busmanager.controller;

import com.busmanager.dao.VehicleDAO;
import com.busmanager.model.Vehicle;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Date;

@WebServlet("/vehicles")
public class VehicleServlet extends HttpServlet {
    private final VehicleDAO vehicleDAO = new VehicleDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String search = req.getParameter("search");
        req.setAttribute("search", search == null ? "" : search);
        req.setAttribute("vehicles", vehicleDAO.findAll(search));
        req.getRequestDispatcher("/vehicles.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        if ("toggleStatus".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            vehicleDAO.cycleStatus(id);
        } else {
            String plate = req.getParameter("licensePlate");
            String brand = req.getParameter("brand");
            int seats = Integer.parseInt(req.getParameter("seatCount"));
            Date expiry = Date.valueOf(req.getParameter("inspectionExpiry"));
            String status = req.getParameter("status");
            vehicleDAO.insert(new Vehicle(0, plate, brand, seats, expiry, status));
        }
        resp.sendRedirect(req.getContextPath() + "/vehicles");
    }
}
