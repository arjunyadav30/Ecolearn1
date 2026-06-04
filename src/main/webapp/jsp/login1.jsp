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
    String usernameOrEmail = request.getParameter("username");
    String password = request.getParameter("password");
    String role = request.getParameter("role");
    
    // Security: Validate required fields
    if (usernameOrEmail == null || usernameOrEmail.trim().isEmpty() ||
        password == null || password.isEmpty() ||
        role == null || role.trim().isEmpty()) {
        
        request.setAttribute("errorMessage", "All fields are required.");
        request.getRequestDispatcher("login.jsp").forward(request, response);
        return;
    }
    
    // Security: Validate role
    String expectedUserType = null;
    if ("student".equalsIgnoreCase(role)) {
        expectedUserType = "Student";
    } else if ("teacher".equalsIgnoreCase(role)) {
        expectedUserType = "Teacher";
    } else if ("admin".equalsIgnoreCase(role)) {
        expectedUserType = "Admin";
    } else {
        request.setAttribute("errorMessage", "Invalid role selected.");
        request.getRequestDispatcher("login.jsp").forward(request, response);
        return;
    }
    
    // Hash the password using SHA-256 for comparison
    String hashedPassword = hashPassword(password);
    
    // Find user by username or email
    UserRepository userRepository = new UserRepository();
    User user = null;
    
    // Try to find user by username first
    user = userRepository.findByUsername(usernameOrEmail.trim());
    
    // If not found by username, try email
    if (user == null) {
        user = userRepository.findByEmail(usernameOrEmail.trim());
    }
    
    // Security: Check if user exists
    if (user == null) {
        request.setAttribute("errorMessage", "Invalid username/email or password.");
        request.getRequestDispatcher("login.jsp").forward(request, response);
        return;
    }
    
    // Security: Check if password matches
    if (!user.getPassword().equals(hashedPassword)) {
        request.setAttribute("errorMessage", "Invalid username/email or password.");
        request.getRequestDispatcher("login.jsp").forward(request, response);
        return;
    }
    
    // Security: Check if user type matches selected role
    // Fix: Use toString() instead of name() to avoid enum conversion issues
    if (!user.getUserType().toString().equals(expectedUserType)) {
        request.setAttribute("errorMessage", "User does not have the selected role.");
        request.getRequestDispatcher("login.jsp").forward(request, response);
        return;
    }
    
    // Login successful - set user in session
    session.setAttribute("user", user);
    session.setAttribute("userId", user.getId());
    session.setAttribute("username", user.getUsername());
    session.setAttribute("userType", user.getUserType().toString());
    
    // Redirect based on user type
    if ("Student".equals(user.getUserType().toString())) {
        response.sendRedirect("dashboard.jsp");
    } else if ("Teacher".equals(user.getUserType().toString())) {
        // Redirect to teacher dashboard in the correct directory
        response.sendRedirect("../Teacher/teacherdashboard.jsp");
    } else if ("Admin".equals(user.getUserType().toString())) {
        // Redirect to admin dashboard
        response.sendRedirect("admin-dashboard.jsp");
    } else {
        // Default redirect
        response.sendRedirect("dashboard.jsp");
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