<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Get user ID from session
    Integer userId = (Integer) session.getAttribute("userId");
    
    // Get lesson ID and title from parameters
    String lessonIdParam = request.getParameter("lessonId");
    String lessonTitle = request.getParameter("lessonTitle");
    String pointsParam = request.getParameter("points");
    
    // Validate user is logged in
    if (userId == null) {
        response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User not logged in");
        return;
    }
    
    // Validate parameters
    if (lessonIdParam == null || lessonTitle == null) {
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters");
        return;
    }
    
    int points = 100; // Default points for completing a lesson
    if (pointsParam != null) {
        try {
            points = Integer.parseInt(pointsParam);
        } catch (NumberFormatException e) {
            // Keep default points if not a valid number
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
        
        // Insert activity log for lesson completion
        String insertSQL = "INSERT INTO activity_log (user_id, activity_type, title, description, points_earned) VALUES (?, ?, ?, ?, ?)";
        stmt = con.prepareStatement(insertSQL);
        stmt.setInt(1, userId);
        stmt.setString(2, "lesson");
        stmt.setString(3, "Finished Lesson: " + lessonTitle);
        stmt.setString(4, "Completed the " + lessonTitle + " lesson");
        stmt.setInt(5, points);
        
        int rowsAffected = stmt.executeUpdate();
        
        if (rowsAffected > 0) {
            // Also update user statistics
            String updateStatsSQL = "UPDATE user_statistics SET lessons_completed = lessons_completed + 1, " +
                                   "points_from_lessons = points_from_lessons + ?, " +
                                   "total_points = total_points + ? " +
                                   "WHERE user_id = ?";
            stmt = con.prepareStatement(updateStatsSQL);
            stmt.setInt(1, points);
            stmt.setInt(2, points);
            stmt.setInt(3, userId);
            stmt.executeUpdate();
            
            response.setContentType("application/json");
            response.getWriter().write("{\"status\":\"success\",\"message\":\"Lesson completed and activity logged successfully\"}");
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