<%@ page import="com.mycompany.sih3.entity.User" %>
<%@ page import="com.mycompany.sih3.entity.Lesson" %>
<%@ include file="auth_check.jsp" %>
<%
    User currentUser = (User) session.getAttribute("user");
    String displayName = currentUser.getFullName();
    if (displayName == null || displayName.trim().isEmpty()) {
        displayName = currentUser.getUsername();
    }
    
    Lesson lesson = (Lesson) request.getAttribute("lesson");
    String transcript = (String) request.getAttribute("transcript");
    String errorMessage = (String) request.getAttribute("errorMessage");
    Boolean isProcessing = (Boolean) request.getAttribute("isProcessing");
    if (isProcessing == null) isProcessing = false;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Video Transcript - EcoLearn Platform</title>
    
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
            min-height: 100vh;
        }
        
        .video-transcript {
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
        
        .section-card {
            background: white;
            border-radius: var(--border-radius-lg);
            box-shadow: var(--shadow-md);
            padding: var(--spacing-lg);
            margin-bottom: var(--spacing-lg);
        }
        
        .section-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--dark-gray);
            margin-bottom: var(--spacing-md);
            padding-bottom: 0.5rem;
            border-bottom: 2px solid var(--primary-green);
        }
        
        .btn-primary {
            background: linear-gradient(135deg, var(--primary-green), var(--secondary-teal));
            border: none;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
        }
        
        .transcript-content {
            white-space: pre-wrap;
            line-height: 1.6;
            font-size: 1.1rem;
            background-color: #f8f9fa;
            border-radius: var(--border-radius-lg);
            padding: var(--spacing-lg);
            max-height: 600px;
            overflow-y: auto;
            font-family: 'Courier New', monospace;
        }
        
        .video-info {
            background-color: #e8f4f8;
            border-radius: var(--border-radius-lg);
            padding: var(--spacing-md);
            margin-bottom: var(--spacing-lg);
        }
        
        .info-item {
            margin-bottom: 0.5rem;
        }
        
        .info-label {
            font-weight: 600;
            color: var(--dark-gray);
        }
        
        footer {
            background: #2c3e50;
            color: #95a5a6;
            padding: 1.5rem 0;
            margin-top: auto;
        }
        
        .action-buttons {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
        }
        
        .processing-message {
            background-color: #fff3cd;
            border-color: #ffeaa7;
            color: #856404;
            padding: 1rem;
            border-radius: 0.5rem;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
        }
        
        .spinner {
            border: 4px solid rgba(0, 0, 0, 0.1);
            border-radius: 50%;
            border-top: 4px solid #3498db;
            width: 20px;
            height: 20px;
            animation: spin 1s linear infinite;
            margin-right: 10px;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        .refresh-btn {
            margin-left: 1rem;
        }
        
        .transcript-note {
            background-color: #e8f4f8;
            border-left: 4px solid var(--primary-green);
            padding: 1rem;
            margin-bottom: 1rem;
            border-radius: 0 0.5rem 0.5rem 0;
        }
    </style>
</head>
<body class="video-transcript">
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
                        <a class="nav-link" href="teacherdashboard.jsp">
                            <i class="fas fa-tachometer-alt me-1"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="manage-lessons.jsp">
                            <i class="fas fa-graduation-cap me-1"></i>Manage Lessons
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="manage-quizzes.jsp">
                            <i class="fas fa-question-circle me-1"></i>Manage Quizzes
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="student-progress.jsp">
                            <i class="fas fa-chart-line me-1"></i>Student Progress
                        </a>
                    </li>
                </ul>
                
                <ul class="navbar-nav">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle d-flex align-items-center" href="#" role="button" data-bs-toggle="dropdown">
                            <div class="user-avatar me-2">
                                <i class="fas fa-user-circle fa-lg"></i>
                            </div>
                            <span class="user-name"><%= displayName %></span>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item" href="profile.jsp"><i class="fas fa-user me-2"></i>Profile</a></li>
                            <li><a class="dropdown-item" href="settings.jsp"><i class="fas fa-cog me-2"></i>Settings</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="../jsp/logout.jsp"><i class="fas fa-sign-out-alt me-2"></i>Logout</a></li>
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
                        <i class="fas fa-file-alt me-2"></i>Video Transcript
                    </h1>
                    <p class="page-subtitle">
                        View the transcript of your lesson video
                    </p>
                </div>
                <div class="col-lg-4 text-end">
                    <button class="btn btn-light" onclick="window.location.href='manage-lessons.jsp'">
                        <i class="fas fa-arrow-left me-2"></i>Back to Lessons
                    </button>
                </div>
            </div>
        </div>

        <!-- Display error message if any -->
        <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <%= errorMessage %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>

        <!-- Lesson Information -->
        <% if (lesson != null) { %>
            <div class="section-card">
                <h2 class="section-title">Lesson Information</h2>
                
                <div class="video-info">
                    <div class="info-item">
                        <span class="info-label">Title:</span> <%= lesson.getTitle() %>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Category:</span> <%= lesson.getCategory() %>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Points:</span> <%= lesson.getPoints() %>
                    </div>
                    <% if (lesson.getDescription() != null && !lesson.getDescription().isEmpty()) { %>
                        <div class="info-item">
                            <span class="info-label">Description:</span> <%= lesson.getDescription() %>
                        </div>
                    <% } %>
                </div>
                
                <div class="action-buttons">
                    <button class="btn btn-primary" onclick="window.location.href='manage-lessons.jsp'">
                        <i class="fas fa-edit me-2"></i>Edit Lesson
                    </button>
                    <button class="btn btn-info" onclick="window.location.href='../<%= lesson.getVideoUrl() %>'">
                        <i class="fas fa-play-circle me-2"></i>Watch Video
                    </button>
                    <% if (isProcessing) { %>
                        <button class="btn btn-warning refresh-btn" onclick="location.reload();">
                            <i class="fas fa-sync-alt me-2"></i>Refresh Transcript
                        </button>
                    <% } %>
                </div>
            </div>

            <!-- Processing Message -->
            <% if (isProcessing) { %>
                <div class="processing-message">
                    <div class="spinner"></div>
                    <div>
                        <strong>Transcript Generation in Progress</strong>
                        <p class="mb-0">This may take a few minutes. Please refresh the page to check for completion.</p>
                    </div>
                </div>
            <% } %>

            <!-- Transcript Section -->
            <div class="section-card">
                <h2 class="section-title">Word-for-Word Video Transcript</h2>
                
                <div class="transcript-note">
                    <i class="fas fa-info-circle me-2"></i>
                    <strong>Note:</strong> This transcript includes every spoken word with accurate punctuation and paragraph formatting. 
                    Background music and sound effects have been ignored. This is not a summary but a complete word-for-word transcript.
                </div>
                
                <% if (transcript != null && !transcript.isEmpty()) { %>
                    <div class="transcript-content">
                        <%= transcript %>
                    </div>
                <% } else { %>
                    <div class="alert alert-info">
                        <i class="fas fa-info-circle me-2"></i>No transcript available for this video.
                    </div>
                <% } %>
            </div>
        <% } %>
    </div>

    <footer class="text-center">
        <div class="container">
            <p>&copy; 2025 EcoLearn Platform. All rights reserved.</p>
        </div>
    </footer>

    <!-- JavaScript Libraries -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>