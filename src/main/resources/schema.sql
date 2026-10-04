-- ==========================================
-- 1. CREATE TABLES
-- ==========================================

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL,
    seller_id INT NOT NULL,
    category VARCHAR(50) NOT NULL,
    image_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (seller_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    status VARCHAR(50) NOT NULL,
    customer_name VARCHAR(150),
    phone VARCHAR(20),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- ==========================================
-- 2. SEED DEFAULT USERS
-- ==========================================

MERGE INTO users (id, username, email, password, role) 
KEY(id) 
VALUES (1, 'Admin', 'admin123@gmail.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'ADMIN');

MERGE INTO users (id, username, email, password, role) 
KEY(id) 
VALUES (2, 'AdminSeller', 'seller@harinimart.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'SELLER');


-- ==========================================
-- 3. CLEAR & SEED PRODUCTS
-- ==========================================

DELETE FROM products;

-- Men Products
INSERT INTO products (name, description, price, stock, seller_id, category, image_url) VALUES ('Formal Cotton Shirt', 'Slim fit casual and formal wear shirt for men', 29.99, 50, 2, 'Men', 'https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?w=400&auto=format&fit=crop&q=80');
INSERT INTO products (name, description, price, stock, seller_id, category, image_url) VALUES ('Casual Cotton T-Shirt Combo', 'Breathable gym and casual wear t-shirts', 19.99, 55, 2, 'Men', 'https://images.unsplash.com/photo-1562157873-818bc0726f68?w=400&auto=format&fit=crop&q=80');
INSERT INTO products (name, description, price, stock, seller_id, category, image_url) VALUES ('Slim Fit Jeans', 'Classic blue stretchable denim jeans', 49.99, 40, 2, 'Men', 'https://images.unsplash.com/photo-1542272604-787c3835535d?w=400&auto=format&fit=crop&q=80');
INSERT INTO products (name, description, price, stock, seller_id, category, image_url) VALUES ('Casual Check Shirt', 'Cotton red and black checked casual shirt', 24.99, 30, 2, 'Men', 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=400&auto=format&fit=crop&q=80');
INSERT INTO products (name, description, price, stock, seller_id, category, image_url) VALUES ('Men Leather Jacket', 'Biker style brown genuine leather jacket', 89.99, 15, 2, 'Men', 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=400&auto=format&fit=crop&q=80');
INSERT INTO products (name, description, price, stock, seller_id, category, image_url) VALUES ('Cotton Chino Pants', 'Comfortable beige casual chinos for men', 34.99, 45, 2, 'Men', 'https://images.unsplash.com/photo-1624378439575-d8705ad7ae80?w=400&auto=format&fit=crop&q=80');
INSERT INTO products (name, description, price, stock, seller_id, category, image_url) VALUES ('Classic Blazer', 'Navy blue formal single-breasted blazer', 79.99, 20, 2, 'Men', 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?w=400&auto=format&fit=crop&q=80');

-- Women Products
INSERT INTO products (name, description, price, stock, seller_id, category, image_url) VALUES ('Floral Maxi Dress', 'Elegant summer party wear maxi dress', 39.99, 35, 2, 'Women', 'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?w=400&auto=format&fit=crop&q=80');
INSERT INTO products (name, description, price, stock, seller_id, category, image_url) VALUES ('Designer Silk Saree', 'Traditional ethnic wear silk saree with blouse', 69.99, 25, 2, 'Women', 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=400&auto=format&fit=crop&q=80');
INSERT INTO products (name, description, price, stock, seller_id, category, image_url) VALUES ('Casual Denim Skirt', 'High waist blue denim mini skirt', 27.99, 40, 2, 'Women', 'https://images.unsplash.com/photo-1583496661160-fb5886a0aaaa?w=400&auto=format&fit=crop&q=80');
INSERT INTO products (name, description, price, stock, seller_id, category, image_url) VALUES ('Party Wear Gown', 'Sequined glamorous evening gown', 99.99, 10, 2, 'Women', 'https://images.unsplash.com/photo-1566174053879-31528523f8ae?w=400&auto=format&fit=crop&q=80');
INSERT INTO products (name, description, price, stock, seller_id, category, image_url) VALUES ('Kurthi', 'Cotton printed straight kurthi for women', 22.99, 60, 2, 'Women', 'https://images.unsplash.com/photo-1583391733956-3750e0ff4e8b?w=400&auto=format&fit=crop&q=80');
INSERT INTO products (name, description, price, stock, seller_id, category, image_url) VALUES ('Classic Trench Coat', 'Beige waterproof long trench coat', 89.99, 15, 2, 'Women', 'https://images.unsplash.com/photo-1539109136881-3be0616acf4b?w=400&auto=format&fit=crop&q=80');

-- Kids Products
INSERT INTO products (name, description, price, stock, seller_id, category, image_url) VALUES ('Kids Cotton T-Shirt', 'Soft and colorful graphic tee for kids', 14.99, 60, 2, 'Kids', 'https://images.unsplash.com/photo-1519238263530-99bdd11df2ea?w=400&auto=format&fit=crop&q=80');
INSERT INTO products (name, description, price, stock, seller_id, category, image_url) VALUES ('Kids Party Frock', 'Pink tulle layered birthday party dress', 29.99, 20, 2, 'Kids', 'https://images.unsplash.com/photo-1622290291468-a28f7a7dc6a8?w=400&auto=format&fit=crop&q=80');
INSERT INTO products (name, description, price, stock, seller_id, category, image_url) VALUES ('Boys Casual T-Shirt', 'Comfortable red cotton t-shirt for boys', 18.99, 40, 2, 'Kids', 'https://images.unsplash.com/photo-1471286174890-9c112ffca5b4?w=400&auto=format&fit=crop&q=80');

-- Groceries Products
INSERT INTO products (name, description, price, stock, seller_id, category, image_url) VALUES ('Organic Basmati Rice', 'Premium long grain aged basmati rice 5kg', 18.50, 100, 2, 'Groceries', 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400&auto=format&fit=crop&q=80');
INSERT INTO products (name, description, price, stock, seller_id, category, image_url) VALUES ('Cold Pressed Olive Oil', 'Extra virgin healthy cooking olive oil 1L', 15.99, 40, 2, 'Groceries', 'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=400&auto=format&fit=crop&q=80');
INSERT INTO products (name, description, price, stock, seller_id, category, image_url) VALUES ('Artisan Dark Chocolate', '70% cocoa rich premium dark chocolate bar', 4.99, 90, 2, 'Groceries', 'https://images.unsplash.com/photo-1549007994-cb92caebd54b?w=400&auto=format&fit=crop&q=80');
INSERT INTO products (name, description, price, stock, seller_id, category, image_url) VALUES ('Green Tea Bags', 'Refreshing natural antioxidant green tea 100pk', 7.50, 75, 2, 'Groceries', 'https://images.unsplash.com/photo-1576092768241-dec231879fc3?w=400&auto=format&fit=crop&q=80');

-- Electronics Products
INSERT INTO products (name, description, price, stock, seller_id, category, image_url) VALUES ('Wireless Bluetooth Earbuds', 'High bass true wireless earbuds with mic', 29.99, 40, 2, 'Electronics', 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=400&auto=format&fit=crop&q=80');
INSERT INTO products (name, description, price, stock, seller_id, category, image_url) VALUES ('Wireless Studio Headphones', 'High-fidelity wireless headphones with deep bass and comfortable ear cushions', 14.99, 60, 2, 'Electronics', 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=400&auto=format&fit=crop&q=80');
INSERT INTO products (name, description, price, stock, seller_id, category, image_url) VALUES ('Smart Fitness Watch', 'Heart rate monitor, step tracker waterproof smartwatch', 49.99, 30, 2, 'Electronics', 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400&auto=format&fit=crop&q=80');
INSERT INTO products (name, description, price, stock, seller_id, category, image_url) VALUES ('Portable Bluetooth Speaker', 'Waterproof outdoor wireless booming speaker', 35.99, 25, 2, 'Electronics', 'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?w=400&auto=format&fit=crop&q=80');
INSERT INTO products (name, description, price, stock, seller_id, category, image_url) VALUES ('Wireless Ergonomic Mouse', 'Silent click optical rechargeable computer mouse', 18.99, 50, 2, 'Electronics', 'https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?w=400&auto=format&fit=crop&q=80');
INSERT INTO products (name, description, price, stock, seller_id, category, image_url) VALUES ('Over-Ear Studio Headphones', 'Deep bass comfortable wired/wireless headphones', 59.99, 18, 2, 'Electronics', 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400&auto=format&fit=crop&q=80');
INSERT INTO products (name, description, price, stock, seller_id, category, image_url) VALUES ('Wireless Keyboard', 'Slim wireless computer keyboard', 32.99, 22, 2, 'Electronics', 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=400&auto=format&fit=crop&q=80');