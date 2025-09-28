<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mycompany.sih3.entity.User" %>
<%
    // Check if user is logged in
    if (session.getAttribute("user") == null) {
        // User not logged in, redirect to login page
        response.sendRedirect("../jsp/login.jsp");
        return;
    }
    
    // Get user from session
    User user = (User) session.getAttribute("user");
    
    // Check if user is a teacher
    if (!"Teacher".equals(user.getUserType().toString())) {
        response.sendError(HttpServletResponse.SC_FORBIDDEN);
        return;
    }
%>