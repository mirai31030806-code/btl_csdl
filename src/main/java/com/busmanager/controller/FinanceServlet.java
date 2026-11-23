package com.busmanager.controller;

import com.busmanager.dao.*;
import com.busmanager.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Date;

@WebServlet("/finance")
public class FinanceServlet extends HttpServlet {
    private final FinanceDAO financeDAO = new FinanceDAO();
    private final TripDAO tripDAO = new TripDAO();
    private final VehicleDAO vehicleDAO = new VehicleDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        var revenues = financeDAO.findAllRevenues();
        var expenses = financeDAO.findAllExpenses();

        req.setAttribute("revenues", revenues);
        req.setAttribute("expenses", expenses);
        req.setAttribute("totalRevenue", revenues.stream().mapToLong(Revenue::getTotal).sum());
        req.setAttribute("totalExpense", expenses.stream().mapToLong(Expense::getAmount).sum());
        req.setAttribute("trips", tripDAO.findAll("ALL"));
        req.setAttribute("vehicles", vehicleDAO.findAll(""));

        req.getRequestDispatcher("/finance.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String type = req.getParameter("formType");

        if ("revenue".equals(type)) {
            Revenue r = new Revenue();
            r.setTripId(Integer.parseInt(req.getParameter("tripId")));
            r.setTicketRevenue(Long.parseLong(req.getParameter("ticketRevenue")));
            r.setCargoRevenue(Long.parseLong(req.getParameter("cargoRevenue")));
            r.setRecordedDate(Date.valueOf(req.getParameter("recordedDate")));
            financeDAO.insertRevenue(r);
        } else if ("expense".equals(type)) {
            Expense exp = new Expense();
            exp.setVehicleId(Integer.parseInt(req.getParameter("vehicleId")));
            exp.setExpenseType(req.getParameter("expenseType"));
            exp.setAmount(Long.parseLong(req.getParameter("amount")));
            exp.setExpenseDate(Date.valueOf(req.getParameter("expenseDate")));
            exp.setNote(req.getParameter("note"));
            financeDAO.insertExpense(exp);
        }
        resp.sendRedirect(req.getContextPath() + "/finance");
    }
}
