package com.harini.harinimart.controller;

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

@WebServlet("/admin/products")
public class AdminProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            String productId = request.getParameter("id");
            String deleteSql = "DELETE FROM products WHERE id = ?";
            try (Connection conn = DBConnection.getDataSource().getConnection();
                 PreparedStatement stmt = conn.prepareStatement(deleteSql)) {
                stmt.setInt(1, Integer.parseInt(productId));
                stmt.executeUpdate();
                response.sendRedirect(request.getContextPath() + "/admin/products?success=deleted");
                return;
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        List<Product> productList = new ArrayList<>();
        String sql = "SELECT * FROM products";

        try (Connection conn = DBConnection.getDataSource().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setDescription(rs.getString("description"));
                p.setPrice(rs.getDouble("price"));
                p.setStock(rs.getInt("stock"));
                p.setCategory(rs.getString("category"));
                p.setImageUrl(rs.getString("image_url"));
                productList.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        request.setAttribute("productList", productList);
        request.getRequestDispatcher("/admin-products.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String name = request.getParameter("name");
        String description = request.getParameter("description");
        double price = Double.parseDouble(request.getParameter("price"));
        int stock = Integer.parseInt(request.getParameter("stock"));
        String category = request.getParameter("category");
        String imageUrl = request.getParameter("imageUrl");

        String sql = "INSERT INTO products (name, description, price, stock, seller_id, category, image_url) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getDataSource().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, name);
            stmt.setString(2, description);
            stmt.setDouble(3, price);
            stmt.setInt(4, stock);
            stmt.setInt(5, user.getId());
            stmt.setString(6, category);
            stmt.setString(7, imageUrl);
            stmt.executeUpdate();

            response.sendRedirect(request.getContextPath() + "/admin/products?success=added");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/products?error=db_error");
        }
    }
}