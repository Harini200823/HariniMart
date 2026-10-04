<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - HariniMart</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Roboto', Arial, sans-serif; }
        body { background: #f1f3f6; min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 20px; }
        .topbar { position: fixed; top: 0; left: 0; right: 0; background: #2874f0; color: #fff; padding: 12px 24px; font-weight: 700; font-size: 20px; font-style: italic; box-shadow: 0 1px 3px rgba(0,0,0,0.2); }
        .reg-box { display: flex; width: 650px; max-width: 100%; background: #fff; box-shadow: 0 1px 2px 0 rgba(0,0,0,0.15); border-radius: 2px; overflow: hidden; margin-top: 40px; }
        .left-panel { background: #2874f0; color: #fff; width: 40%; padding: 40px 30px; }
        .left-panel h2 { font-size: 24px; font-weight: 500; margin-bottom: 12px; }
        .left-panel p { font-size: 15px; color: #d9e8ff; margin-bottom: 30px; }
        .left-panel ul { list-style: none; }
        .left-panel li { font-size: 14px; font-weight: 500; margin-bottom: 28px; display: flex; align-items: center; }
        .left-panel li::before { content: "✓"; background: #fff; color: #2874f0; width: 18px; height: 18px; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; font-size: 11px; margin-right: 10px; flex-shrink: 0; }
        .right-panel { width: 60%; padding: 36px 35px 24px; }
        .form-group { margin-bottom: 24px; position: relative; }
        .form-group input, .form-group select { width: 100%; border: none; border-bottom: 1.4px solid #dbdbdb; padding: 8px 2px; font-size: 15px; outline: none; background: transparent; }
        .form-group input:focus, .form-group select:focus { border-bottom: 1.4px solid #2874f0; }
        .form-group label { position: absolute; top: 8px; left: 2px; color: #878787; font-size: 15px; pointer-events: none; }
        .form-group input:focus ~ label, .form-group input:not(:placeholder-shown) ~ label { display: none; }
        .form-group.select-group label { position: static; display: block; margin-bottom: 4px; font-size: 12px; color: #878787; }
        .alert-danger { font-size: 13px; padding: 10px 12px; border-radius: 2px; margin-bottom: 18px; background: #fff0f0; color: #ff6161; border: 1px solid #ffd6d6; }
        .terms { font-size: 12px; color: #878787; margin-bottom: 22px; }
        .terms a { color: #2874f0; text-decoration: none; }
        button.reg-btn { width: 100%; background: #fb641b; color: #fff; border: none; padding: 13px; font-size: 16px; font-weight: 500; border-radius: 2px; cursor: pointer; box-shadow: 0 2px 4px 0 rgba(0,0,0,0.2); }
        button.reg-btn:hover { background: #f75e10; }
        .existing-account { display: block; text-align: center; margin-top: 20px; padding: 12px; border: 1px solid #2874f0; border-radius: 2px; color: #2874f0; font-weight: 500; font-size: 14px; text-decoration: none; }
        @media (max-width: 600px) { .reg-box { flex-direction: column; width: 100%; } .left-panel, .right-panel { width: 100%; } }
    </style>
</head>
<body>
    <div class="topbar">HariniMart</div>

    <div class="reg-box">
        <div class="left-panel">
            <h2>Looks like you're new here!</h2>
            <p>Sign up with your details to get started</p>
            <ul>
                <li>Track orders and wishlist</li>
                <li>Personalized recommendations</li>
                <li>Sell your own products</li>
            </ul>
        </div>

        <div class="right-panel">
            <% if ("failed".equals(request.getParameter("error"))) { %>
                <div class="alert-danger">Registration failed. Email may already be registered, or a field was left blank.</div>
            <% } %>

            <form action="${pageContext.request.contextPath}/register" method="post">
                <div class="form-group select-group">
                    <label for="role">Register As</label>
                    <select id="role" name="role" required>
                        <option value="CUSTOMER" selected>Customer</option>
                        <option value="SELLER">Seller</option>
                    </select>
                </div>

                <div class="form-group">
                    <input type="text" id="name" name="name" placeholder=" " required>
                    <label for="name">Full Name</label>
                </div>
                <div class="form-group">
                    <input type="email" id="email" name="email" placeholder=" " required>
                    <label for="email">Email Address</label>
                </div>
                <div class="form-group">
                    <input type="password" id="password" name="password" placeholder=" " required>
                    <label for="password">Password</label>
                </div>

                <p class="terms">By continuing, you agree to HariniMart's <a href="#">Terms of Use</a> and <a href="#">Privacy Policy</a>.</p>

                <button type="submit" class="reg-btn">Continue</button>
            </form>

            <a href="login.jsp" class="existing-account">Existing user? Log in</a>
        </div>
    </div>
</body>
</html>