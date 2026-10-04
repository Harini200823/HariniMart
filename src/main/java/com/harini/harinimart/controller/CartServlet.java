package com.harini.harinimart.controller;

import com.harini.harinimart.dao.ProductDAO;
import com.harini.harinimart.dao.ProductDAOImpl;
import com.harini.harinimart.model.CartItem;
import com.harini.harinimart.model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProductDAO productDAO = new ProductDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        @SuppressWarnings("unchecked")
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
            session.setAttribute("cart", cart);
        }

        if ("add".equalsIgnoreCase(action)) {
            try {
                // Support both 'id' and 'productId' parameter names safely
                String idParam = request.getParameter("id");
                if (idParam == null || idParam.isEmpty()) {
                    idParam = request.getParameter("productId");
                }

                if (idParam != null && !idParam.isEmpty()) {
                    int productId = Integer.parseInt(idParam);
                    Product product = productDAO.getProductById(productId);

                    if (product != null) {
                        boolean found = false;
                        for (CartItem item : cart) {
                            if (item.getProduct().getId() == productId) {
                                item.setQuantity(item.getQuantity() + 1);
                                found = true;
                                break;
                            }
                        }

                        if (!found) {
                            cart.add(new CartItem(product, 1));
                        }
                    }
                }
            } catch (NumberFormatException e) {
                System.out.println("🚨 ERROR parsing product id in CartServlet:");
                e.printStackTrace();
            }
            response.sendRedirect(request.getContextPath() + "/cart?action=view");

        } else if ("remove".equalsIgnoreCase(action)) {
            try {
                String idParam = request.getParameter("id");
                if (idParam == null || idParam.isEmpty()) {
                    idParam = request.getParameter("productId");
                }
                if (idParam != null) {
                    int productId = Integer.parseInt(idParam);
                    cart.removeIf(item -> item.getProduct().getId() == productId);
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
            response.sendRedirect(request.getContextPath() + "/cart?action=view");

        } else if ("view".equalsIgnoreCase(action)) {
            request.getRequestDispatcher("/cart.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/products");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}