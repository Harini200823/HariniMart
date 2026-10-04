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

@WebServlet("/seller/orders")
public class SellerOrdersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"SELLER".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        List<Map<String, Object>> allOrders = new ArrayList<>();
        String sql = "SELECT * FROM orders ORDER BY id DESC";

        try (Connection conn = DBConnection.getDataSource().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            ResultSetMetaData metaData = rs.getMetaData();
            int columnCount = metaData.getColumnCount();

            while (rs.next()) {
                Map<String, Object> order = new HashMap<>();
                
                // Fetch all columns dynamically
                for (int i = 1; i <= columnCount; i++) {
                    String colName = metaData.getColumnName(i).toLowerCase();
                    order.put(colName, rs.getObject(i));
                }
                
                // Safe mapping for JSP view fields
                order.put("orderId", order.get("id"));
                order.put("totalAmount", order.get("total_amount") != null ? order.get("total_amount") : order.get("total"));
                order.put("status", order.get("status"));
                
                // Handling multiple possible column names for recipient, phone, address
                Object recipient = order.get("recipient") != null ? order.get("recipient") : 
                                   (order.get("customer_name") != null ? order.get("customer_name") : order.get("name"));
                order.put("customerName", recipient != null ? recipient : "N/A");

                Object phone = order.get("phone") != null ? order.get("phone") : order.get("mobile");
                order.put("phone", phone != null ? phone : "N/A");

                Object address = order.get("shipping_address") != null ? order.get("shipping_address") : order.get("address");
                order.put("address", address != null ? address : "N/A");

                // Extract ONLY Date (ignoring time)
                Object dateVal = order.get("date") != null ? order.get("date") : 
                                 (order.get("created_at") != null ? order.get("created_at") : order.get("order_date"));
                
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

                allOrders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        request.setAttribute("allOrders", allOrders);
        request.getRequestDispatcher("/seller-orders.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}