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
    } else {
        // Redirect to login if not authenticated
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Community Impact - EcoLearn Platform</title>
    
    <!-- CSS Libraries -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --primary-green: #27ae60;
            --secondary-teal: #1abc9c;
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
        
        .impact-page {
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
            background: linear-gradient(135deg, #27ae60 0%, #1abc9c 100%);
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
        
        .impact-card {
            background: white;
            border-radius: var(--border-radius-lg);
            box-shadow: var(--shadow-md);
            margin-bottom: var(--spacing-lg);
            transition: all 0.3s ease;
            overflow: hidden;
            animation: fadeInUp 0.6s ease-out;
        }
        
        .impact-card:hover {
            transform: translateY(-8px) scale(1.02);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.15);
        }
        
        .impact-header {
            padding: var(--spacing-lg);
            color: white;
            position: relative;
        }
        
        .impact-header.co2 {
            background: linear-gradient(135deg, #3498db, #2980b9);
        }
        
        .impact-header.trees {
            background: linear-gradient(135deg, #27ae60, #2ecc71);
        }
        
        .impact-header.waste {
            background: linear-gradient(135deg, #e74c3c, #c0392b);
        }
        
        .impact-header.energy {
            background: linear-gradient(135deg, #f39c12, #e67e22);
        }
        
        .impact-content {
            padding: var(--spacing-lg);
        }
        
        .impact-content h5 {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: var(--dark-gray);
        }
        
        .impact-content p {
            color: #6c757d;
            margin-bottom: 1rem;
        }
        
        .impact-stats {
            display: flex;
            justify-content: space-between;
            margin-bottom: 1rem;
            font-size: 0.9rem;
        }
        
        .stat {
            display: flex;
            align-items: center;
        }
        
        .stat i {
            margin-right: 0.25rem;
            color: var(--primary-green);
        }
        
        .impact-value {
            font-size: 2rem;
            font-weight: 700;
            color: var(--primary-green);
            text-align: center;
            margin: 1rem 0;
        }
        
        .impact-description {
            text-align: center;
            color: #6c757d;
            margin-bottom: 1rem;
        }
        
        .progress-container {
            margin: 1rem 0;
        }
        
        .progress-label {
            display: flex;
            justify-content: space-between;
            font-size: 0.8rem;
            margin-bottom: 0.25rem;
        }
        
        .progress {
            height: 15px;
            border-radius: 10px;
            background: #e9ecef;
            margin-bottom: 0.5rem;
            overflow: hidden;
        }
        
        .progress-bar {
            border-radius: 10px;
            height: 100%;
            background: linear-gradient(90deg, var(--primary-green), var(--secondary-teal));
        }
        
        .map-container {
            background: white;
            border-radius: var(--border-radius-lg);
            padding: var(--spacing-lg);
            box-shadow: var(--shadow-md);
            margin-bottom: var(--spacing-lg);
            height: 400px;
        }
        
        .map-placeholder {
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, #e0f7fa, #c8e6c9);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-direction: column;
        }
        
        .map-placeholder i {
            font-size: 3rem;
            color: var(--primary-green);
            margin-bottom: 1rem;
        }
        
        .leaderboard-container {
            background: white;
            border-radius: var(--border-radius-lg);
            padding: var(--spacing-lg);
            box-shadow: var(--shadow-md);
            margin-bottom: var(--spacing-lg);
        }
        
        .leaderboard-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: var(--spacing-lg);
            padding-bottom: var(--spacing-md);
            border-bottom: 1px solid #e9ecef;
        }
        
        .leaderboard-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--dark-gray);
        }
        
        .leaderboard-item {
            display: flex;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid #f1f3f4;
        }
        
        .leaderboard-item:last-child {
            border-bottom: none;
        }
        
        .rank {
            width: 30px;
            font-weight: 600;
            color: var(--primary-green);
        }
        
        .rank.gold {
            color: #FFD700;
        }
        
        .rank.silver {
            color: #C0C0C0;
        }
        
        .rank.bronze {
            color: #CD7F32;
        }
        
        .player-info {
            flex: 1;
            margin-left: 1rem;
        }
        
        .player-info h6 {
            margin: 0 0 0.25rem 0;
            font-size: 0.9rem;
        }
        
        .player-info small {
            color: #6c757d;
        }
        
        .player-impact {
            font-weight: 600;
            color: var(--primary-green);
        }
        
        .btn-impact {
            padding: 0.75rem 1.5rem;
            border-radius: var(--border-radius-lg);
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .btn-impact:hover {
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
                box-shadow: 0 0 0 0 rgba(39, 174, 96, 0.4);
            }
            70% {
                transform: scale(1.05);
                box-shadow: 0 0 0 10px rgba(39, 174, 96, 0);
            }
            100% {
                transform: scale(1);
                box-shadow: 0 0 0 0 rgba(39, 174, 96, 0);
            }
        }
        
        /* Staggered animations */
        .impact-card:nth-child(1) { animation-delay: 0.1s; }
        .impact-card:nth-child(2) { animation-delay: 0.2s; }
        .impact-card:nth-child(3) { animation-delay: 0.3s; }
        .impact-card:nth-child(4) { animation-delay: 0.4s; }
    </style>
</head>
<body class="impact-page">
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
                        <i class="fas fa-globe-americas me-2"></i>Community Impact Dashboard
                    </h1>
                    <p class="page-subtitle">
                        See how our community is making a real difference for the environment!
                    </p>
                </div>
                <div class="col-lg-4 text-end">
                    <button class="btn btn-light btn-lg" onclick="shareImpact()">
                        <i class="fas fa-share-alt me-2"></i>Share Impact
                    </button>
                </div>
            </div>
        </div>

        <!-- Impact Statistics -->
        <div class="row">
            <div class="col-lg-3 col-md-6">
                <div class="impact-card">
                    <div class="impact-header co2">
                        <h5><i class="fas fa-wind me-2"></i>CO2 Reduction</h5>
                    </div>
                    <div class="impact-content">
                        <div class="impact-value">12,450 kg</div>
                        <div class="impact-description">Total CO2 offset by our community</div>
                        <div class="progress-container">
                            <div class="progress">
                                <div class="progress-bar" style="width: 85%"></div>
                            </div>
                        </div>
                        <p>That's equivalent to taking 2.5 cars off the road for a year!</p>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-3 col-md-6">
                <div class="impact-card">
                    <div class="impact-header trees">
                        <h5><i class="fas fa-tree me-2"></i>Trees Planted</h5>
                    </div>
                    <div class="impact-content">
                        <div class="impact-value">3,280</div>
                        <div class="impact-description">Trees planted by our community</div>
                        <div class="progress-container">
                            <div class="progress">
                                <div class="progress-bar" style="width: 72%"></div>
                            </div>
                        </div>
                        <p>These trees will absorb 65,000 kg of CO2 annually!</p>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-3 col-md-6">
                <div class="impact-card">
                    <div class="impact-header waste">
                        <h5><i class="fas fa-trash-alt me-2"></i>Waste Collected</h5>
                    </div>
                    <div class="impact-content">
                        <div class="impact-value">8,750 kg</div>
                        <div class="impact-description">Waste collected through challenges</div>
                        <div class="progress-container">
                            <div class="progress">
                                <div class="progress-bar" style="width: 65%"></div>
                            </div>
                        </div>
                        <p>That's 3.5 tons of waste diverted from landfills!</p>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-3 col-md-6">
                <div class="impact-card">
                    <div class="impact-header energy">
                        <h5><i class="fas fa-bolt me-2"></i>Energy Saved</h5>
                    </div>
                    <div class="impact-content">
                        <div class="impact-value">15,600 kWh</div>
                        <div class="impact-description">Energy conserved by our actions</div>
                        <div class="progress-container">
                            <div class="progress">
                                <div class="progress-bar" style="width: 78%"></div>
                            </div>
                        </div>
                        <p>Enough to power 5 homes for an entire year!</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Community Map -->
        <div class="row">
            <div class="col-12">
                <div class="map-container">
                    <h3 class="mb-4"><i class="fas fa-map-marked-alt me-2"></i>Community Impact Map</h3>
                    <div class="map-placeholder">
                        <i class="fas fa-map-marked-alt"></i>
                        <h4>Interactive Community Impact Map</h4>
                        <p>See where environmental actions are happening in your region</p>
                        <button class="btn btn-primary mt-3" onclick="viewDetailedMap()">
                            <i class="fas fa-search-plus me-2"></i>View Detailed Map
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Top Contributors -->
        <div class="row">
            <div class="col-12">
                <div class="leaderboard-container">
                    <div class="leaderboard-header">
                        <h3 class="leaderboard-title"><i class="fas fa-medal me-2"></i>Top Environmental Contributors</h3>
                        <div>
                            <button class="btn btn-sm btn-outline-primary me-2">This Week</button>
                            <button class="btn btn-sm btn-primary">All Time</button>
                        </div>
                    </div>
                    
                    <div class="leaderboard-list">
                        <div class="leaderboard-item">
                            <div class="rank gold">1</div>
                            <div class="player-info">
                                <h6>Green Guardians School</h6>
                                <small>Patiala, Punjab</small>
                            </div>
                            <div class="player-impact">2,450 kg CO2</div>
                        </div>
                        
                        <div class="leaderboard-item">
                            <div class="rank silver">2</div>
                            <div class="player-info">
                                <h6>Eco Warriors Academy</h6>
                                <small>Amritsar, Punjab</small>
                            </div>
                            <div class="player-impact">1,980 kg CO2</div>
                        </div>
                        
                        <div class="leaderboard-item">
                            <div class="rank bronze">3</div>
                            <div class="player-info">
                                <h6>Sustainable Scholars</h6>
                                <small>Chandigarh</small>
                            </div>
                            <div class="player-impact">1,650 kg CO2</div>
                        </div>
                        
                        <div class="leaderboard-item">
                            <div class="rank">4</div>
                            <div class="player-info">
                                <h6><%= userName %></h6>
                                <small>Your School</small>
                            </div>
                            <div class="player-impact">1,240 kg CO2</div>
                        </div>
                        
                        <div class="leaderboard-item">
                            <div class="rank">5</div>
                            <div class="player-info">
                                <h6>Earth Protectors</h6>
                                <small>Ludhiana, Punjab</small>
                            </div>
                            <div class="player-impact">980 kg CO2</div>
                        </div>
                    </div>
                    
                    <div class="text-center mt-4">
                        <button class="btn btn-primary" onclick="viewFullLeaderboard()">
                            <i class="fas fa-trophy me-2"></i>View Full Leaderboard
                        </button>
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
        // Community Impact Functions
        function shareImpact() {
            if (navigator.share) {
                navigator.share({
                    title: 'EcoLearn Community Impact',
                    text: 'Our community has reduced 12,450 kg of CO2, planted 3,280 trees, and collected 8,750 kg of waste! Join us in making a difference.',
                    url: window.location.href
                }).catch(console.error);
            } else {
                // Fallback for browsers that don't support Web Share API
                alert("Copy this link to share: " + window.location.href);
            }
        }
        
        function viewDetailedMap() {
            alert("Opening detailed community impact map! In a full implementation, this would show an interactive map with impact data.");
        }
        
        function viewFullLeaderboard() {
            alert("Viewing full leaderboard! In a full implementation, this would show all community contributors.");
        }
        
        // Animate progress bars on load
        document.addEventListener('DOMContentLoaded', function() {
            const progressBars = document.querySelectorAll('.progress-bar');
            progressBars.forEach(bar => {
                const width = bar.style.width;
                bar.style.width = '0%';
                setTimeout(() => {
                    bar.style.transition = 'width 2s ease-in-out';
                    bar.style.width = width;
                }, 300);
            });
        });
    </script>
</body>
</html>