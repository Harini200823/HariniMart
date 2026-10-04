<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <title>HariniMart - Checkout Form</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body class="bg-light">
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
        <a class="navbar-brand" href="<%= ctx %>/products">HariniMart Secure Checkout</a>
        <div class="ml-auto">
            <a href="<%= ctx %>/cart?action=view" class="btn btn-outline-light btn-sm">Back to Cart</a>
        </div>
    </nav>

    <div class="container mb-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card shadow-sm border-0 p-4 bg-white">
                    <h3 class="mb-4 text-center text-primary">Shipping & Payment Details</h3>
                    
                    <!-- Fixed form action with context path -->
                    <form action="<%= ctx %>/checkout" method="POST">
                        <div class="form-group">
                            <label>Full Name</label>
                            <input type="text" name="fullName" class="form-control" required placeholder="Enter your full name">
                        </div>
                        <div class="form-group">
                            <label>Email Address</label>
                            <input type="email" name="email" class="form-control" required placeholder="Enter your email">
                        </div>
                        <div class="form-group">
                            <label>Phone Number</label>
                            <input type="text" name="phone" class="form-control" required placeholder="Enter 10-digit mobile number">
                        </div>
                        <div class="form-group">
                            <label>Delivery Address</label>
                            <textarea name="address" class="form-control" rows="3" required placeholder="Street address, city, pincode"></textarea>
                        </div>
                        <div class="form-group">
                            <label>Payment Method</label>
                            <select name="paymentMethod" class="form-control bg-light">
                                <option value="COD">Cash on Delivery (COD) - ₹</option>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-success btn-block btn-lg mt-4">Place Order (₹)</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>