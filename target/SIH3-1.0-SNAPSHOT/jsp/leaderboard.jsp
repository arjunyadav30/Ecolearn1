<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mycompany.sih3.entity.User" %>
<%@ page import="com.mycompany.sih3.repository.UserRepository" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%
    // Get user ID from session
    Integer userId = (Integer) session.getAttribute("userId");
    String userName = "Guest";
    int currentUserRank = 0;
    int currentUserPoints = 0;
    String currentUserLevel = "Seedling";
    int currentUserSchoolRank = 0;
    Integer currentUserSchoolId = null;
    String currentUserSchoolName = null;
    
    // Fetch user from database if userId exists in session
    if (userId != null) {
        UserRepository userRepository = new UserRepository();
        User user = userRepository.findById(userId);
        if (user != null) {
            userName = user.getFullName();
            currentUserSchoolId = user.getSchoolId();
            
            // Get school name if school ID exists
            if (currentUserSchoolId != null) {
                Connection userCon = null;
                PreparedStatement userStmt = null;
                ResultSet userRs = null;
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    userCon = DriverManager.getConnection("jdbc:mysql://localhost/ecolearn", "root", "1234");
                    userStmt = userCon.prepareStatement("SELECT name FROM schools WHERE id = ?");
                    userStmt.setInt(1, currentUserSchoolId);
                    userRs = userStmt.executeQuery();
                    if (userRs.next()) {
                        currentUserSchoolName = userRs.getString("name");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    try {
                        if (userRs != null) userRs.close();
                        if (userStmt != null) userStmt.close();
                        if (userCon != null) userCon.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            }
        }
    }
    
    // Database connection details
    String url = "jdbc:mysql://localhost/ecolearn";
    String usernameDB = "root";
    String passwordDB = "1234";
    
    // Fetch leaderboard data from database
    ArrayList<Map<String, Object>> leaderboardData = new ArrayList<Map<String, Object>>();
    
    Connection con = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection(url, usernameDB, passwordDB);
        
        // Check if school filter is active
        boolean isSchoolFilter = "school".equals(request.getParameter("filter"));
        
        // Build SQL query based on filter
        StringBuilder sqlBuilder = new StringBuilder();
        sqlBuilder.append("SELECT u.id AS user_id, u.full_name, u.username, us.total_points, us.current_level, us.global_rank, us.school_rank, s.name AS school_name ");
        sqlBuilder.append("FROM users u ");
        sqlBuilder.append("JOIN user_statistics us ON u.id = us.user_id ");
        sqlBuilder.append("LEFT JOIN schools s ON u.school_id = s.id ");
        
        // Add filter condition if school filter is applied
        if (isSchoolFilter && currentUserSchoolId != null) {
            sqlBuilder.append("WHERE u.school_id = ? ");
        }
        
        sqlBuilder.append("ORDER BY us.total_points DESC, u.full_name ASC ");
        sqlBuilder.append("LIMIT 100");
        
        String sql = sqlBuilder.toString();
        
        stmt = con.prepareStatement(sql);
        
        // Set parameter if school filter is applied
        if (isSchoolFilter && currentUserSchoolId != null) {
            stmt.setInt(1, currentUserSchoolId);
        }
        
        rs = stmt.executeQuery();
        
        int rank = 1;
        while (rs.next()) {
            Map<String, Object> entry = new HashMap<String, Object>();
            entry.put("rank", rank);
            entry.put("user_id", rs.getInt("user_id"));
            entry.put("full_name", rs.getString("full_name"));
            entry.put("username", rs.getString("username"));
            entry.put("total_points", rs.getInt("total_points"));
            entry.put("current_level", rs.getString("current_level"));
            entry.put("global_rank", rs.getInt("global_rank"));
            entry.put("school_rank", rs.getInt("school_rank"));
            entry.put("school_name", rs.getString("school_name"));
            leaderboardData.add(entry);
            
            // Get current user's rank and points
            if (userId != null && rs.getInt("user_id") == userId) {
                currentUserRank = rs.getInt("global_rank");
                currentUserPoints = rs.getInt("total_points");
                currentUserLevel = rs.getString("current_level");
                currentUserSchoolRank = rs.getInt("school_rank");
            }
            
            rank++;
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
    <title>Leaderboard - EcoLearn Platform</title>
    
    <!-- CSS Libraries -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --primary-gold: #ffc107;
            --secondary-bronze: #cd7f32;
            --accent-silver: #c0c0c0;
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
        
        .leaderboard-page {
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
            background: linear-gradient(135deg, #ffc107 0%, #ff9800 100%);
            color: #212529;
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
        
        /* Compact Leaderboard Card */
        .leaderboard-compact-card {
            background: white;
            border-radius: var(--border-radius-lg);
            box-shadow: var(--shadow-md);
            margin-bottom: var(--spacing-lg);
            overflow: hidden;
            animation: fadeIn 0.6s ease-out;
        }
        
        .card-header {
            padding: 0.75rem 1rem;
            border-bottom: 1px solid #e9ecef;
            background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
        }
        
        .card-header h5 {
            margin: 0;
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--dark-gray);
        }
        
        .card-body {
            padding: 0;
        }
        
        /* Enhanced Leaderboard Styles */
        .leaderboard-enhanced-item {
            display: flex;
            align-items: center;
            padding: 0.75rem 1rem;
            border-bottom: 1px solid #f1f3f4;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .leaderboard-enhanced-item:hover {
            background: linear-gradient(90deg, #f8f9fa 0%, #ffffff 100%);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
        }
        
        .leaderboard-enhanced-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 3px;
            height: 100%;
            background: linear-gradient(to bottom, var(--primary-gold), var(--secondary-bronze));
            transform: scaleY(0);
            transition: transform 0.3s ease;
        }
        
        .leaderboard-enhanced-item:hover::before {
            transform: scaleY(1);
        }
        
        .leaderboard-enhanced-item:first-child {
            background: linear-gradient(90deg, rgba(255, 215, 0, 0.15) 0%, rgba(255, 215, 0, 0.05) 100%);
        }
        
        .leaderboard-enhanced-item:nth-child(2) {
            background: linear-gradient(90deg, rgba(192, 192, 192, 0.15) 0%, rgba(192, 192, 192, 0.05) 100%);
        }
        
        .leaderboard-enhanced-item:nth-child(3) {
            background: linear-gradient(90deg, rgba(205, 127, 50, 0.15) 0%, rgba(205, 127, 50, 0.05) 100%);
        }
        
        .leaderboard-enhanced-rank {
            width: 40px;
            text-align: center;
            font-weight: 700;
            font-size: 1rem;
            position: relative;
            z-index: 2;
        }
        
        .leaderboard-enhanced-rank.gold {
            color: #ffc107;
            font-size: 1.5rem;
            text-shadow: 0 2px 4px rgba(255, 193, 7, 0.3);
        }
        
        .leaderboard-enhanced-rank.silver {
            color: #c0c0c0;
            font-size: 1.3rem;
            text-shadow: 0 2px 4px rgba(192, 192, 192, 0.3);
        }
        
        .leaderboard-enhanced-rank.bronze {
            color: #cd7f32;
            font-size: 1.1rem;
            text-shadow: 0 2px 4px rgba(205, 127, 50, 0.3);
        }
        
        .leaderboard-enhanced-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary-gold), var(--secondary-bronze));
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
            margin: 0 0.75rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            position: relative;
            z-index: 2;
            font-size: 0.9rem;
        }
        
        .leaderboard-enhanced-info {
            flex: 1;
            position: relative;
            z-index: 2;
        }
        
        .leaderboard-enhanced-info h6 {
            margin: 0 0 0.1rem 0;
            font-size: 1rem;
            font-weight: 600;
            color: #212529;
        }
        
        .leaderboard-enhanced-info small {
            color: #6c757d;
            display: block;
            font-size: 0.8rem;
            margin-bottom: 0.1rem;
        }
        
        .leaderboard-enhanced-info small.school-name {
            color: #495057;
            font-weight: 500;
        }
        
        .leaderboard-enhanced-stats {
            display: flex;
            gap: 1rem;
            align-items: center;
            position: relative;
            z-index: 2;
        }
        
        .leaderboard-enhanced-stat {
            text-align: center;
        }
        
        .leaderboard-enhanced-stat-value {
            display: block;
            font-weight: 700;
            font-size: 1.1rem;
            color: var(--primary-gold);
        }
        
        .leaderboard-enhanced-stat-label {
            font-size: 0.75rem;
            color: #6c757d;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .leaderboard-enhanced-level-badge {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        
        .leaderboard-enhanced-level-badge.seedling {
            background: linear-gradient(135deg, #4caf50, #2e7d32);
            color: white;
        }
        
        .leaderboard-enhanced-level-badge.sprout {
            background: linear-gradient(135deg, #2196f3, #0d47a1);
            color: white;
        }
        
        .leaderboard-enhanced-level-badge.tree {
            background: linear-gradient(135deg, #ff9800, #e65100);
            color: white;
        }
        
        .leaderboard-enhanced-level-badge.forest {
            background: linear-gradient(135deg, #9c27b0, #4a148c);
            color: white;
        }
        
        .leaderboard-enhanced-level-badge.warrior {
            background: linear-gradient(135deg, #f44336, #b71c1c);
            color: white;
        }
        
        /* You indicator */
        .you-indicator {
            background: linear-gradient(135deg, #1abc9c, #17a2b8);
            color: white;
            padding: 0.25rem 0.5rem;
            border-radius: 12px;
            font-size: 0.7rem;
            font-weight: 600;
            margin-left: 0.5rem;
            display: inline-block;
            vertical-align: middle;
            box-shadow: 0 2px 4px rgba(26, 188, 156, 0.3);
        }
        
        /* Enhanced Filters */
        .leaderboard-enhanced-filters {
            display: flex;
            gap: 0.75rem;
            margin-bottom: var(--spacing-lg);
            flex-wrap: wrap;
            justify-content: center;
        }
        
        .leaderboard-enhanced-filter-btn {
            padding: 0.5rem 1rem;
            border-radius: 30px;
            background: white;
            border: 2px solid #e9ecef;
            color: #6c757d;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
            font-size: 0.9rem;
        }
        
        .leaderboard-enhanced-filter-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.1);
        }
        
        .leaderboard-enhanced-filter-btn.active {
            background: linear-gradient(135deg, var(--primary-gold), #ff9800);
            color: #212529;
            border-color: var(--primary-gold);
            box-shadow: 0 4px 8px rgba(255, 193, 7, 0.3);
        }
        
        /* Enhanced Stats Card */
        .leaderboard-enhanced-stats-card {
            background: white;
            border-radius: var(--border-radius-lg);
            padding: 0.75rem;
            box-shadow: var(--shadow-md);
            margin-bottom: var(--spacing-lg);
            animation: fadeIn 0.8s ease-out;
            border-top: 3px solid var(--primary-gold);
        }
        
        .leaderboard-enhanced-stats-card h5 {
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 0.75rem;
            color: var(--dark-gray);
            text-align: center;
        }
        
        .leaderboard-enhanced-stat-item {
            display: flex;
            justify-content: space-between;
            padding: 0.5rem 0;
            border-bottom: 1px solid #f1f3f4;
        }
        
        .leaderboard-enhanced-stat-item:last-child {
            border-bottom: none;
        }
        
        .leaderboard-enhanced-stat-label {
            color: #6c757d;
            font-weight: 500;
            font-size: 0.9rem;
        }
        
        .leaderboard-enhanced-stat-value {
            font-weight: 700;
            color: var(--primary-gold);
            font-size: 1rem;
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
        
        @keyframes shimmer {
            0% {
                background-position: -200% 0;
            }
            100% {
                background-position: 200% 0;
            }
        }
        
        /* Staggered animations */
        .leaderboard-enhanced-item:nth-child(1) { animation-delay: 0.1s; }
        .leaderboard-enhanced-item:nth-child(2) { animation-delay: 0.2s; }
        .leaderboard-enhanced-item:nth-child(3) { animation-delay: 0.3s; }
        .leaderboard-enhanced-item:nth-child(4) { animation-delay: 0.4s; }
        .leaderboard-enhanced-item:nth-child(5) { animation-delay: 0.5s; }
        .leaderboard-enhanced-item:nth-child(6) { animation-delay: 0.6s; }
        .leaderboard-enhanced-item:nth-child(7) { animation-delay: 0.7s; }
        .leaderboard-enhanced-item:nth-child(8) { animation-delay: 0.8s; }
        .leaderboard-enhanced-item:nth-child(9) { animation-delay: 0.9s; }
        .leaderboard-enhanced-item:nth-child(10) { animation-delay: 1.0s; }
        
        /* Responsive Design */
        @media (max-width: 768px) {
            .leaderboard-enhanced-item {
                flex-direction: column;
                align-items: flex-start;
                padding: 0.75rem;
            }
            
            .leaderboard-enhanced-avatar {
                margin: 0.25rem 0;
            }
            
            .leaderboard-enhanced-info {
                width: 100%;
                margin-bottom: 0.25rem;
            }
            
            .leaderboard-enhanced-stats {
                width: 100%;
                justify-content: space-between;
            }
            
            .leaderboard-enhanced-filters {
                justify-content: center;
            }
            
            .leaderboard-enhanced-filter-btn {
                padding: 0.4rem 0.75rem;
                font-size: 0.8rem;
            }
        }
    </style>
</head>
<body class="leaderboard-page">
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
                        <a class="nav-link active" href="leaderboard.jsp">
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
                        <i class="fas fa-trophy me-2"></i>
                        <% if ("school".equals(request.getParameter("filter")) && currentUserSchoolName != null) { %>
                            <%= currentUserSchoolName %> Students
                        <% } else { %>
                            Global Leaderboard
                        <% } %>
                    </h1>
                    <p class="page-subtitle">
                        <% if ("school".equals(request.getParameter("filter")) && currentUserSchoolName != null) { %>
                            Showing only students from your school: <%= currentUserSchoolName %>
                            <a href="leaderboard.jsp" class="btn btn-sm btn-outline-light ms-2">Show All</a>
                        <% } else { %>
                            See how you rank against other eco-warriors in the community. Keep learning and earning points to climb higher!
                        <% } %>
                    </p>
                </div>
                <div class="col-lg-4 text-end">
                    <div class="leaderboard-enhanced-stats-card">
                        <h5>Your Ranking</h5>
                        <div class="leaderboard-enhanced-stat-item">
                            <span class="leaderboard-enhanced-stat-label">
                                <% if ("school".equals(request.getParameter("filter")) && currentUserSchoolName != null) { %>
                                    School Rank
                                <% } else { %>
                                    Global Rank
                                <% } %>
                            </span>
                            <span class="leaderboard-enhanced-stat-value">
                                #<% if ("school".equals(request.getParameter("filter")) && currentUserSchoolName != null) { %>
                                    <%= currentUserSchoolRank %>
                                <% } else { %>
                                    <%= currentUserRank %>
                                <% } %>
                            </span>
                        </div>
                        <div class="leaderboard-enhanced-stat-item">
                            <span class="leaderboard-enhanced-stat-label">Total Points</span>
                            <span class="leaderboard-enhanced-stat-value"><%= currentUserPoints %></span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Filters -->
        <div class="leaderboard-enhanced-filters">
            <button class="leaderboard-enhanced-filter-btn <%= "school".equals(request.getParameter("filter")) ? "" : "active" %>" id="globalFilterBtn">Global</button>
            <button class="leaderboard-enhanced-filter-btn <%= "school".equals(request.getParameter("filter")) ? "active" : "" %>" id="schoolFilterBtn">School</button>
            <button class="leaderboard-enhanced-filter-btn" id="weeklyFilterBtn">Weekly</button>
            <button class="leaderboard-enhanced-filter-btn" id="monthlyFilterBtn">Monthly</button>
            <button class="leaderboard-enhanced-filter-btn" id="friendsFilterBtn">Friends</button>
        </div>

        <!-- Leaderboard -->
        <div class="leaderboard-card">
            <div class="card-header">
                <h5><i class="fas fa-crown me-2"></i>Top Eco-Warriors</h5>
            </div>
            <div class="card-body">
                <% 
                int index = 0;
                for (Map<String, Object> entry : leaderboardData) { 
                    int rank = (Integer) entry.get("rank");
                    int userIdEntry = (Integer) entry.get("user_id");
                    String fullName = (String) entry.get("full_name");
                    String username = (String) entry.get("username");
                    int totalPoints = (Integer) entry.get("total_points");
                    String currentLevel = (String) entry.get("current_level");
                    String schoolName = (String) entry.get("school_name");
                    
                    // Get initials for avatar
                    String initials = "";
                    if (fullName != null && !fullName.isEmpty()) {
                        String[] names = fullName.split(" ");
                        if (names.length > 0) {
                            initials += names[0].substring(0, 1).toUpperCase();
                            if (names.length > 1) {
                                initials += names[names.length - 1].substring(0, 1).toUpperCase();
                            }
                        }
                    }
                    
                    // Determine rank styling
                    String rankClass = "";
                    String medalIcon = "";
                    if (rank == 1) {
                        rankClass = "gold";
                        medalIcon = "<i class=\"fas fa-medal\" style=\"color: #ffc107;\"></i>";
                    } else if (rank == 2) {
                        rankClass = "silver";
                        medalIcon = "<i class=\"fas fa-medal\" style=\"color: #c0c0c0;\"></i>";
                    } else if (rank == 3) {
                        rankClass = "bronze";
                        medalIcon = "<i class=\"fas fa-medal\" style=\"color: #cd7f32;\"></i>";
                    }
                %>
                <div class="leaderboard-enhanced-item <%= (userId != null && userIdEntry == userId) ? "current-user" : "" %>">
                    <div class="leaderboard-enhanced-rank <%= rankClass %>">
                        <% if (rank <= 3) { %>
                            <%= medalIcon %>
                        <% } else { %>
                            <%= rank %>
                        <% } %>
                    </div>
                    <div class="leaderboard-enhanced-avatar"><%= initials %></div>
                    <div class="leaderboard-enhanced-info">
                        <h6>
                            <%= fullName %>
                            <% if (userId != null && userIdEntry == userId) { %>
                                <span class="you-indicator">YOU</span>
                            <% } %>
                        </h6>
                        <% if (schoolName != null && !schoolName.isEmpty()) { %>
                            <small class="school-name"><%= schoolName %></small>
                        <% } %>
                        <small>
                            <span class="leaderboard-enhanced-level-badge <%= currentLevel != null ? currentLevel.toLowerCase() : "seedling" %>">
                                <%= currentLevel != null ? currentLevel : "Seedling" %>
                            </span>
                        </small>
                    </div>
                    <div class="leaderboard-enhanced-stats">
                        <div class="leaderboard-enhanced-stat">
                            <span class="leaderboard-enhanced-stat-value"><%= totalPoints %></span>
                            <span class="leaderboard-enhanced-stat-label">Points</span>
                        </div>
                    </div>
                </div>
                <% 
                    index++;
                } 
                %>
            </div>
        </div>
    </div>

    <!-- JavaScript Libraries -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Theme Management -->
    <script src="../js/theme.js"></script>
    
    <script>
        // Add active class to filter buttons and handle clicks
        document.addEventListener('DOMContentLoaded', function() {
            // Add click handler for global filter button
            const globalFilterBtn = document.getElementById('globalFilterBtn');
            if (globalFilterBtn) {
                globalFilterBtn.addEventListener('click', function() {
                    // Redirect to the same page without filter parameter
                    window.location.href = 'leaderboard.jsp';
                });
            }
            
            // Add click handler for school filter button
            const schoolFilterBtn = document.getElementById('schoolFilterBtn');
            if (schoolFilterBtn) {
                schoolFilterBtn.addEventListener('click', function() {
                    // Redirect to the same page with school filter parameter
                    window.location.href = 'leaderboard.jsp?filter=school';
                });
            }
            
            // Add click handlers for other filter buttons (placeholders for now)
            const weeklyFilterBtn = document.getElementById('weeklyFilterBtn');
            if (weeklyFilterBtn) {
                weeklyFilterBtn.addEventListener('click', function() {
                    alert('Weekly filter coming soon!');
                });
            }
            
            const monthlyFilterBtn = document.getElementById('monthlyFilterBtn');
            if (monthlyFilterBtn) {
                monthlyFilterBtn.addEventListener('click', function() {
                    alert('Monthly filter coming soon!');
                });
            }
            
            const friendsFilterBtn = document.getElementById('friendsFilterBtn');
            if (friendsFilterBtn) {
                friendsFilterBtn.addEventListener('click', function() {
                    alert('Friends filter coming soon!');
                });
            }
        });
    </script>
</body>
</html>