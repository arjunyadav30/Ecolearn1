<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mycompany.sih3.entity.User" %>
<%@ page import="com.mycompany.sih3.repository.UserRepository" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%
    // Get user ID from session
    Integer userId = (Integer) session.getAttribute("userId");
    String userName = "Guest";
    Integer currentUserSchoolId = null;
    Integer schoolRank = 1; // Default value
    Integer globalRank = 3; // Default value
    
    // User statistics variables
    Integer totalPoints = 0;
    Integer lessonsCompleted = 0;
    Integer challengesCompleted = 0;
    Integer gamesPlayed = 0;
    Integer pointsFromLessons = 0;
    Integer pointsFromChallenges = 0;
    Integer pointsFromGames = 0;
    Integer pointsFromBonus = 0;
    Integer currentStreak = 0;
    String currentLevel = "Seedling";
    Integer levelProgress = 0;
    Integer levelTarget = 500;
    
    // Fetch user from database if userId exists in session
    if (userId != null) {
        UserRepository userRepository = new UserRepository();
        User user = userRepository.findById(userId);
        if (user != null) {
            userName = user.getFullName();
            currentUserSchoolId = user.getSchoolId();
        }
    }
    
    // Database connection details
    String url = "jdbc:mysql://localhost/ecolearn";
    String usernameDB = "root";
    String passwordDB = "1234";
    
    // Fetch school leaderboard data from database
    ArrayList<Map<String, Object>> schoolLeaderboardData = new ArrayList<Map<String, Object>>();
    
    // Fetch recent activity data from database
    ArrayList<Map<String, Object>> recentActivityData = new ArrayList<Map<String, Object>>();
    
    Connection con = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection(url, usernameDB, passwordDB);
        
        // Fetch user's school and global rank and statistics
        if (userId != null) {
            String rankSql = "SELECT school_rank, global_rank, total_points, lessons_completed, challenges_completed, " +
                             "games_played, points_from_lessons, points_from_challenges, points_from_games, " +
                             "points_from_bonus, current_level, level_progress, level_target, current_streak " +
                             "FROM user_statistics WHERE user_id = ?";
            stmt = con.prepareStatement(rankSql);
            stmt.setInt(1, userId);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                schoolRank = rs.getInt("school_rank");
                globalRank = rs.getInt("global_rank");
                totalPoints = rs.getInt("total_points");
                lessonsCompleted = rs.getInt("lessons_completed");
                challengesCompleted = rs.getInt("challenges_completed");
                gamesPlayed = rs.getInt("games_played");
                pointsFromLessons = rs.getInt("points_from_lessons");
                pointsFromChallenges = rs.getInt("points_from_challenges");
                pointsFromGames = rs.getInt("points_from_games");
                pointsFromBonus = rs.getInt("points_from_bonus");
                // We'll calculate currentLevel, levelProgress, and levelTarget based on totalPoints
                // currentLevel = rs.getString("current_level");
                // levelProgress = rs.getInt("level_progress");
                // levelTarget = rs.getInt("level_target");
                // Get current streak
                currentStreak = rs.getObject("current_streak", Integer.class) != null ? rs.getObject("current_streak", Integer.class) : 0;
            }
            
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
        }
        
        // Calculate level progress based on current points and defined progression
        if (totalPoints < 500) {
            currentLevel = "Seedling";
            levelProgress = totalPoints;
            levelTarget = 500;
        } else if (totalPoints < 1500) {
            currentLevel = "Sprout";
            levelProgress = totalPoints - 500;
            levelTarget = 1000; // 1500 - 500
        } else if (totalPoints < 3000) {
            currentLevel = "Tree";
            levelProgress = totalPoints - 1500;
            levelTarget = 1500; // 3000 - 1500
        } else if (totalPoints < 5000) {
            currentLevel = "Forest Guardian";
            levelProgress = totalPoints - 3000;
            levelTarget = 2000; // 5000 - 3000
        } else {
            currentLevel = "Eco Warrior";
            levelProgress = totalPoints - 5000;
            levelTarget = 2000; // Continuing with 2000 point increments
        }
        
        // Fetch top 5 students from the same school
        String sql = "SELECT u.id AS user_id, u.full_name, us.total_points, us.current_level " +
                     "FROM users u " +
                     "JOIN user_statistics us ON u.id = us.user_id " +
                     "WHERE u.school_id = ? " +
                     "ORDER BY us.total_points DESC, u.full_name ASC " +
                     "LIMIT 5";
        
        stmt = con.prepareStatement(sql);
        
        // Set school ID parameter
        if (currentUserSchoolId != null) {
            stmt.setInt(1, currentUserSchoolId);
        } else {
            // If no school ID, use a default value that won't match any records
            stmt.setInt(1, -1);
        }
        
        rs = stmt.executeQuery();
        
        int rank = 1;
        while (rs.next()) {
            Map<String, Object> entry = new HashMap<String, Object>();
            entry.put("rank", rank);
            entry.put("user_id", rs.getInt("user_id"));
            entry.put("full_name", rs.getString("full_name"));
            entry.put("total_points", rs.getInt("total_points"));
            entry.put("current_level", rs.getString("current_level"));
            schoolLeaderboardData.add(entry);
            rank++;
        }
        
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        
        // Fetch recent activity for the user (last 5 activities)
        if (userId != null) {
            String activitySql = "SELECT activity_type, title, description, points_earned, created_at " +
                                 "FROM activity_log " +
                                 "WHERE user_id = ? " +
                                 "ORDER BY created_at DESC " +
                                 "LIMIT 5";
            stmt = con.prepareStatement(activitySql);
            stmt.setInt(1, userId);
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
        }
    } catch (Exception e) {
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
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - EcoLearn Platform</title>
    
    <!-- CSS Libraries with CDN Fallbacks -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" crossorigin="anonymous">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/fontawesome.min.css" rel="stylesheet" crossorigin="anonymous">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- Bootstrap CSS Fallback -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Check if Bootstrap CSS loaded
            var bootstrapTest = document.createElement('div');
            bootstrapTest.className = 'container';
            document.body.appendChild(bootstrapTest);
            var computedStyle = window.getComputedStyle(bootstrapTest);
            if (computedStyle.paddingLeft === '0px' || computedStyle.paddingRight === '0px') {
                // Bootstrap didn't load, inject minimal grid system
                var style = document.createElement('style');
                style.innerHTML = `
                    .container, .container-fluid { max-width: 1200px; margin: 0 auto; padding: 0 15px; }
                    .row { display: flex; flex-wrap: wrap; margin: 0 -15px; }
                    .col, .col-lg-3, .col-lg-4, .col-lg-8, .col-md-6, .col-12 { padding: 0 15px; }
                    .col-lg-3 { flex: 0 0 25%; max-width: 25%; }
                    .col-lg-4 { flex: 0 0 33.333333%; max-width: 33.333333%; }
                    .col-lg-8 { flex: 0 0 66.666667%; max-width: 66.666667%; }
                    .col-md-6 { flex: 0 0 50%; max-width: 50%; }
                    .col-12 { flex: 0 0 100%; max-width: 100%; }
                    @media (max-width: 768px) {
                        .col-lg-3, .col-lg-4, .col-lg-8, .col-md-6 { flex: 0 0 100%; max-width: 100%; }
                    }
                    .g-4 > * { margin-bottom: 1.5rem; }
                    .mb-4 { margin-bottom: 1.5rem !important; }
                    .mt-4 { margin-top: 1.5rem !important; }
                    .me-2 { margin-right: 0.5rem !important; }
                    .me-auto { margin-right: auto !important; }
                    .text-end { text-align: right !important; }
                    .text-muted { color: #6c757d !important; }
                    .d-flex { display: flex !important; }
                    .align-items-center { align-items: center !important; }
                    .justify-content-between { justify-content: space-between !important; }
                `;
                document.head.appendChild(style);
            }
            document.body.removeChild(bootstrapTest);
        });
    </script>
    
    <!-- Custom CSS -->
    <link href="../css/main.css" rel="stylesheet">
    
    <!-- Complete Dashboard CSS -->
    <style>
        :root {
            --primary-green: #2d8f44;
            --secondary-teal: #20c997;
            --white: #ffffff;
            --light-gray: #f8f9fa;
            --dark-gray: #343a40;
            --border-radius-lg: 0.75rem;
            --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            --spacing-md: 1rem;
            --spacing-lg: 1.5rem;
            --spacing-xl: 2rem;
            --spacing-xxl: 3rem;
        }
        
        body {
            font-family: 'Poppins', system-ui, -apple-system, sans-serif, 'Segoe UI Emoji';
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            margin: 0;
            padding: 0;
        }
        
        .dashboard-page {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            padding-top: 76px;
        }
        
        .navbar {
            background: linear-gradient(135deg, #1abc9c, #17a2b8) !important;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            height: 76px;
        }
        
        .main-content {
            padding: var(--spacing-xl) 0;
        }
        
        .welcome-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: var(--spacing-xxl);
            border-radius: var(--border-radius-lg);
            margin-bottom: var(--spacing-xl);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            position: relative;
            overflow: hidden;
        }
        
        .welcome-title {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
        
        .welcome-subtitle {
            font-size: 1.125rem;
            opacity: 0.9;
            margin-bottom: 0;
        }
        
        .streak-counter {
            text-align: center;
            background: rgba(255, 255, 255, 0.1);
            padding: 1rem;
            border-radius: var(--border-radius-lg);
        }
        
        .streak-number {
            display: block;
            font-size: 2rem;
            font-weight: 700;
            margin: 0.25rem 0;
        }
        
        .stat-card {
            background: white;
            border-radius: var(--border-radius-lg);
            padding: var(--spacing-xl);
            box-shadow: var(--shadow-md);
            height: 100%;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            margin-bottom: var(--spacing-lg);
            animation: fadeInUp 0.6s ease-out;
            position: relative;
            overflow: hidden;
        }
        
        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(90deg, var(--primary-green), var(--secondary-teal));
            transform: scaleX(1);
            transform-origin: left;
            transition: transform 0.3s ease;
        }
        
        .stat-card:hover {
            transform: translateY(-8px) scale(1.02);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
        }
        
        .stat-icon {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, var(--primary-green), var(--secondary-teal));
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: var(--spacing-md);
            color: white;
            font-size: 1.5rem;
            animation: pulse 2s infinite;
        }
        
        .stat-content h3 {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 0.25rem;
            color: var(--dark-gray);
        }
        
        .stat-content p {
            color: #6c757d;
            margin-bottom: 0.5rem;
            font-weight: 500;
        }
        
        .stat-change {
            font-size: 0.875rem;
            font-weight: 600;
        }
        
        .stat-change.positive {
            color: #28a745;
        }
        
        /* Enhanced Eco Points Card */
        .stat-card.eco-points {
            background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
            border: 1px solid rgba(46, 204, 113, 0.2);
        }
        
        .stat-card.eco-points::before {
            background: linear-gradient(90deg, #2ecc71, #27ae60);
        }
        
        .stat-card.eco-points .stat-icon {
            background: linear-gradient(135deg, #2ecc71, #27ae60);
            animation: pulseEcoPoints 2s infinite;
        }
        
        .stat-card.eco-points .stat-content h3 {
            color: #27ae60;
        }
        
        .stat-card.eco-points .stat-content p {
            color: #2ecc71;
        }
        
        .stat-card.eco-points .stat-change.positive {
            color: #27ae60;
        }
        
        .stat-card.eco-points:hover {
            box-shadow: 0 10px 25px rgba(46, 204, 113, 0.25);
        }
        
        @keyframes pulseEcoPoints {
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
        
        /* Enhanced Lessons Card */
        .stat-card.lessons {
            background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
            border: 1px solid rgba(52, 152, 219, 0.2);
        }
        
        .stat-card.lessons::before {
            background: linear-gradient(90deg, #3498db, #2980b9);
        }
        
        .stat-card.lessons .stat-icon {
            background: linear-gradient(135deg, #3498db, #2980b9);
            animation: pulseLessons 2s infinite;
        }
        
        .stat-card.lessons .stat-content h3 {
            color: #2980b9;
        }
        
        .stat-card.lessons .stat-content p {
            color: #3498db;
        }
        
        .stat-card.lessons:hover {
            box-shadow: 0 10px 25px rgba(52, 152, 219, 0.25);
        }
        
        @keyframes pulseLessons {
            0% {
                transform: scale(1);
                box-shadow: 0 0 0 0 rgba(52, 152, 219, 0.4);
            }
            70% {
                transform: scale(1.05);
                box-shadow: 0 0 0 10px rgba(52, 152, 219, 0);
            }
            100% {
                transform: scale(1);
                box-shadow: 0 0 0 0 rgba(52, 152, 219, 0);
            }
        }
        
        /* Enhanced Challenges Card */
        .stat-card.challenges {
            background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
            border: 1px solid rgba(243, 156, 18, 0.2);
        }
        
        .stat-card.challenges::before {
            background: linear-gradient(90deg, #f39c12, #d35400);
        }
        
        .stat-card.challenges .stat-icon {
            background: linear-gradient(135deg, #f39c12, #d35400);
            animation: pulseChallenges 2s infinite;
        }
        
        .stat-card.challenges .stat-content h3 {
            color: #d35400;
        }
        
        .stat-card.challenges .stat-content p {
            color: #f39c12;
        }
        
        .stat-card.challenges:hover {
            box-shadow: 0 10px 25px rgba(243, 156, 18, 0.25);
        }
        
        @keyframes pulseChallenges {
            0% {
                transform: scale(1);
                box-shadow: 0 0 0 0 rgba(243, 156, 18, 0.4);
            }
            70% {
                transform: scale(1.05);
                box-shadow: 0 0 0 10px rgba(243, 156, 18, 0);
            }
            100% {
                transform: scale(1);
                box-shadow: 0 0 0 0 rgba(243, 156, 18, 0);
            }
        }
        
        .dashboard-card {
            background: white;
            border-radius: var(--border-radius-lg);
            box-shadow: var(--shadow-md);
            margin-bottom: var(--spacing-lg);
            overflow: hidden;
            animation: fadeIn 0.8s ease-out;
            border: 1px solid rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
        }
        
        .dashboard-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.1);
        }
        
        .card-header {
            padding: var(--spacing-lg);
            border-bottom: 1px solid #e9ecef;
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
            position: relative;
            overflow: hidden;
        }
        
        .card-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 3px;
            background: linear-gradient(90deg, var(--primary-green), var(--secondary-teal));
        }
        
        .card-header h5 {
            margin: 0;
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--dark-gray);
        }
        
        .card-body {
            padding: var(--spacing-lg);
        }
        
        .quick-actions {
            display: grid;
            grid-template-columns: 1fr;
            gap: var(--spacing-md);
        }
        
        .quick-action-btn {
            background: white;
            border: 2px solid #e9ecef;
            border-radius: var(--border-radius-lg);
            padding: var(--spacing-lg);
            text-decoration: none;
            color: var(--dark-gray);
            display: flex;
            align-items: center;
            gap: var(--spacing-md);
            transition: all 0.3s ease;
            font-weight: 500;
            position: relative;
            overflow: hidden;
        }
        
        .quick-action-btn:hover {
            border-color: var(--primary-green);
            color: var(--primary-green);
            transform: translateX(8px) scale(1.02);
            text-decoration: none;
        }
        
        .quick-action-btn i {
            font-size: 1.25rem;
            width: 24px;
            text-align: center;
        }
        
        /* Enhanced Lessons Quick Action Button */
        .quick-action-btn.lessons {
            background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
            border: 2px solid #3498db;
            color: #2980b9;
        }
        
        .quick-action-btn.lessons:hover {
            background: linear-gradient(135deg, #3498db 0%, #2980b9 100%);
            color: white;
            border-color: #2980b9;
            box-shadow: 0 5px 15px rgba(52, 152, 219, 0.3);
        }
        
        .quick-action-btn.lessons i {
            color: #3498db;
        }
        
        .quick-action-btn.lessons:hover i {
            color: white;
            animation: bounce 0.5s ease;
        }
        
        /* Enhanced Challenges Quick Action Button */
        .quick-action-btn.challenges {
            background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
            border: 2px solid #f39c12;
            color: #d35400;
        }
        
        .quick-action-btn.challenges:hover {
            background: linear-gradient(135deg, #f39c12 0%, #d35400 100%);
            color: white;
            border-color: #d35400;
            box-shadow: 0 5px 15px rgba(243, 156, 18, 0.3);
        }
        
        .quick-action-btn.challenges i {
            color: #f39c12;
        }
        
        .quick-action-btn.challenges:hover i {
            color: white;
            animation: bounce 0.5s ease;
        }
        
        /* Enhanced Games Quick Action Button */
        .quick-action-btn.games {
            background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
            border: 2px solid #9b59b6;
            color: #8e44ad;
        }
        
        .quick-action-btn.games:hover {
            background: linear-gradient(135deg, #9b59b6 0%, #8e44ad 100%);
            color: white;
            border-color: #8e44ad;
            box-shadow: 0 5px 15px rgba(155, 89, 182, 0.3);
        }
        
        .quick-action-btn.games i {
            color: #9b59b6;
        }
        
        .quick-action-btn.games:hover i {
            color: white;
            animation: bounce 0.5s ease;
        }
        
        /* Enhanced Leaderboard Quick Action Button */
        .quick-action-btn.leaderboard {
            background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
            border: 2px solid #f1c40f;
            color: #f39c12;
        }
        
        .quick-action-btn.leaderboard:hover {
            background: linear-gradient(135deg, #f1c40f 0%, #f39c12 100%);
            color: white;
            border-color: #f39c12;
            box-shadow: 0 5px 15px rgba(241, 196, 15, 0.3);
        }
        
        .quick-action-btn.leaderboard i {
            color: #f1c40f;
        }
        
        .quick-action-btn.leaderboard:hover i {
            color: white;
            animation: bounce 0.5s ease;
        }
        
        .level-progress-card {
            background: linear-gradient(135deg, #fff 0%, #f8f9fa 100%);
            border-radius: var(--border-radius-lg);
            padding: var(--spacing-xl);
            box-shadow: var(--shadow-md);
            margin-bottom: var(--spacing-lg);
            animation: slideInLeft 0.7s ease-out;
        }
        
        .level-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: var(--spacing-lg);
        }
        
        .level-header h4 {
            margin: 0;
            font-size: 1.5rem;
            font-weight: 600;
        }
        
        .level-icon {
            font-size: 1.5rem;
            margin-right: 0.5rem;
        }
        
        .level-points {
            font-weight: 600;
            color: #6c757d;
        }
        
        .progress-container {
            position: relative;
        }
        
        .level-progress {
            height: 12px;
            background: #e9ecef;
            border-radius: 6px;
            overflow: hidden;
            margin-bottom: 0.5rem;
        }
        
        .progress-bar {
            height: 100%;
            background: linear-gradient(90deg, var(--primary-green), var(--secondary-teal));
            border-radius: 6px;
            width: 65%;
            transition: width 2s ease-in-out;
            position: relative;
            overflow: hidden;
        }
        
        .progress-bar::after {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.4), transparent);
            animation: shimmer 2s infinite;
        }
        
        .progress-text {
            font-size: 0.875rem;
            color: #6c757d;
            text-align: center;
        }
        
        .empty-state {
            text-align: center;
            padding: var(--spacing-xl);
            color: #6c757d;
        }
        
        .empty-state i {
            font-size: 3rem;
            margin-bottom: var(--spacing-md);
            opacity: 0.5;
        }
        
        .empty-state h6 {
            font-size: 1.125rem;
            font-weight: 600;
            margin-bottom: var(--spacing-sm);
        }
        
        .empty-state p {
            margin-bottom: var(--spacing-lg);
        }
        
        .btn {
            padding: 0.75rem 1.5rem;
            border-radius: var(--border-radius-lg);
            font-weight: 500;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            position: relative;
            overflow: hidden;
        }
        
        .btn-success {
            background: linear-gradient(135deg, var(--primary-green), var(--secondary-teal));
            color: white;
        }
        
        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(45, 143, 68, 0.4);
            color: white;
            text-decoration: none;
        }
        
        .btn-primary {
            background: #007bff;
            color: white;
        }
        
        .btn-outline-primary {
            border: 2px solid #007bff;
            color: #007bff;
            background: transparent;
        }
        
        .btn-outline-primary:hover {
            background: #007bff;
            color: white;
        }
        
        /* Enhanced Icon Visibility Fix */
        /* Ensure all Font Awesome icons are properly displayed */
        [class^="fas"], [class*=" fas"],
        [class^="far"], [class*=" far"],
        [class^="fal"], [class*=" fal"],
        [class^="fab"], [class*=" fab"] {
            display: inline-block;
            font-family: 'Font Awesome 6 Free' !important;
            font-weight: 900 !important;
            speak: none;
            text-rendering: auto;
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
        }
        
        /* Specific icon container fixes */
        .nav-link i, .stat-icon > i, .points-icon > i, .activity-icon > i, .badge-icon {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25em;
            width: 1.5em;
            height: 1.5em;
            text-align: center;
            vertical-align: middle;
        }
        
        /* Force proper rendering in all contexts */
        i[class*="fa-"], .fa[class*="fa-"] {
            font-family: 'Font Awesome 6 Free', 'Font Awesome 6 Brands' !important;
            font-display: swap;
        }
        
        /* Responsive Design */
        @media (max-width: 768px) {
            .dashboard-page {
                padding-top: 60px;
            }
            
            .welcome-section {
                padding: var(--spacing-lg);
                text-align: center;
            }
            
            .welcome-title {
                font-size: 1.5rem;
            }
            
            .stat-card {
                margin-bottom: var(--spacing-md);
            }
            
            .level-header {
                flex-direction: column;
                gap: var(--spacing-sm);
                text-align: center;
            }
        }
        
        /* Activity Timeline */
        .activity-timeline {
            position: relative;
        }
        
        .activity-item {
            display: flex;
            align-items: flex-start;
            gap: var(--spacing-md);
            padding: var(--spacing-md) 0;
            border-bottom: 1px solid #f1f3f4;
            animation: fadeIn 0.5s ease-out;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .activity-item:hover {
            transform: translateX(5px);
            background: linear-gradient(90deg, rgba(45, 143, 68, 0.05) 0%, transparent 100%);
            border-radius: 8px;
            padding-left: 15px;
            margin-left: -15px;
            margin-right: -15px;
            padding-right: 15px;
        }
        
        .activity-item.new-activity {
            animation: highlightActivity 2s ease-out;
            position: relative;
        }
        
        @keyframes highlightActivity {
            0% {
                background-color: rgba(45, 143, 68, 0.2);
                transform: translateX(10px);
            }
            50% {
                background-color: rgba(45, 143, 68, 0.3);
                transform: translateX(15px);
            }
            100% {
                background-color: transparent;
                transform: translateX(0);
            }
        }
        
        .activity-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 3px;
            height: 100%;
            background: linear-gradient(to bottom, var(--primary-green), var(--secondary-teal));
            transform: scaleY(0);
            transition: transform 0.3s ease;
            transform-origin: top;
        }
        
        .activity-item:hover::before {
            transform: scaleY(1);
        }
        
        /* Eco Points Breakdown Styles */
        .points-stat {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 1rem;
            background: #f8f9fa;
            border-radius: 8px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            animation: bounceIn 0.6s ease-out;
            position: relative;
            overflow: hidden;
            border: 1px solid #e9ecef;
        }
        
        .points-stat::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(120deg, transparent, rgba(255, 255, 255, 0.3), transparent);
            transform: translateX(-100%);
            transition: transform 0.6s;
        }
        
        .points-stat:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        
        .points-stat:hover::before {
            transform: translateX(100%);
        }
        
        .points-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.2rem;
        }
        
        .points-icon.lessons {
            background: linear-gradient(135deg, #3498db, #2980b9);
            animation: pulseLessonsSmall 1.5s infinite;
        }
        
        @keyframes pulseLessonsSmall {
            0% {
                transform: scale(1);
                box-shadow: 0 0 0 0 rgba(52, 152, 219, 0.4);
            }
            70% {
                transform: scale(1.1);
                box-shadow: 0 0 0 5px rgba(52, 152, 219, 0);
            }
            100% {
                transform: scale(1);
                box-shadow: 0 0 0 0 rgba(52, 152, 219, 0);
            }
        }
        
        .points-icon.challenges {
            background: linear-gradient(135deg, #f39c12, #d35400);
            animation: pulseChallengesSmall 1.5s infinite;
        }
        
        @keyframes pulseChallengesSmall {
            0% {
                transform: scale(1);
                box-shadow: 0 0 0 0 rgba(243, 156, 18, 0.4);
            }
            70% {
                transform: scale(1.1);
                box-shadow: 0 0 0 5px rgba(243, 156, 18, 0);
            }
            100% {
                transform: scale(1);
                box-shadow: 0 0 0 0 rgba(243, 156, 18, 0);
            }
        }
        
        .points-icon.games {
            background: linear-gradient(135deg, #6f42c1, #e83e8c);
        }
        
        .points-icon.bonus {
            background: linear-gradient(135deg, #17a2b8, #6610f2);
        }
        
        .points-info {
            flex: 1;
        }
        
        .points-value {
            display: block;
            font-size: 1.5rem;
            font-weight: 700;
            color: #212529;
            line-height: 1;
        }
        
        .points-label {
            display: block;
            font-size: 0.875rem;
            color: #6c757d;
            margin-top: 2px;
        }
        
        .level-badges {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            justify-content: center;
        }
        
        .level-badge {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 12px 16px;
            background: #f8f9fa;
            border-radius: 8px;
            border: 2px solid #e9ecef;
            transition: all 0.3s ease;
            min-width: 80px;
            animation: bounceIn 0.5s ease-out;
            position: relative;
            overflow: hidden;
        }
        
        .level-badge::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(120deg, transparent, rgba(255, 255, 255, 0.3), transparent);
            transform: translateX(-100%);
            transition: transform 0.6s;
        }
        
        .level-badge:hover::before {
            transform: translateX(100%);
        }
        
        .level-badge.active {
            background: linear-gradient(135deg, var(--primary-green), var(--secondary-teal));
            color: white;
            border-color: var(--primary-green);
            transform: scale(1.05);
            animation: pulse 1.5s infinite;
            box-shadow: 0 5px 15px rgba(45, 143, 68, 0.3);
        }
        
        .level-badge.active::before {
            display: none;
        }
        
        .badge-icon {
            font-size: 1.5rem;
            margin-bottom: 4px;
        }
        
        .badge-name {
            font-size: 0.75rem;
            font-weight: 600;
            margin-bottom: 2px;
        }
        
        .badge-points {
            font-size: 0.625rem;
            opacity: 0.8;
        }
        
        .activity-item:last-child {
            border-bottom: none;
        }
        
        .activity-icon {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, var(--primary-green), var(--secondary-teal));
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            flex-shrink: 0;
            animation: bounce 2s infinite;
            box-shadow: 0 4px 8px rgba(45, 143, 68, 0.3);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .activity-icon::after {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(rgba(255, 255, 255, 0.2) 0%, transparent 50%);
            transform: rotate(30deg);
            transition: all 0.6s ease;
        }
        
        .activity-item:hover .activity-icon {
            transform: scale(1.1) rotate(5deg);
            box-shadow: 0 6px 12px rgba(45, 143, 68, 0.4);
        }
        
        .activity-item:hover .activity-icon::after {
            transform: rotate(30deg) translate(20%, 20%);
        }
        
        .activity-content {
            flex: 1;
        }
        
        .activity-content h6 {
            margin: 0 0 0.25rem 0;
            font-size: 1rem;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .activity-content p {
            margin: 0 0 0.25rem 0;
            color: #6c757d;
            transition: all 0.3s ease;
        }
        
        .activity-points {
            font-weight: 600;
            color: var(--primary-green);
            font-size: 1.125rem;
            transition: all 0.3s ease;
            animation: pulse 1.5s infinite;
            background: linear-gradient(135deg, #2ecc71, #27ae60);
            padding: 5px 10px;
            border-radius: 20px;
            color: white;
            box-shadow: 0 2px 5px rgba(45, 143, 68, 0.3);
        }
        
        .activity-item:hover .activity-content h6 {
            color: var(--primary-green);
            transform: translateX(5px);
        }
        
        .activity-item:hover .activity-content p {
            color: #495057;
        }
        
        .activity-item:hover .activity-points {
            transform: scale(1.1);
            color: #27ae60;
        }
        
        /* Transaction and Achievement Items */
        .transaction-item, .achievement-item {
            padding: 0.75rem 0;
            border-bottom: 1px solid #f1f3f4;
            animation: fadeIn 0.4s ease-out;
        }
        
        .transaction-item:last-child, .achievement-item:last-child {
            border-bottom: none;
        }
        
        .transaction-item .badge, .achievement-item .badge {
            font-size: 0.75rem;
        }
        
        /* Floating particles effect */
        .floating-particle {
            position: absolute;
            border-radius: 50%;
            pointer-events: none;
            z-index: 1;
        }
        
        /* Unique Dashboard Leaderboard Styles */
        .eco-leaderboard-container {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }
        
        .eco-leaderboard-item {
            display: flex;
            align-items: center;
            padding: 12px 16px;
            background: #f8f9fa;
            border-radius: 12px;
            transition: all 0.3s ease;
            border: 2px solid transparent;
            position: relative;
            overflow: hidden;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        }
        
        .eco-leaderboard-item:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.1);
            border-color: var(--primary-teal);
            background: linear-gradient(90deg, #fff 0%, #f1f9f5 100%);
        }
        
        .eco-leaderboard-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 4px;
            height: 100%;
            background: linear-gradient(to bottom, var(--primary-teal), var(--secondary-cyan));
            transform: scaleY(0);
            transition: transform 0.3s ease;
        }
        
        .eco-leaderboard-item:hover::before {
            transform: scaleY(1);
        }
        
        .eco-rank-display {
            width: 36px;
            height: 36px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 1rem;
            border-radius: 50%;
            margin-right: 12px;
            flex-shrink: 0;
        }
        
        .eco-rank-display.gold {
            background: linear-gradient(135deg, #FFD700, #FFA500);
            color: #212529;
            box-shadow: 0 2px 4px rgba(255, 215, 0, 0.3);
        }
        
        .eco-rank-display.silver {
            background: linear-gradient(135deg, #C0C0C0, #A9A9A9);
            color: #212529;
            box-shadow: 0 2px 4px rgba(192, 192, 192, 0.3);
        }
        
        .eco-rank-display.bronze {
            background: linear-gradient(135deg, #CD7F32, #A0522D);
            color: #fff;
            box-shadow: 0 2px 4px rgba(205, 127, 50, 0.3);
        }
        
        .eco-rank-display.standard {
            background: linear-gradient(135deg, #6c757d, #495057);
            color: #fff;
            box-shadow: 0 2px 4px rgba(108, 117, 125, 0.3);
        }
        
        .eco-player-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary-teal), var(--secondary-cyan));
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
            margin-right: 12px;
            flex-shrink: 0;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
        }
        
        .eco-player-info {
            flex: 1;
            min-width: 0;
        }
        
        .eco-player-info h6 {
            margin: 0 0 4px 0;
            font-size: 0.95rem;
            font-weight: 600;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        
        .eco-player-info small {
            color: #6c757d;
            font-size: 0.8rem;
        }
        
        .eco-level-badge {
            display: inline-block;
            padding: 2px 8px;
            border-radius: 20px;
            font-size: 0.7rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .eco-level-badge.seedling {
            background: linear-gradient(135deg, #20c997, #0f5132);
            color: white;
        }
        
        .eco-level-badge.sprout {
            background: linear-gradient(135deg, #198754, #0f5132);
            color: white;
        }
        
        .eco-level-badge.tree {
            background: linear-gradient(135deg, #157347, #0f5132);
            color: white;
        }
        
        .eco-level-badge.forest-guardian {
            background: linear-gradient(135deg, #0f5132, #0d3b28);
            color: white;
        }
        
        .eco-level-badge.eco-warrior {
            background: linear-gradient(135deg, #0d3b28, #0a2e1f);
            color: white;
        }
        
        .eco-player-stats {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            margin-left: 12px;
            position: relative;
            z-index: 2; /* Ensure stats are above the "You" indicator */
        }
        
        .eco-stat-value {
            font-weight: 700;
            font-size: 1.1rem;
            color: var(--dark-gray);
        }
        
        .eco-stat-label {
            font-size: 0.7rem;
            color: #6c757d;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        /* Current user highlight */
        .eco-leaderboard-item.current-user {
            background: linear-gradient(90deg, #e8f5e9 0%, #c8e6c9 100%);
            border-color: var(--primary-teal);
        }
        
        .eco-leaderboard-item.current-user::after {
            content: 'You';
            position: absolute;
            top: 8px;
            right: 8px;
            background: var(--primary-teal);
            color: white;
            font-size: 0.7rem;
            font-weight: 600;
            padding: 2px 6px;
            border-radius: 4px;
            z-index: 1; /* Ensure "You" is below the stats */
        }
        
        /* Empty state */
        .eco-leaderboard-empty {
            text-align: center;
            padding: 2rem;
            color: #6c757d;
        }
        
        .eco-leaderboard-empty i {
            font-size: 3rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }
        
        .eco-leaderboard-empty h6 {
            font-size: 1.125rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
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
        
        @keyframes slideInLeft {
            from {
                opacity: 0;
                transform: translateX(-50px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }
        
        @keyframes bounceIn {
            0% {
                opacity: 0;
                transform: scale(0.3);
            }
            50% {
                opacity: 1;
                transform: scale(1.05);
            }
            70% {
                transform: scale(0.9);
            }
            100% {
                opacity: 1;
                transform: scale(1);
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
        
        @keyframes bounce {
            0%, 20%, 50%, 80%, 100% {
                transform: translateY(0);
            }
            40% {
                transform: translateY(-10px);
            }
            60% {
                transform: translateY(-5px);
            }
        }
        
        @keyframes slideInRight {
            from {
                opacity: 0;
                transform: translateX(-30px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }
        
        @keyframes shimmer {
            0% {
                left: -100%;
            }
            100% {
                left: 100%;
            }
        }
        
        @keyframes floatParticle {
            0%, 100% {
                transform: translateY(0px) translateX(0px) rotate(0deg);
                opacity: 0.3;
            }
            25% {
                transform: translateY(-20px) translateX(10px) rotate(90deg);
                opacity: 0.8;
            }
            50% {
                transform: translateY(-10px) translateX(-15px) rotate(180deg);
                opacity: 0.5;
            }
            75% {
                transform: translateY(-25px) translateX(5px) rotate(270deg);
                opacity: 0.7;
            }
        }
        
        @keyframes ripple {
            to {
                transform: scale(4);
                opacity: 0;
            }
        }
        
        /* Staggered animations */
        .stat-card:nth-child(1) { animation-delay: 0.1s; }
        .stat-card:nth-child(2) { animation-delay: 0.2s; }
        .stat-card:nth-child(3) { animation-delay: 0.3s; }
        .stat-card:nth-child(4) { animation-delay: 0.4s; }
        
        .points-stat:nth-child(1) { animation-delay: 0.1s; }
        .points-stat:nth-child(2) { animation-delay: 0.2s; }
        .points-stat:nth-child(3) { animation-delay: 0.3s; }
        .points-stat:nth-child(4) { animation-delay: 0.4s; }
        
        .level-badge:nth-child(1) { animation-delay: 0.1s; }
        .level-badge:nth-child(2) { animation-delay: 0.2s; }
        .level-badge:nth-child(3) { animation-delay: 0.3s; }
        .level-badge:nth-child(4) { animation-delay: 0.4s; }
        .level-badge:nth-child(5) { animation-delay: 0.5s; }
        
        .activity-item:nth-child(1) { animation-delay: 0.1s; }
        .activity-item:nth-child(2) { animation-delay: 0.2s; }
        .activity-item:nth-child(3) { animation-delay: 0.3s; }
        .activity-item:nth-child(4) { animation-delay: 0.4s; }
        .activity-item:nth-child(5) { animation-delay: 0.5s; }
        
        /* Leaderboard rank colors */
        .rank.gold {
            color: gold;
        }
        
        .rank.silver {
            color: silver;
        }
        
        .rank.bronze {
            color: #cd7f32;
        }
        
    </style>
    
    <!-- Enhanced Rank Card Styles -->
    <style>
        .stat-card.rank {
            background: linear-gradient(135deg, #ff9800 0%, #ff5722 100%);
            border: none;
            position: relative;
            overflow: hidden;
            transform: translateY(0);
            transition: all 0.3s ease;
            background-image: radial-gradient(circle at 10% 20%, rgba(255, 255, 255, 0.1) 0%, transparent 20%),
                              radial-gradient(circle at 90% 80%, rgba(255, 255, 255, 0.1) 0%, transparent 20%);
            animation: floatRank 3s ease-in-out infinite;
        }
        
        .stat-card.rank::after {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(rgba(255, 255, 255,0.1) 0%, transparent 50%);
            transform: rotate(30deg);
            transition: all 0.6s ease;
        }
        
        .stat-card.rank:hover::after {
            transform: rotate(30deg) translate(20%, 20%);
        }
        
        .stat-card.rank:hover {
            animation: none;
            transform: translateY(-8px) scale(1.02);
            box-shadow: 0 15px 30px rgba(255, 152, 0, 0.3);
        }
        
        .stat-card.rank::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(90deg, #ffd700, #ffa500, #ff8c00);
        }
        
        .stat-card.rank:hover {
            box-shadow: 0 15px 30px rgba(255, 152, 0, 0.3);
        }
        
        .stat-card.rank .stat-icon {
            background: linear-gradient(135deg, #ffd700, #ffa500);
            animation: pulseRank 1.5s infinite;
            box-shadow: 0 4px 8px rgba(255, 152, 0, 0.3);
        }
        
        .stat-card.rank .stat-content h3 {
            color: #000000;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
            font-size: 2.8rem;
            margin-bottom: 0.5rem;
        }
        
        .stat-card.rank .stat-content p {
            color: #000000;
            font-weight: 500;
            font-size: 1.1rem;
            margin-bottom: 0.75rem;
        }
        
        .stat-card.rank .stat-change {
            color: #000000;
            font-weight: 600;
            padding: 0.5rem;
            background: rgba(0, 0, 0, 0.1);
            border-radius: 20px;
            display: inline-block;
        }
        
        .stat-card.rank .stat-change i {
            color: #000000;
        }
        
        /* Special styling for silver rank */
        /* Removed as all text is now black */
        

        
        /* Enhanced floating animation for rank card */
        @keyframes floatRank {
            0% {
                transform: translateY(0px);
            }
            50% {
                transform: translateY(-10px);
            }
            100% {
                transform: translateY(0px);
            }
        }
        
        @keyframes pulseRank {
            0% {
                transform: scale(1);
                box-shadow: 0 0 0 0 rgba(255, 215, 0, 0.4);
            }
            70% {
                transform: scale(1.05);
                box-shadow: 0 0 0 10px rgba(255, 215, 0, 0);
            }
            100% {
                transform: scale(1);
                box-shadow: 0 0 0 0 rgba(255, 215, 0, 0);
            }
        }
        
        /* Floating animation for Recent Activity card */
        @keyframes floatCard {
            0% {
                transform: translateY(0px);
            }
            50% {
                transform: translateY(-5px);
            }
            100% {
                transform: translateY(0px);
            }
        }
        
        /* Medal badge for top ranks */
        .medal-badge {
            position: absolute;
            top: 20px;
            right: 20px;
            width: 36px;
            height: 36px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #212529;
            font-size: 0.8rem;
            font-weight: bold;
            z-index: 2;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.3);
            animation: bounce 2s infinite;
            border: 2px solid rgba(255, 255, 255, 0.5);
        }
        
        .medal-badge.medal-silver {
            color: #212529; /* Dark color for better visibility on silver */
            text-shadow: 0 0 1px rgba(255, 255, 255, 0.8);
        }
        
        .medal-badge.medal-bronze {
            color: #FFFFFF; /* White color for better visibility on bronze */
            text-shadow: 0 0 2px rgba(0, 0, 0, 0.7); /* Add text shadow for better contrast */
        }
        
        .medal-gold {
            background: linear-gradient(135deg, #FFD700, #FFA500);
            box-shadow: 0 0 15px rgba(255, 215, 0, 0.5);
            animation: pulseMedal 2s infinite;
        }
        
        .medal-silver {
            background: linear-gradient(135deg, #C0C0C0, #A9A9A9);
            box-shadow: 0 0 15px rgba(192, 192, 192, 0.5);
            animation: pulseMedal 2s infinite;
        }
        
        .medal-bronze {
            background: linear-gradient(135deg, #CD7F32, #A0522D);
            box-shadow: 0 0 15px rgba(205, 127, 50, 0.5);
            animation: pulseMedal 2s infinite;
        }
        
        @keyframes pulseMedal {
            0% {
                transform: scale(1) rotate(0deg);
            }
            50% {
                transform: scale(1.1) rotate(5deg);
            }
            100% {
                transform: scale(1) rotate(0deg);
            }
        }
        
        /* Rank position indicator */
        .rank-position {
            position: absolute;
            top: 10px;
            left: 10px;
            font-size: 0.8rem;
            font-weight: bold;
            color: #000000;
            text-shadow: 0 0 2px rgba(255, 255, 255, 0.8);
        }
    </style>
</head>
<body class="dashboard-page">
    
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
                        <a class="nav-link active" href="dashboard.jsp">
                            <i class="fas fa-tachometer-alt me-1"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="lessons.jsp">
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
                        <a class="nav-link" href="community-impact.jsp">
                            <i class="fas fa-globe-americas me-1"></i>Community Impact
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
        <!-- Welcome Section -->
        <div class="welcome-section">
            <div class="row align-items-center">
                <div class="col-lg-8">
                    <h1 class="welcome-title">
                        Welcome back, <%= userName %>! <i class="fas fa-tree" style="color: #2d8f44;"></i>
                    </h1>
                    <p class="welcome-subtitle">
                        Ready to continue your environmental learning journey? You're currently a <strong><%= currentLevel %></strong> with <strong><%= String.format("%,d", totalPoints) %> eco-points</strong>!
                    </p>
                </div>
                <div class="col-lg-4 text-end">
                    <div class="streak-counter">
                        <i class="fas fa-fire text-warning" style="font-size: 1.5em;"></i>
                        <span class="streak-number"><%= currentStreak != null ? currentStreak : 0 %></span>
                        <span class="streak-text">Day Streak</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Stats -->
        <div class="row g-4 mb-4">
            <div class="col-lg-3 col-md-6">
                <div class="stat-card eco-points">
                    <div class="stat-icon">
                        <i class="fas fa-leaf"></i>
                    </div>
                    <div class="stat-content">
                        <h3><%= String.format("%,d", totalPoints) %></h3>
                        <p>Total Eco Points</p>
                        <div class="stat-change positive">
                            <i class="fas fa-arrow-up"></i> +45 today
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-3 col-md-6">
                <div class="stat-card lessons">
                    <div class="stat-icon">
                        <i class="fas fa-graduation-cap"></i>
                    </div>
                    <div class="stat-content">
                        <h3><%= lessonsCompleted %></h3>
                        <p>Lessons Completed</p>
                        <div class="stat-change">
                            <i class="fas fa-leaf"></i> <%= pointsFromLessons %> points earned
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-3 col-md-6">
                <div class="stat-card challenges">
                    <div class="stat-icon">
                        <i class="fas fa-trophy"></i>
                    </div>
                    <div class="stat-content">
                        <h3><%= challengesCompleted %></h3>
                        <p>Challenges Completed</p>
                        <div class="stat-change positive">
                            <i class="fas fa-leaf"></i> <%= pointsFromChallenges %> points earned
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-3 col-md-6">
                <div class="stat-card rank">
                    <div class="rank-position">RANK</div>
                    <% if (schoolRank <= 3) { %>
                        <div class="medal-badge <%= schoolRank == 1 ? "medal-gold" : (schoolRank == 2 ? "medal-silver" : "medal-bronze") %>" title="<%= schoolRank == 1 ? "Gold Medal - 1st Place" : (schoolRank == 2 ? "Silver Medal - 2nd Place" : "Bronze Medal - 3rd Place") %>">
                            <i class="fas fa-medal"></i>
                        </div>
                    <% } %>
                    <div class="stat-icon">
                        <i class="fas fa-medal"></i>
                    </div>
                    <div class="stat-content">
                        <h3>#<%= schoolRank %></h3>
                        <p>School Rank</p>
                        <div class="stat-change">
                            <i class="fas fa-globe"></i> Global: #<%= globalRank %>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Level Progress -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="level-progress-card">
                    <div class="level-header">
                        <h4>
                            <i class="fas fa-tree" style="font-size: 1.5em; color: #2d8f44;"></i>
                            Current Level: <%= currentLevel %>
                        </h4>
                        <div class="level-points">
                            <%= String.format("%,d", levelProgress) %> / <%= String.format("%,d", levelTarget) %> points
                        </div>
                    </div>
                    <div class="progress-container">
                        <div class="progress level-progress">
                            <div class="progress-bar" data-level-progress="<%= levelProgress %>" data-level-target="<%= levelTarget %>"></div>
                        </div>
                        <div class="progress-text">
                            <%= String.format("%,d", (levelTarget - levelProgress)) %> points to next level
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Eco Points Breakdown -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="dashboard-card">
                    <div class="card-header">
                        <h5><i class="fas fa-coins me-2"></i>Eco Points Overview</h5>
                        <div class="d-flex gap-2">
                            <span class="badge bg-success"><%= String.format("%,d", totalPoints) %> Total Points</span>
                            <span class="badge bg-info">Rank #<%= globalRank %></span>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="row g-3">
                            <div class="col-md-3">
                                <div class="points-stat">
                                    <div class="points-icon lessons">
                                        <i class="fas fa-graduation-cap"></i>
                                    </div>
                                    <div class="points-info">
                                        <span class="points-value"><%= pointsFromLessons %></span>
                                        <span class="points-label">From Lessons</span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="points-stat">
                                    <div class="points-icon challenges">
                                        <i class="fas fa-trophy"></i>
                                    </div>
                                    <div class="points-info">
                                        <span class="points-value"><%= pointsFromChallenges %></span>
                                        <span class="points-label">From Challenges</span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="points-stat">
                                    <div class="points-icon games">
                                        <i class="fas fa-gamepad"></i>
                                    </div>
                                    <div class="points-info">
                                        <span class="points-value"><%= pointsFromGames %></span>
                                        <span class="points-label">From Games</span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="points-stat">
                                    <div class="points-icon bonus">
                                        <i class="fas fa-gift"></i>
                                    </div>
                                    <div class="points-info">
                                        <span class="points-value"><%= pointsFromBonus %></span>
                                        <span class="points-label">Bonus & Others</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="mt-4">
                            <h6 class="mb-3">Level Progression</h6>
                            <div class="level-badges">
                                <div class="level-badge <%= "Seedling".equals(currentLevel) ? "active" : "" %>">
                                    <i class="fas fa-seedling" style="font-size: 1.5em; color: #2d8f44;"></i>
                                    <span class="badge-name">Seedling</span>
                                    <span class="badge-points">0 pts</span>
                                </div>
                                <div class="level-badge <%= "Sprout".equals(currentLevel) ? "active" : "" %>">
                                    <i class="fas fa-leaf" style="font-size: 1.5em; color: #2d8f44;"></i>
                                    <span class="badge-name">Sprout</span>
                                    <span class="badge-points">500 pts</span>
                                </div>
                                <div class="level-badge <%= "Tree".equals(currentLevel) ? "active" : "" %>">
                                    <i class="fas fa-tree" style="font-size: 1.5em; color: #2d8f44;"></i>
                                    <span class="badge-name">Tree</span>
                                    <span class="badge-points">1,500 pts</span>
                                </div>
                                <div class="level-badge <%= "Forest Guardian".equals(currentLevel) ? "active" : "" %>">
                                    <i class="fas fa-mountain" style="font-size: 1.5em; color: #2d8f44;"></i>
                                    <span class="badge-name">Forest Guardian</span>
                                    <span class="badge-points">3,000 pts</span>
                                </div>
                                <div class="level-badge <%= "Eco Warrior".equals(currentLevel) ? "active" : "" %>">
                                    <i class="fas fa-globe-americas" style="font-size: 1.5em; color: #2d8f44;"></i>
                                    <span class="badge-name">Eco Warrior</span>
                                    <span class="badge-points">5,000 pts</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- AI Personalized Recommendations -->
        <div class="row mb-4">
            <div class="col-12">
                <div id="ai-recommendations-container">
                    <div class="text-center p-4">
                        <div class="spinner-border text-success" role="status">
                            <span class="visually-hidden">Loading...</span>
                        </div>
                        <p class="mt-2">Generating personalized recommendations...</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Main Dashboard Content -->
        <div class="row g-4">
            <!-- Left Column -->
            <div class="col-lg-8">
                <!-- Recent Activity -->
                <div class="dashboard-card">
                    <div class="card-header">
                        <h5><i class="fas fa-clock me-2"></i>Recent Activity</h5>
                        <div class="d-flex gap-2">
                            <a href="#" class="btn btn-sm btn-outline-primary">View All</a>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="activity-timeline">
                            <%
                                // Display recent activity from database
                                if (recentActivityData != null && !recentActivityData.isEmpty()) {
                                    for (int i = 0; i < recentActivityData.size(); i++) {
                                        Map<String, Object> activity = recentActivityData.get(i);
                                        String activityType = (String) activity.get("activity_type");
                                        String title = (String) activity.get("title");
                                        String description = (String) activity.get("description");
                                        Integer pointsEarned = (Integer) activity.get("points_earned");
                                        Timestamp createdAt = (Timestamp) activity.get("created_at");
                                        
                                        // Calculate time ago
                                        String timeAgo = "Just now";
                                        if (createdAt != null) {
                                            long diffInMillis = System.currentTimeMillis() - createdAt.getTime();
                                            long diffInMinutes = diffInMillis / (60 * 1000);
                                            long diffInHours = diffInMillis / (60 * 60 * 1000);
                                            long diffInDays = diffInMillis / (24 * 60 * 60 * 1000);
                                            
                                            if (diffInDays > 0) {
                                                timeAgo = diffInDays + " day" + (diffInDays > 1 ? "s" : "") + " ago";
                                            } else if (diffInHours > 0) {
                                                timeAgo = diffInHours + " hour" + (diffInHours > 1 ? "s" : "") + " ago";
                                            } else if (diffInMinutes > 0) {
                                                timeAgo = diffInMinutes + " minute" + (diffInMinutes > 1 ? "s" : "") + " ago";
                                            }
                                        }
                                        
                                        // Determine icon based on activity type
                                        String iconClass = "fas fa-trophy";
                                        if ("lesson".equals(activityType)) {
                                            iconClass = "fas fa-graduation-cap";
                                        } else if ("game".equals(activityType)) {
                                            iconClass = "fas fa-gamepad";
                                        } else if ("achievement".equals(activityType)) {
                                            iconClass = "fas fa-medal";
                                        } else if ("challenge".equals(activityType)) {
                                            iconClass = "fas fa-leaf";
                                        }
                                        
                                        // Add animation delay
                                        double animationDelay = i * 0.1;
                            %>
                            <div class="activity-item" style="animation: slideInRight 0.6s ease-out; animation-delay: <%= animationDelay %>s;">
                                <div class="activity-icon">
                                    <i class="<%= iconClass %>"></i>
                                </div>
                                <div class="activity-content">
                                    <h6><%= title != null ? title : "" %></h6>
                                    <p><%= pointsEarned != null ? "+" + pointsEarned : "+0" %> eco-points</p>
                                    <small class="text-muted"><%= timeAgo %></small>
                                </div>
                                <div class="activity-points">
                                    <%= pointsEarned != null ? "+" + pointsEarned : "+0" %>
                                </div>
                            </div>
                            <%
                                    }
                                } else {
                            %>
                            <div class="text-center p-4">
                                <i class="fas fa-info-circle text-muted" style="font-size: 3rem;"></i>
                                <h6 class="mt-3">No Recent Activity</h6>
                                <p class="text-muted">Complete lessons, challenges, or games to see your activity here.</p>
                            </div>
                            <%
                                }
                            %>
                        </div>
                    </div>
                </div>

                <!-- Recent Transactions & Achievements Side by Side -->
                <div class="row mt-4">
                    <!-- Recent Transactions -->
                    <div class="col-md-6">
                        <div class="dashboard-card h-100">
                            <div class="card-header">
                                <h5><i class="fas fa-exchange-alt me-2"></i>Recent Transactions</h5>
                            </div>
                            <div class="card-body">
                                <div class="transactions-list">
                                    <div class="transaction-item">
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <div>
                                                <i class="fas fa-trophy me-2"></i>
                                                <span>Plastic-Free Week Challenge</span>
                                            </div>
                                            <span class="badge bg-success">+150</span>
                                        </div>
                                        <small class="text-muted">2 hours ago</small>
                                    </div>
                                    
                                    <div class="transaction-item">
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <div>
                                                <i class="fas fa-graduation-cap me-2"></i>
                                                <span>Renewable Energy Lesson</span>
                                            </div>
                                            <span class="badge bg-success">+100</span>
                                        </div>
                                        <small class="text-muted">1 day ago</small>
                                    </div>
                                    
                                    <div class="transaction-item">
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <div>
                                                <i class="fas fa-gamepad me-2"></i>
                                                <span>Eco Sorting Game</span>
                                            </div>
                                            <span class="badge bg-success">+50</span>
                                        </div>
                                        <small class="text-muted">2 days ago</small>
                                    </div>
                                    
                                    <div class="transaction-item">
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <div>
                                                <i class="fas fa-leaf me-2"></i>
                                                <span>Plant a Tree Challenge</span>
                                            </div>
                                            <span class="badge bg-success">+100</span>
                                        </div>
                                        <small class="text-muted">4 days ago</small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Recent Achievements -->
                    <div class="col-md-6">
                        <div class="dashboard-card h-100">
                            <div class="card-header">
                                <h5><i class="fas fa-medal me-2"></i>Recent Achievements</h5>
                            </div>
                            <div class="card-body">
                                <div class="achievements-list">
                                    <div class="achievement-item">
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <div>
                                                <i class="fas fa-medal me-2"></i>
                                                <span>Eco Warrior</span>
                                            </div>
                                            <span class="badge bg-warning">+75</span>
                                        </div>
                                        <small class="text-muted">3 days ago</small>
                                    </div>
                                    
                                    <div class="achievement-item">
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <div>
                                                <i class="fas fa-trophy me-2"></i>
                                                <span>Challenge Master</span>
                                            </div>
                                            <span class="badge bg-warning">+50</span>
                                        </div>
                                        <small class="text-muted">1 week ago</small>
                                    </div>
                                    
                                    <div class="achievement-item">
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <div>
                                                <i class="fas fa-graduation-cap me-2"></i>
                                                <span>Lesson Expert</span>
                                            </div>
                                            <span class="badge bg-warning">+40</span>
                                        </div>
                                        <small class="text-muted">2 weeks ago</small>
                                    </div>
                                    
                                    <div class="achievement-item">
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <div>
                                                <i class="fas fa-gamepad me-2"></i>
                                                <span>Game Champion</span>
                                            </div>
                                            <span class="badge bg-warning">+30</span>
                                        </div>
                                        <small class="text-muted">3 weeks ago</small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Column -->
            <div class="col-lg-4">
                <!-- Recent Achievements (moved from Quick Actions position) -->
                <div class="dashboard-card">
                    <div class="card-header">
                        <h5><i class="fas fa-medal me-2"></i>Recent Achievements</h5>
                        <a href="#" class="btn btn-sm btn-outline-primary">View All</a>
                    </div>
                    <div class="card-body">
                        <div class="achievements-list">
                            <div class="achievement-item">
                                <div class="achievement-icon">
                                    <i class="fas fa-medal text-warning" style="font-size: 2rem;"></i>
                                </div>
                                <div class="achievement-content">
                                    <h6>Eco Warrior</h6>
                                    <p>Complete 10 challenges</p>
                                    <small class="text-muted">3 days ago</small>
                                </div>
                            </div>
                            
                            <div class="achievement-item">
                                <div class="achievement-icon">
                                    <i class="fas fa-trophy text-success" style="font-size: 2rem;"></i>
                                </div>
                                <div class="achievement-content">
                                    <h6>Challenge Master</h6>
                                    <p>Complete 5 challenges in a week</p>
                                    <small class="text-muted">1 week ago</small>
                                </div>
                            </div>
                            
                            <div class="achievement-item">
                                <div class="achievement-icon">
                                    <i class="fas fa-graduation-cap text-info" style="font-size: 2rem;"></i>
                                </div>
                                <div class="achievement-content">
                                    <h6>Lesson Expert</h6>
                                    <p>Complete 10 lessons</p>
                                    <small class="text-muted">2 weeks ago</small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- School Leaderboard -->
                <div class="dashboard-card mt-4">
                    <div class="card-header">
                        <h5><i class="fas fa-school me-2"></i>School Leaderboard</h5>
                        <a href="leaderboard.jsp" class="btn btn-sm btn-outline-primary">View Full</a>
                    </div>
                    <div class="card-body">
                        <div class="eco-leaderboard-container">
                            <%
                                // Display school leaderboard data
                                if (schoolLeaderboardData != null && !schoolLeaderboardData.isEmpty()) {
                                    for (int i = 0; i < schoolLeaderboardData.size(); i++) {
                                        Map<String, Object> student = schoolLeaderboardData.get(i);
                                        int rank = (Integer) student.get("rank");
                                        String fullName = (String) student.get("full_name");
                                        int points = (Integer) student.get("total_points");
                                        String level = (String) student.get("current_level");
                                        
                                        // Get first letter for avatar
                                        String firstLetter = fullName.length() > 0 ? fullName.substring(0, 1).toUpperCase() : "U";
                                        
                                        // Determine rank class
                                        String rankClass = "standard";
                                        if (rank == 1) rankClass = "gold";
                                        else if (rank == 2) rankClass = "silver";
                                        else if (rank == 3) rankClass = "bronze";
                                        
                                        // Check if this is the current user
                                        boolean isCurrentUser = false;
                                        if (userId != null && student.get("user_id") != null) {
                                            isCurrentUser = userId.equals((Integer) student.get("user_id"));
                                        }
                            %>
                            <div class="eco-leaderboard-item <%= isCurrentUser ? "current-user" : "" %>">
                                <div class="eco-rank-display <%= rankClass %>">
                                    <% if (rank <= 3) { %>
                                        <i class="fas fa-medal"></i>
                                    <% } else { %>
                                        #<%= rank %>
                                    <% } %>
                                </div>
                                <div class="eco-player-avatar">
                                    <%= firstLetter %>
                                </div>
                                <div class="eco-player-info">
                                    <h6><%= fullName %></h6>
                                    <small><span class="eco-level-badge <%= level.toLowerCase().replace(" ", "-") %>"><%= level %></span></small>
                                </div>
                                <div class="eco-player-stats">
                                    <div class="eco-stat-value"><%= points %></div>
                                    <div class="eco-stat-label">Points</div>
                                </div>
                            </div>
                            <%
                                    }
                                } else {
                            %>
                            <div class="eco-leaderboard-empty">
                                <i class="fas fa-users"></i>
                                <h6>No School Leaderboard Data</h6>
                                <p>There are no students in your school yet.</p>
                            </div>
                            <%
                                }
                            %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript Libraries -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Theme Management -->
    <script src="../js/theme.js"></script>
    
    <script>
        // Enhanced Dashboard Initialization
        document.addEventListener('DOMContentLoaded', function() {
            // Add hover effects to cards
            initializeCardHoverEffects();
            
            // Add floating particles effect
            createFloatingParticles();
            
            // Animate progress bars
            animateProgressBars();
            
            // Load AI personalized recommendations
            setTimeout(() => {
                loadAIRecommendations();
            }, 1000);
            
            // Add special entrance animation for eco points card
            const ecoPointsCard = document.querySelector('.stat-card.eco-points');
            if (ecoPointsCard) {
                // Initially hide the card
                ecoPointsCard.style.opacity = '0';
                ecoPointsCard.style.transform = 'translateY(50px)';
                
                // Animate it in after a short delay
                setTimeout(() => {
                    ecoPointsCard.style.transition = 'opacity 0.8s ease, transform 0.8s ease';
                    ecoPointsCard.style.opacity = '1';
                    ecoPointsCard.style.transform = 'translateY(0)';
                    
                    // Add a subtle bounce effect
                    setTimeout(() => {
                        ecoPointsCard.style.transition = 'transform 0.3s ease';
                        ecoPointsCard.style.transform = 'translateY(-10px)';
                        
                        setTimeout(() => {
                            ecoPointsCard.style.transform = 'translateY(0)';
                        }, 300);
                    }, 800);
                }, 300);
            }
        });
        
        // Add hover effects to cards
        function initializeCardHoverEffects() {
            const cards = document.querySelectorAll('.stat-card, .dashboard-card');
            
            cards.forEach(card => {
                card.addEventListener('mouseenter', function() {
                    this.style.transform = this.classList.contains('stat-card') ? 
                        'translateY(-8px) scale(1.02)' : 
                        'translateY(-5px)';
                });
                
                card.addEventListener('mouseleave', function() {
                    this.style.transform = '';
                });
            });
            

        }
        
        // Create floating particles effect
        function createFloatingParticles() {
            const welcomeSection = document.querySelector('.welcome-section');
            if (!welcomeSection) return;
            
            for (let i = 0; i < 15; i++) {
                const particle = document.createElement('div');
                particle.className = 'floating-particle';
                particle.style.cssText = `
                    width: ${Math.random() * 8 + 4}px;
                    height: ${Math.random() * 8 + 4}px;
                    background: rgba(255, 255, 255, ${Math.random() * 0.5 + 0.2});
                    border-radius: 50%;
                    left: ${Math.random() * 100}%;
                    top: ${Math.random() * 100}%;
                    animation: floatParticle ${Math.random() * 10 + 5}s ease-in-out infinite;
                    animation-delay: ${Math.random() * 5}s;
                    pointer-events: none;
                    z-index: 1;
                `;
                welcomeSection.appendChild(particle);
            }
        }
        

        
        // Animate progress bars
        function animateProgressBars() {
            const progressBars = document.querySelectorAll('.progress-bar');
            
            progressBars.forEach(bar => {
                // Get values from data attributes
                const levelProgress = parseInt(bar.getAttribute('data-level-progress')) || 0;
                const levelTarget = parseInt(bar.getAttribute('data-level-target')) || 0;
                
                // Calculate progress percentage
                const progressPercentage = levelTarget > 0 ? (levelProgress * 100 / levelTarget) : 0;
                
                // Start with 0% width
                bar.style.width = '0%';
                
                // Animate to target width after a short delay
                setTimeout(() => {
                    bar.style.transition = 'width 2s ease-in-out';
                    bar.style.width = progressPercentage + '%';
                }, 500);
            });
            
            // Animate eco points value
            const ecoPointsValue = document.querySelector('.stat-card.eco-points .stat-content h3');
            if (ecoPointsValue) {
                const finalValue = parseInt(ecoPointsValue.textContent.replace(/,/g, '')) || 0;
                ecoPointsValue.textContent = '0';
                
                let currentValue = 0;
                const increment = Math.ceil(finalValue / 50);
                const duration = 2000; // 2 seconds
                const intervalTime = duration / (finalValue / increment);
                
                const counter = setInterval(() => {
                    currentValue += increment;
                    if (currentValue >= finalValue) {
                        currentValue = finalValue;
                        clearInterval(counter);
                    }
                    
                    // Format number with commas
                    ecoPointsValue.textContent = currentValue.toLocaleString();
                }, intervalTime);
            }
        }
        
        // Add click effects to interactive elements
        document.addEventListener('click', function(e) {
            // Exclude dropdown menu items and links with href attributes
            if (e.target.closest('.quick-action-btn, .btn') && 
                !e.target.closest('.dropdown-item') && 
                !e.target.closest('a[href]')) {
                const ripple = document.createElement('span');
                const rect = e.target.getBoundingClientRect();
                const size = Math.max(rect.width, rect.height);
                const x = e.clientX - rect.left - size / 2;
                const y = e.clientY - rect.top - size / 2;
                
                ripple.style.cssText = `
                    position: absolute;
                    width: ${size}px;
                    height: ${size}px;
                    left: ${x}px;
                    top: ${y}px;
                    background: rgba(45, 143, 68, 0.3);
                    border-radius: 50%;
                    transform: scale(0);
                    animation: ripple 0.6s ease-out;
                    pointer-events: none;
                    z-index: 10;
                `;
                
                const button = e.target.closest('.quick-action-btn, .btn');
                button.style.position = 'relative';
                button.style.overflow = 'hidden';
                button.appendChild(ripple);
                
                setTimeout(() => ripple.remove(), 600);
            }
        });
    </script>
    
    <!-- AR/VR and AI Features -->
    <script src="../js/ar-vr-features.js"></script>
</body>
</html>
</html>