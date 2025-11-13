<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="auth_check.jsp" %>
<%@ page import="com.mycompany.sih3.entity.User" %>
<%@ page import="com.mycompany.sih3.repository.UserRepository" %>
<%
    // Get user from session (set by auth_check.jsp)
    User currentUser = (User) session.getAttribute("user");
    String userName = "User"; // Default name
    String userEmail = "user@example.com"; // Default email
    String userUsername = "username"; // Default username
    
    if (currentUser != null) {
        userName = currentUser.getFullName();
        userEmail = currentUser.getEmail() != null ? currentUser.getEmail() : userEmail;
        userUsername = currentUser.getUsername() != null ? currentUser.getUsername() : userUsername;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Settings - EcoLearn Platform</title>
    
    <!-- CSS Libraries -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --primary-teal: #1abc9c;
            --secondary-cyan: #17a2b8;
            --accent-green: #20c997;
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
        
        .settings-page {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            padding-top: 76px;
        }
        
        .navbar {
            background: var(--primary-teal) !important;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .main-content {
            padding: var(--spacing-xl) 0;
        }
        
        .page-header {
            background: linear-gradient(135deg, #1abc9c 0%, #17a2b8 100%);
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
        
        .settings-card {
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
        
        .settings-section {
            margin-bottom: var(--spacing-xl);
        }
        
        .settings-section:last-child {
            margin-bottom: 0;
        }
        
        .section-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--dark-gray);
            margin-bottom: var(--spacing-md);
            padding-bottom: 0.5rem;
            border-bottom: 1px solid #f1f3f4;
        }
        
        .form-group {
            margin-bottom: var(--spacing-md);
        }
        
        .form-group label {
            font-weight: 500;
            color: var(--dark-gray);
            margin-bottom: 0.5rem;
        }
        
        .form-control {
            padding: 0.75rem;
            border-radius: var(--border-radius-lg);
            border: 1px solid #e9ecef;
        }
        
        .form-control:focus {
            border-color: var(--primary-teal);
            box-shadow: 0 0 0 0.25rem rgba(26, 188, 156, 0.25);
        }
        
        .form-check {
            margin-bottom: 0.5rem;
        }
        
        .form-check-label {
            color: var(--dark-gray);
        }
        
        .btn {
            padding: 0.75rem 1.5rem;
            border-radius: var(--border-radius-lg);
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, var(--primary-teal), var(--accent-green));
            border: none;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(26, 188, 156, 0.4);
        }
        
        .btn-outline-danger {
            border: 2px solid #dc3545;
            color: #dc3545;
        }
        
        .btn-outline-danger:hover {
            background: #dc3545;
            color: white;
        }
        
        .setting-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem 0;
            border-bottom: 1px solid #f1f3f4;
        }
        
        .setting-item:last-child {
            border-bottom: none;
        }
        
        .setting-info h6 {
            margin: 0 0 0.25rem 0;
            font-size: 1rem;
            font-weight: 500;
            color: var(--dark-gray);
        }
        
        .setting-info p {
            margin: 0;
            font-size: 0.875rem;
            color: #6c757d;
        }
        
        .setting-control {
            width: 60px;
        }
        
        .theme-option {
            display: flex;
            align-items: center;
            padding: 0.75rem;
            border: 2px solid #e9ecef;
            border-radius: var(--border-radius-lg);
            margin-bottom: var(--spacing-md);
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .theme-option:hover {
            border-color: var(--primary-teal);
        }
        
        .theme-option.active {
            border-color: var(--primary-teal);
            background: rgba(26, 188, 156, 0.1);
        }
        
        .theme-preview {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            margin-right: 1rem;
        }
        
        .theme-name {
            font-weight: 500;
            color: var(--dark-gray);
        }
        
        .danger-zone {
            background: #fff5f5;
            border: 1px solid #fed7d7;
            border-radius: var(--border-radius-lg);
            padding: var(--spacing-lg);
        }
        
        .danger-zone h6 {
            color: #c53030;
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
    </style>
</head>
<body class="settings-page">
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
                        <i class="fas fa-cog me-2"></i>Account Settings
                    </h1>
                    <p class="page-subtitle">
                        Manage your account preferences, notifications, and privacy settings.
                    </p>
                </div>
                <div class="col-lg-4 text-end">
                    <button class="btn btn-light" id="saveAllButton">
                        <i class="fas fa-save me-2"></i>Save All Changes
                    </button>
                </div>
            </div>
        </div>

        <!-- Settings Content -->
        <div class="row">
            <div class="col-lg-8">
                <div class="settings-card">
                    <div class="card-header">
                        <h5><i class="fas fa-user-cog me-2"></i>General Settings</h5>
                    </div>
                    <div class="card-body">
                        <div class="settings-section">
                            <h6 class="section-title">Account Information</h6>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="username">Username</label>
                                        <input type="text" class="form-control" id="username" value="<%= userUsername %>" readonly>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="email">Email Address</label>
                                        <input type="email" class="form-control" id="email" value="<%= userEmail %>" readonly>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row mt-3">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="firstName">First Name</label>
                                        <input type="text" class="form-control" id="firstName" value="<%= userName.indexOf(' ') > 0 ? userName.substring(0, userName.indexOf(' ')) : userName %>">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="lastName">Last Name</label>
                                        <input type="text" class="form-control" id="lastName" value="<%= userName.indexOf(' ') > 0 ? userName.substring(userName.indexOf(' ') + 1) : "" %>">
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="settings-section">
                            <h6 class="section-title">Notification Preferences</h6>
                            <div class="setting-item">
                                <div class="setting-info">
                                    <h6>Email Notifications</h6>
                                    <p>Receive email updates about your progress and new content</p>
                                </div>
                                <div class="setting-control">
                                    <div class="form-check form-switch">
                                        <input class="form-check-input" type="checkbox" id="emailNotifications" checked>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="setting-item">
                                <div class="setting-info">
                                    <h6>Push Notifications</h6>
                                    <p>Receive push notifications on your device</p>
                                </div>
                                <div class="setting-control">
                                    <div class="form-check form-switch">
                                        <input class="form-check-input" type="checkbox" id="pushNotifications" checked>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="setting-item">
                                <div class="setting-info">
                                    <h6>Weekly Progress Reports</h6>
                                    <p>Get weekly summaries of your learning progress</p>
                                </div>
                                <div class="setting-control">
                                    <div class="form-check form-switch">
                                        <input class="form-check-input" type="checkbox" id="weeklyReports" checked>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="setting-item">
                                <div class="setting-info">
                                    <h6>New Achievement Alerts</h6>
                                    <p>Get notified when you unlock new achievements</p>
                                </div>
                                <div class="setting-control">
                                    <div class="form-check form-switch">
                                        <input class="form-check-input" type="checkbox" id="achievementAlerts" checked>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="settings-section">
                            <h6 class="section-title">Privacy Settings</h6>
                            <div class="setting-item">
                                <div class="setting-info">
                                    <h6>Profile Visibility</h6>
                                    <p>Make your profile visible to other users</p>
                                </div>
                                <div class="setting-control">
                                    <div class="form-check form-switch">
                                        <input class="form-check-input" type="checkbox" id="profileVisibility" checked>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="setting-item">
                                <div class="setting-info">
                                    <h6>Activity Sharing</h6>
                                    <p>Share your learning activities with friends</p>
                                </div>
                                <div class="setting-control">
                                    <div class="form-check form-switch">
                                        <input class="form-check-input" type="checkbox" id="activitySharing">
                                    </div>
                                </div>
                            </div>
                            
                            <div class="setting-item">
                                <div class="setting-info">
                                    <h6>Leaderboard Participation</h6>
                                    <p>Appear in public leaderboards</p>
                                </div>
                                <div class="setting-control">
                                    <div class="form-check form-switch">
                                        <input class="form-check-input" type="checkbox" id="leaderboardParticipation" checked>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-4">
                <div class="settings-card mb-4">
                    <div class="card-header">
                        <h5><i class="fas fa-palette me-2"></i>Appearance</h5>
                    </div>
                    <div class="card-body">
                        <h6 class="section-title">Theme</h6>
                        <div class="theme-option" data-theme="Eco Green">
                            <div class="theme-preview" style="background: linear-gradient(135deg, #2d8f44, #20c997);"></div>
                            <span class="theme-name">Eco Green</span>
                        </div>
                        
                        <div class="theme-option" data-theme="Ocean Blue">
                            <div class="theme-preview" style="background: linear-gradient(135deg, #3498db, #2c3e50);"></div>
                            <span class="theme-name">Ocean Blue</span>
                        </div>
                        
                        <div class="theme-option" data-theme="Sunset Red">
                            <div class="theme-preview" style="background: linear-gradient(135deg, #e74c3c, #c0392b);"></div>
                            <span class="theme-name">Sunset Red</span>
                        </div>
                        
                        <div class="theme-option" data-theme="Purple Haze">
                            <div class="theme-preview" style="background: linear-gradient(135deg, #9b59b6, #8e44ad);"></div>
                            <span class="theme-name">Purple Haze</span>
                        </div>
                        
                        <div class="theme-option" data-theme="Mixable">
                            <div class="theme-preview" style="background: linear-gradient(135deg, #1abc9c, #3498db, #9b59b6);"></div>
                            <span class="theme-name">Mixable</span>
                        </div>
                    </div>
                </div>
                
                <div class="settings-card">
                    <div class="card-header">
                        <h5><i class="fas fa-exclamation-triangle me-2"></i>Danger Zone</h5>
                    </div>
                    <div class="card-body">
                        <div class="danger-zone">
                            <h6>Delete Account</h6>
                            <p>Permanently delete your account and all associated data. This action cannot be undone.</p>
                            <button class="btn btn-outline-danger w-100">
                                <i class="fas fa-trash-alt me-2"></i>Delete Account
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript Libraries -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="../js/theme.js"></script>
    
    <script>
        // Theme selection
        document.addEventListener('DOMContentLoaded', function() {
            const themeOptions = document.querySelectorAll('.theme-option');
            const saveAllButton = document.getElementById('saveAllButton');
            
            // Get current theme from localStorage or default to 'Eco Green'
            let currentTheme = localStorage.getItem('selectedTheme') || 'Eco Green';
            
            // Set active theme on page load
            themeOptions.forEach(option => {
                if (option.getAttribute('data-theme') === currentTheme) {
                    option.classList.add('active');
                }
                
                // Add click event to each theme option
                option.addEventListener('click', function() {
                    // Remove active class from all options
                    themeOptions.forEach(opt => opt.classList.remove('active'));
                    
                    // Add active class to clicked option
                    this.classList.add('active');
                    
                    // Get selected theme
                    const selectedTheme = this.getAttribute('data-theme');
                    
                    // Save theme immediately
                    saveThemeOnly(selectedTheme);
                });
            });
            
            // Function to save only the theme
            function saveThemeOnly(themeName) {
                // Update localStorage
                localStorage.setItem('selectedTheme', themeName);
                
                // Apply theme immediately
                if (typeof applyTheme === 'function') {
                    applyTheme(themeName);
                }
                
                // Show alert
                alert('Theme changed to ' + themeName + ' successfully!');
            }
            
            // Function to save all changes (including theme)
            function saveAllChanges() {
                // Get all form values
                const firstName = document.getElementById('firstName').value;
                const lastName = document.getElementById('lastName').value;
                const emailNotifications = document.getElementById('emailNotifications').checked;
                const pushNotifications = document.getElementById('pushNotifications').checked;
                const weeklyReports = document.getElementById('weeklyReports').checked;
                const achievementAlerts = document.getElementById('achievementAlerts').checked;
                const profileVisibility = document.getElementById('profileVisibility').checked;
                const activitySharing = document.getElementById('activitySharing').checked;
                const leaderboardParticipation = document.getElementById('leaderboardParticipation').checked;
                
                // Get selected theme
                let selectedTheme = 'Eco Green';
                const activeTheme = document.querySelector('.theme-option.active');
                if (activeTheme) {
                    selectedTheme = activeTheme.getAttribute('data-theme');
                }
                
                // Validate required fields
                if (!firstName || firstName.trim() === '') {
                    alert('Please enter your first name');
                    return;
                }
                
                // Prepare data to send
                const formData = new FormData();
                formData.append('firstName', firstName.trim());
                formData.append('lastName', lastName ? lastName.trim() : '');
                formData.append('emailNotifications', emailNotifications);
                formData.append('pushNotifications', pushNotifications);
                formData.append('weeklyReports', weeklyReports);
                formData.append('achievementAlerts', achievementAlerts);
                formData.append('profileVisibility', profileVisibility);
                formData.append('activitySharing', activitySharing);
                formData.append('leaderboardParticipation', leaderboardParticipation);
                formData.append('theme', selectedTheme);
                
                // Send data to server
                fetch('saveSettings.jsp', {
                    method: 'POST',
                    body: formData
                })
                .then(response => response.json())
                .then(data => {
                    if (data.status === 'success') {
                        alert('All settings saved successfully!');
                        
                        // Apply the theme immediately
                        if (typeof applyTheme === 'function') {
                            applyTheme(selectedTheme);
                        }
                    } else {
                        alert('Error saving settings: ' + data.message);
                    }
                })
                .catch(error => {
                    alert('Error saving settings: ' + error);
                });
            }
            
            // Save all changes functionality
            if (saveAllButton) {
                saveAllButton.addEventListener('click', saveAllChanges);
            }
            
            // Add event listeners to all form elements to track changes
            const formElements = document.querySelectorAll('input, select, textarea');
            formElements.forEach(element => {
                element.addEventListener('change', function() {
                    // Mark form as changed (for UI feedback if needed)
                });
            });
            
            // Also track input events for text fields
            const textInputs = document.querySelectorAll('input[type="text"], input[type="email"]');
            textInputs.forEach(input => {
                input.addEventListener('input', function() {
                    // Mark form as changed (for UI feedback if needed)
                });
            });
        });
    </script>
</body>
</html>