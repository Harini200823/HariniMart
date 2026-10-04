package com.harini.harinimart.filter;

import com.harini.harinimart.model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization logic if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String uri = httpRequest.getRequestURI();

        // Allow public pages, static resources, login, and register without authentication
        if (uri.endsWith("login.jsp") || uri.endsWith("register.jsp") || 
            uri.endsWith("/login") || uri.endsWith("/register") || 
            uri.contains("css") || uri.contains("js")) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = httpRequest.getSession(false);
        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);

        if (isLoggedIn) {
            User user = (User) session.getAttribute("user");
            String role = user.getRole();

            // Admin restriction check
            if (uri.contains("/admin/") && !"ADMIN".equalsIgnoreCase(role)) {
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp?error=unauthorized");
                return;
            }

            // Seller restriction check
            if (uri.contains("/seller/") && !"SELLER".equalsIgnoreCase(role)) {
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp?error=unauthorized");
                return;
            }

            chain.doFilter(request, response);
        } else {
            // Redirect to login if not logged in
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp");
        }
    }

    @Override
    public void destroy() {
        // Cleanup logic if needed
    }
}