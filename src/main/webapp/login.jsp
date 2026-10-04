<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - HariniMart</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Roboto', Arial, sans-serif; }
        body {
            background: #f1f3f6;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .topbar {
            position: fixed;
            top: 0; left: 0; right: 0;
            background: #2874f0;
            color: #fff;
            padding: 12px 24px;
            font-weight: 700;
            font-size: 20px;
            font-style: italic;
            box-shadow: 0 1px 3px rgba(0,0,0,0.2);
            z-index: 1000;
        }
        .login-box {
            display: flex;
            width: 650px;
            max-width: 100%;
            background: #fff;
            box-shadow: 0 1px 2px 0 rgba(0,0,0,0.15);
            border-radius: 2px;
            overflow: hidden;
            margin-top: 40px;
        }
        .left-panel {
            background: #2874f0;
            color: #fff;
            width: 40%;
            padding: 40px 30px;
        }
        .left-panel h2 { font-size: 26px; font-weight: 500; margin-bottom: 12px; }
        .left-panel p { font-size: 15px; color: #d9e8ff; margin-bottom: 30px; }
        .left-panel ul { list-style: none; }
        .left-panel li {
            font-size: 14px;
            font-weight: 500;
            margin-bottom: 28px;
            display: flex;
            align-items: center;
        }
        .left-panel li::before {
            content: "✓";
            background: #fff;
            color: #2874f0;
            width: 18px;
            height: 18px;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 11px;
            margin-right: 10px;
            flex-shrink: 0;
        }
        .right-panel { width: 60%; padding: 40px 35px 24px; }
        .form-group { margin-bottom: 28px; position: relative; }
        .form-group input {
            width: 100%;
            border: none;
            border-bottom: 1.4px solid #dbdbdb;
            padding: 8px 2px;
            font-size: 15px;
            outline: none;
            background: transparent;
        }
        .form-group input:focus { border-bottom: 1.4px solid #2874f0; }
        .form-group label {
            position: absolute;
            top: 8px;
            left: 2px;
            color: #878787;
            font-size: 15px;
            pointer-events: none;
        }
        .form-group input:focus ~ label,
        .form-group input:not(:placeholder-shown) ~ label { display: none; }
        .alert { font-size: 13px; padding: 10px 12px; border-radius: 2px; margin-bottom: 18px; }
        .alert-danger { background: #fff0f0; color: #ff6161; border: 1px solid #ffd6d6; }
        .alert-success { background: #e9ffe9; color: #388e3c; border: 1px solid #c7f0c7; }
        .terms { font-size: 12px; color: #878787; margin-bottom: 24px; }
        .terms a { color: #2874f0; text-decoration: none; }
        button.login-btn {
            width: 100%;
            background: #fb641b;
            color: #fff;
            border: none;
            padding: 13px;
            font-size: 16px;
            font-weight: 500;
            border-radius: 2px;
            cursor: pointer;
            box-shadow: 0 2px 4px 0 rgba(0,0,0,0.2);
        }
        button.login-btn:hover { background: #f75e10; }
        .create-account {
            display: block;
            text-align: center;
            margin-top: 20px;
            padding: 12px;
            border: 1px solid #2874f0;
            border-radius: 2px;
            color: #2874f0;
            font-weight: 500;
            font-size: 14px;
            text-decoration: none;
        }
        @media (max-width: 600px) {
            .login-box { flex-direction: column; width: 100%; }
            .left-panel, .right-panel { width: 100%; }
        }
    </style>
</head>
<body>
    <div class="topbar">HariniMart</div>

    <div class="login-box">
        <div class="left-panel">
            <h2>Login</h2>
            <p>Get access to your Orders, Wishlist and Recommendations</p>
            <ul>
                <li>Track your orders easily</li>
                <li>Personalized recommendations</li>
                <li>Faster checkout every time</li>
            </ul>
        </div>

        <div class="right-panel">
            <% if ("invalid".equals(request.getParameter("error"))) { %>
                <div class="alert alert-danger">Invalid email or password. Please try again.</div>
            <% } %>
            <% if ("registered".equals(request.getParameter("success"))) { %>
                <div class="alert alert-success">Registration successful! Please log in.</div>
            <% } %>

            <form action="${pageContext.request.contextPath}/login" method="post">
                <div class="form-group">
                    <input type="email" id="email" name="email" placeholder=" " required>
                    <label for="email">Email Address</label>
                </div>
                <div class="form-group">
                    <input type="password" id="password" name="password" placeholder=" " required>
                    <label for="password">Password</label>
                </div>

                <p class="terms">By continuing, you agree to HariniMart's <a href="#">Terms of Use</a> and <a href="#">Privacy Policy</a>.</p>

                <button type="submit" class="login-btn">Login</button>
            </form>

            <a href="register.jsp" class="create-account">New to HariniMart? Create an account</a>
        </div>
    </div>
</body>
</html>