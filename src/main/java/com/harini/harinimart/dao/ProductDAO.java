package com.harini.harinimart.dao;

import com.harini.harinimart.model.Product;
import java.util.List;

public interface ProductDAO {
    boolean addProduct(Product product);
    List<Product> getAllProducts();
    List<Product> getProductsByCategory(String category);
    List<Product> getProductsBySeller(int sellerId);
    Product getProductById(int id);
    boolean deleteProduct(int id);
}
