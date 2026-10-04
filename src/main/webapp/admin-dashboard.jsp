<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Security check: Ensure only authenticated ADMIN users can access this page
    com.harini.harinimart.model.User authUser = (com.harini.harinimart.model.User) session.getAttribute("user");
    if (authUser == null || !"ADMIN".equalsIgnoreCase(authUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HariniMart - Admin Dashboard</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body class="bg-light">
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/admin-dashboard.jsp">HariniMart Admin</a>
        <div class="ml-auto">
            <span class="text-white mr-3">Welcome, <%= authUser.getUsername() %></span>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm">Logout</a>
        </div>
    </nav>

    <div class="container">
        <h2 class="mb-4">Admin Dashboard</h2>
        <p class="text-muted">You have full control over HariniMart catalog and orders.</p>
        <hr class="mb-4">

        <div class="row">
            <div class="col-md-6 mb-3">
                <div class="card shadow-sm border-0 p-4 bg-white">
                    <h4 class="text-primary">Product Management</h4>
                    <p class="text-muted">Add new products to the catalog, update prices, or manage stock levels.</p>
                    <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-primary btn-block">Manage Products</a>
                </div>
            </div>
            <div class="col-md-6 mb-3">
                <div class="card shadow-sm border-0 p-4 bg-white">
                    <h4 class="text-success">Customer Orders</h4>
                    <p class="text-muted">View all orders placed by customers through Cash on Delivery.</p>
                    <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-success btn-block">View Orders</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>