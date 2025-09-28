<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%
    // Database connection details
    String url = "jdbc:mysql://localhost/ecolearn";
    String usernameDB = "root";
    String passwordDB = "1234";
    
    int totalStudents = 0;
    int totalSchools = 0;
    int totalTreesPlanted = 0; // Add tree count variable
    
    // Fetch schools from database
    ArrayList<Map<String, String>> schoolsList = new ArrayList<Map<String, String>>();
    
    Connection con = null;
    PreparedStatement stmt1 = null, stmt2 = null, stmt3 = null, stmt4 = null;
    ResultSet rs1 = null, rs2 = null, rs3 = null, rs4 = null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection(url, usernameDB, passwordDB);
        
        // Count total students
        stmt1 = con.prepareStatement("SELECT COUNT(*) as studentCount FROM users WHERE user_type = 'Student'");
        rs1 = stmt1.executeQuery();
        if (rs1.next()) {
            totalStudents = rs1.getInt("studentCount");
        }
        
        // Count total schools from schools table
        stmt2 = con.prepareStatement("SELECT COUNT(*) as schoolCount FROM schools");
        rs2 = stmt2.executeQuery();
        if (rs2.next()) {
            totalSchools = rs2.getInt("schoolCount");
        }
        
        // Count total trees planted (with error handling for missing table)
        try {
            stmt3 = con.prepareStatement("SELECT COUNT(*) as treeCount FROM trees_planted");
            rs3 = stmt3.executeQuery();
            if (rs3.next()) {
                totalTreesPlanted = rs3.getInt("treeCount");
            }
        } catch (SQLException e) {
            // If trees_planted table doesn't exist, use 0
            totalTreesPlanted = 0;
        }
        
        // Fetch all schools for the dropdown
        stmt4 = con.prepareStatement("SELECT id, name FROM schools ORDER BY name");
        rs4 = stmt4.executeQuery();
        while (rs4.next()) {
            Map<String, String> school = new HashMap<String, String>();
            school.put("id", rs4.getString("id"));
            school.put("name", rs4.getString("name"));
            schoolsList.add(school);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        // Close all resources
        try {
            if (rs1 != null) rs1.close();
            if (rs2 != null) rs2.close();
            if (rs3 != null) rs3.close();
            if (rs4 != null) rs4.close();
            if (stmt1 != null) stmt1.close();
            if (stmt2 != null) stmt2.close();
            if (stmt3 != null) stmt3.close();
            if (stmt4 != null) stmt4.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            out.println("<p class='error'>✗ Error closing connection: " + e.getMessage() + "</p>");
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - EcoLearn Platform</title>
    <link rel="stylesheet" href="../css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Select2 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    <style>
        .register-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 20px;
        }
        
        .register-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            display: flex;
            max-width: 1000px;
            width: 100%;
        }
        
        // Style for Select2 dropdown
        .select2-container {
            width: 100% !important;
        }
        
        .select2-container .select2-selection--single {
            height: 45px;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 12px;
        }
        
        .select2-container .select2-selection--single .select2-selection__rendered {
            line-height: 22px;
            color: #666;
        }
        
        .select2-container .select2-selection--single .select2-selection__arrow {
            height: 43px;
        }
        
        .register-image {
            flex: 1;
            background: linear-gradient(135deg, #2ecc71, #27ae60);
            padding: 40px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            color: white;
            text-align: center;
        }
        
        .register-image h2 {
            font-size: 32px;
            margin-bottom: 20px;
        }
        
        .register-image p {
            font-size: 18px;
            opacity: 0.9;
            margin-bottom: 30px;
        }
        
        .eco-stats {
            display: flex;
            gap: 30px;
            margin-top: 30px;
        }
        
        .eco-stat {
            text-align: center;
        }
        
        .eco-stat i {
            font-size: 30px;
            margin-bottom: 10px;
        }
        
        .eco-stat span {
            display: block;
            font-size: 24px;
            font-weight: bold;
        }
        
        .eco-stat small {
            display: block;
            font-size: 12px;
            opacity: 0.9;
        }
        
        .register-form-container {
            flex: 1;
            padding: 40px;
            max-height: 100vh;
            overflow-y: auto;
        }
        
        .form-header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .form-header h1 {
            color: #2c3e50;
            margin-bottom: 10px;
        }
        
        .form-header p {
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
        
        .form-group input,
        .form-group select {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
            transition: border-color 0.3s;
            box-sizing: border-box;
        }
        
        .form-group.with-icon input {
            padding-right: 40px;
        }
        
        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #2ecc71;
        }
        
        .password-toggle {
            position: absolute;
            right: 12px;
            top: 35px;
            color: #7f8c8d;
            cursor: pointer;
            transition: color 0.3s;
            background: none;
            border: none;
            padding: 5px;
            z-index: 2;
        }
        
        .password-toggle:hover {
            color: #2ecc71;
        }
        
        .form-row {
            display: flex;
            gap: 15px;
        }
        
        .form-row .form-group {
            flex: 1;
        }
        
        .user-type-selector {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
        }
        
        .user-type-option {
            flex: 1;
            padding: 15px;
            border: 2px solid #ddd;
            border-radius: 8px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .user-type-option:hover {
            border-color: #2ecc71;
        }
        
        .user-type-option.selected {
            border-color: #2ecc71;
            background: rgba(46, 204, 113, 0.1);
        }
        
        .user-type-option i {
            font-size: 24px;
            color: #2ecc71;
            margin-bottom: 5px;
            display: block;
        }
        
        .password-strength {
            margin-top: 5px;
            height: 4px;
            background: #e0e0e0;
            border-radius: 2px;
            overflow: hidden;
            display: none;
        }
        
        .password-strength.show {
            display: block;
        }
        
        .password-strength-bar {
            height: 100%;
            width: 0%;
            transition: width 0.3s, background-color 0.3s;
            border-radius: 2px;
        }
        
        .password-strength-bar.weak {
            width: 33%;
            background-color: #e74c3c;
     
     }
        
        .password-strength-bar.medium {
            width: 66%;
            background-color: #f39c12;
        }
        
        .password-strength-bar.strong {
            width: 100%;
            background-color: #2ecc71;
        }
        
        .password-hint {
            font-size: 12px;
            color: #7f8c8d;
            margin-top: 5px;
        }
        
        .submit-btn {
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
        
        .submit-btn:hover {
            transform: translateY(-2px);
        }
        
        .submit-btn:disabled {
            opacity: 0.7;
            cursor: not-allowed;
        }
        
        .login-link {
            text-align: center;
            margin-top: 20px;
            color: #7f8c8d;
        }
        
        .login-link a {
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
            z-index: 10;
        }
        
        .back-home:hover {
            opacity: 0.8;
        }
        
        .error-message {
            color: #e74c3c;
            font-size: 12px;
            margin-top: 5px;
            display: none;
        }
        
        .error-message.show {
            display: block;
        }
        
        .success-icon {
            color: #2ecc71;
            position: absolute;
            right: 12px;
            top: 35px;
            display: none;
        }
        
        .success-icon.show {
            display: block;
        }
        
        @media (max-width: 768px) {
            .register-card {
                flex-direction: column;
            }
            .register-image {
                padding: 30px;
            }
            .eco-stats {
                flex-direction: column;
                gap: 15px;
            }
        }
    </style>
</head>
<body>
    <a href="../index.jsp" class="back-home">
        <i class="fas fa-arrow-left"></i> Back to Home
    </a>
    
    <div class="register-container">
        <div class="register-card">
            <div class="register-image">
                <i class="fas fa-leaf" style="font-size: 60px; margin-bottom: 20px;"></i>
                <h2>Join the Green Revolution!</h2>
                <p>Start your eco-journey today and make a real difference</p>
                
                <div class="eco-stats">
                    <div class="eco-stat">
                        <i class="fas fa-users"></i>
                        <span><%= totalStudents %>+</span>
                        <small>Students</small>
                    </div>
                    <div class="eco-stat">
                        <i class="fas fa-school"></i>
                        <span><%= totalSchools %>+</span>
                        <small>Schools</small>
                    </div>
                    <div class="eco-stat">
                        <i class="fas fa-tree"></i>
                        <span><%= totalTreesPlanted %>+</span>
                        <small>Trees Planted</small>
                    </div>
                </div>
            </div>
            
            <div class="register-form-container">
                <div class="form-header">
                    <h1>Create Account</h1>
                    <p>Fill in your details to get started</p>
                </div>
                
                <% if (request.getAttribute("errorMessage") != null) { %>
                    <div style="background-color: #f8d7da; color: #721c24; padding: 10px; border-radius: 5px; margin-bottom: 20px; border: 1px solid #f5c6cb;">
                        <%= request.getAttribute("errorMessage") %>
                    </div>
                <% } %>
                
                <% if (session.getAttribute("registrationSuccess") != null) { 
                    String successMessage = (String) session.getAttribute("registrationSuccess");
                    session.removeAttribute("registrationSuccess"); // Remove the message so it doesn't show again
                %>
                    <div style="background-color: #d4edda; color: #155724; padding: 10px; border-radius: 5px; margin-bottom: 20px; border: 1px solid #c3e6cb;">
                        <%= successMessage %>
                    </div>
                <% } %>
                
                <form action="register1.jsp" method="POST" id="registerForm">
                    <div class="user-type-selector">
                        <div class="user-type-option selected" data-type="Student">
                            <i class="fas fa-user-graduate"></i>
                            <span>Student</span>
                        </div>
                        <div class="user-type-option" data-type="Teacher">
                            <i class="fas fa-chalkboard-teacher"></i>
                            <span>Teacher</span>
                        </div>
                    </div>
                    <input type="hidden" name="userType" id="userType" value="Student">
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="fullName">Full Name *</label>
                            <input type="text" id="fullName" name="fullName" required>
                            <span class="error-message" id="fullNameError"></span>
                        </div>
                        <div class="form-group">
                            <label for="username">Username *</label>
                            <input type="text" id="username" name="username" required>
                            <i class="fas fa-check-circle success-icon" id="usernameSuccess"></i>
                            <span class="error-message" id="usernameError"></span>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="email">Email Address *</label>
                        <input type="email" id="email" name="email" required>
                        <span class="error-message" id="emailError"></span>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group with-icon">
                            <label for="password">Password *</label>
                            <input type="password" id="password" name="password" required minlength="6">
                            <button type="button" class="password-toggle" onclick="togglePassword('password', 'passwordIcon')">
                                <i class="fas fa-eye" id="passwordIcon"></i>
                            </button>
                            <div class="password-strength" id="passwordStrength">
                                <div class="password-strength-bar" id="passwordStrengthBar"></div>
                            </div>
                            <span class="password-hint">At least 6 characters with numbers and letters</span>
                            <span class="error-message" id="passwordError"></span>
                        </div>
                        <div class="form-group with-icon">
                            <label for="confirmPassword">Confirm Password *</label>
                            <input type="password" id="confirmPassword" name="confirmPassword" required>
                            <button type="button" class="password-toggle" onclick="togglePassword('confirmPassword', 'confirmPasswordIcon')">
                                <i class="fas fa-eye" id="confirmPasswordIcon"></i>
                            </button>
                            <span class="error-message" id="confirmPasswordError"></span>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="school">School/College *</label>
                        <select id="school" name="schoolId" required class="select2-school">
                            <option value="">Select your institution</option>
                            <% for (Map<String, String> school : schoolsList) { %>
                                <option value="<%= school.get("id") %>"><%= school.get("name") %></option>
                            <% } %>
                            <option value="other">Other</option>
                        </select>
                        <span class="error-message" id="schoolError"></span>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="age">Age</label>
                            <input type="number" id="age" name="age" min="5" max="100">
                            <span class="error-message" id="ageError"></span>
                        </div>
                        <div class="form-group">
                            <label for="classGrade">Class/Grade</label>
                            <input type="text" id="classGrade" name="classGrade" placeholder="e.g., 10th, B.Tech 2nd Year">
                            <span class="error-message" id="classGradeError"></span>
                        </div>
                    </div>
                    
                    <button type="submit" class="submit-btn" id="submitBtn">
                        <i class="fas fa-rocket"></i> Start Your Eco-Journey
                    </button>
                </form>
                
                <div class="login-link">
                    Already have an account? <a href="login.jsp">Login here</a>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        // Toggle password visibility
        function togglePassword(fieldId, iconId) {
            const passwordField = document.getElementById(fieldId);
            const toggleIcon = document.getElementById(iconId);
            
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
        
        // Initialize Select2 for school dropdown
        document.addEventListener('DOMContentLoaded', function() {
            $('#school').select2({
                placeholder: "Start typing to search for your school...",
                allowClear: true,
                width: '100%',
                minimumInputLength: 1,
                sorter: function(data) {
                    return data.sort(function(a, b) {
                        return a.text.toLowerCase().localeCompare(b.text.toLowerCase());
                    });
                }
            });
        });
        
        // User type selection
        document.querySelectorAll('.user-type-option').forEach(option => {
            option.addEventListener('click', function() {
                document.querySelectorAll('.user-type-option').forEach(opt => {
                    opt.classList.remove('selected');
                });
                this.classList.add('selected');
                document.getElementById('userType').value = this.dataset.type;
                
                // Hide grade field for teachers
                const classGradeGroup = document.querySelector('.form-group input#classGrade').closest('.form-group');
                if (this.dataset.type === 'Teacher') {
                    classGradeGroup.style.display = 'none';
                } else {
                    classGradeGroup.style.display = 'block';
                }
            });
        });
        
        // Password strength checker
        document.getElementById('password').addEventListener('input', function() {
            const password = this.value;
            const strengthBar = document.getElementById('passwordStrengthBar');
            const strengthContainer = document.getElementById('passwordStrength');
            
            if (password.length > 0) {
                strengthContainer.classList.add('show');
                
                let strength = 0;
                if (password.length >= 6) strength++;
                if (password.length >= 10) strength++;
                if (/[a-z]/.test(password) && /[A-Z]/.test(password)) strength++;
                if (/[0-9]/.test(password)) strength++;
                if (/[^a-zA-Z0-9]/.test(password)) strength++;
                
                strengthBar.className = 'password-strength-bar';
                if (strength <= 2) {
                    strengthBar.classList.add('weak');
                } else if (strength <= 4) {
                    strengthBar.classList.add('medium');
                } else {
                    strengthBar.classList.add('strong');
                }
            } else {
                strengthContainer.classList.remove('show');
            }
        });
        
        // Real-time password match validation
        document.getElementById('confirmPassword').addEventListener('input', function() {
            const password = document.getElementById('password').value;
            const confirmPassword = this.value;
            const errorElement = document.getElementById('confirmPasswordError');
            
            if (confirmPassword && password !== confirmPassword) {
                errorElement.textContent = 'Passwords do not match';
                errorElement.classList.add('show');
                this.style.borderColor = '#e74c3c';
            } else {
                errorElement.classList.remove('show');
                this.style.borderColor = '';
            }
        });
        
        // Email validation
        document.getElementById('email').addEventListener('blur', function() {
            const email = this.value;
            const errorElement = document.getElementById('emailError');
            const emailRegex = /^[\w.-]+@([\w-]+\.)+[\w-]{2,}$/;
            
            if (email && !emailRegex.test(email)) {
                errorElement.textContent = 'Please enter a valid email address';
                errorElement.classList.add('show');
                this.style.borderColor = '#e74c3c';
            } else {
                errorElement.classList.remove('show');
                this.style.borderColor = '';
            }
        });
        
        // Username availability check (simulated)
        document.getElementById('username').addEventListener('blur', function() {
            const username = this.value;
            const errorElement = document.getElementById('usernameError');
            const successIcon = document.getElementById('usernameSuccess');
            
            if (username.length < 3) {
                errorElement.textContent = 'Username must be at least 3 characters';
                errorElement.classList.add('show');
                successIcon.classList.remove('show');
                this.style.borderColor = '#e74c3c';
            } else {
                // Simulate checking availability
                setTimeout(() => {
                    errorElement.classList.remove('show');
                    successIcon.classList.add('show');
                    this.style.borderColor = '#2ecc71';
                }, 500);
            }
        });
        
        // Full name validation
        document.getElementById('fullName').addEventListener('blur', function() {
            const fullName = this.value.trim();
            const errorElement = document.getElementById('fullNameError');
            
            if (fullName && fullName.length < 2) {
                errorElement.textContent = 'Full name must be at least 2 characters';
                errorElement.classList.add('show');
                this.style.borderColor = '#e74c3c';
            } else if (fullName && /\\d/.test(fullName)) {
                errorElement.textContent = 'Full name should not contain numbers';
                errorElement.classList.add('show');
                this.style.borderColor = '#e74c3c';
            } else {
                errorElement.classList.remove('show');
                this.style.borderColor = '';
            }
        });
        
        // Age validation
        document.getElementById('age').addEventListener('blur', function() {
            const age = this.value;
            const errorElement = document.getElementById('ageError');
            
            if (age && (age < 5 || age > 100)) {
                errorElement.textContent = 'Please enter a valid age between 5 and 100';
                errorElement.classList.add('show');
                this.style.borderColor = '#e74c3c';
            } else {
                errorElement.classList.remove('show');
                this.style.borderColor = '';
            }
        });
        
        // Class/Grade validation
        document.getElementById('classGrade').addEventListener('blur', function() {
            const classGrade = this.value.trim();
            const errorElement = document.getElementById('classGradeError');
            
            // Only validate if field is visible (for students)
            const userType = document.getElementById('userType').value;
            if (userType !== 'Teacher' && classGrade && classGrade.length < 1) {
                errorElement.textContent = 'Please enter a valid class/grade';
                errorElement.classList.add('show');
                this.style.borderColor = '#e74c3c';
            } else {
                errorElement.classList.remove('show');
                this.style.borderColor = '';
            }
        });
        
        // School validation
        document.getElementById('school').addEventListener('change', function() {
            const school = this.value;
            const errorElement = document.getElementById('schoolError');
            
            if (!school) {
                errorElement.textContent = 'Please select your school';
                errorElement.classList.add('show');
                this.style.borderColor = '#e74c3c';
            } else {
                errorElement.classList.remove('show');
                this.style.borderColor = '';
            }
        });
        
        // Comprehensive form validation
        function validateForm() {
            let isValid = true;
            
            // Validate full name
            const fullName = document.getElementById('fullName').value.trim();
            const fullNameError = document.getElementById('fullNameError');
            if (!fullName) {
                fullNameError.textContent = 'Full name is required';
                fullNameError.classList.add('show');
                document.getElementById('fullName').style.borderColor = '#e74c3c';
                isValid = false;
            } else if (fullName.length < 2) {
                fullNameError.textContent = 'Full name must be at least 2 characters';
                fullNameError.classList.add('show');
                document.getElementById('fullName').style.borderColor = '#e74c3c';
                isValid = false;
            } else if (/\\d/.test(fullName)) {
                fullNameError.textContent = 'Full name should not contain numbers';
                fullNameError.classList.add('show');
                document.getElementById('fullName').style.borderColor = '#e74c3c';
                isValid = false;
            }
            
            // Validate username
            const username = document.getElementById('username').value.trim();
            const usernameError = document.getElementById('usernameError');
            if (!username) {
                usernameError.textContent = 'Username is required';
                usernameError.classList.add('show');
                document.getElementById('username').style.borderColor = '#e74c3c';
                isValid = false;
            } else if (username.length < 3) {
                usernameError.textContent = 'Username must be at least 3 characters';
                usernameError.classList.add('show');
                document.getElementById('username').style.borderColor = '#e74c3c';
                isValid = false;
            }
            
            // Validate email
            const email = document.getElementById('email').value.trim();
            const emailError = document.getElementById('emailError');
            const emailRegex = /^[\w.-]+@([\w-]+\.)+[\w-]{2,}$/;
            if (!email) {
                emailError.textContent = 'Email is required';
                emailError.classList.add('show');
                document.getElementById('email').style.borderColor = '#e74c3c';
                isValid = false;
            } else if (!emailRegex.test(email)) {
                emailError.textContent = 'Please enter a valid email address';
                emailError.classList.add('show');
                document.getElementById('email').style.borderColor = '#e74c3c';
                isValid = false;
            }
            
            // Validate password
            const password = document.getElementById('password').value;
            const passwordError = document.getElementById('passwordError');
            if (!password) {
                passwordError.textContent = 'Password is required';
                passwordError.classList.add('show');
                document.getElementById('password').style.borderColor = '#e74c3c';
                isValid = false;
            } else if (password.length < 6) {
                passwordError.textContent = 'Password must be at least 6 characters';
                passwordError.classList.add('show');
                document.getElementById('password').style.borderColor = '#e74c3c';
                isValid = false;
            }
            
            // Validate confirm password
            const confirmPassword = document.getElementById('confirmPassword').value;
            const confirmPasswordError = document.getElementById('confirmPasswordError');
            if (!confirmPassword) {
                confirmPasswordError.textContent = 'Please confirm your password';
                confirmPasswordError.classList.add('show');
                document.getElementById('confirmPassword').style.borderColor = '#e74c3c';
                isValid = false;
            } else if (password !== confirmPassword) {
                confirmPasswordError.textContent = 'Passwords do not match';
                confirmPasswordError.classList.add('show');
                document.getElementById('confirmPassword').style.borderColor = '#e74c3c';
                isValid = false;
            }
            
            // Validate school
            const school = document.getElementById('school').value;
            const schoolError = document.getElementById('schoolError');
            if (!school) {
                schoolError.textContent = 'Please select your school';
                schoolError.classList.add('show');
                document.getElementById('school').style.borderColor = '#e74c3c';
                isValid = false;
            }
            
            // Validate age (optional field, but if provided must be valid)
            const age = document.getElementById('age').value;
            const ageError = document.getElementById('ageError');
            if (age && (age < 5 || age > 100)) {
                ageError.textContent = 'Please enter a valid age between 5 and 100';
                ageError.classList.add('show');
                document.getElementById('age').style.borderColor = '#e74c3c';
                isValid = false;
            }
            
            // Validate class/grade (only required for students)
            const userType = document.getElementById('userType').value;
            const classGrade = document.getElementById('classGrade').value.trim();
            const classGradeError = document.getElementById('classGradeError');
            if (userType !== 'Teacher' && !classGrade) {
                classGradeError.textContent = 'Please enter your class/grade';
                classGradeError.classList.add('show');
                document.getElementById('classGrade').style.borderColor = '#e74c3c';
                isValid = false;
            } else if (userType !== 'Teacher' && classGrade && classGrade.length < 1) {
                classGradeError.textContent = 'Please enter a valid class/grade';
                classGradeError.classList.add('show');
                document.getElementById('classGrade').style.borderColor = '#e74c3c';
                isValid = false;
            }
            
            return isValid;
        }
        
        // Form submission
        document.getElementById('registerForm').addEventListener('submit', function(e) {
            // Reset all error messages
            document.querySelectorAll('.error-message').forEach(el => {
                el.classList.remove('show');
            });
            
            // Reset all borders
            document.querySelectorAll('input, select').forEach(el => {
                el.style.borderColor = '';
            });
            
            // Validate form
            if (!validateForm()) {
                e.preventDefault();
                return;
            }
            
            // Show loading state
            const btn = document.getElementById('submitBtn');
            const originalContent = btn.innerHTML;
            btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Creating Account...';
            btn.disabled = true;
            
            // Simulate registration process
            setTimeout(() => {
                alert('Registration successful! Welcome to EcoLearn!');
                window.location.href = 'dashboard.jsp';
            }, 2000);
        });
    </script>
    <br>
    
    <!-- jQuery and Select2 JS -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
    <script>
        // Initialize Select2 for school dropdown when page loads
        $(document).ready(function() {
            $('#school').select2({
                placeholder: "Start typing to search for your school...",
                allowClear: true,
                width: '100%',
                // Enable search functionality
                minimumInputLength: 1,
                // Sort results with matching items first
                sorter: function(data) {
                    return data.sort(function(a, b) {
                        // Sort alphabetically by text
                        return a.text.toLowerCase().localeCompare(b.text.toLowerCase());
                    });
                }
            });
        });
    </script>
</body>
</html>