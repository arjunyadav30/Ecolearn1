<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mycompany.sih3.entity.User" %>
<%@ page import="com.mycompany.sih3.repository.UserRepository" %>
<%@ page import="java.sql.*" %>
<%
    // Get user ID from session
    Integer userId = (Integer) session.getAttribute("userId");
    String userName = "Guest";
    Integer currentStreak = 0;
    Integer challengesCompleted = 8;
    Integer pointsEarned = 850;
    
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
            String sql = "SELECT current_streak, challenges_completed, points_from_challenges FROM user_statistics WHERE user_id = ?";
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                currentStreak = rs.getObject("current_streak", Integer.class) != null ? rs.getObject("current_streak", Integer.class) : 0;
                challengesCompleted = rs.getObject("challenges_completed", Integer.class) != null ? rs.getObject("challenges_completed", Integer.class) : 0;
                pointsEarned = rs.getObject("points_from_challenges", Integer.class) != null ? rs.getObject("points_from_challenges", Integer.class) : 0;
            }
            
            rs.close();
            stmt.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Challenges - EcoLearn Platform</title>
    
    <!-- CSS Libraries -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --primary-orange: #fd7e14;
            --secondary-red: #e74c3c;
            --accent-green: #27ae60;
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
        
        .challenges-page {
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
            background: linear-gradient(135deg, #fd7e14 0%, #e74c3c 100%);
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
        
        .challenge-header.easy {
            background: linear-gradient(135deg, #27ae60, #2ecc71);
        }
        
        .challenge-header.medium {
            background: linear-gradient(135deg, #f39c12, #e67e22);
        }
        
        .challenge-header.hard {
            background: linear-gradient(135deg, #e74c3c, #c0392b);
        }
        
        .challenge-badge {
            position: absolute;
            top: 1rem;
            right: 1rem;
            background: rgba(255, 255, 255, 0.2);
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
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
        
        .challenge-details {
            display: flex;
            justify-content: space-between;
            margin-bottom: 1rem;
            font-size: 0.9rem;
        }
        
        .detail {
            display: flex;
            align-items: center;
        }
        
        .detail i {
            margin-right: 0.25rem;
            color: var(--primary-orange);
        }
        
        .progress-container {
            margin-bottom: 1rem;
        }
        
        .progress-label {
            display: flex;
            justify-content: space-between;
            font-size: 0.8rem;
            margin-bottom: 0.25rem;
        }
        
        .progress {
            height: 10px;
            border-radius: 5px;
            background: #e9ecef;
            margin-bottom: 0.5rem;
        }
        
        .progress-bar {
            border-radius: 5px;
            height: 100%;
        }
        
        .progress-bar.easy {
            background: linear-gradient(90deg, #27ae60, #2ecc71);
        }
        
        .progress-bar.medium {
            background: linear-gradient(90deg, #f39c12, #e67e22);
        }
        
        .progress-bar.hard {
            background: linear-gradient(90deg, #e74c3c, #c0392b);
        }
        
        .btn-challenge {
            width: 100%;
            padding: 0.75rem;
            border-radius: var(--border-radius-lg);
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .btn-challenge:hover {
            transform: translateY(-2px);
        }
        
        .btn-primary {
            background: linear-gradient(135deg, var(--primary-orange), var(--secondary-red));
            border: none;
        }
        
        .btn-outline-primary {
            border: 2px solid var(--primary-orange);
            color: var(--primary-orange);
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
            color: var(--primary-orange);
        }
        
        .daily-challenge {
            background: linear-gradient(135deg, #9b59b6, #8e44ad);
            color: white;
            border-radius: var(--border-radius-lg);
            padding: var(--spacing-lg);
            margin-bottom: var(--spacing-lg);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            animation: pulse 2s infinite;
        }
        
        .daily-challenge h4 {
            margin-top: 0;
            font-weight: 600;
        }
        
        .daily-challenge .btn {
            background: white;
            color: #9b59b6;
            border: none;
            font-weight: 600;
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
                box-shadow: 0 0 0 0 rgba(155, 89, 182, 0.4);
            }
            70% {
                transform: scale(1.02);
                box-shadow: 0 0 0 10px rgba(155, 89, 182, 0);
            }
            100% {
                transform: scale(1);
                box-shadow: 0 0 0 0 rgba(155, 89, 182, 0);
            }
        }
        
        /* Staggered animations */
        .challenge-card:nth-child(1) { animation-delay: 0.1s; }
        .challenge-card:nth-child(2) { animation-delay: 0.2s; }
        .challenge-card:nth-child(3) { animation-delay: 0.3s; }
        .challenge-card:nth-child(4) { animation-delay: 0.4s; }
        .challenge-card:nth-child(5) { animation-delay: 0.5s; }
    </style>
</head>
<body class="challenges-page">
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
                        <a class="nav-link active" href="challenges.jsp">
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
                        <i class="fas fa-leaf me-2"></i>Environmental Challenges
                    </h1>
                    <p class="page-subtitle">
                        Take on real-world environmental challenges to make a positive impact and earn eco-points!
                    </p>
                </div>
                <div class="col-lg-4 text-end">
                    <div class="stats-card">
                        <h5>Your Challenge Stats</h5>
                        <div class="stat-item">
                            <span class="stat-label">Challenges Completed</span>
                            <span class="stat-value"><%= challengesCompleted %>/15</span>
                        </div>
                        <div class="stat-item">
                            <span class="stat-label">Points Earned</span>
                            <span class="stat-value"><%= pointsEarned %></span>
                        </div>
                        <div class="stat-item">
                            <span class="stat-label">Current Streak</span>
                            <span class="stat-value"><%= currentStreak %> days</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Daily Challenge -->
        <div class="daily-challenge">
            <h4><i class="fas fa-star me-2"></i>Daily Challenge</h4>
            <h5>Reduce Plastic Use Today</h5>
            <p>Commit to using no single-use plastics for the entire day. Bring your own water bottle, reusable bags, and containers.</p>
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <span class="badge bg-light text-dark">150 points</span>
                    <span class="badge bg-light text-dark ms-2">Easy</span>
                </div>
                <button class="btn">
                    <i class="fas fa-check-circle me-2"></i>Accept Challenge
                </button>
            </div>
        </div>

        <!-- Challenges Grid -->
        <div class="row">
            <div class="col-lg-4 col-md-6">
                <div class="challenge-card">
                    <div class="challenge-header easy">
                        <h5>Plant a Tree</h5>
                        <p>Plant a tree in your community or backyard</p>
                        <div class="challenge-badge">Easy</div>
                    </div>
                    <div class="challenge-content">
                        <p>Plant a native tree species in your area and care for it. This helps with carbon sequestration and biodiversity.</p>
                        <div class="challenge-details">
                            <div class="detail">
                                <i class="fas fa-leaf"></i>
                                <span>100 points</span>
                            </div>
                            <div class="detail">
                                <i class="fas fa-clock"></i>
                                <span>2-3 hours</span>
                            </div>
                        </div>
                        <div class="progress-container">
                            <div class="progress-label">
                                <span>Completion Rate</span>
                                <span>78%</span>
                            </div>
                            <div class="progress">
                                <div class="progress-bar easy" style="width: 78%;"></div>
                            </div>
                        </div>
                        <a href="plant-tree-challenge.jsp" class="btn btn-primary btn-challenge">
                            <i class="fas fa-camera me-2"></i>Complete with Camera
                        </a>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-4 col-md-6">
                <div class="challenge-card">
                    <div class="challenge-header easy">
                        <h5>Energy Audit</h5>
                        <p>Conduct an energy audit of your home</p>
                        <div class="challenge-badge">Easy</div>
                    </div>
                    <div class="challenge-content">
                        <p>Identify energy waste in your home and create a plan to reduce consumption by at least 10%.</p>
                        <div class="challenge-details">
                            <div class="detail">
                                <i class="fas fa-leaf"></i>
                                <span>120 points</span>
                            </div>
                            <div class="detail">
                                <i class="fas fa-clock"></i>
                                <span>1-2 hours</span>
                            </div>
                        </div>
                        <div class="progress-container">
                            <div class="progress-label">
                                <span>Completion Rate</span>
                                <span>65%</span>
                            </div>
                            <div class="progress">
                                <div class="progress-bar easy" style="width: 65%;"></div>
                            </div>
                        </div>
                        <button class="btn btn-outline-primary btn-challenge">
                            <i class="fas fa-play me-2"></i>Start Challenge
                        </button>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-4 col-md-6">
                <div class="challenge-card">
                    <div class="challenge-header medium">
                        <h5>Plastic-Free Week</h5>
                        <p>Eliminate single-use plastics for a week</p>
                        <div class="challenge-badge">Medium</div>
                    </div>
                    <div class="challenge-content">
                        <p>Avoid all single-use plastics for 7 days. Use reusable bags, bottles, and containers instead.</p>
                        <div class="challenge-details">
                            <div class="detail">
                                <i class="fas fa-leaf"></i>
                                <span>150 points</span>
                            </div>
                            <div class="detail">
                                <i class="fas fa-clock"></i>
                                <span>1 week</span>
                            </div>
                        </div>
                        <div class="progress-container">
                            <div class="progress-label">
                                <span>Completion Rate</span>
                                <span>52%</span>
                            </div>
                            <div class="progress">
                                <div class="progress-bar medium" style="width: 52%;"></div>
                            </div>
                        </div>
                        <button class="btn btn-primary btn-challenge">
                            <i class="fas fa-check-circle me-2"></i>Complete Challenge
                        </button>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-4 col-md-6">
                <div class="challenge-card">
                    <div class="challenge-header medium">
                        <h5>Community Cleanup</h5>
                        <p>Organize or join a local cleanup event</p>
                        <div class="challenge-badge">Medium</div>
                    </div>
                    <div class="challenge-content">
                        <p>Participate in a community cleanup event or organize one with friends to collect at least 10kg of waste.</p>
                        <div class="challenge-details">
                            <div class="detail">
                                <i class="fas fa-leaf"></i>
                                <span>180 points</span>
                            </div>
                            <div class="detail">
                                <i class="fas fa-clock"></i>
                                <span>3-4 hours</span>
                            </div>
                        </div>
                        <div class="progress-container">
                            <div class="progress-label">
                                <span>Completion Rate</span>
                                <span>45%</span>
                            </div>
                            <div class="progress">
                                <div class="progress-bar medium" style="width: 45%;"></div>
                            </div>
                        </div>
                        <button class="btn btn-outline-primary btn-challenge">
                            <i class="fas fa-play me-2"></i>Start Challenge
                        </button>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-4 col-md-6">
                <div class="challenge-card">
                    <div class="challenge-header hard">
                        <h5>Sustainable Garden</h5>
                        <p>Create a sustainable garden with native plants</p>
                        <div class="challenge-badge">Hard</div>
                    </div>
                    <div class="challenge-content">
                        <p>Design and plant a garden using native plants that require minimal water and support local wildlife.</p>
                        <div class="challenge-details">
                            <div class="detail">
                                <i class="fas fa-leaf"></i>
                                <span>250 points</span>
                            </div>
                            <div class="detail">
                                <i class="fas fa-clock"></i>
                                <span>2-3 weeks</span>
                            </div>
                        </div>
                        <div class="progress-container">
                            <div class="progress-label">
                                <span>Completion Rate</span>
                                <span>30%</span>
                            </div>
                            <div class="progress">
                                <div class="progress-bar hard" style="width: 30%;"></div>
                            </div>
                        </div>
                        <button class="btn btn-outline-primary btn-challenge">
                            <i class="fas fa-play me-2"></i>Start Challenge
                        </button>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-4 col-md-6">
                <div class="challenge-card">
                    <div class="challenge-header hard">
                        <h5>Zero Waste Week</h5>
                        <p>Produce no waste for an entire week</p>
                        <div class="challenge-badge">Hard</div>
                    </div>
                    <div class="challenge-content">
                        <p>Commit to producing zero waste for 7 days by composting, recycling, and avoiding all disposable items.</p>
                        <div class="challenge-details">
                            <div class="detail">
                                <i class="fas fa-leaf"></i>
                                <span>300 points</span>
                            </div>
                            <div class="detail">
                                <i class="fas fa-clock"></i>
                                <span>1 week</span>
                            </div>
                        </div>
                        <div class="progress-container">
                            <div class="progress-label">
                                <span>Completion Rate</span>
                                <span>18%</span>
                            </div>
                            <div class="progress">
                                <div class="progress-bar hard" style="width: 18%;"></div>
                            </div>
                        </div>
                        <button class="btn btn-outline-primary btn-challenge">
                            <i class="fas fa-play me-2"></i>Start Challenge
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
    
    <!-- Activity Logging Functions -->
    <script>
        // Function to log challenge completion
        function logChallengeCompletion(challengeTitle, points) {
            // Make AJAX call to log the challenge completion
            fetch('complete-challenge.jsp', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'challengeTitle=' + encodeURIComponent(challengeTitle) + 
                      '&points=' + encodeURIComponent(points || 150)
            })
            .then(response => response.json())
            .then(data => {
                if (data.status === 'success') {
                    console.log('Challenge completion logged successfully');
                    // Optionally show a notification to the user
                    showNotification('Challenge completed! Activity logged successfully.', 'success');
                } else {
                    console.error('Failed to log challenge completion:', data.message);
                }
            })
            .catch(error => {
                console.error('Error logging challenge completion:', error);
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
        
        // Add event listeners to challenge completion buttons
        document.addEventListener('DOMContentLoaded', function() {
            // Add event listeners to all challenge buttons
            const challengeButtons = document.querySelectorAll('.btn-challenge');
            challengeButtons.forEach((button, index) => {
                button.addEventListener('click', function() {
                    const challengeCard = this.closest('.challenge-card');
                    const challengeTitle = challengeCard.querySelector('h5').textContent;
                    const pointsElement = challengeCard.querySelector('.detail span');
                    let points = 150; // Default points
                    
                    // Try to extract points from the button text
                    if (pointsElement) {
                        const pointsText = pointsElement.textContent;
                        const pointsMatch = pointsText.match(/(\d+)/);
                        if (pointsMatch) {
                            points = parseInt(pointsMatch[1]);
                        }
                    }
                    
                    // Log challenge completion
                    logChallengeCompletion(challengeTitle, points);
                });
            });
        });
    </script>
</body>
</html>