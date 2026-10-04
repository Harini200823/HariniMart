package com.harini.harinimart.dao;

import com.harini.harinimart.model.Product;
import com.harini.harinimart.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAOImpl implements ProductDAO {

    @Override
    public boolean addProduct(Product product) {
        String query = "INSERT INTO products (name, description, price, stock, seller_id, category, image_url) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getDataSource().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, product.getName());
            pstmt.setString(2, product.getDescription());
            pstmt.setDouble(3, product.getPrice());
            pstmt.setInt(4, product.getStock());
            pstmt.setInt(5, product.getSellerId());
            pstmt.setString(6, product.getCategory());
            pstmt.setString(7, product.getImageUrl());

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        String query = "SELECT * FROM products ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getDataSource().getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }

    @Override
    public List<Product> getProductsByCategory(String category) {
        List<Product> products = new ArrayList<>();
        String query = "SELECT * FROM products WHERE category = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getDataSource().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, category);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    products.add(mapResultSetToProduct(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }

    @Override
    public List<Product> getProductsBySeller(int sellerId) {
        List<Product> products = new ArrayList<>();
        String query = "SELECT * FROM products WHERE seller_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getDataSource().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, sellerId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    products.add(mapResultSetToProduct(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }

    @Override
    public Product getProductById(int id) {
        String query = "SELECT * FROM products WHERE id = ?";
        try (Connection conn = DBConnection.getDataSource().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToProduct(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean deleteProduct(int id) {
        String query = "DELETE FROM products WHERE id = ?";
        try (Connection conn = DBConnection.getDataSource().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Helper method to map ResultSet to Product Object
    private Product mapResultSetToProduct(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setId(rs.getInt("id"));
        p.setName(rs.getString("name"));
        p.setDescription(rs.getString("description"));
        p.setPrice(rs.getDouble("price"));
        p.setStock(rs.getInt("stock"));
        p.setSellerId(rs.getInt("seller_id"));
        p.setCategory(rs.getString("category"));
        p.setImageUrl(rs.getString("image_url"));
        p.setCreatedAt(rs.getTimestamp("created_at"));
        return p;
    }
}