<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mycompany.sih3.entity.User" %>
<%@ page import="com.mycompany.sih3.entity.UserImage" %>
<%@ page import="com.mycompany.sih3.repository.UserRepository" %>
<%@ page import="com.mycompany.sih3.repository.UserImageRepository" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.nio.file.Files" %>
<%@ page import="java.nio.file.Paths" %>
<%@ page import="java.nio.file.StandardCopyOption" %>

<%
    // Check if user is logged in
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    try {
        // For now, we'll just redirect back to the profile page with a success message
        // In a real implementation with Apache Commons FileUpload, you would handle the file upload here
        
        // Simulate a successful upload
        // In a real implementation, you would:
        // 1. Get the uploaded file using request.getPart("avatar")
        // 2. Save the file to the server
        // 3. Save the file path to the database
        
        response.sendRedirect("profile.jsp?updated=true&image=uploaded");
    } catch (Exception e) {
        // Log the error and redirect with error message
        e.printStackTrace();
        response.sendRedirect("profile.jsp?error=image_upload_failed");
    }
%>