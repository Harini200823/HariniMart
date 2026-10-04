package com.harini.harinimart.controller;

import com.harini.harinimart.model.User;
import com.harini.harinimart.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/orders")
public class AdminOrderServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        List<Map<String, Object>> ordersList = new ArrayList<>();
        String sql = "SELECT o.id as order_id, u.username, o.total_amount, o.status, o.customer_name, o.phone, o.address, o.created_at " +
                     "FROM orders o JOIN users u ON o.customer_id = u.id ORDER BY o.created_at DESC";

        try (Connection conn = DBConnection.getDataSource().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> order = new HashMap<>();
                order.put("orderId", rs.getInt("order_id"));
                order.put("username", rs.getString("username"));
                order.put("totalAmount", rs.getDouble("total_amount"));
                order.put("status", rs.getString("status"));
                order.put("customerName", rs.getString("customer_name"));
                order.put("phone", rs.getString("phone"));
                order.put("address", rs.getString("address"));
                
                Object dateVal = rs.getTimestamp("created_at");
                String dateOnly = "N/A";
                if (dateVal != null) {
                    String tempDate = dateVal.toString();
                    if (tempDate.contains(" ")) {
                        dateOnly = tempDate.split(" ")[0];
                    } else {
                        dateOnly = tempDate;
                    }
                }
                order.put("createdAt", dateOnly);
                ordersList.add(order);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        request.setAttribute("ordersList", ordersList);
        request.getRequestDispatcher("/admin-orders.jsp").forward(request, response);
    }
}