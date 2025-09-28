<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mycompany.sih3.entity.User" %>
<%
    // Check if user is logged in
    if (session.getAttribute("user") == null) {
        // User not logged in, redirect to login page
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get user from session
    User user = (User) session.getAttribute("user");
    
    // You can add role-based checks here if needed
    // For example:
    // String userType = user.getUserType().name();
    // if (!"Teacher".equals(userType)) {
    //     response.sendError(HttpServletResponse.SC_FORBIDDEN);
    //     return;
    // }
%>