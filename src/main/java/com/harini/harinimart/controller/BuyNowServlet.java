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
import java.util.HashMap;
import java.util.Map;

@WebServlet("/buy-now")
public class BuyNowServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }

        String productIdStr = request.getParameter("productId");
        String quantityStr = request.getParameter("quantity");

        if (productIdStr != null) {
            try {
                int productId = Integer.parseInt(productIdStr);
                int quantity = (quantityStr != null) ? Integer.parseInt(quantityStr) : 1;
                String sql = "SELECT id, name, price, description FROM products WHERE id = ?";
                
                try (Connection conn = DBConnection.getDataSource().getConnection();
                     PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setInt(1, productId);

                    try (ResultSet rs = stmt.executeQuery()) {
                        if (rs.next()) {
                            Map<String, Object> buyNowItem = new HashMap<>();
                            buyNowItem.put("id", rs.getInt("id"));
                            buyNowItem.put("name", rs.getString("name"));
                            buyNowItem.put("price", rs.getDouble("price"));
                            buyNowItem.put("quantity", quantity);
                            buyNowItem.put("total", rs.getDouble("price") * quantity);

                            session.setAttribute("buyNowItem", buyNowItem);
                            response.sendRedirect(request.getContextPath() + "/checkout-form.jsp");
                            return;
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect(request.getContextPath() + "/products");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}