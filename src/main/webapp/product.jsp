<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.harini.harinimart.model.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>HariniMart - Product Catalog</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body class="bg-light">
    <!-- Navbar with View Cart & My Orders Button -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/products">HariniMart</a>
        <div class="ml-auto d-flex align-items-center">
            <!-- View Cart Button -->
            <a href="${pageContext.request.contextPath}/cart?action=view" class="btn btn-outline-warning btn-sm mr-2">🛒 View Cart</a>
            
            <% 
                User user = (User) session.getAttribute("user");
                if (user != null) { 
            %>
                <!-- Customer My Orders Button -->
                <a href="${pageContext.request.contextPath}/my-orders" class="btn btn-outline-info btn-sm mr-3">📦 My Orders</a>

                <% if ("SELLER".equals(user.getRole()) || "ADMIN".equals(user.getRole())) { %>
                    <a href="${pageContext.request.contextPath}/admin-dashboard.jsp" class="btn btn-outline-light btn-sm mr-2">Dashboard</a>
                <% } %>

                <span class="text-white mr-3">Hello, <b><%= user.getUsername() %></b> (<%= user.getRole() %>)</span>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm">Logout</a>
            <% } else { %>
                <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-outline-light btn-sm mr-2">Login</a>
                <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-primary btn-sm">Register</a>
            <% } %>
        </div>
    </nav>

    <div class="container">
        <h2 class="mb-3">Our Product Catalog</h2>
        
        <!-- Category Filter Bar -->
        <div class="mb-4">
            <div class="btn-group" role="group" aria-label="Category Filter">
                <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-secondary ${empty selectedCategory ? 'active' : ''}">All Products</a>
                <a href="${pageContext.request.contextPath}/products?category=Men" class="btn btn-outline-secondary ${selectedCategory == 'Men' ? 'active' : ''}">Men</a>
                <a href="${pageContext.request.contextPath}/products?category=Women" class="btn btn-outline-secondary ${selectedCategory == 'Women' ? 'active' : ''}">Women</a>
                <a href="${pageContext.request.contextPath}/products?category=Kids" class="btn btn-outline-secondary ${selectedCategory == 'Kids' ? 'active' : ''}">Kids</a>
                <a href="${pageContext.request.contextPath}/products?category=Groceries" class="btn btn-outline-secondary ${selectedCategory == 'Groceries' ? 'active' : ''}">Groceries</a>
                <a href="${pageContext.request.contextPath}/products?category=Electronics" class="btn btn-outline-secondary ${selectedCategory == 'Electronics' ? 'active' : ''}">Electronics</a>
            </div>
        </div>

        <c:if test="${not empty selectedCategory}">
            <p class="text-muted">Showing category: <strong>${selectedCategory}</strong></p>
        </c:if>

        <!-- Product Grid -->
        <div class="row">
            <c:choose>
                <c:when test="${not empty productList}">
                    <c:forEach var="product" items="${productList}">
                        <div class="col-md-4 mb-4">
                            <div class="card h-100 shadow-sm border-0">
                                <!-- Product Image -->
                                <img src="${product.imageUrl}" class="card-img-top" alt="${product.name}" style="height: 180px; object-fit: cover;" onerror="this.src='https://via.placeholder.com/300x180?text=HariniMart'">
                                
                                <div class="card-body d-flex flex-column">
                                    <h5 class="card-title font-weight-bold">${product.name}</h5>
                                    <p class="card-text text-muted small">${product.description}</p>
                                    
                                    <!-- Ratings Placeholder -->
                                    <div class="mb-2 text-warning small">
                                        ★★★★☆ <span class="text-muted">(4.0 / 5)</span>
                                    </div>

                                    <h6 class="text-success font-weight-bold mt-auto">₹${product.price}</h6>
                                    <p class="text-secondary small">Available Stock: ${product.stock}</p>
                                    
                                    <!-- Action Buttons: Add to Cart & Buy Now -->
                                    <div class="mt-2">
                                        <a href="${pageContext.request.contextPath}/cart?action=add&id=${product.id}" class="btn btn-dark btn-sm btn-block mb-1">Add to Cart</a>
                                        <a href="${pageContext.request.contextPath}/buy-now?productId=${product.id}&quantity=1" class="btn btn-success btn-sm btn-block">Buy Now</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="col-12">
                        <div class="alert alert-warning text-center" role="alert">
                            No products found in this category!
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Floating Chat Widget -->
    <div id="chat-widget-container" style="position: fixed; bottom: 20px; right: 20px; z-index: 1000; font-family: Arial, sans-serif;">
        <button id="chat-toggle-btn" onclick="toggleChat()" style="background-color: #0d6efd; color: white; border: none; border-radius: 50px; padding: 12px 20px; cursor: pointer; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">💬 HariniMart AI</button>
        
        <div id="chat-box" style="display: none; width: 320px; height: 400px; background: white; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.15); flex-direction: column; overflow: hidden; margin-bottom: 10px;">
            <div style="background: #0d6efd; color: white; padding: 10px; font-weight: bold; display: flex; justify-content: space-between; align-items: center;">
                <span>HariniMart Assistant</span>
                <button onclick="toggleChat()" style="background: none; border: none; color: white; cursor: pointer; font-weight: bold; font-size: 16px;">✕</button>
            </div>
            <div id="chat-messages" style="flex: 1; padding: 10px; overflow-y: auto; font-size: 14px; background: #f8f9fa;">
                <div style="margin-bottom: 8px; background: #e2e3e5; padding: 8px; border-radius: 6px;">Hello! Ask me about HariniMart products, shipping, or returns.</div>
            </div>
            <div style="padding: 10px; border-top: 1px solid #ddd; display: flex;">
                <input type="text" id="chat-input" placeholder="Type a question..." style="flex: 1; padding: 8px; border: 1px solid #ccc; border-radius: 4px; outline: none;" onkeypress="handleKeyPress(event)">
                <button onclick="sendMessage()" style="background: #0d6efd; color: white; border: none; padding: 8px 12px; margin-left: 5px; border-radius: 4px; cursor: pointer;">Send</button>
            </div>
        </div>
    </div>

    <script>
        function toggleChat() {
            const box = document.getElementById('chat-box');
            box.style.display = box.style.display === 'none' ? 'flex' : 'none';
        }

        function handleKeyPress(e) {
            if (e.key === 'Enter') sendMessage();
        }

        function appendMessage(text, sender, isError = false) {
            const messages = document.getElementById('chat-messages');
            
            const wrapper = document.createElement('div');
            wrapper.style.marginBottom = '8px';
            wrapper.style.textAlign = (sender === 'user') ? 'right' : 'left';

            const bubble = document.createElement('span');
            bubble.style.padding = '8px 12px';
            bubble.style.borderRadius = '6px';
            bubble.style.display = 'inline-block';
            bubble.style.maxWidth = '85%';
            bubble.style.wordBreak = 'break-word';
            bubble.style.fontSize = '14px';

            if (sender === 'user') {
                bubble.style.backgroundColor = '#0d6efd';
                bubble.style.color = 'white';
            } else if (isError) {
                bubble.style.backgroundColor = '#f8d7da';
                bubble.style.color = '#721c24';
            } else {
                bubble.style.backgroundColor = '#e2e3e5';
                bubble.style.color = '#333';
            }

            bubble.textContent = text;
            wrapper.appendChild(bubble);
            messages.appendChild(wrapper);
            messages.scrollTop = messages.scrollHeight;
        }

        async function sendMessage() {
            const input = document.getElementById('chat-input');
            const text = input.value.trim();
            if (!text) return;

            // Append User Message
            appendMessage(text, 'user');
            input.value = '';

            try {
                const response = await fetch('${pageContext.request.contextPath}/api/chat', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ message: text })
                });
                const result = await response.json();
                
                let reply = "Sorry, I couldn't process that.";
                if (result.success && result.data) {
                    reply = result.data.reply;
                }

                // Append Bot Reply
                appendMessage(reply, 'bot');
            } catch (err) {
                appendMessage('Error connecting to chatbot.', 'bot', true);
            }
        }
    </script>
</body>
</html>