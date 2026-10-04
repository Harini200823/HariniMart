package com.harini.harinimart.controller;

import com.harini.harinimart.dao.ProductDAO;
import com.harini.harinimart.dao.ProductDAOImpl;
import com.harini.harinimart.model.Product;
import com.harini.harinimart.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/seller/add-product")
public class AddProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProductDAO productDAO = new ProductDAOImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"SELLER".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            String name = request.getParameter("name");
            String category = request.getParameter("category");
            double price = Double.parseDouble(request.getParameter("price"));
            int stock = Integer.parseInt(request.getParameter("stock"));

            Product product = new Product();
            product.setName(name);
            product.setCategory(category);
            product.setPrice(price);
            product.setStock(stock);

            // Assuming productDAO has an addProduct method
            productDAO.addProduct(product);

        } catch (Exception e) {
            e.printStackTrace();
        }

        // Redirect back to the manage products page
        response.sendRedirect(request.getContextPath() + "/seller/products");
    }
}
