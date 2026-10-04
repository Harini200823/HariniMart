<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.harini.harinimart.model.User" %>
<%
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <title>HariniMart - Order Success</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body class="bg-light">
    <div class="container text-center mt-5">
        <div class="card p-5 shadow-sm border-0 mx-auto" style="max-width: 500px;">
            <div class="card-body">
                <h1 class="text-success mb-3">🎉 Order Placed Successfully!</h1>
                <p class="text-muted">Thank you for shopping with HariniMart. Your order has been placed and confirmed successfully.</p>
                <hr>
                <a href="<%= ctx %>/products" class="btn btn-primary btn-block mt-3">Continue Shopping</a>
                <!-- Corrected link from 'orders' to '<%= ctx %>/my-orders' -->
                <a href="<%= ctx %>/my-orders" class="btn btn-outline-secondary btn-block mt-2">View My Order History</a>
            </div>
        </div>
    </div>
</body>
</html>