package com.busmanager.controller;

import com.busmanager.dao.ReportDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;

@WebServlet("/reports")
public class ReportServlet extends HttpServlet {

    private final ReportDAO reportDAO = new ReportDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        LocalDate now = LocalDate.now();

        int year = parseIntOrDefault(req.getParameter("year"), now.getYear());
        int month = parseIntOrDefault(req.getParameter("month"), now.getMonthValue());

        String startStr = req.getParameter("startDate");
        String endStr = req.getParameter("endDate");
        Date startDate = (startStr != null && !startStr.isBlank())
                ? Date.valueOf(startStr)
                : Date.valueOf(now.withDayOfMonth(1));
        Date endDate = (endStr != null && !endStr.isBlank())
                ? Date.valueOf(endStr)
                : Date.valueOf(now.withDayOfMonth(now.lengthOfMonth()));

        try {
            req.setAttribute("year", year);
            req.setAttribute("month", month);
            req.setAttribute("startDate", startDate.toString());
            req.setAttribute("endDate", endDate.toString());

            req.setAttribute("salaries", reportDAO.getSalaryByMonth(year, month));
            req.setAttribute("vehicleRevenues", reportDAO.getVehicleRevenueByDateRange(startDate, endDate));
            req.setAttribute("maintenanceList", reportDAO.getMaintenanceSchedule());
            req.setAttribute("recordCounts", reportDAO.getRecordCounts());

            req.getRequestDispatcher("/reports.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException("Không thể tải báo cáo tổng hợp Nhóm 12", e);
        }
    }

    private int parseIntOrDefault(String raw, int defaultVal) {
        if (raw == null || raw.isBlank()) {
            return defaultVal;
        }
        try {
            return Integer.parseInt(raw.trim());
        } catch (NumberFormatException e) {
            return defaultVal;
        }
    }
}
