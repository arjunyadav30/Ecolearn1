<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mycompany.sih3.entity.User" %>
<%@ page import="com.mycompany.sih3.repository.UserRepository" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%
    // Set response type
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    
    // Get user from session
    User currentUser = (User) session.getAttribute("user");
    
    if (currentUser == null) {
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        out.print("{\"status\":\"error\",\"message\":\"User not authenticated\"}");
        return;
    }
    
    try {
        // Get parameters from request
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String emailNotifications = request.getParameter("emailNotifications");
        String pushNotifications = request.getParameter("pushNotifications");
        String weeklyReports = request.getParameter("weeklyReports");
        String achievementAlerts = request.getParameter("achievementAlerts");
        String profileVisibility = request.getParameter("profileVisibility");
        String activitySharing = request.getParameter("activitySharing");
        String leaderboardParticipation = request.getParameter("leaderboardParticipation");
        String theme = request.getParameter("theme");
        
        // Validate required fields
        if (firstName == null || firstName.trim().isEmpty()) {
            out.print("{\"status\":\"error\",\"message\":\"First name is required\"}");
            return;
        }
        
        // Update user information
        String fullName = firstName.trim();
        if (lastName != null && !lastName.trim().isEmpty()) {
            fullName += " " + lastName.trim();
        }
        
        currentUser.setFullName(fullName);
        
        // Save user to database
        UserRepository userRepository = new UserRepository();
        userRepository.update(currentUser);
        
        // Also store settings in session for persistence during the session
        Map<String, Object> userSettings = (Map<String, Object>) session.getAttribute("userSettings");
        if (userSettings == null) {
            userSettings = new HashMap<String, Object>();
        }
        
        userSettings.put("emailNotifications", "true".equals(emailNotifications));
        userSettings.put("pushNotifications", "true".equals(pushNotifications));
        userSettings.put("weeklyReports", "true".equals(weeklyReports));
        userSettings.put("achievementAlerts", "true".equals(achievementAlerts));
        userSettings.put("profileVisibility", "true".equals(profileVisibility));
        userSettings.put("activitySharing", "true".equals(activitySharing));
        userSettings.put("leaderboardParticipation", "true".equals(leaderboardParticipation));
        userSettings.put("theme", theme != null ? theme : "Eco Green");
        
        session.setAttribute("userSettings", userSettings);
        session.setAttribute("user", currentUser);
        
        // Send success response with theme information
        out.print("{\"status\":\"success\",\"message\":\"Settings saved successfully\",\"theme\":\"" + (theme != null ? theme : "Eco Green") + "\"}");
    } catch (Exception e) {
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        out.print("{\"status\":\"error\",\"message\":\"Error saving settings: " + e.getMessage() + "\"}");
    }
%>