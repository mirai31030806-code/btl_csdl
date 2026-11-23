package com.busmanager.controller;

import com.busmanager.dao.RouteDAO;
import com.busmanager.model.Route;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/routes")
public class RouteServlet extends HttpServlet {
    private final RouteDAO dao = new RouteDAO();
    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("routes", dao.findAll());
        req.getRequestDispatcher("/routes.jsp").forward(req, resp);
    }
    @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        try {
            if ("delete".equals(action)) dao.delete(Integer.parseInt(req.getParameter("id")));
            else {
                Route r = new Route(); r.setRouteCode(req.getParameter("routeCode"));
                r.setStartPoint(req.getParameter("startPoint")); r.setEndPoint(req.getParameter("endPoint"));
                r.setDistanceKm(new BigDecimal(req.getParameter("distanceKm")));
                r.setComplexityLevel(Integer.parseInt(req.getParameter("complexityLevel")));
                r.setTicketPrice(Long.parseLong(req.getParameter("ticketPrice"))); dao.insert(r);
            }
            resp.sendRedirect(req.getContextPath()+"/routes");
        } catch (RuntimeException e) {
            resp.sendError(400, e.getMessage());
        }
    }
}
