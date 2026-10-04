<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>HariniMart - Admin Orders</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body class="bg-light">
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/admin-dashboard.jsp">HariniMart Admin</a>
        <div class="ml-auto">
            <a href="${pageContext.request.contextPath}/admin-dashboard.jsp" class="btn btn-outline-light btn-sm mr-2">Dashboard</a>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm">Logout</a>
        </div>
    </nav>

    <div class="container-fluid px-4">
        <h2 class="mb-4">Customer Orders</h2>

        <c:choose>
            <c:when test="${not empty ordersList}">
                <div class="table-responsive bg-white p-3 shadow-sm rounded">
                    <table class="table table-bordered mb-0">
                        <thead class="thead-light">
                            <tr>
                                <th>Order ID</th>
                                <th>Username</th>
                                <th>Recipient Name</th>
                                <th>Phone</th>
                                <th>Shipping Address</th>
                                <th>Total Amount</th>
                                <th>Status</th>
                                <th>Order Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="order" items="${ordersList}">
                                <tr>
                                    <td>#${order.orderId}</td>
                                    <td>${order.username}</td>
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
                <div class="alert alert-info text-center" role="alert">
                    No orders placed yet!
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>