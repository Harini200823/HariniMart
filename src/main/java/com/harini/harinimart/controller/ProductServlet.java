package com.harini.harinimart.controller;

import com.harini.harinimart.dao.ProductDAO;
import com.harini.harinimart.dao.ProductDAOImpl;
import com.harini.harinimart.model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/products")
public class ProductServlet extends HttpServlet {
    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        // Initialize DAO implementation
        productDAO = new ProductDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Read category parameter from the request (if any)
        String category = request.getParameter("category");
        List<Product> productList;

        // Fetch products based on category filter
        if (category != null && !category.trim().isEmpty() && !category.equalsIgnoreCase("All")) {
            productList = productDAO.getProductsByCategory(category);
        } else {
            productList = productDAO.getAllProducts();
        }

        // Set attributes to pass to product.jsp
        request.setAttribute("productList", productList);
        request.setAttribute("selectedCategory", category);
        
        // Forward request and response to product.jsp view
        request.getRequestDispatcher("product.jsp").forward(request, response);
    }
}