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

@WebServlet("/my-orders")
public class OrderHistoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        List<Map<String, Object>> orderList = new ArrayList<>();
        String sql = "SELECT id, total_amount, status, customer_name, phone, address, created_at " +
                     "FROM orders WHERE customer_id = ? ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getDataSource().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, user.getId());

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> order = new HashMap<>();
                    order.put("orderId", rs.getInt("id"));
                    order.put("totalAmount", rs.getDouble("total_amount"));
                    order.put("status", rs.getString("status"));
                    order.put("customerName", rs.getString("customer_name"));
                    order.put("phone", rs.getString("phone"));
                    order.put("address", rs.getString("address"));
                    
                    // Extract ONLY Date (ignoring time)
                    Object dateVal = rs.getTimestamp("created_at");
                    String dateOnly = "N/A";
                    if (dateVal != null) {
                        String tempDate = dateVal.toString();
                        if (tempDate.contains(" ")) {
                            dateOnly = tempDate.split(" ")[0]; // Splits time and keeps only YYYY-MM-DD
                        } else {
                            dateOnly = tempDate;
                        }
                    }
                    order.put("createdAt", dateOnly);
                    
                    orderList.add(order);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        request.setAttribute("orderList", orderList);
        request.getRequestDispatcher("/my-orders.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}