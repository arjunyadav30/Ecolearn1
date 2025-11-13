<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mycompany.sih3.entity.User" %>
<%@ page import="com.mycompany.sih3.entity.UserType" %>
<%@ page import="com.mycompany.sih3.repository.UserRepository" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.security.NoSuchAlgorithmException" %>
<%
    // Security: Disable caching
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
    response.setHeader("Pragma", "no-cache"); // HTTP 1.0
    response.setDateHeader("Expires", 0); // Proxies
    
    // Security: Check if request method is POST
    if (!"POST".equals(request.getMethod())) {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        return;
    }
    
    // Get form parameters
    String fullName = request.getParameter("fullName");
    String username = request.getParameter("username");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String userTypeStr = request.getParameter("userType");
    String schoolIdStr = request.getParameter("schoolId");
    String ageStr = request.getParameter("age");
    String classGrade = request.getParameter("classGrade");
    
    // Security: Validate required fields
    if (fullName == null || fullName.trim().isEmpty() ||
        username == null || username.trim().isEmpty() ||
        email == null || email.trim().isEmpty() ||
        password == null || password.isEmpty() ||
        userTypeStr == null || userTypeStr.trim().isEmpty() ||
        schoolIdStr == null || schoolIdStr.trim().isEmpty()) {
        
        request.setAttribute("errorMessage", "All required fields must be filled.");
        request.getRequestDispatcher("register.jsp").forward(request, response);
        return;
    }
    
    // Security: Validate email format with a more permissive regex
    String emailRegex = "^[\\w.-]+@([\\w-]+\\.)+[\\w-]{2,}$";
    if (!email.matches(emailRegex)) {
        request.setAttribute("errorMessage", "Invalid email format.");
        request.getRequestDispatcher("register.jsp").forward(request, response);
        return;
    }
    
    // Security: Validate password strength
    if (password.length() < 6) {
        request.setAttribute("errorMessage", "Password must be at least 6 characters long.");
        request.getRequestDispatcher("register.jsp").forward(request, response);
        return;
    }
    
    // Security: Validate user type
    UserType userType;
    try {
        userType = UserType.valueOf(userTypeStr);
    } catch (IllegalArgumentException e) {
        request.setAttribute("errorMessage", "Invalid user type.");
        request.getRequestDispatcher("register.jsp").forward(request, response);
        return;
    }
    
    // Handle school selection
    Integer schoolId = null;
    if (!"other".equals(schoolIdStr)) {
        try {
            schoolId = Integer.parseInt(schoolIdStr);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid school selection.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
    }
    // If schoolIdStr is "other", we leave schoolId as null
    
    // Security: Validate age if provided
    Integer age = null;
    if (ageStr != null && !ageStr.trim().isEmpty()) {
        try {
            age = Integer.parseInt(ageStr);
            if (age < 5 || age > 100) {
                request.setAttribute("errorMessage", "Age must be between 5 and 100.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid age format.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
    }
    
    // Security: For students, classGrade is required
    if (userType == UserType.Student && (classGrade == null || classGrade.trim().isEmpty())) {
        request.setAttribute("errorMessage", "Class/Grade is required for students.");
        request.getRequestDispatcher("register.jsp").forward(request, response);
        return;
    }
    
    // Hash the password using SHA-256
    String hashedPassword = hashPassword(password);
    
    // Create User object
    User user = new User();
    user.setFullName(fullName.trim());
    user.setUsername(username.trim());
    user.setEmail(email.trim().toLowerCase());
    user.setPassword(hashedPassword);
    user.setUserType(userType);
    user.setSchoolId(schoolId); // This can be null for "other" option
    user.setAge(age);
    user.setClassGrade(classGrade != null ? classGrade.trim() : null);
    
    // Save user to database
    UserRepository userRepository = new UserRepository();
    try {
        // Check if username or email already exists
        User existingUserByUsername = userRepository.findByUsername(username.trim());
        if (existingUserByUsername != null) {
            request.setAttribute("errorMessage", "Username already exists. Please choose a different username.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        User existingUserByEmail = userRepository.findByEmail(email.trim().toLowerCase());
        if (existingUserByEmail != null) {
            request.setAttribute("errorMessage", "Email already registered. Please use a different email.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        // Save the new user
        userRepository.save(user);
        
        // Set success message and redirect to login page
        session.setAttribute("registrationSuccess", "Registration successful! You can now log in.");
        response.sendRedirect("login.jsp");
    } catch (Exception e) {
        // Log the error (in a real application, use a proper logging framework)
        e.printStackTrace();
        
        // Show generic error message to user
        request.setAttribute("errorMessage", "An error occurred during registration. Please try again.");
        request.getRequestDispatcher("register.jsp").forward(request, response);
    } finally {
        // Close the repository connection
        // Note: In this implementation, connections are created per method call, so no explicit close is needed
    }
%>

<%!
    // Method to hash password using SHA-256
    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            // This should never happen as SHA-256 is a standard algorithm
            throw new RuntimeException("SHA-256 algorithm not found", e);
        }
    }
%>