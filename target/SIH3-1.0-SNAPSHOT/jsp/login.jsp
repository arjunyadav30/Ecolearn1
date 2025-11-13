<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - EcoLearn Platform</title>
    <link rel="stylesheet" href="../css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .login-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 20px;
            position: relative;
            overflow: hidden;
        }
        
        .floating-element {
            position: absolute;
            opacity: 0.1;
            transition: transform 3s ease-in-out;
        }
        
        .floating-element:hover {
            transform: scale(1.2) rotate(180deg);
        }
        
        .floating-element:nth-child(1) {
            top: 10%;
            left: 10%;
            font-size: 60px;
        }
        
        .floating-element:nth-child(2) {
            top: 20%;
            right: 10%;
            font-size: 80px;
        }
        
        .floating-element:nth-child(3) {
            bottom: 20%;
            left: 15%;
            font-size: 70px;
        }
        
        .floating-element:nth-child(4) {
            bottom: 10%;
            right: 20%;
            font-size: 90px;
        }
        
        .login-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 450px;
            padding: 40px;
            position: relative;
            z-index: 1;
        }
        
        .login-header {
            text-align: center;
            margin-bottom: 40px;
        }
        
        .login-header i {
            font-size: 50px;
            color: #2ecc71;
            margin-bottom: 20px;
        }
        
        .login-header h1 {
            color: #2c3e50;
            margin-bottom: 10px;
        }
        
        .login-header p {
            color: #7f8c8d;
        }
        
        .form-group {
            margin-bottom: 20px;
            position: relative;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #2c3e50;
            font-weight: 500;
        }
        
        .form-group input {
            width: 100%;
            padding: 12px;
            padding-left: 40px;
            padding-right: 40px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
            transition: border-color 0.3s;
            box-sizing: border-box;
        }
        
        .form-group input:focus {
            outline: none;
            border-color: #2ecc71;
        }
        
        .form-group .input-icon {
            position: absolute;
            left: 12px;
            top: 38px;
            color: #7f8c8d;
        }
        
        .password-toggle {
            position: absolute;
            right: 12px;
            top: 38px;
            color: #7f8c8d;
            cursor: pointer;
            transition: color 0.3s;
            background: none;
            border: none;
            padding: 0;
        }
        
        .password-toggle:hover {
            color: #2ecc71;
        }
        
        .remember-forgot {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .remember-forgot label {
            display: flex;
            align-items: center;
            color: #7f8c8d;
            font-size: 14px;
        }
        
        .remember-forgot input[type="checkbox"] {
            margin-right: 5px;
            width: auto;
        }
        
        .remember-forgot a {
            color: #2ecc71;
            text-decoration: none;
            font-size: 14px;
        }
        
        .login-btn {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #2ecc71, #27ae60);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.3s;
        }
        
        .login-btn:hover {
            transform: translateY(-2px);
        }
        
        .login-btn:disabled {
            opacity: 0.7;
            cursor: not-allowed;
        }
        
        .divider {
            text-align: center;
            margin: 30px 0;
            position: relative;
        }
        
        .divider::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            height: 1px;
            background: #ddd;
        }
        
        .divider span {
            background: white;
            padding: 0 15px;
            color: #7f8c8d;
            position: relative;
        }
        
        .social-login {
            display: flex;
            gap: 15px;
        }
        
        .social-btn {
            flex: 1;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 8px;
            background: white;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        
        .social-btn:hover {
            background: #f8f9fa;
            transform: translateY(-2px);
        }
        
        .social-btn i {
            font-size: 18px;
        }
        
        .social-btn.google i {
            color: #db4437;
        }
        
        .social-btn.facebook i {
            color: #1877f2;
        }
        
        .register-link {
            text-align: center;
            margin-top: 30px;
            color: #7f8c8d;
        }
        
        .register-link a {
            color: #2ecc71;
            text-decoration: none;
            font-weight: 600;
        }
        
        .back-home {
            position: absolute;
            top: 20px;
            left: 20px;
            color: white;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 5px;
            font-weight: 500;
            transition: opacity 0.3s;
            z-index: 2;
        }
        
        .back-home:hover {
            opacity: 0.8;
        }
        
        .spinner {
            display: inline-block;
            width: 16px;
            height: 16px;
            border: 2px solid rgba(255,255,255,0.3);
            border-radius: 50%;
            border-top-color: white;
            animation: spin 0.6s linear infinite;
        }
        
        @keyframes spin {
            to { transform: rotate(360deg); }
        }
        
        /* Internal CSS for dropdown animation */
        .role-select {
            width: 100%;
            padding: 12px;
            padding-left: 40px;
            padding-right: 40px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s ease;
            background: #f9f9f9;
            appearance: none;
            background-image: url('data:image/svg+xml;utf8,<svg fill="%237f8c8d" height="20" viewBox="0 0 20 20" width="20" xmlns="http://www.w3.org/2000/svg"><path d="M7 10l5 5 5-5H7z"/></svg>');
            background-repeat: no-repeat;
            background-position: right 10px center;
            background-size: 15px;
        }
        
        .role-select:focus {
            outline: none;
            border-color: #2ecc71;
            box-shadow: 0 0 0 2px rgba(46, 204, 113, 0.2);
        }
        
        .role-select:hover {
            background-color: #f5f5f5;
        }
        
        .role-select option {
            background: white;
            color: #2c3e50;
            padding: 10px;
        }
        
        .role-select option:checked {
            background: #ecf0f1;
            color: #27ae60;
            font-weight: bold;
        }
        
        .role-select option:hover {
            background: #f8f9fa;
        }
        
        /* Dropdown animation on selection */
        @keyframes selectGrow {
            0% {
                transform: scale(1);
                opacity: 0.8;
            }
            50% {
                transform: scale(1.05);
                opacity: 1;
            }
            100% {
                transform: scale(1);
                opacity: 0.8;
            }
        }
        
        .role-select:focus {
            animation: selectGrow 0.5s ease-out;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <!-- Floating background elements -->
        <i class="fas fa-leaf floating-element"></i>
        <i class="fas fa-tree floating-element"></i>
        <i class="fas fa-seedling floating-element"></i>
        <i class="fas fa-recycle floating-element"></i>
        
        <a href="../index.jsp" class="back-home">
            <i class="fas fa-arrow-left"></i> Back to Home
        </a>
        
        <div class="login-card">
            <div class="login-header">
                <i class="fas fa-leaf"></i>
                <h1>Welcome Back!</h1>
                <p>Login to continue your eco-journey</p>
            </div>
            
            <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-danger" style="background-color: #f8d7da; color: #721c24; padding: 12px; border-radius: 8px; margin-bottom: 20px; border: 1px solid #f5c6cb;">
                <i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("errorMessage") %>
            </div>
            <% } %>
            
            <form action="login1.jsp" method="POST" id="loginForm">
                <div class="form-group">
                    <label for="username">Username or Email</label>
                    <i class="fas fa-user input-icon"></i>
                    <input type="text" id="username" name="username" required>
                </div>
                
                <div class="form-group">
                    <label for="password">Password</label>
                    <i class="fas fa-lock input-icon"></i>
                    <input type="password" id="password" name="password" required>
                    <button type="button" class="password-toggle" onclick="togglePassword('password')">
                        <i class="fas fa-eye" id="passwordToggleIcon"></i>
                    </button>
                </div>
                
                <div class="form-group">
                    <label for="role">Login As</label>
                    <i class="fas fa-id-badge input-icon"></i>
                    <select id="role" name="role" class="form-control role-select" required>
                        <option value="">Select Role</option>
                        <option value="student">Student</option>
                        <option value="teacher">Teacher</option>
                        <option value="admin">Admin</option>
                    </select>
                </div>
                
                <div class="remember-forgot">
                    <label>
                        <input type="checkbox" name="remember"> Remember me
                    </label>
                    <a href="#">Forgot password?</a>
                </div>
                
                <button type="submit" class="login-btn" id="loginBtn">
                    <i class="fas fa-sign-in-alt"></i> Login
                </button>
            </form>
            
            <div class="divider">
                <span>OR</span>
            </div>
            
            <div class="social-login">
                <button class="social-btn google" onclick="socialLogin('google')">
                    <i class="fab fa-google"></i>
                    <span>Google</span>
                </button>
                <button class="social-btn facebook" onclick="socialLogin('facebook')">
                    <i class="fab fa-facebook-f"></i>
                    <span>Facebook</span>
                </button>
            </div>
            
            <div class="register-link">
                Don't have an account? <a href="register.jsp">Sign up now</a>
            </div>
        </div>
    </div>
    
    <script>
        // Toggle password visibility
        function togglePassword(fieldId) {
            const passwordField = document.getElementById(fieldId);
            const toggleIcon = document.getElementById('passwordToggleIcon');
            
            if (passwordField.type === 'password') {
                passwordField.type = 'text';
                toggleIcon.classList.remove('fa-eye');
                toggleIcon.classList.add('fa-eye-slash');
            } else {
                passwordField.type = 'password';
                toggleIcon.classList.remove('fa-eye-slash');
                toggleIcon.classList.add('fa-eye');
            }
        }
        
        // Form submission
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            // Allow form to submit normally to the server
            // The server-side login1.jsp will handle authentication and redirection
            const btn = document.getElementById('loginBtn');
            const originalContent = btn.innerHTML;
            
            // Show loading state
            btn.innerHTML = '<span class="spinner"></span> Logging in...';
            btn.disabled = true;
            
            // Let the form submit to login1.jsp
            // No need to prevent default or handle redirection here
        });
        
        // Social login
        function socialLogin(provider) {
            alert(provider.charAt(0).toUpperCase() + provider.slice(1) + ' login coming soon!');
        }
        
        // Auto-focus username field
        window.onload = function() {
            document.getElementById('username').focus();
        };
    </script>
</body>
</html>