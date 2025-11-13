<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Get user ID from session
    Integer userId = (Integer) session.getAttribute("userId");
    
    // Get parameters
    String activityType = request.getParameter("type");
    String title = request.getParameter("title");
    String description = request.getParameter("description");
    String pointsParam = request.getParameter("points");
    
    // Validate user is logged in
    if (userId == null) {
        response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User not logged in");
        return;
    }
    
    // Validate parameters
    if (activityType == null || title == null) {
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters");
        return;
    }
    
    int points = 0;
    if (pointsParam != null) {
        try {
            points = Integer.parseInt(pointsParam);
        } catch (NumberFormatException e) {
            // Keep points as 0 if not a valid number
        }
    }
    
    // Database connection details
    String url = "jdbc:mysql://localhost/ecolearn";
    String usernameDB = "root";
    String passwordDB = "1234";
    
    Connection con = null;
    PreparedStatement stmt = null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection(url, usernameDB, passwordDB);
        
        // Insert activity log
        String insertSQL = "INSERT INTO activity_log (user_id, activity_type, title, description, points_earned) VALUES (?, ?, ?, ?, ?)";
        stmt = con.prepareStatement(insertSQL);
        stmt.setInt(1, userId);
        stmt.setString(2, activityType);
        stmt.setString(3, title);
        stmt.setString(4, description != null ? description : "");
        stmt.setInt(5, points);
        
        int rowsAffected = stmt.executeUpdate();
        
        if (rowsAffected > 0) {
            response.setContentType("application/json");
            response.getWriter().write("{\"status\":\"success\",\"message\":\"Activity logged successfully\"}");
        } else {
            response.setContentType("application/json");
            response.getWriter().write("{\"status\":\"error\",\"message\":\"Failed to log activity\"}");
        }
        
    } catch (Exception e) {
        response.setContentType("application/json");
        response.getWriter().write("{\"status\":\"error\",\"message\":\"" + e.getMessage() + "\"}");
        e.printStackTrace();
    } finally {
        try {
            if (stmt != null) stmt.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>