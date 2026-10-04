<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.harini.harinimart.model.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>HariniMart - Shopping Cart</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body class="bg-light">
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
        <a class="navbar-brand" href="products">HariniMart</a>
        <div class="ml-auto">
            <a href="products" class="btn btn-outline-light btn-sm mr-2">Continue Shopping</a>
            <a href="logout" class="btn btn-outline-danger btn-sm">Logout</a>
        </div>
    </nav>

    <div class="container">
        <h2 class="mb-4">Your Shopping Cart</h2>

        <c:choose>
            <c:when test="${not empty sessionScope.cart}">
                <div class="table-responsive bg-white p-3 shadow-sm rounded">
                    <table class="table table-bordered mb-0">
                        <thead class="thead-light">
                            <tr>
                                <th>Product Name</th>
                                <th>Price</th>
                                <th>Quantity</th>
                                <th>Total</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:set var="grandTotal" value="0" />
                            <c:forEach var="item" items="${sessionScope.cart}">
                                <c:set var="itemTotal" value="${item.product.price * item.quantity}" />
                                <c:set var="grandTotal" value="${grandTotal + itemTotal}" />
                                <tr>
                                    <td>${item.product.name}</td>
                                    <td>₹${item.product.price}</td>
                                    <td>${item.quantity}</td>
                                    <td>₹${itemTotal}</td>
                                    <td>
                                        <a href="cart?action=remove&id=${item.product.id}" class="btn btn-danger btn-sm">Remove</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <div class="d-flex justify-content-between align-items-center mt-4 p-3 bg-white shadow-sm rounded">
                    <h4>Grand Total: <span class="text-success">₹${grandTotal}</span></h4>
                    <a href="checkout" class="btn btn-success btn-lg">Proceed to Checkout</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="alert alert-info text-center" role="alert">
                    Your cart is empty! <a href="products" class="alert-link">Start shopping now</a>.
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>