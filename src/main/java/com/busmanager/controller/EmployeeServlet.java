package com.busmanager.controller;

import com.busmanager.dao.EmployeeDAO;
import com.busmanager.model.Employee;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/employees")
public class EmployeeServlet extends HttpServlet {
    private final EmployeeDAO employeeDAO = new EmployeeDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String role = req.getParameter("role");
        req.setAttribute("selectedRole", role == null ? "ALL" : role);
        req.setAttribute("employees", employeeDAO.findAll(role));
        req.getRequestDispatcher("/employees.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String name = req.getParameter("fullName");
        String role = req.getParameter("role");
        String phone = req.getParameter("phone");
        String license = req.getParameter("licenseType");
        if (license == null || license.isBlank()) license = "Không";

        employeeDAO.insert(new Employee(0, name, role, phone, license, 0));
        resp.sendRedirect(req.getContextPath() + "/employees");
    }
}
