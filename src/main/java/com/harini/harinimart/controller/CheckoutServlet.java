package com.harini.harinimart.controller;

import com.harini.harinimart.model.CartItem;
import com.harini.harinimart.model.Product;
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
import java.util.List;
import java.util.Map;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        List<CartItem> cart = getCartFromSession(session);

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart?action=view");
            return;
        }

        request.getRequestDispatcher("/checkout-form.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        List<CartItem> cart = getCartFromSession(session);

        if (cart == null || cart.isEmpty()) {
            System.out.println("❌ CHECKOUT ERROR: Cart is empty or null during doPost!");
            response.sendRedirect(request.getContextPath() + "/cart?action=view");
            return;
        }

        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        double grandTotal = 0;
        for (CartItem item : cart) {
            grandTotal += item.getProduct().getPrice() * item.getQuantity();
        }

        String orderSql = "INSERT INTO orders (customer_id, total_amount, status, customer_name, phone, address) VALUES (?, ?, ?, ?, ?, ?)";
        String itemSql = "INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getDataSource().getConnection()) {
            conn.setAutoCommit(false); // Start transaction

            int orderId = 0;
            try (PreparedStatement orderStmt = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {
                orderStmt.setInt(1, user.getId());
                orderStmt.setDouble(2, grandTotal);
                orderStmt.setString(3, "CONFIRMED (COD)");
                orderStmt.setString(4, fullName);
                orderStmt.setString(5, phone);
                orderStmt.setString(6, address);
                
                int affectedRows = orderStmt.executeUpdate();

                if (affectedRows == 0) {
                    throw new SQLException("Creating order failed, no rows affected.");
                }

                try (ResultSet generatedKeys = orderStmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        orderId = generatedKeys.getInt(1);
                    } else {
                        throw new SQLException("Creating order failed, no ID obtained.");
                    }
                }
            }

            // Insert order items
            try (PreparedStatement itemStmt = conn.prepareStatement(itemSql)) {
                for (CartItem item : cart) {
                    itemStmt.setInt(1, orderId);
                    itemStmt.setInt(2, item.getProduct().getId());
                    itemStmt.setInt(3, item.getQuantity());
                    itemStmt.setDouble(4, item.getProduct().getPrice());
                    itemStmt.addBatch();
                }
                itemStmt.executeBatch();
            }

            conn.commit(); // Commit transaction successfully
            
            // Clear cart & buyNowItem session safely
            session.removeAttribute("cart");
            session.removeAttribute("cartList");
            session.removeAttribute("cartItems");
            session.removeAttribute("buyNowItem");

            // Redirect to success page
            response.sendRedirect(request.getContextPath() + "/order-success.jsp");

        } catch (SQLException e) {
            System.out.println("🚨 SQL EXCEPTION DURING CHECKOUT:");
            e.printStackTrace();
            session.setAttribute("errorMessage", "Checkout failed: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/cart?action=view");
        }
    }

    // Helper method to handle both regular Cart and Buy Now items seamlessly
    @SuppressWarnings("unchecked")
    private List<CartItem> getCartFromSession(HttpSession session) {
        if (session == null) return null;

        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            cart = (List<CartItem>) session.getAttribute("cartList");
        }
        if (cart == null || cart.isEmpty()) {
            cart = (List<CartItem>) session.getAttribute("cartItems");
        }

        // If still empty, check if user came via "Buy Now"
        if (cart == null || cart.isEmpty()) {
            Map<String, Object> buyNowItem = (Map<String, Object>) session.getAttribute("buyNowItem");
            if (buyNowItem != null && !buyNowItem.isEmpty()) {
                cart = new ArrayList<>();
                Product p = new Product();
                p.setId((Integer) buyNowItem.get("id"));
                p.setName((String) buyNowItem.get("name"));
                p.setPrice((Double) buyNowItem.get("price"));
                
                int qty = (Integer) buyNowItem.get("quantity");
                cart.add(new CartItem(p, qty));
            }
        }
        return cart;
    }
}