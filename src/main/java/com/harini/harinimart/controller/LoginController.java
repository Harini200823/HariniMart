package com.harini.harinimart.controller;

import com.harini.harinimart.model.User;
import com.harini.harinimart.service.UserService;
import com.harini.harinimart.service.UserServiceImpl;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserService userService = new UserServiceImpl();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        // Validation for empty inputs
        if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=invalid");
            return;
        }

        // Authenticate user via service layer
        User user = userService.loginUser(email.trim(), password);
        
        if (user != null) {
            HttpSession session = req.getSession();
            session.setAttribute("user", user);
            session.setAttribute("role", user.getRole());

            // Role-based redirection (Updated to point directly to root admin-dashboard.jsp)
            if ("ADMIN".equalsIgnoreCase(user.getRole())) {
                resp.sendRedirect(req.getContextPath() + "/admin-dashboard.jsp");
            } else if ("SELLER".equalsIgnoreCase(user.getRole())) {
                resp.sendRedirect(req.getContextPath() + "/seller/dashboard");
            } else {
                resp.sendRedirect(req.getContextPath() + "/products");
            }
        } else {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=invalid");
        }
    }
}