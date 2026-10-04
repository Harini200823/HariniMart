
package com.harini.harinimart.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.harini.harinimart.model.User;

@WebServlet("/seller/dashboard") // Illa ungaloda URL mapping-ku etha maathiri
public class SellerDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // dashboard.jsp reads a User object under the "user" session key
        // and checks user.getRole().equals("SELLER") — the servlet must
        // check the SAME key/value.
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user != null && "SELLER".equalsIgnoreCase(user.getRole())) {

            // Forward to the dashboard JSP at the webapp root.
            // Leading slash = resolved from the webapp root, not from
            // the current URL (/seller/dashboard), so this stays correct
            // no matter what URL the servlet is mapped to.
            request.getRequestDispatcher("/seller-dashboard.jsp").forward(request, response);
        } else {
            // If not logged in or not a seller, redirect to login page
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}