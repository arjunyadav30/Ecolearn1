<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    response.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");
    
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ecolearn?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true", "root", "1234");
        
        out.println("<h2>Database Schema Information:</h2>");
        
        // Get table structure
        stmt = conn.createStatement();
        rs = stmt.executeQuery("DESCRIBE questions");
        
        out.println("<h3>Questions Table Structure:</h3>");
        out.println("<table border='1'><tr><th>Field</th><th>Type</th><th>Null</th><th>Key</th><th>Default</th><th>Extra</th></tr>");
        
        while (rs.next()) {
            out.println("<tr>");
            out.println("<td>" + rs.getString("Field") + "</td>");
            out.println("<td>" + rs.getString("Type") + "</td>");
            out.println("<td>" + rs.getString("Null") + "</td>");
            out.println("<td>" + rs.getString("Key") + "</td>");
            out.println("<td>" + rs.getString("Default") + "</td>");
            out.println("<td>" + rs.getString("Extra") + "</td>");
            out.println("</tr>");
        }
        out.println("</table>");
        
        // Get sample data
        rs = stmt.executeQuery("SELECT * FROM questions LIMIT 3");
        
        out.println("<h3>Sample Questions Data:</h3>");
        out.println("<table border='1'>");
        
        ResultSetMetaData metaData = rs.getMetaData();
        int columnCount = metaData.getColumnCount();
        
        // Print column headers
        out.println("<tr>");
        for (int i = 1; i <= columnCount; i++) {
            out.println("<th>" + metaData.getColumnName(i) + "</th>");
        }
        out.println("</tr>");
        
        // Print data rows
        while (rs.next()) {
            out.println("<tr>");
            for (int i = 1; i <= columnCount; i++) {
                out.println("<td>" + rs.getString(i) + "</td>");
            }
            out.println("</tr>");
        }
        out.println("</table>");
        
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<p>Error: " + e.getMessage() + "</p>");
    } finally {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>