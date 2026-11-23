package com.busmanager.controller;

import com.busmanager.dao.*;
import com.busmanager.model.Trip;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;

@WebServlet("/trips")
public class TripServlet extends HttpServlet {
    private final TripDAO tripDAO = new TripDAO();
    private final VehicleDAO vehicleDAO = new VehicleDAO();
    private final EmployeeDAO employeeDAO = new EmployeeDAO();
    private final RouteDAO routeDAO = new RouteDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String status = req.getParameter("status");
        req.setAttribute("selectedStatus", status == null ? "ALL" : status);
        req.setAttribute("trips", tripDAO.findAll(status));
        req.setAttribute("vehicles", vehicleDAO.findAll(""));
        req.setAttribute("routes", routeDAO.findAll());
        req.setAttribute("employees", employeeDAO.findAll("ALL"));
        req.getRequestDispatcher("/trips.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        if ("update".equals(action)) {
            int tripId = Integer.parseInt(req.getParameter("tripId"));
            String status = req.getParameter("status");
            int passengers = Integer.parseInt(req.getParameter("passengerCount"));
            tripDAO.updateTrip(tripId, status, passengers);
        } else {
            int routeId = Integer.parseInt(req.getParameter("routeId"));
            com.busmanager.model.Route route = routeDAO.findById(routeId);
            if (route == null) throw new IllegalArgumentException("Tuyến xe không tồn tại");
            int vehicleId = Integer.parseInt(req.getParameter("vehicleId"));
            int driverId = Integer.parseInt(req.getParameter("driverId"));
            String assistantParam = req.getParameter("assistantId");
            Integer assistantId = (assistantParam == null || assistantParam.isBlank()) ? null : Integer.parseInt(assistantParam);

            LocalDateTime ldt = LocalDateTime.parse(req.getParameter("departureTime"));
            int passengers = Integer.parseInt(req.getParameter("passengerCount"));
            com.busmanager.model.Vehicle selectedVehicle = vehicleDAO.findAll("").stream()
                    .filter(v -> v.getId() == vehicleId).findFirst().orElseThrow(() -> new IllegalArgumentException("Không tìm thấy xe"));
            if (passengers < 0 || passengers > selectedVehicle.getSeatCount() - 2)
                throw new IllegalArgumentException("Số hành khách không được vượt quá số ghế trừ 2 (" + (selectedVehicle.getSeatCount() - 2) + ")");

            Trip t = new Trip();
            t.setTripCode("CH-" + System.currentTimeMillis());
            t.setRouteName(route.getRouteName());
            t.setVehicleId(vehicleId);
            t.setDriverId(driverId);
            t.setAssistantId(assistantId);
            t.setDepartureTime(Timestamp.valueOf(ldt));
            t.setPassengerCount(passengers);
            t.setStatus("Sắp khởi hành");

            tripDAO.insert(t, routeId);
            vehicleDAO.updateStatus(vehicleId, "Đang chạy");
        }
        resp.sendRedirect(req.getContextPath() + "/trips");
    }
}
