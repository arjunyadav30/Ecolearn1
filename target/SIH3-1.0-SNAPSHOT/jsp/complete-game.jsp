<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Get user ID from session
    Integer userId = (Integer) session.getAttribute("userId");
    
    // Get game details from parameters
    String gameTitle = request.getParameter("gameTitle");
    String pointsParam = request.getParameter("points");
    
    // Validate user is logged in
    if (userId == null) {
        response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User not logged in");
        return;
    }
    
    // Validate parameters
    if (gameTitle == null) {
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters");
        return;
    }
    
    int points = 50; // Default points for completing a game
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
        
        // Insert activity log for game completion
        String insertSQL = "INSERT INTO activity_log (user_id, activity_type, title, description, points_earned) VALUES (?, ?, ?, ?, ?)";
        stmt = con.prepareStatement(insertSQL);
        stmt.setInt(1, userId);
        stmt.setString(2, "game");
        stmt.setString(3, "Completed Game: " + gameTitle);
        stmt.setString(4, "Achieved high score in the " + gameTitle + " game");
        stmt.setInt(5, points);
        
        int rowsAffected = stmt.executeUpdate();
        
        if (rowsAffected > 0) {
            // Also update user statistics
            String updateStatsSQL = "UPDATE user_statistics SET games_played = games_played + 1, " +
                                   "points_from_games = points_from_games + ?, " +
                                   "total_points = total_points + ? " +
                                   "WHERE user_id = ?";
            stmt = con.prepareStatement(updateStatsSQL);
            stmt.setInt(1, points);
            stmt.setInt(2, points);
            stmt.setInt(3, userId);
            stmt.executeUpdate();
            
            response.setContentType("application/json");
            response.getWriter().write("{\"status\":\"success\",\"message\":\"Game completed and activity logged successfully\"}");
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