package com.harini.harinimart.controller;

import com.harini.harinimart.model.User;
import com.harini.harinimart.service.UserService;
import com.harini.harinimart.service.UserServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/register")
public class RegisterController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserService userService = new UserServiceImpl();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Ensure proper encoding for form data
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String role = req.getParameter("role"); // CUSTOMER, SELLER, or ADMIN

        // Validate fields
        if (name == null || email == null || password == null || role == null ||
            name.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/register.jsp?error=failed");
            return;
        }

        User user = new User();
        user.setUsername(name.trim());
        user.setEmail(email.trim());
        user.setPassword(password); // Hashed inside UserServiceImpl using BCrypt
        user.setRole(role.toUpperCase());

        boolean isRegistered = userService.registerUser(user);

        if (isRegistered) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?success=registered");
        } else {
            resp.sendRedirect(req.getContextPath() + "/register.jsp?error=failed");
        }
    }
}