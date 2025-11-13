<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mycompany.sih3.entity.User" %>
<%@ page import="com.mycompany.sih3.repository.UserRepository" %>
<%
    // Get user ID from session
    Integer userId = (Integer) session.getAttribute("userId");
    String userName = "Guest";
    
    // Fetch user from database if userId exists in session
    if (userId != null) {
        UserRepository userRepository = new UserRepository();
        User user = userRepository.findById(userId);
        if (user != null) {
            userName = user.getFullName();
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Achievements - EcoLearn Platform</title>
    
    <!-- CSS Libraries -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --primary-purple: #6f42c1;
            --secondary-pink: #e83e8c;
            --accent-indigo: #6610f2;
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
        
        .achievements-page {
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
            background: linear-gradient(135deg, #6f42c1 0%, #6610f2 100%);
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
        
        .achievements-card {
            background: white;
            border-radius: var(--border-radius-lg);
            box-shadow: var(--shadow-md);
            margin-bottom: var(--spacing-lg);
            overflow: hidden;
            animation: fadeIn 0.6s ease-out;
        }
        
        .card-header {
            padding: var(--spacing-lg);
            border-bottom: 1px solid #e9ecef;
            background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
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
        
        .achievement-item {
            display: flex;
            align-items: center;
            padding: 1.5rem;
            border-bottom: 1px solid #f1f3f4;
            transition: all 0.3s ease;
            animation: fadeInUp 0.5s ease-out;
        }
        
        .achievement-item:hover {
            background: #f8f9fa;
            transform: translateX(5px);
        }
        
        .achievement-item:last-child {
            border-bottom: none;
        }
        
        .achievement-icon {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.75rem;
            margin-right: 1.5rem;
            flex-shrink: 0;
        }
        
        .achievement-icon.locked {
            background: #e9ecef;
            color: #6c757d;
        }
        
        .achievement-icon.unlocked {
            background: linear-gradient(135deg, var(--primary-purple), var(--secondary-pink));
            color: white;
            box-shadow: 0 5px 15px rgba(111, 66, 193, 0.3);
        }
        
        .achievement-content {
            flex: 1;
        }
        
        .achievement-content h6 {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 0.25rem;
            color: var(--dark-gray);
        }
        
        .achievement-content p {
            color: #6c757d;
            margin-bottom: 0.5rem;
        }
        
        .achievement-meta {
            display: flex;
            gap: 1rem;
            font-size: 0.875rem;
        }
        
        .achievement-date {
            color: #6c757d;
        }
        
        .achievement-points {
            font-weight: 600;
            color: var(--primary-purple);
        }
        
        .achievement-status {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
        }
        
        .status-unlocked {
            background: #e8f5e9;
            color: #2e7d32;
        }
        
        .status-locked {
            background: #ffebee;
            color: #c62828;
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
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: var(--spacing-md);
        }
        
        .stat-item {
            text-align: center;
            padding: 1rem;
            background: #f8f9fa;
            border-radius: var(--border-radius-lg);
        }
        
        .stat-value {
            display: block;
            font-size: 2rem;
            font-weight: 700;
            color: var(--primary-purple);
            margin-bottom: 0.25rem;
        }
        
        .stat-label {
            font-size: 0.875rem;
            color: #6c757d;
        }
        
        .filters {
            display: flex;
            gap: 1rem;
            margin-bottom: var(--spacing-lg);
            flex-wrap: wrap;
        }
        
        .filter-btn {
            padding: 0.5rem 1rem;
            border-radius: 20px;
            background: white;
            border: 1px solid #e9ecef;
            color: #6c757d;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .filter-btn:hover, .filter-btn.active {
            background: var(--primary-purple);
            color: white;
            border-color: var(--primary-purple);
        }
        
        .level-progress {
            margin-top: var(--spacing-lg);
        }
        
        .progress {
            height: 12px;
            border-radius: 6px;
            background: #e9ecef;
            margin-bottom: 0.5rem;
        }
        
        .progress-bar {
            background: linear-gradient(90deg, var(--primary-purple), var(--secondary-pink));
            border-radius: 6px;
            height: 100%;
            width: 65%;
        }
        
        .progress-text {
            font-size: 0.875rem;
            color: #6c757d;
            text-align: center;
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
                box-shadow: 0 0 0 0 rgba(111, 66, 193, 0.4);
            }
            70% {
                transform: scale(1.05);
                box-shadow: 0 0 0 10px rgba(111, 66, 193, 0);
            }
            100% {
                transform: scale(1);
                box-shadow: 0 0 0 0 rgba(111, 66, 193, 0);
            }
        }
        
        /* Staggered animations */
        .achievement-item:nth-child(1) { animation-delay: 0.1s; }
        .achievement-item:nth-child(2) { animation-delay: 0.2s; }
        .achievement-item:nth-child(3) { animation-delay: 0.3s; }
        .achievement-item:nth-child(4) { animation-delay: 0.4s; }
        .achievement-item:nth-child(5) { animation-delay: 0.5s; }
        .achievement-item:nth-child(6) { animation-delay: 0.6s; }
        .achievement-item:nth-child(7) { animation-delay: 0.7s; }
        .achievement-item:nth-child(8) { animation-delay: 0.8s; }
    </style>
</head>
<body class="achievements-page">
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
                        <i class="fas fa-medal me-2"></i>Achievements
                    </h1>
                    <p class="page-subtitle">
                        Track your progress and unlock new achievements as you learn about environmental conservation.
                    </p>
                </div>
                <div class="col-lg-4 text-end">
                    <div class="stats-card">
                        <h5>Your Achievements</h5>
                        <div class="stats-grid">
                            <div class="stat-item">
                                <span class="stat-value">12</span>
                                <span class="stat-label">Unlocked</span>
                            </div>
                            <div class="stat-item">
                                <span class="stat-value">8</span>
                                <span class="stat-label">Locked</span>
                            </div>
                            <div class="stat-item">
                                <span class="stat-value">20</span>
                                <span class="stat-label">Total</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Filters -->
        <div class="filters">
            <button class="filter-btn active">All</button>
            <button class="filter-btn">Unlocked</button>
            <button class="filter-btn">Locked</button>
            <button class="filter-btn">Lessons</button>
            <button class="filter-btn">Challenges</button>
            <button class="filter-btn">Games</button>
        </div>

        <!-- Achievements List -->
        <div class="achievements-card">
            <div class="card-header">
                <h5><i class="fas fa-trophy me-2"></i>Eco Achievements</h5>
            </div>
            <div class="card-body">
                <!-- Unlocked Achievements -->
                <div class="achievement-item">
                    <div class="achievement-icon unlocked">
                        <i class="fas fa-medal"></i>
                    </div>
                    <div class="achievement-content">
                        <h6>Eco Warrior</h6>
                        <p>Complete 10 challenges to earn this prestigious badge.</p>
                        <div class="achievement-meta">
                            <span class="achievement-date">Unlocked: 3 days ago</span>
                            <span class="achievement-points">+75 points</span>
                            <span class="achievement-status status-unlocked">Unlocked</span>
                        </div>
                    </div>
                </div>
                
                <div class="achievement-item">
                    <div class="achievement-icon unlocked">
                        <i class="fas fa-trophy"></i>
                    </div>
                    <div class="achievement-content">
                        <h6>Challenge Master</h6>
                        <p>Complete 5 challenges in a week to demonstrate your dedication.</p>
                        <div class="achievement-meta">
                            <span class="achievement-date">Unlocked: 1 week ago</span>
                            <span class="achievement-points">+50 points</span>
                            <span class="achievement-status status-unlocked">Unlocked</span>
                        </div>
                    </div>
                </div>
                
                <div class="achievement-item">
                    <div class="achievement-icon unlocked">
                        <i class="fas fa-graduation-cap"></i>
                    </div>
                    <div class="achievement-content">
                        <h6>Lesson Expert</h6>
                        <p>Complete 10 lessons to show your commitment to learning.</p>
                        <div class="achievement-meta">
                            <span class="achievement-date">Unlocked: 2 weeks ago</span>
                            <span class="achievement-points">+40 points</span>
                            <span class="achievement-status status-unlocked">Unlocked</span>
                        </div>
                    </div>
                </div>
                
                <div class="achievement-item">
                    <div class="achievement-icon unlocked">
                        <i class="fas fa-gamepad"></i>
                    </div>
                    <div class="achievement-content">
                        <h6>Game Champion</h6>
                        <p>Complete 5 games with a score of 80% or higher.</p>
                        <div class="achievement-meta">
                            <span class="achievement-date">Unlocked: 3 weeks ago</span>
                            <span class="achievement-points">+30 points</span>
                            <span class="achievement-status status-unlocked">Unlocked</span>
                        </div>
                    </div>
                </div>
                
                <div class="achievement-item">
                    <div class="achievement-icon unlocked">
                        <i class="fas fa-leaf"></i>
                    </div>
                    <div class="achievement-content">
                        <h6>Green Thumb</h6>
                        <p>Complete the Plant a Tree challenge 5 times.</p>
                        <div class="achievement-meta">
                            <span class="achievement-date">Unlocked: 1 month ago</span>
                            <span class="achievement-points">+60 points</span>
                            <span class="achievement-status status-unlocked">Unlocked</span>
                        </div>
                    </div>
                </div>
                
                <div class="achievement-item">
                    <div class="achievement-icon unlocked">
                        <i class="fas fa-recycle"></i>
                    </div>
                    <div class="achievement-content">
                        <h6>Recycling Hero</h6>
                        <p>Score 100% in the Eco Sorting Challenge game.</p>
                        <div class="achievement-meta">
                            <span class="achievement-date">Unlocked: 1 month ago</span>
                            <span class="achievement-points">+45 points</span>
                            <span class="achievement-status status-unlocked">Unlocked</span>
                        </div>
                    </div>
                </div>
                
                <div class="achievement-item">
                    <div class="achievement-icon unlocked">
                        <i class="fas fa-fire"></i>
                    </div>
                    <div class="achievement-content">
                        <h6>Streak Master</h6>
                        <p>Maintain a 7-day learning streak.</p>
                        <div class="achievement-meta">
                            <span class="achievement-date">Unlocked: 2 months ago</span>
                            <span class="achievement-points">+55 points</span>
                            <span class="achievement-status status-unlocked">Unlocked</span>
                        </div>
                    </div>
                </div>
                
                <div class="achievement-item">
                    <div class="achievement-icon unlocked">
                        <i class="fas fa-book"></i>
                    </div>
                    <div class="achievement-content">
                        <h6>Knowledge Seeker</h6>
                        <p>Complete your first lesson on the platform.</p>
                        <div class="achievement-meta">
                            <span class="achievement-date">Unlocked: 6 months ago</span>
                            <span class="achievement-points">+20 points</span>
                            <span class="achievement-status status-unlocked">Unlocked</span>
                        </div>
                    </div>
                </div>
                
                <!-- Locked Achievements -->
                <div class="achievement-item">
                    <div class="achievement-icon locked">
                        <i class="fas fa-crown"></i>
                    </div>
                    <div class="achievement-content">
                        <h6>Eco Champion</h6>
                        <p>Reach the top 10 in the global leaderboard.</p>
                        <div class="achievement-meta">
                            <span class="achievement-date">Requirement: Top 10 Global Rank</span>
                            <span class="achievement-points">+100 points</span>
                            <span class="achievement-status status-locked">Locked</span>
                        </div>
                    </div>
                </div>
                
                <div class="achievement-item">
                    <div class="achievement-icon locked">
                        <i class="fas fa-globe"></i>
                    </div>
                    <div class="achievement-content">
                        <h6>Global Impact</h6>
                        <p>Earn 5,000 total eco-points.</p>
                        <div class="achievement-meta">
                            <span class="achievement-date">Requirement: 5,000 Points</span>
                            <span class="achievement-points">+120 points</span>
                            <span class="achievement-status status-locked">Locked</span>
                        </div>
                    </div>
                </div>
                
                <div class="achievement-item">
                    <div class="achievement-icon locked">
                        <i class="fas fa-star"></i>
                    </div>
                    <div class="achievement-content">
                        <h6>Perfect Score</h6>
                        <p>Complete 20 lessons with 100% scores.</p>
                        <div class="achievement-meta">
                            <span class="achievement-date">Requirement: 20 Perfect Lessons</span>
                            <span class="achievement-points">+80 points</span>
                            <span class="achievement-status status-locked">Locked</span>
                        </div>
                    </div>
                </div>
                
                <div class="achievement-item">
                    <div class="achievement-icon locked">
                        <i class="fas fa-bolt"></i>
                    </div>
                    <div class="achievement-content">
                        <h6>Lightning Fast</h6>
                        <p>Complete a challenge in under 10 minutes.</p>
                        <div class="achievement-meta">
                            <span class="achievement-date">Requirement: Sub-10min Challenge</span>
                            <span class="achievement-points">+35 points</span>
                            <span class="achievement-status status-locked">Locked</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Progress Toward Next Level -->
        <div class="achievements-card mt-4">
            <div class="card-header">
                <h5><i class="fas fa-chart-line me-2"></i>Progress Toward Next Level</h5>
            </div>
            <div class="card-body">
                <div class="level-progress">
                    <h6>Tree → Forest Guardian</h6>
                    <div class="progress">
                        <div class="progress-bar"></div>
                    </div>
                    <div class="progress-text">
                        1,850 / 3,000 points (62% complete)
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
        // Add active class to filter buttons
        document.addEventListener('DOMContentLoaded', function() {
            const filterButtons = document.querySelectorAll('.filter-btn');
            
            filterButtons.forEach(button => {
                button.addEventListener('click', function() {
                    // Remove active class from all buttons
                    filterButtons.forEach(btn => btn.classList.remove('active'));
                    
                    // Add active class to clicked button
                    this.classList.add('active');
                });
            });
        });
    </script>
</body>
</html>