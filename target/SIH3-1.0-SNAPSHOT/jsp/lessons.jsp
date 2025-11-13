<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mycompany.sih3.entity.User" %>
<%@ page import="com.mycompany.sih3.repository.UserRepository" %>
<%@ page import="com.mycompany.sih3.entity.Lesson" %>
<%@ page import="com.mycompany.sih3.repository.LessonRepository" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.*" %>
<%
    // Get user ID from session
    Integer userId = (Integer) session.getAttribute("userId");
    String userName = "Guest";
    Integer currentStreak = 0;
    
    // Fetch user from database if userId exists in session
    if (userId != null) {
        UserRepository userRepository = new UserRepository();
        User user = userRepository.findById(userId);
        if (user != null) {
            userName = user.getFullName();
        }
        
        // Fetch user statistics including streak
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost/ecolearn", "root", "1234");
            String sql = "SELECT current_streak FROM user_statistics WHERE user_id = ?";
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                currentStreak = rs.getObject("current_streak", Integer.class) != null ? rs.getObject("current_streak", Integer.class) : 0;
            }
            
            rs.close();
            stmt.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    // Fetch lessons from database
    LessonRepository lessonRepository = new LessonRepository();
    List<Lesson> lessons = lessonRepository.findAll();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lessons - EcoLearn Platform</title>
    
    <!-- CSS Libraries -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --primary-green: #2d8f44;
            --secondary-teal: #20c997;
            --accent-blue: #3498db;
            --light-gray: #f8f9fa;
            --dark-gray: #343a40;
            --border-radius-lg: 0.75rem;
            --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            --spacing-md: 1rem;
            --spacing-lg: 1.5rem;
            --spacing-xl: 2rem;
        }
        
        body {
            font-family: 'Poppins', system-ui, -apple-system, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            margin: 0;
            padding: 0;
        }
        
        .lessons-page {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            padding-top: 76px;
        }
        
        .navbar {
            background: linear-gradient(135deg, #1abc9c, #17a2b8) !important;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .main-content {
            padding: var(--spacing-xl) 0;
        }
        
        .page-header {
            background: linear-gradient(135deg, #3498db 0%, #2c3e50 100%);
            color: white;
            padding: var(--spacing-xl);
            border-radius: var(--border-radius-lg);
            margin-bottom: var(--spacing-xl);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            position: relative;
            overflow: hidden;
        }
        
        .page-title {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
        
        .page-subtitle {
            font-size: 1.125rem;
            opacity: 0.9;
            margin-bottom: 0;
        }
        
        .lesson-card {
            background: white;
            border-radius: var(--border-radius-lg);
            box-shadow: var(--shadow-md);
            margin-bottom: var(--spacing-lg);
            transition: all 0.3s ease;
            overflow: hidden;
            animation: fadeInUp 0.6s ease-out;
        }
        
        .lesson-card:hover {
            transform: translateY(-8px) scale(1.02);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.15);
        }
        
        .lesson-thumbnail {
            height: 200px;
            background: linear-gradient(135deg, var(--accent-blue), var(--primary-green));
            position: relative;
            overflow: hidden;
        }
        
        .lesson-category {
            position: absolute;
            top: 1rem;
            left: 1rem;
            background: rgba(255, 255, 255, 0.9);
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            color: var(--primary-green);
        }
        
        .lesson-duration {
            position: absolute;
            bottom: 1rem;
            right: 1rem;
            background: rgba(0, 0, 0, 0.7);
            color: white;
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
        }
        
        .lesson-content {
            padding: var(--spacing-lg);
        }
        
        .lesson-content h5 {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: var(--dark-gray);
        }
        
        .lesson-content p {
            color: #6c757d;
            margin-bottom: 1rem;
        }
        
        .lesson-progress {
            margin-bottom: 1rem;
        }
        
        .progress {
            height: 8px;
            border-radius: 4px;
            background: #e9ecef;
            margin-bottom: 0.5rem;
        }
        
        .progress-bar {
            background: linear-gradient(90deg, var(--primary-green), var(--secondary-teal));
            border-radius: 4px;
            height: 100%;
            width: 0%;
            transition: width 1.5s ease-in-out;
        }
        
        .progress-text {
            font-size: 0.8rem;
            color: #6c757d;
            text-align: right;
        }
        
        .btn-lesson {
            width: 100%;
            padding: 0.75rem;
            border-radius: var(--border-radius-lg);
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .btn-lesson:hover {
            transform: translateY(-2px);
        }
        
        .btn-primary {
            background: linear-gradient(135deg, var(--primary-green), var(--secondary-teal));
            border: none;
        }
        
        .btn-outline-primary {
            border: 2px solid var(--primary-green);
            color: var(--primary-green);
        }
        
        .stats-card {
            background: white;
            border-radius: var(--border-radius-lg);
            padding: var(--spacing-lg);
            box-shadow: var(--shadow-md);
            margin-bottom: var(--spacing-lg);
            animation: fadeIn 0.8s ease-out;
        }
        
        .stats-card h5 {
            font-size: 1.125rem;
            font-weight: 600;
            margin-bottom: 1rem;
            color: var(--dark-gray);
        }
        
        .stat-item {
            display: flex;
            justify-content: space-between;
            padding: 0.5rem 0;
            border-bottom: 1px solid #f1f3f4;
        }
        
        .stat-item:last-child {
            border-bottom: none;
        }
        
        .stat-label {
            color: #6c757d;
        }
        
        .stat-value {
            font-weight: 600;
            color: var(--primary-green);
        }
        
        /* Animations */
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        @keyframes pulse {
            0% {
                transform: scale(1);
                box-shadow: 0 0 0 0 rgba(46, 204, 113, 0.4);
            }
            70% {
                transform: scale(1.05);
                box-shadow: 0 0 0 10px rgba(46, 204, 113, 0);
            }
            100% {
                transform: scale(1);
                box-shadow: 0 0 0 0 rgba(46, 204, 113, 0);
            }
        }
        
        @keyframes float {
            0% {
                transform: translateY(0px);
            }
            50% {
                transform: translateY(-15px);
            }
            100% {
                transform: translateY(0px);
            }
        }
        
        /* Staggered animations */
        .lesson-card:nth-child(1) { animation-delay: 0.1s; }
        .lesson-card:nth-child(2) { animation-delay: 0.2s; }
        .lesson-card:nth-child(3) { animation-delay: 0.3s; }
        .lesson-card:nth-child(4) { animation-delay: 0.4s; }
        .lesson-card:nth-child(5) { animation-delay: 0.5s; }
        .lesson-card:nth-child(6) { animation-delay: 0.6s; }
    </style>
</head>
<body class="lessons-page">
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary fixed-top">
        <div class="container-fluid">
            <a class="navbar-brand" href="../index.jsp">
                <i class="fas fa-leaf me-2"></i>EcoLearn
            </a>
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="dashboard.jsp">
                            <i class="fas fa-tachometer-alt me-1"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="lessons.jsp">
                            <i class="fas fa-graduation-cap me-1"></i>Lessons
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="games.jsp">
                            <i class="fas fa-gamepad me-1"></i>Games
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="challenges.jsp">
                            <i class="fas fa-leaf me-1"></i>Challenges
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="leaderboard.jsp">
                            <i class="fas fa-trophy me-1"></i>Leaderboard
                        </a>
                    </li>
                </ul>
                
                <ul class="navbar-nav">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle d-flex align-items-center" href="#" role="button" data-bs-toggle="dropdown">
                            <div class="user-avatar me-2">
                                <div class="avatar-placeholder">
                                    <%= userName.length() > 0 ? userName.substring(0, 1).toUpperCase() : "U" %>
                                </div>
                            </div>
                            <span class="user-name"><%= userName %></span>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item" href="profile.jsp"><i class="fas fa-user me-2"></i>Profile</a></li>
                            <li><a class="dropdown-item" href="achievements.jsp"><i class="fas fa-medal me-2"></i>Achievements</a></li>
                            <li><a class="dropdown-item" href="settings.jsp"><i class="fas fa-cog me-2"></i>Settings</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="logout.jsp"><i class="fas fa-sign-out-alt me-2"></i>Logout</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container main-content">
        <!-- Page Header -->
        <div class="page-header">
            <div class="row align-items-center">
                <div class="col-lg-8">
                    <h1 class="page-title">
                        <i class="fas fa-graduation-cap me-2"></i>Environmental Lessons
                    </h1>
                    <p class="page-subtitle">
                        Explore our interactive lessons to learn about environmental conservation, sustainability, and climate action.
                    </p>
                </div>
                <div class="col-lg-4 text-end">
                    <div class="stats-card">
                        <h5>Your Progress</h5>
                        <div class="stat-item">
                            <span class="stat-label">Lessons Completed</span>
                            <span class="stat-value">0/0</span>
                        </div>
                        <div class="stat-item">
                            <span class="stat-label">Points Earned</span>
                            <span class="stat-value">0</span>
                        </div>
                        <div class="stat-item">
                            <span class="stat-label">Current Streak</span>
                            <span class="stat-value"><%= currentStreak %> days</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Lessons Grid -->
        <div class="row">
            <%
                if (lessons.isEmpty()) {
            %>
            <div class="col-12">
                <div class="alert alert-info text-center">
                    <h4>No lessons available at the moment</h4>
                    <p>Please check back later for new educational content.</p>
                </div>
            </div>
            <%
                } else {
                    // Display lessons from database
                    for (Lesson lesson : lessons) {
            %>
            <div class="col-lg-4 col-md-6">
                <div class="lesson-card">
                    <div class="lesson-thumbnail">
                        <div class="lesson-category"><%= lesson.getCategory() != null ? lesson.getCategory() : "General" %></div>
                        <div class="lesson-duration">
                            <i class="fas fa-clock"></i> <%= lesson.getPoints() != null ? lesson.getPoints() + " points" : "N/A" %>
                        </div>
                    </div>
                    <div class="lesson-content">
                        <h5><%= lesson.getTitle() != null ? lesson.getTitle() : "Untitled Lesson" %></h5>
                        <p><%= lesson.getDescription() != null ? lesson.getDescription() : "No description available." %></p>
                        <div class="lesson-progress">
                            <div class="progress">
                                <div class="progress-bar" style="width: 0%;"></div>
                            </div>
                            <div class="progress-text">Not Started</div>
                        </div>
                        <button class="btn btn-primary btn-lesson" onclick="startLesson(<%= lesson.getId() %>)">
                            <i class="fas fa-play me-2"></i>Start Lesson
                        </button>
                    </div>
                </div>
            </div>
            <%
                    }
                }
            %>
        </div>
    </div>

    <!-- JavaScript Libraries -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Theme Management -->
    <script src="../js/theme.js"></script>
    
    <script>
        // Animate progress bars when page loads
        document.addEventListener('DOMContentLoaded', function() {
            const progressBars = document.querySelectorAll('.progress-bar');
            
            progressBars.forEach(bar => {
                const targetWidth = bar.style.width;
                bar.style.width = '0%';
                
                setTimeout(() => {
                    bar.style.transition = 'width 1.5s ease-in-out';
                    bar.style.width = targetWidth;
                }, 300);
            });
        });
        
        // Function to start a lesson
        function startLesson(lessonId) {
            // Redirect to lesson viewing page with lesson ID
            window.location.href = 'view-lesson.jsp?id=' + lessonId;
        }
    </script>
</body>
</html>