package com.harini.harinimart.util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

public class DBConnection {
    private static final HikariDataSource dataSource;

    static {
        try {
            HikariConfig config = new HikariConfig();
            config.setJdbcUrl("jdbc:h2:~/harinimart;AUTO_SERVER=TRUE");
            config.setUsername("sa");
            config.setPassword("");
            config.setDriverClassName("org.h2.Driver");

            // HikariCP Connection Pool settings
            config.setMaximumPoolSize(10);
            config.setMinimumIdle(2);
            config.setIdleTimeout(30000);
            config.setConnectionTimeout(10000);

            dataSource = new HikariDataSource(config);

            // Automatically setup all tables, users, and products
            initializeDatabaseAndSeedData();

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to initialize HikariCP connection pool!", e);
        }
    }

    public static HikariDataSource getDataSource() {
        return dataSource;
    }

    private static void initializeDatabaseAndSeedData() {
        try (Connection conn = dataSource.getConnection();
             Statement stmt = conn.createStatement()) {
             
            // 1. Create Users Table
            stmt.execute("CREATE TABLE IF NOT EXISTS users (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "username VARCHAR(100) NOT NULL, " +
                    "email VARCHAR(100) UNIQUE NOT NULL, " +
                    "password VARCHAR(255) NOT NULL, " +
                    "role VARCHAR(50) NOT NULL, " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");

            // 2. Create Products Table
            stmt.execute("CREATE TABLE IF NOT EXISTS products (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "name VARCHAR(150) NOT NULL, " +
                    "description TEXT, " +
                    "price DECIMAL(10, 2) NOT NULL, " +
                    "stock INT NOT NULL, " +
                    "seller_id INT NOT NULL, " +
                    "category VARCHAR(50) NOT NULL, " +
                    "image_url VARCHAR(255), " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                    "FOREIGN KEY (seller_id) REFERENCES users(id) ON DELETE CASCADE)");

            // 3. Create Orders Table
            stmt.execute("CREATE TABLE IF NOT EXISTS orders (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "customer_id INT NOT NULL, " +
                    "total_amount DECIMAL(10, 2) NOT NULL, " +
                    "status VARCHAR(50) NOT NULL, " +
                    "customer_name VARCHAR(150), " +
                    "phone VARCHAR(20), " +
                    "address TEXT, " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                    "FOREIGN KEY (customer_id) REFERENCES users(id) ON DELETE CASCADE)");

            // 4. Create Order Items Table
            stmt.execute("CREATE TABLE IF NOT EXISTS order_items (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "order_id INT NOT NULL, " +
                    "product_id INT NOT NULL, " +
                    "quantity INT NOT NULL, " +
                    "price DECIMAL(10, 2) NOT NULL, " +
                    "FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE, " +
                    "FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE)");

            // 5. Seed Default Admin & Seller
            String hashedPassword = BCrypt.hashpw("admin123", BCrypt.gensalt());
            seedUserIfNotExists(conn, 1, "Admin", "admin123@gmail.com", hashedPassword, "ADMIN");
            seedUserIfNotExists(conn, 2, "AdminSeller", "seller@harinimart.com", hashedPassword, "SELLER");

            // 6. Seed Products if table is empty
            seedProductsIfEmpty(conn);

            System.out.println(">> HariniMart: Database tables, default users, and products initialized successfully!");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static void seedUserIfNotExists(Connection conn, int id, String username, String email, String password, String role) {
        try {
            String checkSql = "SELECT 1 FROM users WHERE id = ? OR email = ?";
            try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
                ps.setInt(1, id);
                ps.setString(2, email);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        String insertSql = "INSERT INTO users (id, username, email, password, role) VALUES (?, ?, ?, ?, ?)";
                        try (PreparedStatement insertPs = conn.prepareStatement(insertSql)) {
                            insertPs.setInt(1, id);
                            insertPs.setString(2, username);
                            insertPs.setString(3, email);
                            insertPs.setString(4, password);
                            insertPs.setString(5, role);
                            insertPs.executeUpdate();
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static void seedProductsIfEmpty(Connection conn) {
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM products")) {
            if (rs.next() && rs.getInt(1) == 0) {
                // Insert Men Products
                insertProduct(conn, 'M', "Formal Cotton Shirt", "Slim fit casual and formal wear shirt for men", 29.99, 50, 2, "Men", "https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?w=400&auto=format&fit=crop&q=80");
                insertProduct(conn, 'M', "Casual Cotton T-Shirt Combo", "Breathable gym and casual wear t-shirts", 19.99, 55, 2, "Men", "https://images.unsplash.com/photo-1562157873-818bc0726f68?w=400&auto=format&fit=crop&q=80");
                insertProduct(conn, 'M', "Slim Fit Jeans", "Classic blue stretchable denim jeans", 49.99, 40, 2, "Men", "https://images.unsplash.com/photo-1542272604-787c3835535d?w=400&auto=format&fit=crop&q=80");
                insertProduct(conn, 'M', "Casual Check Shirt", "Cotton red and black checked casual shirt", 24.99, 30, 2, "Men", "https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=400&auto=format&fit=crop&q=80");
                insertProduct(conn, 'M', "Men Leather Jacket", "Biker style brown genuine leather jacket", 89.99, 15, 2, "Men", "https://images.unsplash.com/photo-1551028719-00167b16eac5?w=400&auto=format&fit=crop&q=80");
                insertProduct(conn, 'M', "Cotton Chino Pants", "Comfortable beige casual chinos for men", 34.99, 45, 2, "Men", "https://images.unsplash.com/photo-1624378439575-d8705ad7ae80?w=400&auto=format&fit=crop&q=80");
                insertProduct(conn, 'M', "Classic Blazer", "Navy blue formal single-breasted blazer", 79.99, 20, 2, "Men", "https://images.unsplash.com/photo-1507679799987-c73779587ccf?w=400&auto=format&fit=crop&q=80");

                // Insert Women Products
                insertProduct(conn, 'M', "Floral Maxi Dress", "Elegant summer party wear maxi dress", 39.99, 35, 2, "Women", "https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?w=400&auto=format&fit=crop&q=80");
                insertProduct(conn, 'M', "Designer Silk Saree", "Traditional ethnic wear silk saree with blouse", 69.99, 25, 2, "Women", "https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=400&auto=format&fit=crop&q=80");
                insertProduct(conn, 'M', "Casual Denim Skirt", "High waist blue denim mini skirt", 27.99, 40, 2, "Women", "https://images.unsplash.com/photo-1583496661160-fb5886a0aaaa?w=400&auto=format&fit=crop&q=80");
                insertProduct(conn, 'M', "Party Wear Gown", "Sequined glamorous evening gown", 99.99, 10, 2, "Women", "https://images.unsplash.com/photo-1566174053879-31528523f8ae?w=400&auto=format&fit=crop&q=80");
                insertProduct(conn, 'M', "Kurthi", "Cotton printed straight kurthi for women", 22.99, 60, 2, "Women", "https://images.unsplash.com/photo-1583391733956-3750e0ff4e8b?w=400&auto=format&fit=crop&q=80");
                insertProduct(conn, 'M', "Classic Trench Coat", "Beige waterproof long trench coat", 89.99, 15, 2, "Women", "https://images.unsplash.com/photo-1539109136881-3be0616acf4b?w=400&auto=format&fit=crop&q=80");

                // Insert Kids Products
                insertProduct(conn, 'M', "Kids Cotton T-Shirt", "Soft and colorful graphic tee for kids", 14.99, 60, 2, "Kids", "https://images.unsplash.com/photo-1519238263530-99bdd11df2ea?w=400&auto=format&fit=crop&q=80");
                insertProduct(conn, 'M', "Kids Party Frock", "Pink tulle layered birthday party dress", 29.99, 20, 2, "Kids", "https://images.unsplash.com/photo-1622290291468-a28f7a7dc6a8?w=400&auto=format&fit=crop&q=80");
                insertProduct(conn, 'M', "Boys Casual T-Shirt", "Comfortable red cotton t-shirt for boys", 18.99, 40, 2, "Kids", "https://images.unsplash.com/photo-1471286174890-9c112ffca5b4?w=400&auto=format&fit=crop&q=80");

                // Insert Groceries Products
                insertProduct(conn, 'M', "Organic Basmati Rice", "Premium long grain aged basmati rice 5kg", 18.50, 100, 2, "Groceries", "https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400&auto=format&fit=crop&q=80");
                insertProduct(conn, 'M', "Cold Pressed Olive Oil", "Extra virgin healthy cooking olive oil 1L", 15.99, 40, 2, "Groceries", "https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=400&auto=format&fit=crop&q=80");
                insertProduct(conn, 'M', "Artisan Dark Chocolate", "70% cocoa rich premium dark chocolate bar", 4.99, 90, 2, "Groceries", "https://images.unsplash.com/photo-1549007994-cb92caebd54b?w=400&auto=format&fit=crop&q=80");
                insertProduct(conn, 'M', "Green Tea Bags", "Refreshing natural antioxidant green tea 100pk", 7.50, 75, 2, "Groceries", "https://images.unsplash.com/photo-1576092768241-dec231879fc3?w=400&auto=format&fit=crop&q=80");

                // Insert Electronics Products
                insertProduct(conn, 'M', "Wireless Bluetooth Earbuds", "High bass true wireless earbuds with mic", 29.99, 40, 2, "Electronics", "https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=400&auto=format&fit=crop&q=80");
                insertProduct(conn, 'M', "Wireless Studio Headphones", "High-fidelity wireless headphones with deep bass and comfortable ear cushions", 14.99, 60, 2, "Electronics", "https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=400&auto=format&fit=crop&q=80");
                insertProduct(conn, 'M', "Smart Fitness Watch", "Heart rate monitor, step tracker waterproof smartwatch", 49.99, 30, 2, "Electronics", "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400&auto=format&fit=crop&q=80");
                insertProduct(conn, 'M', "Portable Bluetooth Speaker", "Waterproof outdoor wireless booming speaker", 35.99, 25, 2, "Electronics", "https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?w=400&auto=format&fit=crop&q=80");
                insertProduct(conn, 'M', "Wireless Ergonomic Mouse", "Silent click optical rechargeable computer mouse", 18.99, 50, 2, "Electronics", "https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?w=400&auto=format&fit=crop&q=80");
                insertProduct(conn, 'M', "Over-Ear Studio Headphones", "Deep bass comfortable wired/wireless headphones", 59.99, 18, 2, "Electronics", "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400&auto=format&fit=crop&q=80");
                insertProduct(conn, 'M', "Wireless Keyboard", "Slim wireless computer keyboard", 32.99, 22, 2, "Electronics", "https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=400&auto=format&fit=crop&q=80");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static void insertProduct(Connection conn, char dummy, String name, String desc, double price, int stock, int sellerId, String category, String imageUrl) {
        String sql = "INSERT INTO products (name, description, price, stock, seller_id, category, image_url) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, desc);
            ps.setDouble(3, price);
            ps.setInt(4, stock);
            ps.setInt(5, sellerId);
            ps.setString(6, category);
            ps.setString(7, imageUrl);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}