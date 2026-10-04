<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <title>HariniMart - My Orders</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body class="bg-light">
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
        <a class="navbar-brand" href="<%= ctx %>/products">HariniMart</a>
        <div class="ml-auto">
            <a href="<%= ctx %>/products" class="btn btn-outline-light btn-sm mr-2">Home</a>
            <a href="<%= ctx %>/cart?action=view" class="btn btn-outline-light btn-sm mr-2">Cart</a>
            <a href="<%= ctx %>/my-orders" class="btn btn-outline-light btn-sm mr-2">My Orders</a>
            <a href="<%= ctx %>/logout" class="btn btn-outline-danger btn-sm">Logout</a>
        </div>
    </nav>

    <div class="container">
        <h2 class="mb-4">📦 My Order History</h2>

        <c:choose>
            <c:when test="${not empty orderList}">
                <div class="table-responsive bg-white p-3 shadow-sm rounded">
                    <table class="table table-bordered table-striped mb-0">
                        <thead class="thead-dark">
                            <tr>
                                <th>Order ID</th>
                                <th>Recipient</th>
                                <th>Phone</th>
                                <th>Shipping Address</th>
                                <th>Total Amount (₹)</th>
                                <th>Status</th>
                                <th>Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="order" items="${orderList}">
                                <tr>
                                    <td>#${order.orderId}</td>
                                    <td>${order.customerName}</td>
                                    <td>${order.phone}</td>
                                    <td>${order.address}</td>
                                    <td>₹${order.totalAmount}</td>
                                    <td><span class="badge badge-success">${order.status}</span></td>
                                    <td>${order.createdAt}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="alert alert-info text-center shadow-sm p-4" role="alert">
                    <h4 class="alert-heading">No Orders Found!</h4>
                    <p class="mb-3">You haven't placed any orders yet. Explore our products and start shopping today.</p>
                    <a href="<%= ctx %>/products" class="btn btn-primary">Start Shopping</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>