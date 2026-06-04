package com.mycompany.sih3.servlet;

import com.mycompany.sih3.entity.User;
import com.mycompany.sih3.entity.ActivityLog;
import com.mycompany.sih3.entity.UserStatistics;
import com.mycompany.sih3.repository.UserRepository;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "AdminAnalyticsServlet", urlPatterns = {"/admin/analytics/*"})
public class AdminAnalyticsServlet extends HttpServlet {
    
    private UserRepository userRepository;
    
    @Override
    public void init() throws ServletException {
        userRepository = new UserRepository();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is admin
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }
        
        User currentUser = (User) session.getAttribute("user");
        if (!"Admin".equals(currentUser.getUserType().toString())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        String action = request.getPathInfo();
        
        if (action == null || action.equals("/")) {
            // Show analytics dashboard
            showAnalyticsDashboard(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    private void showAnalyticsDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Get analytics data
            Map<String, Object> analyticsData = getAnalyticsData();
            request.setAttribute("analyticsData", analyticsData);
            
            // Forward to analytics dashboard
            request.getRequestDispatcher("/jsp/admin-analytics-dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error retrieving analytics data: " + e.getMessage());
            request.getRequestDispatcher("/jsp/error/500.jsp").forward(request, response);
        }
    }
    
    private Map<String, Object> getAnalyticsData() {
        Map<String, Object> data = new HashMap<>();
        
        try {
            // Get total users
            List<User> allUsers = userRepository.findAll();
            data.put("totalUsers", allUsers.size());
            
            // Count users by type
            int studentCount = 0;
            int teacherCount = 0;
            int adminCount = 0;
            
            for (User user : allUsers) {
                switch (user.getUserType().toString()) {
                    case "Student":
                        studentCount++;
                        break;
                    case "Teacher":
                        teacherCount++;
                        break;
                    case "Admin":
                        adminCount++;
                        break;
                }
            }
            
            data.put("studentCount", studentCount);
            data.put("teacherCount", teacherCount);
            data.put("adminCount", adminCount);
            
            // For now, we'll use mock data for other statistics
            // In a real implementation, we would query the database for actual data
            
            // Active users (mock data)
            data.put("activeUsers", 1842);
            
            // Lessons completed (mock data)
            data.put("lessonsCompleted", 5287);
            
            // Games played (mock data)
            data.put("gamesPlayed", 3156);
            
            // Average session time (mock data)
            data.put("avgSessionTime", "24m");
            
            // User growth data (mock data)
            List<Map<String, Object>> userGrowthData = new ArrayList<>();
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM dd");
            
            for (int i = 30; i >= 0; i--) {
                Map<String, Object> dayData = new HashMap<>();
                LocalDateTime date = LocalDateTime.now().minusDays(i);
                dayData.put("date", date.format(formatter));
                // Generate mock data with some variation
                dayData.put("users", 1500 + (int)(Math.random() * 500));
                userGrowthData.add(dayData);
            }
            
            data.put("userGrowthData", userGrowthData);
            
            // Popular content (mock data)
            List<Map<String, Object>> popularContent = new ArrayList<>();
            
            Map<String, Object> content1 = new HashMap<>();
            content1.put("title", "Introduction to Climate Change");
            content1.put("views", 1250);
            popularContent.add(content1);
            
            Map<String, Object> content2 = new HashMap<>();
            content2.put("title", "Biodiversity Conservation");
            content2.put("views", 980);
            popularContent.add(content2);
            
            Map<String, Object> content3 = new HashMap<>();
            content3.put("title", "Renewable Energy Sources");
            content3.put("views", 875);
            popularContent.add(content3);
            
            Map<String, Object> content4 = new HashMap<>();
            content4.put("title", "Ocean Pollution");
            content4.put("views", 760);
            popularContent.add(content4);
            
            Map<String, Object> content5 = new HashMap<>();
            content5.put("title", "Forest Conservation");
            content5.put("views", 650);
            popularContent.add(content5);
            
            data.put("popularContent", popularContent);
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return data;
    }
}