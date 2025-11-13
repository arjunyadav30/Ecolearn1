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
    <title>Games - EcoLearn Platform</title>
    
    <!-- CSS Libraries -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="../css/game.css" rel="stylesheet">
    
    <style>
        :root {
            --primary-purple: #6f42c1;
            --secondary-pink: #e83e8c;
            --accent-yellow: #ffc107;
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
        
        .games-page {
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
            background: linear-gradient(135deg, #6f42c1 0%, #e83e8c 100%);
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
        
        .game-card {
            background: white;
            border-radius: var(--border-radius-lg);
            box-shadow: var(--shadow-md);
            margin-bottom: var(--spacing-lg);
            transition: all 0.3s ease;
            overflow: hidden;
            animation: fadeInUp 0.6s ease-out;
        }
        
        .game-card:hover {
            transform: translateY(-8px) scale(1.02);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.15);
        }
        
        .game-thumbnail {
            height: 200px;
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .game-thumbnail.blue {
            background: linear-gradient(135deg, #3498db, #2c3e50);
        }
        
        .game-thumbnail.green {
            background: linear-gradient(135deg, #27ae60, #2ecc71);
        }
        
        .game-thumbnail.purple {
            background: linear-gradient(135deg, #8e44ad, #9b59b6);
        }
        
        .game-thumbnail.orange {
            background: linear-gradient(135deg, #e67e22, #d35400);
        }
        
        .game-icon {
            font-size: 4rem;
            color: rgba(255, 255, 255, 0.8);
            animation: float 3s ease-in-out infinite;
        }
        
        .game-badge {
            position: absolute;
            top: 1rem;
            left: 1rem;
            background: rgba(255, 255, 255, 0.9);
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
        }
        
        .game-badge.new {
            background: var(--accent-yellow);
            color: #212529;
        }
        
        .game-badge.popular {
            background: var(--primary-purple);
            color: white;
        }
        
        .game-content {
            padding: var(--spacing-lg);
        }
        
        .game-content h5 {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: var(--dark-gray);
        }
        
        .game-content p {
            color: #6c757d;
            margin-bottom: 1rem;
        }
        
        .game-stats {
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
            color: var(--primary-purple);
        }
        
        .btn-game {
            width: 100%;
            padding: 0.75rem;
            border-radius: var(--border-radius-lg);
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .btn-game:hover {
            transform: translateY(-2px);
        }
        
        .btn-primary {
            background: linear-gradient(135deg, var(--primary-purple), var(--secondary-pink));
            border: none;
        }
        
        .btn-outline-primary {
            border: 2px solid var(--primary-purple);
            color: var(--primary-purple);
        }
        
        .leaderboard-card {
            background: white;
            border-radius: var(--border-radius-lg);
            padding: var(--spacing-lg);
            box-shadow: var(--shadow-md);
            margin-bottom: var(--spacing-lg);
            animation: fadeIn 0.8s ease-out;
        }
        
        .leaderboard-card h5 {
            font-size: 1.125rem;
            font-weight: 600;
            margin-bottom: 1rem;
            color: var(--dark-gray);
        }
        
        .leaderboard-item {
            display: flex;
            align-items: center;
            padding: 0.75rem 0;
            border-bottom: 1px solid #f1f3f4;
        }
        
        .leaderboard-item:last-child {
            border-bottom: none;
        }
        
        .rank {
            width: 30px;
            font-weight: 600;
            color: var(--primary-purple);
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
        
        .player-score {
            font-weight: 600;
            color: var(--primary-purple);
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
        .game-card:nth-child(1) { animation-delay: 0.1s; }
        .game-card:nth-child(2) { animation-delay: 0.2s; }
        .game-card:nth-child(3) { animation-delay: 0.3s; }
        .game-card:nth-child(4) { animation-delay: 0.4s; }
    </style>
</head>
<body class="games-page">
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
                        <a class="nav-link active" href="games.jsp">
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
        <!-- Page Header -->
        <div class="page-header">
            <div class="row align-items-center">
                <div class="col-lg-8">
                    <h1 class="page-title">
                        <i class="fas fa-gamepad me-2"></i>Eco Games
                    </h1>
                    <p class="page-subtitle">
                        Play fun and educational games to learn about environmental conservation while earning eco-points!
                    </p>
                </div>
                <div class="col-lg-4 text-end">
                    <div class="leaderboard-card">
                        <h5><i class="fas fa-trophy me-2"></i>Top Players</h5>
                        <div class="leaderboard-item">
                            <div class="rank">1</div>
                            <div class="player-info">
                                <h6>Priya Sharma</h6>
                                <small>Forest Guardian</small>
                            </div>
                            <div class="player-score">2,450</div>
                        </div>
                        <div class="leaderboard-item">
                            <div class="rank">2</div>
                            <div class="player-info">
                                <h6>Rahul Verma</h6>
                                <small>Tree</small>
                            </div>
                            <div class="player-score">2,100</div>
                        </div>
                        <div class="leaderboard-item">
                            <div class="rank">3</div>
                            <div class="player-info">
                                <h6><%= userName %></h6>
                                <small>Tree</small>
                            </div>
                            <div class="player-score">1,850</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Games Grid -->
        <div class="row">
            <div class="col-lg-6 col-md-6">
                <div class="game-card">
                    <div class="game-thumbnail blue">
                        <i class="fas fa-recycle game-icon"></i>
                        <div class="game-badge new">NEW</div>
                    </div>
                    <div class="game-content">
                        <h5>Eco Sorting Challenge</h5>
                        <p>Sort different types of waste into the correct recycling bins as quickly as possible!</p>
                        <div class="game-stats">
                            <div class="stat">
                                <i class="fas fa-star"></i>
                                <span>4.8 (1.2k plays)</span>
                            </div>
                            <div class="stat">
                                <i class="fas fa-clock"></i>
                                <span>5-10 min</span>
                            </div>
                        </div>
                        <button class="btn btn-primary btn-game" onclick="launchEcoSortingGame()">
                            <i class="fas fa-play me-2"></i>Play Now
                        </button>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-6 col-md-6">
                <div class="game-card">
                    <div class="game-thumbnail green">
                        <i class="fas fa-tree game-icon"></i>
                        <div class="game-badge popular">POPULAR</div>
                    </div>
                    <div class="game-content">
                        <h5>Forest Guardian</h5>
                        <p>Protect the forest from deforestation by planting trees and fighting wildfires!</p>
                        <div class="game-stats">
                            <div class="stat">
                                <i class="fas fa-star"></i>
                                <span>4.9 (2.5k plays)</span>
                            </div>
                            <div class="stat">
                                <i class="fas fa-clock"></i>
                                <span>10-15 min</span>
                            </div>
                        </div>
                        <button class="btn btn-primary btn-game">
                            <i class="fas fa-play me-2"></i>Play Now
                        </button>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-6 col-md-6">
                <div class="game-card">
                    <div class="game-thumbnail purple">
                        <i class="fas fa-water game-icon"></i>
                        <div class="game-badge">FEATURED</div>
                    </div>
                    <div class="game-content">
                        <h5>Ocean Cleanup</h5>
                        <p>Clean up ocean pollution by collecting plastic waste and protecting marine life!</p>
                        <div class="game-stats">
                            <div class="stat">
                                <i class="fas fa-star"></i>
                                <span>4.7 (1.8k plays)</span>
                            </div>
                            <div class="stat">
                                <i class="fas fa-clock"></i>
                                <span>8-12 min</span>
                            </div>
                        </div>
                        <button class="btn btn-primary btn-game">
                            <i class="fas fa-play me-2"></i>Play Now
                        </button>
                    </div>
                </div>
            </div>
            
            <!-- Educational Snake and Ladder Game Card -->
            <div class="col-lg-6 col-md-6">
                <div class="game-card">
                    <div class="game-thumbnail orange">
                        <i class="fas fa-dice game-icon"></i>
                        <div class="game-badge new">QUIZ MODE</div>
                    </div>
                    <div class="game-content">
                        <h5>Snake and Ladder Quiz</h5>
                        <p>Answer environmental questions correctly to move forward on the board. Climb ladders and avoid snakes!</p>
                        <div class="game-stats">
                            <div class="stat">
                                <i class="fas fa-star"></i>
                                <span>4.9 (850 plays)</span>
                            </div>
                            <div class="stat">
                                <i class="fas fa-clock"></i>
                                <span>15-20 min</span>
                            </div>
                        </div>
                        <button class="btn btn-primary btn-game" onclick="window.location.href='snakeladder.jsp'">
                            <i class="fas fa-play me-2"></i>Play Now
                        </button>
                    </div>
                </div>
            </div>
            
            <!-- Standard Snake and Ladder Game Card -->
            <div class="col-lg-6 col-md-6">
                <div class="game-card">
                    <div class="game-thumbnail" style="background: linear-gradient(135deg, #9b59b6, #8e44ad);">
                        <i class="fas fa-camera game-icon"></i>
                        <div class="game-badge new">AR</div>
                    </div>
                    <div class="game-content">
                        <h5>AR Plant Scanner</h5>
                        <p>Use your camera to identify plants and learn about local biodiversity in augmented reality!</p>
                        <div class="game-stats">
                            <div class="stat">
                                <i class="fas fa-star"></i>
                                <span>4.9 (320 plays)</span>
                            </div>
                            <div class="stat">
                                <i class="fas fa-clock"></i>
                                <span>5-10 min</span>
                            </div>
                        </div>
                        <button class="btn btn-primary btn-game" onclick="launchARPlantScanner()">
                            <i class="fas fa-play me-2"></i>Scan Plants
                        </button>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-6 col-md-6">
                <div class="game-card">
                    <div class="game-thumbnail" style="background: linear-gradient(135deg, #3498db, #2980b9);">
                        <i class="fas fa-vr-cardboard game-icon"></i>
                        <div class="game-badge new">VR</div>
                    </div>
                    <div class="game-content">
                        <h5>Virtual Ecosystem Explorer</h5>
                        <p>Explore endangered ecosystems in virtual reality and understand their environmental importance!</p>
                        <div class="game-stats">
                            <div class="stat">
                                <i class="fas fa-star"></i>
                                <span>4.8 (280 plays)</span>
                            </div>
                            <div class="stat">
                                <i class="fas fa-clock"></i>
                                <span>15-20 min</span>
                            </div>
                        </div>
                        <button class="btn btn-primary btn-game" onclick="launchVREcosystemTour()">
                            <i class="fas fa-play me-2"></i>Explore VR
                        </button>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-6 col-md-6">
                <div class="game-card">
                    <div class="game-thumbnail" style="background: linear-gradient(135deg, #e74c3c, #c0392b);">
                        <i class="fas fa-users game-icon"></i>
                        <div class="game-badge popular">MULTIPLAYER</div>
                    </div>
                    <div class="game-content">
                        <h5>Team Cleanup Challenge</h5>
                        <p>Collaborate with friends in real-time to clean up virtual environments and earn team rewards!</p>
                        <div class="game-stats">
                            <div class="stat">
                                <i class="fas fa-star"></i>
                                <span>4.9 (450 plays)</span>
                            </div>
                            <div class="stat">
                                <i class="fas fa-clock"></i>
                                <span>10-15 min</span>
                            </div>
                        </div>
                        <button class="btn btn-primary btn-game" onclick="window.location.href='multiplayer-challenge.jsp'">
                            <i class="fas fa-play me-2"></i>Play Together
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript Libraries -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="../js/eco-game.js"></script>
    <script src="../js/ar-vr-features.js"></script>
    
    <!-- Theme Management -->
    <script src="../js/theme.js"></script>
    
    <!-- Activity Logging Functions -->
    <script>
        // Function to log game completion
        function logGameCompletion(gameTitle, points) {
            // Make AJAX call to log the game completion
            fetch('complete-game.jsp', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'gameTitle=' + encodeURIComponent(gameTitle) + 
                      '&points=' + encodeURIComponent(points || 50)
            })
            .then(response => response.json())
            .then(data => {
                if (data.status === 'success') {
                    console.log('Game completion logged successfully');
                    // Optionally show a notification to the user
                    showNotification('Game completed! Activity logged successfully.', 'success');
                } else {
                    console.error('Failed to log game completion:', data.message);
                }
            })
            .catch(error => {
                console.error('Error logging game completion:', error);
            });
        }
        
        // Show notification to user
        function showNotification(message, type) {
            // Create notification element
            const notification = document.createElement('div');
            notification.textContent = message;
            notification.style.position = 'fixed';
            notification.style.top = '20px';
            notification.style.right = '20px';
            notification.style.padding = '15px';
            notification.style.borderRadius = '5px';
            notification.style.color = 'white';
            notification.style.fontWeight = 'bold';
            notification.style.zIndex = '10000';
            notification.style.boxShadow = '0 4px 8px rgba(0,0,0,0.2)';
            notification.style.maxWidth = '300px';
            
            if (type === 'success') {
                notification.style.backgroundColor = '#28a745';
            } else {
                notification.style.backgroundColor = '#dc3545';
            }
            
            // Add to document
            document.body.appendChild(notification);
            
            // Remove after 3 seconds
            setTimeout(() => {
                if (notification.parentNode) {
                    notification.parentNode.removeChild(notification);
                }
            }, 3000);
        }
        
        // Example game launch functions with completion logging
        function launchEcoSortingGame() {
            // In a real application, this would launch the actual game
            // For demo purposes, we'll simulate game completion after a delay
            alert('Launching Eco Sorting Challenge... (This is a demo)');
            
            // Simulate game completion after 2 seconds
            setTimeout(() => {
                logGameCompletion('Eco Sorting Challenge', 50);
            }, 2000);
        }
        
        // You can add similar functions for other games
        // For now, let's add onclick handlers to the existing buttons
        document.addEventListener('DOMContentLoaded', function() {
            // Add event listeners to all "Play Now" buttons
            const playButtons = document.querySelectorAll('.btn-game');
            playButtons.forEach((button, index) => {
                // Skip the Snake and Ladder buttons that already have onclick handlers
                if (!button.hasAttribute('onclick')) {
                    button.addEventListener('click', function() {
                        const gameCard = this.closest('.game-card');
                        const gameTitle = gameCard.querySelector('h5').textContent;
                        // Log game completion with default points
                        logGameCompletion(gameTitle, 50);
                    });
                }
            });
        });
    </script>
</body>
</html>