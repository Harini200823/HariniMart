<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.harini.harinimart.model.User, com.harini.harinimart.model.Product, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"SELLER".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    String ctx = request.getContextPath();
    @SuppressWarnings("unchecked")
    List<Product> productList = (List<Product>) request.getAttribute("productList");
%>
<!DOCTYPE html>
<html>
<head>
    <title>HariniMart - Manage Products</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body class="bg-light">
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
        <a class="navbar-brand" href="<%= ctx %>/seller/dashboard">HariniMart Seller Panel</a>
        <div class="ml-auto">
            <a href="<%= ctx %>/seller/dashboard" class="btn btn-outline-light btn-sm mr-2">Dashboard</a>
            <a href="<%= ctx %>/logout" class="btn btn-outline-danger btn-sm">Logout</a>
        </div>
    </nav>

    <div class="container">
        <h2 class="mb-4">Manage Products</h2>

        <!-- Top Bar with Back Button and Add Product Button -->
        <div class="d-flex justify-content-between align-items-center mb-3">
            <a href="<%= ctx %>/seller/dashboard" class="btn btn-secondary">&larr; Back to Dashboard</a>
            <button type="button" class="btn btn-success" data-toggle="modal" data-target="#addProductModal">
                + Add New Product
            </button>
        </div>

        <div class="card shadow-sm border-0 p-4 bg-white">
            <div class="table-responsive">
                <table class="table table-bordered table-hover">
                    <thead class="thead-dark">
                        <tr>
                            <th>ID</th>
                            <th>Product Name</th>
                            <th>Category</th>
                            <th>Price (&#8377;)</th>
                            <th>Stock</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (productList != null && !productList.isEmpty()) { 
                            for (Product p : productList) { %>
                        <tr>
                            <td>#<%= p.getId() %></td>
                            <td><%= p.getName() %></td>
                            <td><%= p.getCategory() %></td>
                            <td>&#8377;<%= p.getPrice() %></td>
                            <td><%= p.getStock() %></td>
                        </tr>
                        <%   } 
                           } else { %>
                        <tr>
                            <td colspan="5" class="text-center text-muted">No products found.</td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Add Product Modal Form -->
    <div class="modal fade" id="addProductModal" tabindex="-1" role="dialog" aria-labelledby="addProductModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <form action="<%= ctx %>/seller/add-product" method="POST">
                    <div class="modal-header">
                        <h5 class="modal-title" id="addProductModalLabel">Add New Product</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <div class="form-group">
                            <label>Product Name</label>
                            <input type="text" name="name" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label>Category</label>
                            <input type="text" name="category" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label>Price (&#8377;)</label>
                            <input type="number" step="0.01" name="price" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label>Stock Quantity</label>
                            <input type="number" name="stock" class="form-control" required>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Save Product</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS dependencies for Modal to work -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>