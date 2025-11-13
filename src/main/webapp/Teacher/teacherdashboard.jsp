<%@ page import="com.mycompany.sih3.entity.User" %>
<%@ include file="auth_check.jsp" %>
<%
    User currentUser = (User) session.getAttribute("user");
    String displayName = currentUser.getFullName();
    if (displayName == null || displayName.trim().isEmpty()) {
        displayName = currentUser.getUsername();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Teacher Dashboard - EcoLearn Platform</title>
    
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
        
        .teacher-dashboard {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            padding: 20px 0;
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
        
        .welcome-section {
            text-align: center;
            padding: 3rem 1rem;
            background: white;
            border-radius: var(--border-radius-lg);
            box-shadow: var(--shadow-md);
            margin-bottom: var(--spacing-lg);
            animation: fadeIn 0.6s ease-out;
        }
        
        .welcome-icon {
            font-size: 4rem;
            color: var(--primary-green);
            margin-bottom: 1.5rem;
        }
        
        .welcome-title {
            font-size: 2rem;
            font-weight: 600;
            color: var(--dark-gray);
            margin-bottom: 1rem;
        }
        
        .welcome-text {
            font-size: 1.1rem;
            color: #6c757d;
            max-width: 600px;
            margin: 0 auto 2rem;
        }
        
        footer {
            background: #2c3e50;
            color: #95a5a6;
            padding: 1.5rem 0;
            margin-top: auto;
        }
        
        /* Sidebar Navigation Styles */
        .sidebar {
            background: white;
            border-radius: var(--border-radius-lg);
            box-shadow: var(--shadow-md);
            height: fit-content;
            position: sticky;
            top: 20px;
        }
        
        .nav-header {
            padding: 1.5rem;
            background: linear-gradient(135deg, var(--primary-green), var(--secondary-teal));
            color: white;
            border-radius: var(--border-radius-lg) var(--border-radius-lg) 0 0;
            text-align: center;
        }
        
        .nav-header h4 {
            margin: 0;
            font-weight: 600;
        }
        
        .nav-header p {
            margin: 0;
            font-size: 0.9rem;
            opacity: 0.9;
        }
        
        .nav-item {
            padding: 0.75rem 1.5rem;
            border-bottom: 1px solid #f1f3f4;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
        }
        
        .nav-item:last-child {
            border-bottom: none;
            border-radius: 0 0 var(--border-radius-lg) var(--border-radius-lg);
        }
        
        .nav-item:hover {
            background: rgba(45, 143, 68, 0.1);
        }
        
        .nav-item.active {
            background: linear-gradient(135deg, var(--primary-green), var(--secondary-teal));
            color: white;
        }
        
        .nav-item i {
            margin-right: 0.75rem;
            width: 20px;
            text-align: center;
        }
        
        .user-info {
            padding: 1rem 1.5rem;
            border-top: 1px solid #f1f3f4;
            display: flex;
            align-items: center;
        }
        
        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: rgba(45, 143, 68, 0.1);
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 0.75rem;
            color: var(--primary-green);
        }
        
        .user-details {
            flex: 1;
        }
        
        .user-name {
            font-weight: 500;
            font-size: 0.95rem;
        }
        
        .user-role {
            font-size: 0.8rem;
            color: #6c757d;
        }
        
        /* Dashboard Stats */
        .stat-card {
            background: white;
            border-radius: var(--border-radius-lg);
            box-shadow: var(--shadow-md);
            padding: 1.5rem;
            height: 100%;
            transition: transform 0.3s ease;
            border-left: 4px solid var(--primary-green);
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
        }
        
        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: rgba(45, 143, 68, 0.1);
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 1rem;
            color: var(--primary-green);
            font-size: 1.5rem;
        }
        
        .stat-title {
            font-size: 0.9rem;
            color: #6c757d;
            margin-bottom: 0.5rem;
        }
        
        .stat-value {
            font-size: 2rem;
            font-weight: 700;
            color: var(--dark-gray);
            margin-bottom: 0;
        }
        
        .stat-trend {
            font-size: 0.85rem;
            margin-top: 0.5rem;
        }
        
        .trend-up {
            color: #28a745;
        }
        
        .trend-down {
            color: #dc3545;
        }
        
        /* Quick Actions */
        .action-card {
            background: white;
            border-radius: var(--border-radius-lg);
            box-shadow: var(--shadow-md);
            padding: 1.5rem;
            height: 100%;
            transition: transform 0.3s ease;
        }
        
        .action-card:hover {
            transform: translateY(-5px);
        }
        
        .action-icon {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: rgba(45, 143, 68, 0.1);
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 1rem;
            color: var(--primary-green);
            font-size: 1.25rem;
        }
        
        .action-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--dark-gray);
            margin-bottom: 0.5rem;
        }
        
        .action-desc {
            font-size: 0.9rem;
            color: #6c757d;
            margin-bottom: 1.5rem;
        }
        
        .action-btn {
            width: 100%;
            background: linear-gradient(135deg, var(--primary-green), var(--secondary-teal));
            border: none;
            padding: 0.75rem;
            border-radius: var(--border-radius-lg);
            color: white;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .action-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(45, 143, 68, 0.4);
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body class="teacher-dashboard">
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar Navigation -->
            <div class="col-lg-3">
                <div class="sidebar">
                    <div class="nav-header">
                        <h4>EcoLearn</h4>
                        <p>Teacher Portal</p>
                    </div>
                    <div class="nav-item active" onclick="window.location.href='teacherdashboard.jsp'">
                        <i class="fas fa-tachometer-alt"></i>
                        <span>Dashboard</span>
                    </div>
                    <div class="nav-item" onclick="window.location.href='manage-lessons.jsp'">
                        <i class="fas fa-book-open"></i>
                        <span>Manage Lessons</span>
                    </div>
                    <div class="nav-item" onclick="window.location.href='video-transcripts.jsp'">
                        <i class="fas fa-file-alt"></i>
                        <span>Video Transcripts</span>
                    </div>
                    <div class="nav-item" onclick="window.location.href='test-transcript.jsp'">
                        <i class="fas fa-bug"></i>
                        <span>Test Transcript</span>
                    </div>
                    <div class="nav-item" onclick="window.location.href='manage-quizzes.jsp'">
                        <i class="fas fa-question-circle"></i>
                        <span>Manage Quizzes</span>
                    </div>
                    <div class="nav-item" onclick="window.location.href='student-management.jsp'">
                        <i class="fas fa-users"></i>
                        <span>Student Management</span>
                    </div>
                    <div class="nav-item" onclick="window.location.href='student-progress.jsp'">
                        <i class="fas fa-chart-line"></i>
                        <span>Student Progress</span>
                    </div>
                    <div class="nav-item" onclick="window.location.href='class-management.jsp'">
                        <i class="fas fa-users-class"></i>
                        <span>Class Management</span>
                    </div>
                    <div class="nav-item" onclick="window.location.href='profile.jsp'">
                        <i class="fas fa-user"></i>
                        <span>Profile</span>
                    </div>
                    <div class="nav-item" onclick="window.location.href='settings.jsp'">
                        <i class="fas fa-cog"></i>
                        <span>Settings</span>
                    </div>
                    <div class="user-info">
                        <div class="user-avatar">
                            <i class="fas fa-user"></i>
                        </div>
                        <div class="user-details">
                            <div class="user-name"><%= displayName %></div>
                            <div class="user-role">Teacher</div>
                        </div>
                    </div>
                    <div class="nav-item" onclick="window.location.href='../jsp/logout.jsp'">
                        <i class="fas fa-sign-out-alt"></i>
                        <span>Logout</span>
                    </div>
                </div>
            </div>

            <!-- Main Content -->
            <div class="col-lg-9">
                <div class="main-content">
                    <!-- Page Header -->
                    <div class="page-header">
                        <div class="row align-items-center">
                            <div class="col-lg-8">
                                <h1 class="page-title">
                                    <i class="fas fa-chalkboard-teacher me-2"></i>Teacher Dashboard
                                </h1>
                                <p class="page-subtitle">
                                    Welcome, <%= displayName %>. This is your secure teacher dashboard.
                                </p>
                            </div>
                            <div class="col-lg-4 text-end">
                                <div class="btn-group" role="group">
                                    <button type="button" class="btn btn-light">
                                        <i class="fas fa-calendar-alt me-2"></i>Today
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Dashboard Stats -->
                    <div class="row mb-4">
                        <div class="col-md-3 mb-4">
                            <div class="stat-card">
                                <div class="stat-icon">
                                    <i class="fas fa-graduation-cap"></i>
                                </div>
                                <div class="stat-title">Total Lessons</div>
                                <h3 class="stat-value">12</h3>
                                <div class="stat-trend trend-up">
                                    <i class="fas fa-arrow-up me-1"></i>2 this month
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-3 mb-4">
                            <div class="stat-card">
                                <div class="stat-icon">
                                    <i class="fas fa-question-circle"></i>
                                </div>
                                <div class="stat-title">Active Quizzes</div>
                                <h3 class="stat-value">8</h3>
                                <div class="stat-trend trend-up">
                                    <i class="fas fa-arrow-up me-1"></i>1 this week
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-3 mb-4">
                            <div class="stat-card">
                                <div class="stat-icon">
                                    <i class="fas fa-users"></i>
                                </div>
                                <div class="stat-title">Your Students</div>
                                <h3 class="stat-value">42</h3>
                                <div class="stat-trend trend-down">
                                    <i class="fas fa-arrow-down me-1"></i>3 inactive
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-3 mb-4">
                            <div class="stat-card">
                                <div class="stat-icon">
                                    <i class="fas fa-clipboard-check"></i>
                                </div>
                                <div class="stat-title">Pending Reviews</div>
                                <h3 class="stat-value">3</h3>
                                <div class="stat-trend">
                                    <i class="fas fa-equals me-1"></i>No change
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Welcome Section -->
                    <div class="welcome-section">
                        <div class="welcome-icon">
                            <i class="fas fa-chalkboard-teacher"></i>
                        </div>
                        <h2 class="welcome-title">Teacher Dashboard</h2>
                        <p class="welcome-text">
                            This is a secure teacher dashboard page. You are logged in as <%= displayName %> and have access to teacher-specific features.
                        </p>
                        <div class="d-flex justify-content-center gap-3">
                            <button class="btn btn-primary" onclick="window.location.href='manage-lessons.jsp'">
                                <i class="fas fa-book me-2"></i>Manage Lessons
                            </button>
                            <button class="btn btn-success" onclick="window.location.href='manage-quizzes.jsp'">
                                <i class="fas fa-question-circle me-2"></i>Manage Quizzes
                            </button>
                            <button class="btn btn-info" onclick="window.location.href='student-progress.jsp'">
                                <i class="fas fa-chart-line me-2"></i>View Progress
                            </button>
                        </div>
                    </div>

                    <!-- Quick Actions -->
                    <div class="row">
                        <div class="col-md-4 mb-4">
                            <div class="action-card">
                                <div class="action-icon">
                                    <i class="fas fa-plus-circle"></i>
                                </div>
                                <h5 class="action-title">Create New Lesson</h5>
                                <p class="action-desc">Add a new educational lesson with videos and resources</p>
                                <button class="action-btn" onclick="window.location.href='manage-lessons.jsp'">
                                    <i class="fas fa-plus me-2"></i>Create Lesson
                                </button>
                            </div>
                        </div>
                        
                        <div class="col-md-4 mb-4">
                            <div class="action-card">
                                <div class="action-icon">
                                    <i class="fas fa-question"></i>
                                </div>
                                <h5 class="action-title">Create Quiz</h5>
                                <p class="action-desc">Generate quizzes to test student understanding</p>
                                <button class="action-btn" onclick="window.location.href='manage-quizzes.jsp'">
                                    <i class="fas fa-plus me-2"></i>Create Quiz
                                </button>
                            </div>
                        </div>
                        
                        <div class="col-md-4 mb-4">
                            <div class="action-card">
                                <div class="action-icon">
                                    <i class="fas fa-chart-bar"></i>
                                </div>
                                <h5 class="action-title">View Reports</h5>
                                <p class="action-desc">Analyze student performance and progress</p>
                                <button class="action-btn" onclick="window.location.href='student-progress.jsp'">
                                    <i class="fas fa-chart-line me-2"></i>View Reports
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
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