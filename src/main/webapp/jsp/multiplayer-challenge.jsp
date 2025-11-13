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
    <title>Multiplayer Challenge - EcoLearn Platform</title>
    
    <!-- CSS Libraries -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --primary-teal: #1abc9c;
            --secondary-blue: #3498db;
            --accent-purple: #9b59b6;
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
        
        .multiplayer-page {
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
            background: linear-gradient(135deg, #1abc9c 0%, #3498db 100%);
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
        
        .challenge-card {
            background: white;
            border-radius: var(--border-radius-lg);
            box-shadow: var(--shadow-md);
            margin-bottom: var(--spacing-lg);
            transition: all 0.3s ease;
            overflow: hidden;
            animation: fadeInUp 0.6s ease-out;
        }
        
        .challenge-card:hover {
            transform: translateY(-8px) scale(1.02);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.15);
        }
        
        .challenge-header {
            padding: var(--spacing-lg);
            color: white;
            position: relative;
        }
        
        .challenge-header.team {
            background: linear-gradient(135deg, #9b59b6, #8e44ad);
        }
        
        .challenge-content {
            padding: var(--spacing-lg);
        }
        
        .challenge-content h5 {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: var(--dark-gray);
        }
        
        .challenge-content p {
            color: #6c757d;
            margin-bottom: 1rem;
        }
        
        .player-list {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin: 15px 0;
        }
        
        .player-badge {
            background: #e9ecef;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.8rem;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .player-badge.active {
            background: #d4edda;
            color: #155724;
        }
        
        .player-badge.host {
            background: #cce5ff;
            color: #004085;
        }
        
        .challenge-actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        
        .btn-challenge {
            padding: 0.75rem 1.5rem;
            border-radius: var(--border-radius-lg);
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .btn-challenge:hover {
            transform: translateY(-2px);
        }
        
        .btn-primary {
            background: linear-gradient(135deg, var(--primary-teal), var(--secondary-blue));
            border: none;
        }
        
        .btn-outline-primary {
            border: 2px solid var(--primary-teal);
            color: var(--primary-teal);
        }
        
        .btn-success {
            background: linear-gradient(135deg, #27ae60, #2ecc71);
            border: none;
        }
        
        .btn-warning {
            background: linear-gradient(135deg, #f39c12, #e67e22);
            border: none;
        }
        
        .btn-danger {
            background: linear-gradient(135deg, #e74c3c, #c0392b);
            border: none;
        }
        
        .lobby-container {
            background: white;
            border-radius: var(--border-radius-lg);
            padding: var(--spacing-lg);
            box-shadow: var(--shadow-md);
            margin-bottom: var(--spacing-lg);
        }
        
        .lobby-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: var(--spacing-lg);
            padding-bottom: var(--spacing-md);
            border-bottom: 1px solid #e9ecef;
        }
        
        .lobby-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--dark-gray);
        }
        
        .challenge-info {
            display: flex;
            gap: 20px;
            margin-bottom: var(--spacing-lg);
            flex-wrap: wrap;
        }
        
        .info-card {
            flex: 1;
            min-width: 200px;
            background: #f8f9fa;
            border-radius: 10px;
            padding: 15px;
            text-align: center;
        }
        
        .info-card h6 {
            color: #6c757d;
            margin-bottom: 10px;
        }
        
        .info-card .value {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary-teal);
        }
        
        .players-section {
            margin-bottom: var(--spacing-lg);
        }
        
        .players-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 15px;
        }
        
        .player-card {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 15px;
            text-align: center;
            border: 2px solid transparent;
            transition: all 0.3s ease;
        }
        
        .player-card.host {
            border-color: #9b59b6;
            background: #f5f0ff;
        }
        
        .player-avatar {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary-teal), var(--secondary-blue));
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
            margin: 0 auto 10px;
        }
        
        .player-name {
            font-weight: 600;
            margin-bottom: 5px;
        }
        
        .player-status {
            font-size: 0.8rem;
            padding: 2px 8px;
            border-radius: 20px;
        }
        
        .status-ready {
            background: #d4edda;
            color: #155724;
        }
        
        .status-waiting {
            background: #fff3cd;
            color: #856404;
        }
        
        .chat-container {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 15px;
            margin-top: var(--spacing-lg);
        }
        
        .chat-messages {
            height: 200px;
            overflow-y: auto;
            background: white;
            border-radius: 8px;
            padding: 10px;
            margin-bottom: 10px;
        }
        
        .message {
            margin-bottom: 10px;
            padding: 8px;
            border-radius: 5px;
        }
        
        .message.system {
            background: #e9ecef;
            font-size: 0.8rem;
            text-align: center;
        }
        
        .message.user {
            background: #d1ecf1;
        }
        
        .chat-input {
            display: flex;
            gap: 10px;
        }
        
        .chat-input input {
            flex: 1;
            padding: 10px;
            border: 1px solid #ced4da;
            border-radius: 5px;
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
                box-shadow: 0 0 0 0 rgba(26, 188, 156, 0.4);
            }
            70% {
                transform: scale(1.05);
                box-shadow: 0 0 0 10px rgba(26, 188, 156, 0);
            }
            100% {
                transform: scale(1);
                box-shadow: 0 0 0 0 rgba(26, 188, 156, 0);
            }
        }
        
        /* Staggered animations */
        .challenge-card:nth-child(1) { animation-delay: 0.1s; }
        .challenge-card:nth-child(2) { animation-delay: 0.2s; }
        .challenge-card:nth-child(3) { animation-delay: 0.3s; }
        .challenge-card:nth-child(4) { animation-delay: 0.4s; }
    </style>
</head>
<body class="multiplayer-page">
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
                        <i class="fas fa-users me-2"></i>Multiplayer Challenges
                    </h1>
                    <p class="page-subtitle">
                        Team up with friends to complete environmental challenges and earn bonus rewards!
                    </p>
                </div>
                <div class="col-lg-4 text-end">
                    <button class="btn btn-light btn-lg" onclick="createNewChallenge()">
                        <i class="fas fa-plus me-2"></i>Create Challenge
                    </button>
                </div>
            </div>
        </div>

        <!-- Active Challenges -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="challenge-card">
                    <div class="challenge-header team">
                        <h5><i class="fas fa-leaf me-2"></i>Community Cleanup Challenge</h5>
                    </div>
                    <div class="challenge-content">
                        <p>Work together with your team to collect virtual waste and learn about proper waste management. The team that collects the most waste wins bonus eco-points!</p>
                        
                        <div class="player-list">
                            <div class="player-badge host">
                                <i class="fas fa-crown"></i> <%= userName %>
                            </div>
                            <div class="player-badge active">
                                <i class="fas fa-user"></i> Rohan Mehta
                            </div>
                            <div class="player-badge">
                                <i class="fas fa-user"></i> Vikram Singh
                            </div>
                            <div class="player-badge">
                                <i class="fas fa-user"></i> Arjun Patel
                            </div>
                        </div>
                        
                        <div class="challenge-actions">
                            <button class="btn btn-primary btn-challenge" onclick="joinChallenge('cleanup')">
                                <i class="fas fa-play me-2"></i>Start Challenge
                            </button>
                            <button class="btn btn-outline-primary btn-challenge" onclick="inviteFriends()">
                                <i class="fas fa-user-plus me-2"></i>Invite Friends
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Challenge Lobby -->
        <div class="lobby-container">
            <div class="lobby-header">
                <h3 class="lobby-title"><i class="fas fa-trophy me-2"></i>Community Cleanup Challenge Lobby</h3>
                <div class="timer">
                    <span class="badge bg-warning">Starting in: 05:00</span>
                </div>
            </div>
            
            <div class="challenge-info">
                <div class="info-card">
                    <h6>Challenge Type</h6>
                    <div class="value">Waste Collection</div>
                </div>
                <div class="info-card">
                    <h6>Team Size</h6>
                    <div class="value">4 Players</div>
                </div>
                <div class="info-card">
                    <h6>Reward</h6>
                    <div class="value">200 Points</div>
                </div>
                <div class="info-card">
                    <h6>Duration</h6>
                    <div class="value">15 Minutes</div>
                </div>
            </div>
            
            <div class="players-section">
                <h5><i class="fas fa-users me-2"></i>Team Members</h5>
                <div class="players-grid">
                    <div class="player-card host">
                        <div class="player-avatar"><%= userName.substring(0, 1).toUpperCase() %></div>
                        <div class="player-name"><%= userName %></div>
                        <div class="player-status status-ready">Ready</div>
                        <small class="text-muted">Host</small>
                    </div>
                    <div class="player-card">
                        <div class="player-avatar">A</div>
                        <div class="player-name">Rohan Mehta</div>
                        <div class="player-status status-ready">Ready</div>
                    </div>
                    <div class="player-card">
                        <div class="player-avatar">S</div>
                        <div class="player-name">Vikram Singh</div>
                        <div class="player-status status-waiting">Waiting</div>
                    </div>
                    <div class="player-card">
                        <div class="player-avatar">J</div>
                        <div class="player-name">Arjun Patel</div>
                        <div class="player-status status-waiting">Waiting</div>
                    </div>
                </div>
            </div>
            
            <div class="chat-container">
                <h6><i class="fas fa-comments me-2"></i>Team Chat</h6>
                <div class="chat-messages">
                    <div class="message system">
                        <small>Challenge created by <%= userName %></small>
                    </div>
                    <div class="message user">
                        <strong><%= userName %>:</strong> Hey everyone, ready for the cleanup challenge?
                    </div>
                    <div class="message user">
                        <strong>Rohan:</strong> Yes! I've been looking forward to this.
                    </div>
                    <div class="message system">
                        <small>Sam joined the challenge</small>
                    </div>
                </div>
                <div class="chat-input">
                    <input type="text" placeholder="Type your message..." id="chatMessage">
                    <button class="btn btn-primary" onclick="sendMessage()"><i class="fas fa-paper-plane"></i></button>
                </div>
            </div>
            
            <div class="text-center mt-4">
                <button class="btn btn-success btn-lg" onclick="startChallenge()">
                    <i class="fas fa-play me-2"></i>Start Challenge Now
                </button>
                <button class="btn btn-warning btn-lg ms-2" onclick="leaveChallenge()">
                    <i class="fas fa-times me-2"></i>Leave Challenge
                </button>
            </div>
        </div>
    </div>

    <!-- JavaScript Libraries -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Theme Management -->
    <script src="../js/theme.js"></script>
    
    <script>
        // Multiplayer Challenge Functions
        function createNewChallenge() {
            alert("Creating a new multiplayer challenge! In a full implementation, this would open a form to configure the challenge settings.");
        }
        
        function joinChallenge(challengeType) {
            alert(`Joining ${challengeType} challenge! In a full implementation, this would connect you to the challenge lobby.`);
        }
        
        function inviteFriends() {
            alert("Inviting friends to join the challenge! In a full implementation, this would open a friend selector and send invitations.");
        }
        
        function sendMessage() {
            const messageInput = document.getElementById('chatMessage');
            const message = messageInput.value.trim();
            
            if (message) {
                const chatMessages = document.querySelector('.chat-messages');
                const messageElement = document.createElement('div');
                messageElement.className = 'message user';
                messageElement.innerHTML = `<strong><%= userName %>:</strong> ${message}`;
                chatMessages.appendChild(messageElement);
                
                // Scroll to bottom
                chatMessages.scrollTop = chatMessages.scrollHeight;
                
                // Clear input
                messageInput.value = '';
            }
        }
        
        function startChallenge() {
            alert("Starting the challenge! In a full implementation, this would launch the multiplayer challenge interface.");
        }
        
        function leaveChallenge() {
            if (confirm("Are you sure you want to leave this challenge?")) {
                alert("Left the challenge. In a full implementation, you would be redirected to the challenges page.");
                // window.location.href = 'challenges.jsp';
            }
        }
        
        // Allow sending message with Enter key
        document.getElementById('chatMessage').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                sendMessage();
            }
        });
    </script>
</body>
</html>