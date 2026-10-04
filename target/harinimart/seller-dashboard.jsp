<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.harini.harinimart.model.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"SELLER".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <title>HariniMart - Seller Dashboard</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body class="bg-light">
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
        <a class="navbar-brand" href="<%= ctx %>/products">HariniMart Seller Panel</a>
        <div class="ml-auto">
            <span class="text-white mr-3">Welcome, <b><%= user.getUsername() %></b></span>
            <a href="<%= ctx %>/logout" class="btn btn-outline-danger btn-sm">Logout</a>
        </div>
    </nav>

    <div class="container">
        <h2 class="mb-4">Seller Dashboard</h2>
        <p class="text-muted">Welcome back! Here you can manage your products and view customer orders with &#8377; currency support.</p>
        <hr class="mb-4">

        <div class="row">
            <div class="col-md-6 mb-3">
                <div class="card shadow-sm border-0 p-4 bg-white h-100">
                    <h4 class="text-primary">Product Management</h4>
                    <p class="text-muted">Add new products, update pricing, or manage your inventory catalog.</p>
                    <!-- Updated to correct seller product route -->
                    <a href="<%= ctx %>/seller/products" class="btn btn-primary btn-block mt-auto">Manage Products</a>
                </div>
            </div>
            <div class="col-md-6 mb-3">
                <div class="card shadow-sm border-0 p-4 bg-white h-100">
                    <h4 class="text-success">Customer Orders</h4>
                    <p class="text-muted">View all incoming customer orders and shipping details.</p>
                    <!-- Updated to correct seller orders route -->
                    <a href="<%= ctx %>/seller/orders" class="btn btn-success btn-block mt-auto">View Orders</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>