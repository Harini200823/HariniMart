<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>HariniMart - Admin Product Management</title>
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

    <div class="container">
        <h2 class="mb-4">Manage Products</h2>

        <c:if test="${param.success == 'added'}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                Product added successfully!
                <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
        </c:if>

        <c:if test="${param.success == 'deleted'}">
            <div class="alert alert-warning alert-dismissible fade show" role="alert">
                Product deleted successfully!
                <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
        </c:if>

        <div class="card shadow-sm border-0 p-4 mb-5 bg-white">
            <h4 class="mb-3">Add New Product</h4>
            <form action="${pageContext.request.contextPath}/admin/products" method="POST">
                <div class="form-row">
                    <div class="form-group col-md-4">
                        <label>Product Name</label>
                        <input type="text" name="name" class="form-control" required placeholder="Enter product name">
                    </div>
                    <div class="form-group col-md-4">
                        <label>Category</label>
                        <select name="category" class="form-control" required>
                            <option value="Men">Men</option>
                            <option value="Women">Women</option>
                            <option value="Kids">Kids</option>
                            <option value="Groceries">Groceries</option>
                            <option value="Electronics">Electronics</option>
                        </select>
                    </div>
                    <div class="form-group col-md-2">
                        <label>Price (₹)</label>
                        <input type="number" step="0.01" name="price" class="form-control" required placeholder="0.00">
                    </div>
                    <div class="form-group col-md-2">
                        <label>Stock</label>
                        <input type="number" name="stock" class="form-control" required placeholder="Quantity">
                    </div>
                </div>
                <div class="form-group">
                    <label>Description</label>
                    <textarea name="description" class="form-control" rows="2" required placeholder="Enter description"></textarea>
                </div>
                <div class="form-group">
                    <label>Image URL (Unsplash Link)</label>
                    <input type="text" name="imageUrl" class="form-control" required placeholder="https://images.unsplash.com/...">
                </div>
                <button type="submit" class="btn btn-primary">Add Product</button>
            </form>
        </div>

        <h4 class="mb-3">Product Catalog</h4>
        <div class="table-responsive bg-white p-3 shadow-sm rounded">
            <table class="table table-bordered mb-0">
                <thead class="thead-light">
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Category</th>
                        <th>Price</th>
                        <th>Stock</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="p" items="${productList}">
                        <tr>
                            <td>#${p.id}</td>
                            <td>${p.name}</td>
                            <td>${p.category}</td>
                            <td>₹${p.price}</td>
                            <td>${p.stock}</td>
                            <td>
                                <a href="${pageContext.request.contextPath}/admin/products?action=delete&id=${p.id}" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to delete this product?');">Delete</a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty productList}">
                        <tr>
                            <td colspan="6" class="text-center text-muted">No products added yet.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>