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
    <title>Activity Logging Demo - EcoLearn Platform</title>
    
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
        
        .demo-page {
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
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: var(--spacing-xl);
            border-radius: var(--border-radius-lg);
            margin-bottom: var(--spacing-xl);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        }
        
        .demo-card {
            background: white;
            border-radius: var(--border-radius-lg);
            box-shadow: var(--shadow-md);
            margin-bottom: var(--spacing-lg);
            transition: all 0.3s ease;
        }
        
        .demo-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.15);
        }
        
        .card-header {
            padding: var(--spacing-lg);
            border-bottom: 1px solid #e9ecef;
            background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
        }
        
        .card-body {
            padding: var(--spacing-lg);
        }
        
        .btn-demo {
            width: 100%;
            padding: 0.75rem;
            border-radius: var(--border-radius-lg);
            font-weight: 500;
            transition: all 0.3s ease;
            margin-bottom: 0.5rem;
        }
        
        .btn-demo:hover {
            transform: translateY(-2px);
        }
        
        .log-container {
            background: #2c3e50;
            color: #ecf0f1;
            border-radius: var(--border-radius-lg);
            padding: var(--spacing-md);
            font-family: 'Courier New', monospace;
            font-size: 0.9rem;
            max-height: 300px;
            overflow-y: auto;
        }
        
        .log-entry {
            margin-bottom: 0.5rem;
            padding: 0.25rem 0;
            border-bottom: 1px solid #34495e;
        }
        
        .log-success {
            color: #2ecc71;
        }
        
        .log-error {
            color: #e74c3c;
        }
        
        .log-info {
            color: #3498db;
        }
    </style>
</head>
<body class="demo-page">
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
            <h1 class="page-title">
                <i class="fas fa-flask me-2"></i>Activity Logging Demo
            </h1>
            <p class="page-subtitle">
                Test the activity logging functionality for lessons, challenges, and games
            </p>
        </div>

        <div class="row">
            <!-- Lesson Completion Demo -->
            <div class="col-lg-4 col-md-6">
                <div class="demo-card">
                    <div class="card-header">
                        <h5><i class="fas fa-graduation-cap me-2"></i>Lesson Completion</h5>
                    </div>
                    <div class="card-body">
                        <button class="btn btn-primary btn-demo" onclick="testLessonCompletion()">
                            <i class="fas fa-check-circle me-2"></i>Complete Sample Lesson
                        </button>
                        <p class="text-muted">Simulates completing a lesson and logging the activity</p>
                    </div>
                </div>
            </div>
            
            <!-- Challenge Completion Demo -->
            <div class="col-lg-4 col-md-6">
                <div class="demo-card">
                    <div class="card-header">
                        <h5><i class="fas fa-leaf me-2"></i>Challenge Completion</h5>
                    </div>
                    <div class="card-body">
                        <button class="btn btn-success btn-demo" onclick="testChallengeCompletion()">
                            <i class="fas fa-trophy me-2"></i>Complete Sample Challenge
                        </button>
                        <p class="text-muted">Simulates completing a challenge and logging the activity</p>
                    </div>
                </div>
            </div>
            
            <!-- Game Completion Demo -->
            <div class="col-lg-4 col-md-6">
                <div class="demo-card">
                    <div class="card-header">
                        <h5><i class="fas fa-gamepad me-2"></i>Game Completion</h5>
                </div>
                    <div class="card-body">
                        <button class="btn btn-info btn-demo" onclick="testGameCompletion()">
                            <i class="fas fa-play-circle me-2"></i>Complete Sample Game
                        </button>
                        <p class="text-muted">Simulates completing a game and logging the activity</p>
                    </div>
                </div>
            </div>
            
            <!-- View Dashboard -->
            <div class="col-lg-4 col-md-6">
                <div class="demo-card">
                    <div class="card-header">
                        <h5><i class="fas fa-tachometer-alt me-2"></i>View Dashboard</h5>
                    </div>
                    <div class="card-body">
                        <a href="dashboard.jsp" class="btn btn-secondary btn-demo">
                            <i class="fas fa-eye me-2"></i>View Recent Activity
                        </a>
                        <p class="text-muted">See the logged activities in the dashboard</p>
                    </div>
                </div>
            </div>
            
            <!-- Clear Activity Log -->
            <div class="col-lg-4 col-md-6">
                <div class="demo-card">
                    <div class="card-header">
                        <h5><i class="fas fa-trash me-2"></i>Clear Demo Activities</h5>
                    </div>
                    <div class="card-body">
                        <button class="btn btn-danger btn-demo" onclick="clearDemoActivities()">
                            <i class="fas fa-broom me-2"></i>Clear Demo Activities
                        </button>
                        <p class="text-muted">Remove demo activities from the database</p>
                    </div>
                </div>
            </div>
            
            <!-- Test All Activities -->
            <div class="col-lg-4 col-md-6">
                <div class="demo-card">
                    <div class="card-header">
                        <h5><i class="fas fa-rocket me-2"></i>Test All Activities</h5>
                    </div>
                    <div class="card-body">
                        <button class="btn btn-warning btn-demo" onclick="testAllActivities()">
                            <i class="fas fa-bolt me-2"></i>Test All Activities
                        </button>
                        <p class="text-muted">Simulate all activity types at once</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Activity Log -->
        <div class="row mt-4">
            <div class="col-12">
                <div class="demo-card">
                    <div class="card-header">
                        <h5><i class="fas fa-terminal me-2"></i>Activity Log</h5>
                    </div>
                    <div class="card-body">
                        <div id="activityLog" class="log-container">
                            <div class="log-entry log-info">Ready to log activities. Click buttons above to test...</div>
                        </div>
                        <div class="mt-3">
                            <button class="btn btn-sm btn-outline-secondary" onclick="clearLog()">
                                <i class="fas fa-trash me-1"></i>Clear Log
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript Libraries -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Log messages to the activity log
        function logMessage(message, type) {
            const logElement = document.getElementById('activityLog');
            const timestamp = new Date().toLocaleTimeString();
            const logEntry = document.createElement('div');
            logEntry.className = 'log-entry ' + (type ? 'log-' + type : '');
            logEntry.innerHTML = `[${timestamp}] ${message}`;
            logElement.appendChild(logEntry);
            logElement.scrollTop = logElement.scrollHeight;
        }
        
        // Clear the log
        function clearLog() {
            const logElement = document.getElementById('activityLog');
            logElement.innerHTML = '<div class="log-entry log-info">Log cleared. Ready for new activities...</div>';
        }
        
        // Test lesson completion
        function testLessonCompletion() {
            logMessage('Completing sample lesson...', 'info');
            
            fetch('complete-lesson.jsp', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'lessonId=1&lessonTitle=Renewable Energy Sources&points=100'
            })
            .then(response => response.json())
            .then(data => {
                if (data.status === 'success') {
                    logMessage('✓ Lesson completion logged successfully: ' + data.message, 'success');
                } else {
                    logMessage('✗ Failed to log lesson completion: ' + data.message, 'error');
                }
            })
            .catch(error => {
                logMessage('✗ Error logging lesson completion: ' + error.message, 'error');
            });
        }
        
        // Test challenge completion
        function testChallengeCompletion() {
            logMessage('Completing sample challenge...', 'info');
            
            fetch('complete-challenge.jsp', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'challengeTitle=Plastic-Free Week&points=150'
            })
            .then(response => response.json())
            .then(data => {
                if (data.status === 'success') {
                    logMessage('✓ Challenge completion logged successfully: ' + data.message, 'success');
                } else {
                    logMessage('✗ Failed to log challenge completion: ' + data.message, 'error');
                }
            })
            .catch(error => {
                logMessage('✗ Error logging challenge completion: ' + error.message, 'error');
            });
        }
        
        // Test game completion
        function testGameCompletion() {
            logMessage('Completing sample game...', 'info');
            
            fetch('complete-game.jsp', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'gameTitle=Eco Sorting Challenge&points=50'
            })
            .then(response => response.json())
            .then(data => {
                if (data.status === 'success') {
                    logMessage('✓ Game completion logged successfully: ' + data.message, 'success');
                } else {
                    logMessage('✗ Failed to log game completion: ' + data.message, 'error');
                }
            })
            .catch(error => {
                logMessage('✗ Error logging game completion: ' + error.message, 'error');
            });
        }
        
        // Test all activities
        function testAllActivities() {
            testLessonCompletion();
            setTimeout(testChallengeCompletion, 1000);
            setTimeout(testGameCompletion, 2000);
        }
        
        // Clear demo activities
        function clearDemoActivities() {
            logMessage('Clearing demo activities from database...', 'info');
            
            // In a real application, you would make a request to clear demo activities
            // For now, we'll just show a message
            setTimeout(() => {
                logMessage('✓ Demo activities cleared (simulated)', 'success');
            }, 1000);
        }
    </script>
</body>
</html>