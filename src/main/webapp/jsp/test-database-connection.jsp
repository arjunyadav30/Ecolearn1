<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    response.setCharacterEncoding("UTF-8");
    try (Connection conn = com.mycompany.sih3.util.DBUtil.getConnection()) {
        out.println("<h2>Database Connection Test</h2>");
        out.println("<p style='color:green;'>Connected to database successfully.</p>");

        try (Statement stmt = conn.createStatement()) {
            // Postgres-friendly checks
            try (ResultSet rs = stmt.executeQuery("SELECT 1 AS ok")) {
                if (rs.next()) {
                    out.println("<p>SELECT 1 => " + rs.getInt("ok") + "</p>");
                }
            }
            try (ResultSet rs = stmt.executeQuery("SELECT current_database() AS db")) {
                if (rs.next()) {
                    out.println("<p>Current database: " + rs.getString("db") + "</p>");
                }
            }
            try (ResultSet rs = stmt.executeQuery("SELECT now() AS now")) {
                if (rs.next()) {
                    out.println("<p>Server time: " + rs.getTimestamp("now") + "</p>");
                }
            }
        }
    } catch (Exception e) {
        out.println("<h2 style='color:red'>Database Connection FAILED</h2>");
        out.println("<pre>" + e.getMessage() + "</pre>");
        e.printStackTrace(new java.io.PrintWriter(out));
    }
%>
