<%@ page import="com.harini.harinimart.model.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>HariniMart - Home</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body class="bg-light">
    <div class="container mt-4">
        <!-- Header / Navigation Section -->
        <div class="d-flex justify-content-between align-items-center mb-4 border-bottom pb-3">
            <h1>Welcome to HariniMart!</h1>
            <div>
                <% 
                    User user = (User) session.getAttribute("user");
                    if (user != null) { 
                %>
                    <span class="mr-3">Hello, <b><%= user.getUsername() %></b> (<%= user.getRole() %>)</span>
                    <a href="logout" class="btn btn-outline-danger btn-sm">Logout</a>
                <% } else { %>
                    <a href="login.jsp" class="btn btn-outline-primary btn-sm">Login</a> | 
                    <a href="register.jsp" class="btn btn-primary btn-sm">Register</a>
                <% } %>
            </div>
        </div>

        <!-- Quick Navigation / Action Bar -->
        <div class="mb-4">
            <a href="products" class="btn btn-dark">Browse All Products Catalog</a>
            <c:if test="${not empty sessionScope.cart}">
                <a href="cart?action=view" class="btn btn-outline-success float-right">View Cart</a>
            </c:if>
        </div>

        <!-- Welcome Banner -->
        <div class="jumbotron bg-white shadow-sm text-center">
            <h2 class="display-4">Your One-Stop Shop!</h2>
            <p class="lead">Explore our wide range of products across Men, Women, Kids, Groceries, and Electronics.</p>
            <hr class="my-4">
            <a class="btn btn-primary btn-lg" href="products" role="load">Shop Now</a>
        </div>
    </div>
</body>
</html>
