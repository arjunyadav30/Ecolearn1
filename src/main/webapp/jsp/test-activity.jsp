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
    
    // Fetch recent activity data from database
    ArrayList<Map<String, Object>> recentActivityData = new ArrayList<Map<String, Object>>();
    
    Connection con = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection(url, usernameDB, passwordDB);
        
        // Fetch recent activity (last 5 activities)
        String activitySql = "SELECT activity_type, title, description, points_earned, created_at " +
                             "FROM activity_log " +
                             "ORDER BY created_at DESC " +
                             "LIMIT 5";
        stmt = con.prepareStatement(activitySql);
        rs = stmt.executeQuery();
        
        while (rs.next()) {
            Map<String, Object> activity = new HashMap<String, Object>();
            activity.put("activity_type", rs.getString("activity_type"));
            activity.put("title", rs.getString("title"));
            activity.put("description", rs.getString("description"));
            activity.put("points_earned", rs.getInt("points_earned"));
            activity.put("created_at", rs.getTimestamp("created_at"));
            recentActivityData.add(activity);
        }
        
        out.println("<h2>Activity Log Data</h2>");
        out.println("<p>Found " + recentActivityData.size() + " activities:</p>");
        out.println("<ul>");
        
        for (Map<String, Object> activity : recentActivityData) {
            String title = (String) activity.get("title");
            Integer points = (Integer) activity.get("points_earned");
            out.println("<li>" + title + " (" + points + " points)</li>");
        }
        
        out.println("</ul>");
        
    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>