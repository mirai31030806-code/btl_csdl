package com.busmanager.controller;

import com.busmanager.config.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if ("logout".equals(req.getParameter("action"))) {
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        if (username == null || username.isBlank() || password == null || password.isBlank()) {
            req.setAttribute("error", "Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        String sql = "SELECT full_name FROM manager_accounts WHERE username = ? AND password = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username.trim());
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    HttpSession session = req.getSession(true);
                    session.setAttribute("loggedInManager", username.trim());
                    session.setAttribute("managerName", rs.getString("full_name"));
                    resp.sendRedirect(req.getContextPath() + "/dashboard");
                    return;
                }
            }
            req.setAttribute("error", "Sai tên đăng nhập hoặc mật khẩu quản lý.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException("Không thể xử lý đăng nhập quản lý", e);
        }
    }
}
