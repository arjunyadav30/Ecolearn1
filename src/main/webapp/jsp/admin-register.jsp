<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mycompany.sih3.entity.User" %>
<%@ page import="com.mycompany.sih3.entity.UserType" %>
<%@ page import="com.mycompany.sih3.repository.UserRepository" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.security.NoSuchAlgorithmException" %>
<%
    // Check if form is submitted
    if ("POST".equals(request.getMethod())) {
        // Get form parameters
        String fullName = request.getParameter("fullName");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validate required fields
        if (fullName == null || fullName.trim().isEmpty() ||
            username == null || username.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.isEmpty() ||
            confirmPassword == null || confirmPassword.isEmpty()) {
            
            request.setAttribute("error", "missing_fields");
        }
        // Validate password match
        else if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "password_mismatch");
        }
        // Validate password length
        else if (password.length() < 8) {
            request.setAttribute("error", "invalid_password");
        }
        else {
            try {
                UserRepository userRepository = new UserRepository();
                
                // Check if username or email already exists
                User existingUserByUsername = userRepository.findByUsername(username.trim());
                if (existingUserByUsername != null) {
                    request.setAttribute("error", "user_exists");
                } else {
                    User existingUserByEmail = userRepository.findByEmail(email.trim());
                    if (existingUserByEmail != null) {
                        request.setAttribute("error", "user_exists");
                    } else {
                        // Hash the password
                        MessageDigest md = MessageDigest.getInstance("SHA-256");
                        byte[] hashedBytes = md.digest(password.getBytes());
                        StringBuilder sb = new StringBuilder();
                        for (byte b : hashedBytes) {
                            sb.append(String.format("%02x", b));
                        }
                        String hashedPassword = sb.toString();
                        
                        // Create new admin user
                        User user = new User();
                        user.setFullName(fullName.trim());
                        user.setUsername(username.trim());
                        user.setEmail(email.trim());
                        user.setPassword(hashedPassword);
                        user.setUserType(UserType.Admin); // Set as Admin
                        
                        // Save user
                        userRepository.save(user);
                        
                        // Set success flag
                        request.setAttribute("success", "true");
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "registration_failed");
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Registration - EcoLearn Platform</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-green: #2d8f44;
            --secondary-teal: #20c997;
            --accent-blue: #3498db;
            --light-gray: #f8f9fa;
            --dark-gray: #343a40;
        }
        
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #e4edf5 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            padding: 20px;
            font-family: 'Poppins', sans-serif;
        }
        
        .registration-card {
            border-radius: 1rem;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            border: none;
            overflow: hidden;
        }
        
        .card-header {
            background: linear-gradient(135deg, var(--primary-green), #1e6b30);
            color: white;
            border-bottom: none;
            padding: 1.5rem;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, var(--primary-green), #1e6b30);
            border: none;
            padding: 10px 20px;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .btn-primary:hover {
            background: linear-gradient(135deg, #1e6b30, var(--primary-green));
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(45, 143, 68, 0.3);
        }
        
        .form-control {
            padding: 12px 15px;
            border-radius: 8px;
            border: 1px solid #dee2e6;
        }
        
        .form-control:focus {
            border-color: var(--primary-green);
            box-shadow: 0 0 0 0.25rem rgba(45, 143, 68, 0.25);
        }
        
        .password-toggle {
            cursor: pointer;
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #6c757d;
        }
        
        .password-container {
            position: relative;
        }
        
        .logo {
            text-align: center;
            margin-bottom: 1.5rem;
        }
        
        .logo i {
            font-size: 3rem;
            color: var(--primary-green);
        }
        
        .logo h2 {
            color: var(--dark-gray);
            margin-top: 1rem;
            font-weight: 600;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-5">
                <div class="registration-card">
                    <div class="card-header text-center">
                        <h3 class="mb-0"><i class="fas fa-user-shield me-2"></i>Admin Registration</h3>
                        <p class="mb-0 mt-2 opacity-75">Create your admin account</p>
                    </div>
                    <div class="card-body p-4">
                        <div class="logo">
                            <i class="fas fa-leaf"></i>
                            <h2>EcoLearn Platform</h2>
                        </div>
                        
                        <!-- Success Message -->
                        <% if ("true".equals(request.getAttribute("success"))) { %>
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="fas fa-check-circle me-2"></i>Admin account created successfully!
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        <% } %>
                        
                        <!-- Error Message -->
                        <% if (request.getAttribute("error") != null) { %>
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-circle me-2"></i>
                                <% 
                                String error = (String) request.getAttribute("error");
                                if ("password_mismatch".equals(error)) {
                                    out.print("Passwords do not match!");
                                } else if ("missing_fields".equals(error)) {
                                    out.print("Please fill in all required fields!");
                                } else if ("user_exists".equals(error)) {
                                    out.print("Username or email already exists!");
                                } else if ("invalid_password".equals(error)) {
                                    out.print("Password must be at least 8 characters long!");
                                } else {
                                    out.print("Registration failed. Please try again.");
                                }
                                %>
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        <% } %>
                        
                        <form method="POST">
                            <div class="mb-3">
                                <label for="fullName" class="form-label">Full Name</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-user"></i></span>
                                    <input type="text" class="form-control" id="fullName" name="fullName" placeholder="Enter your full name" required>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="username" class="form-label">Username</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-user-tag"></i></span>
                                    <input type="text" class="form-control" id="username" name="username" placeholder="Choose a username" required>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="email" class="form-label">Email Address</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                                    <input type="email" class="form-control" id="email" name="email" placeholder="Enter your email" required>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="password" class="form-label">Password</label>
                                <div class="input-group password-container">
                                    <span class="input-group-text"><i class="fas fa-lock"></i></span>
                                    <input type="password" class="form-control" id="password" name="password" placeholder="Create a password" required>
                                    <span class="password-toggle" onclick="togglePassword('password')">
                                        <i class="fas fa-eye" id="togglePasswordIcon"></i>
                                    </span>
                                </div>
                                <div class="form-text">Password must be at least 8 characters long.</div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="confirmPassword" class="form-label">Confirm Password</label>
                                <div class="input-group password-container">
                                    <span class="input-group-text"><i class="fas fa-lock"></i></span>
                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="Confirm your password" required>
                                    <span class="password-toggle" onclick="togglePassword('confirmPassword')">
                                        <i class="fas fa-eye" id="toggleConfirmPasswordIcon"></i>
                                    </span>
                                </div>
                            </div>
                            
                            <div class="d-grid mt-4">
                                <button type="submit" class="btn btn-primary btn-lg">
                                    <i class="fas fa-user-plus me-2"></i>Create Admin Account
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript Libraries -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom JavaScript -->
    <script>
        function togglePassword(fieldId) {
            const passwordField = document.getElementById(fieldId);
            const icon = fieldId === 'password' ? 
                document.getElementById('togglePasswordIcon') : 
                document.getElementById('toggleConfirmPasswordIcon');
            
            if (passwordField.type === 'password') {
                passwordField.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                passwordField.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        }
    </script>
</body>
</html>