<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mycompany.sih3.entity.User" %>
<%@ page import="com.mycompany.sih3.repository.UserRepository" %>
<%
    // Get user ID from session
    Integer userId = (Integer) session.getAttribute("userId");
    String userName = "Guest";
    String userEmail = "guest@example.com";
    String userUsername = "guest_user";
    String userAvatar = null;
    String firstName = "";
    String lastName = "";
    
    // Fetch user from database if userId exists in session
    if (userId != null) {
        UserRepository userRepository = new UserRepository();
        User user = userRepository.findById(userId);
        if (user != null) {
            userName = user.getFullName();
            userEmail = user.getEmail();
            userUsername = user.getUsername();
            userAvatar = user.getAvatar();
            
            // Split full name into first and last name for the edit form
            if (userName != null && !userName.isEmpty()) {
                String[] nameParts = userName.split(" ", 2);
                firstName = nameParts[0];
                if (nameParts.length > 1) {
                    lastName = nameParts[1];
                }
            }
        }
    }
    
    // Check if profile was updated
    String updated = request.getParameter("updated");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile - EcoLearn Platform</title>
    
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
        
        .profile-page {
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
            background: linear-gradient(135deg, #2d8f44 0%, #20c997 100%);
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
        
        .profile-card {
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
        
        .profile-header {
            display: flex;
            align-items: center;
            gap: var(--spacing-lg);
            margin-bottom: var(--spacing-xl);
            padding-bottom: var(--spacing-lg);
            border-bottom: 1px solid #f1f3f4;  
        }
        
        .avatar-container {
            position: relative;
        }
        
        .profile-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary-green), var(--secondary-teal));
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
            font-size: 2rem;
            border: 4px solid white;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        
        .avatar-edit {
            position: absolute;
            bottom: 0;
            right: 0;
            background: var(--primary-green);
            color: white;
            width: 36px;
            height: 36px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            border: 2px solid white;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
        }
        
        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            overflow: hidden;
        }
        
        .user-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .profile-info {
            flex: 1;
        }
        
        .profile-name {
            font-size: 1.75rem;
            font-weight: 700;
            margin-bottom: 0.25rem;
            color: var(--dark-gray);
        }
        
        .profile-level {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            background: linear-gradient(135deg, var(--primary-green), var(--secondary-teal));
            color: white;
            font-weight: 600;
            font-size: 0.9rem;
            margin-bottom: 0.5rem;
        }
        
        .profile-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: var(--spacing-lg);
            margin-bottom: var(--spacing-xl);
        }
        
        .detail-item {
            display: flex;
            flex-direction: column;
        }
        
        .detail-label {
            font-size: 0.875rem;
            color: #6c757d;
            margin-bottom: 0.25rem;
        }
        
        .detail-value {
            font-size: 1.125rem;
            font-weight: 600;
            color: var(--dark-gray);
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: var(--spacing-md);
            margin-bottom: var(--spacing-xl);
        }
        
        .stat-card {
            background: #f8f9fa;
            border-radius: var(--border-radius-lg);
            padding: var(--spacing-md);
            text-align: center;
            transition: all 0.3s ease;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        
        .stat-icon {
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, var(--primary-green), var(--secondary-teal));
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.25rem;
            margin: 0 auto var(--spacing-sm);
        }
        
        .stat-value {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--dark-gray);
            margin-bottom: 0.25rem;
        }
        
        .stat-label {
            font-size: 0.875rem;
            color: #6c757d;
        }
        
        .edit-form .form-group {
            margin-bottom: var(--spacing-md);
        }
        
        .edit-form label {
            font-weight: 500;
            color: var(--dark-gray);
            margin-bottom: 0.5rem;
        }
        
        .edit-form .form-control {
            padding: 0.75rem;
            border-radius: var(--border-radius-lg);
            border: 1px solid #e9ecef;
        }
        
        .edit-form .form-control:focus {
            border-color: var(--primary-green);
            box-shadow: 0 0 0 0.25rem rgba(45, 143, 68, 0.25);
        }
        
        .btn {
            padding: 0.75rem 1.5rem;
            border-radius: var(--border-radius-lg);
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, var(--primary-green), var(--secondary-teal));
            border: none;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(45, 143, 68, 0.4);
        }
        
        .btn-outline-primary {
            border: 2px solid var(--primary-green);
            color: var(--primary-green);
        }
        
        .btn-outline-primary:hover {
            background: var(--primary-green);
            color: white;
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
                box-shadow: 0 0 0 0 rgba(46, 204, 113, 0.4);
            }
            70% {
                transform: scale(1.05);
                box-shadow: 0 0 0 10px rgba(46, 204, 113, 0);
            }
            100% {
                transform: scale(1);
                box-shadow: 0 0 0 0 rgba(46, 204, 113, 0);
            }
        }
        
        /* Staggered animations */
        .stat-card:nth-child(1) { animation-delay: 0.1s; }
        .stat-card:nth-child(2) { animation-delay: 0.2s; }
        .stat-card:nth-child(3) { animation-delay: 0.3s; }
        .stat-card:nth-child(4) { animation-delay: 0.4s; }
        
        /* Avatar save button */
        #saveAvatarBtn {
            background: linear-gradient(135deg, var(--primary-green), var(--secondary-teal));
            border: none;
            color: white;
            font-weight: 500;
        }
        
        #saveAvatarBtn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(45, 143, 68, 0.4);
        }
    </style>
</head>
<body class="profile-page">
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
                                <% if (userAvatar != null && !userAvatar.isEmpty()) { %>
                                    <img src="<%= request.getContextPath() + "/" + userAvatar %>" alt="Profile">
                                <% } else { %>
                                    <div class="avatar-placeholder" style="width: 100%; height: 100%; display: flex; align-items: center; justify-content: center; background: linear-gradient(135deg, var(--primary-green), var(--secondary-teal)); color: white; font-weight: 600;">
                                        <%= userName != null && userName.length() > 0 ? userName.substring(0, 1).toUpperCase() : "U" %>
                                    </div>
                                <% } %>
                            </div>
                            <span class="user-name"><%= userName != null ? userName : "Guest" %></span>
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
                        <i class="fas fa-user me-2"></i>User Profile
                    </h1>
                    <p class="page-subtitle">
                        Manage your personal information and track your environmental learning progress.
                    </p>
                </div>
                <div class="col-lg-4 text-end">
                    <button class="btn btn-light" id="editProfileBtn">
                        <i class="fas fa-edit me-2"></i>Edit Profile
                    </button>
                </div>
            </div>
        </div>

        <!-- Profile Content -->
        <div class="row">
            <div class="col-lg-8">
                <div class="profile-card">
                    <div class="card-header">
                        <h5><i class="fas fa-user-circle me-2"></i>Personal Information</h5>
                    </div>
                    <div class="card-body">
                        <div class="profile-header">
                            <div class="avatar-container">
                                <div class="profile-avatar">
                                    <% if (userAvatar != null && !userAvatar.isEmpty()) { %>
                                        <img src="<%= request.getContextPath() + "/" + userAvatar %>" alt="Profile Picture" style="width: 100%; height: 100%; border-radius: 50%; object-fit: cover;">
                                    <% } else { %>
                                        <%= userName != null && userName.length() > 0 ? userName.substring(0, 1).toUpperCase() : "U" %>
                                    <% } %>
                                </div>
                                <div class="avatar-edit" onclick="document.getElementById('avatar').click()">
                                    <i class="fas fa-camera"></i>
                                </div>
                            </div>
                            <div class="profile-info">
                                <h2 class="profile-name"><%= userName != null ? userName : "Guest User" %></h2>
                                <span class="profile-level">Tree Level</span>
                                <p class="text-muted">Student at Greenfield High School</p>
                            </div>
                        </div>
                        
                        <div class="profile-details">
                            <div class="detail-item">
                                <span class="detail-label">Full Name</span>
                                <span class="detail-value"><%= userName != null ? userName : "Guest User" %></span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">Email</span>
                                <span class="detail-value"><%= userEmail != null ? userEmail : "guest@example.com" %></span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">Username</span>
                                <span class="detail-value"><%= userUsername != null ? userUsername : "guest_user" %></span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">School</span>
                                <span class="detail-value">Greenfield High School</span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">Grade</span>
                                <span class="detail-value">10th Grade</span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">Member Since</span>
                                <span class="detail-value">January 15, 2023</span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">Last Active</span>
                                <span class="detail-value">2 hours ago</span>
                            </div>
                        </div>
                        
                        <div class="stats-grid">
                            <div class="stat-card">
                                <div class="stat-icon">
                                    <i class="fas fa-leaf"></i>
                                </div>
                                <div class="stat-value">1,850</div>
                                <div class="stat-label">Eco Points</div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-icon">
                                    <i class="fas fa-graduation-cap"></i>
                                </div>
                                <div class="stat-value">12</div>
                                <div class="stat-label">Lessons</div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-icon">
                                    <i class="fas fa-trophy"></i>
                                </div>
                                <div class="stat-value">8</div>
                                <div class="stat-label">Challenges</div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-icon">
                                    <i class="fas fa-gamepad"></i>
                                </div>
                                <div class="stat-value">5</div>
                                <div class="stat-label">Games</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-4">
                <div class="profile-card mb-4">
                    <div class="card-header">
                        <h5><i class="fas fa-chart-line me-2"></i>Progress Overview</h5>
                    </div>
                    <div class="card-body">
                        <div class="text-center mb-4">
                            <div class="stat-value">65%</div>
                            <div class="stat-label">Course Completion</div>
                        </div>
                        <div class="progress mb-3">
                            <div class="progress-bar" role="progressbar" style="width: 65%; background: linear-gradient(90deg, var(--primary-green), var(--secondary-teal));"></div>
                        </div>
                        <p class="text-muted text-center">You're making great progress! Keep going to reach the next level.</p>
                    </div>
                </div>
                
                <div class="profile-card">
                    <div class="card-header">
                        <h5><i class="fas fa-medal me-2"></i>Recent Achievements</h5>
                    </div>
                    <div class="card-body">
                        <div class="d-flex align-items-center mb-3">
                            <div class="stat-icon me-3">
                                <i class="fas fa-medal text-warning"></i>
                            </div>
                            <div>
                                <h6 class="mb-0">Eco Warrior</h6>
                                <small class="text-muted">3 days ago</small>
                            </div>
                        </div>
                        <div class="d-flex align-items-center mb-3">
                            <div class="stat-icon me-3">
                                <i class="fas fa-trophy text-success"></i>
                            </div>
                            <div>
                                <h6 class="mb-0">Challenge Master</h6>
                                <small class="text-muted">1 week ago</small>
                            </div>
                        </div>
                        <div class="d-flex align-items-center">
                            <div class="stat-icon me-3">
                                <i class="fas fa-graduation-cap text-info"></i>
                            </div>
                            <div>
                                <h6 class="mb-0">Lesson Expert</h6>
                                <small class="text-muted">2 weeks ago</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Edit Profile Form (Hidden by default) -->
        <div class="row mt-4" id="editProfileForm" style="display: none;">
            <div class="col-12">
                <div class="profile-card">
                    <div class="card-header">
                        <h5><i class="fas fa-edit me-2"></i>Edit Profile</h5>
                    </div>
                    <div class="card-body">
                        <% if ("true".equals(updated)) { %>
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <strong>Success!</strong> Your profile has been updated successfully.
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                        <% } %>
                        <% if (error != null && "update_failed".equals(error)) { %>
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <strong>Error!</strong> Failed to update profile. Please try again later.
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                        <% } %>
                        
                        <!-- Form without backend processing -->
                        <form class="edit-form" id="profileEditForm" action="updateProfileGeneral.jsp" method="post" enctype="multipart/form-data">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="firstName">First Name</label>
                                        <input type="text" class="form-control" id="firstName" name="firstName" value="<%= firstName %>">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="lastName">Last Name</label>
                                        <input type="text" class="form-control" id="lastName" name="lastName" value="<%= lastName %>">
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row mt-3">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="username">Username</label>
                                        <input type="text" class="form-control" id="username" name="username" value="<%= userUsername != null ? userUsername : "" %>">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="email">Email Address</label>
                                        <input type="email" class="form-control" id="email" name="email" value="<%= userEmail != null ? userEmail : "" %>">
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row mt-3">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="school">School</label>
                                        <input type="text" class="form-control" id="school" name="school" value="Greenfield High School">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="grade">Grade</label>
                                        <select class="form-control" id="grade" name="grade">
                                            <option>9th Grade</option>
                                            <option selected>10th Grade</option>
                                            <option>11th Grade</option>
                                            <option>12th Grade</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row mt-3">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="avatar">Profile Picture</label>
                                        <input type="file" class="form-control" id="avatar" name="avatar" accept="image/*" onchange="previewAvatar(event)">
                                        <div class="form-text text-muted mt-1" id="avatarSaveNotice" style="display: none;">
                                            <i class="fas fa-info-circle me-1"></i>Don't forget to save your changes after selecting a new avatar.
                                        </div>
                                    </div>
                                    
                                    <div class="mt-2">
                                        <% if (userAvatar != null && !userAvatar.isEmpty()) { %>
                                            <button type="button" class="btn btn-sm btn-outline-danger me-2" onclick="confirmRemoveAvatarGeneral()">
                                                <i class="fas fa-trash me-1"></i>Remove Photo
                                            </button>
                                        <% } %>
                                        <button type="button" class="btn btn-sm btn-outline-primary" id="saveAvatarBtn" onclick="document.getElementById('profileEditForm').submit()" style="display: none;">
                                            <i class="fas fa-save me-1"></i>Save Avatar
                                        </button>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Hidden field for remove avatar -->
                            <input type="hidden" id="removeAvatarGeneral" name="removeAvatar" value="false">
                            
                            <div class="d-flex justify-content-end mt-4">
                                <button type="button" class="btn btn-outline-primary me-2" id="cancelEditBtn">Cancel</button>
                                <button type="submit" class="btn btn-primary">Save Changes</button>
                            </div>
                        </form>
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
        // Toggle edit profile form
        document.addEventListener('DOMContentLoaded', function() {
            const editProfileBtn = document.getElementById('editProfileBtn');
            const editProfileForm = document.getElementById('editProfileForm');
            const cancelEditBtn = document.getElementById('cancelEditBtn');
            const profileEditForm = document.getElementById('profileEditForm');
            
            editProfileBtn.addEventListener('click', function() {
                editProfileForm.style.display = 'block';
                // Scroll to form
                editProfileForm.scrollIntoView({ behavior: 'smooth' });
            });
            
            cancelEditBtn.addEventListener('click', function() {
                editProfileForm.style.display = 'none';
            });
            
            // Handle form submission
            // No need to prevent default since we're submitting to the server now
        });
        
        function confirmRemoveAvatarGeneral() {
            if (confirm("Are you sure you want to remove your profile photo?")) {
                // Set the hidden field to true
                document.getElementById('removeAvatarGeneral').value = 'true';
                // Submit the form
                document.getElementById('profileEditForm').submit();
            }
        }
        
        // Preview avatar image before upload
        function previewAvatar(event) {
            const file = event.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    // Update the profile avatar preview
                    const profileAvatar = document.querySelector('.profile-avatar');
                    if (profileAvatar) {
                        profileAvatar.innerHTML = '<img src="' + e.target.result + '" alt="Profile Picture" style="width: 100%; height: 100%; border-radius: 50%; object-fit: cover;">';
                    }
                    
                    // Show the save avatar button
                    const saveAvatarBtn = document.getElementById('saveAvatarBtn');
                    if (saveAvatarBtn) {
                        saveAvatarBtn.style.display = 'inline-block';
                    }
                    
                    // Show the save notice
                    const avatarSaveNotice = document.getElementById('avatarSaveNotice');
                    if (avatarSaveNotice) {
                        avatarSaveNotice.style.display = 'block';
                    }
                }
                reader.readAsDataURL(file);
            }
        }
    </script>
</body>
</html>