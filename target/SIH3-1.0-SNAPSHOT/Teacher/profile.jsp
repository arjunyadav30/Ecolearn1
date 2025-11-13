<%@ page import="com.mycompany.sih3.entity.User" %>
<%@ include file="auth_check.jsp" %>
<%
    User currentUser = (User) session.getAttribute("user");
    String displayName = currentUser.getFullName();
    if (displayName == null || displayName.trim().isEmpty()) {
        displayName = currentUser.getUsername();
    }
    
    String email = currentUser.getEmail();
    String username = currentUser.getUsername();
    String userType = currentUser.getUserType().toString();
    String avatarPath = currentUser.getAvatar();
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
            min-height: 100vh;
        }
        
        .profile-page {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            padding-top: 20px;
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
            text-align: center;
            padding: 2rem;
            background: linear-gradient(135deg, var(--primary-green), var(--secondary-teal));
            color: white;
            border-radius: var(--border-radius-lg) var(--border-radius-lg) 0 0;
        }
        
        .profile-avatar-container {
            position: relative;
            display: inline-block;
            margin-bottom: 1rem;
        }
        
        .profile-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.2);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
            font-size: 3rem;
            border: 3px solid white;
            overflow: hidden;
        }
        
        .profile-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .change-photo-btn {
            position: absolute;
            bottom: 5px;
            right: 5px;
            background: var(--primary-green);
            color: white;
            border: 2px solid white;
            border-radius: 50%;
            width: 35px;
            height: 35px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
        }
        
        .profile-name {
            font-size: 1.75rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }
        
        .profile-role {
            font-size: 1.125rem;
            opacity: 0.9;
            margin-bottom: 1rem;
        }
        
        .profile-stats {
            display: flex;
            justify-content: center;
            gap: 2rem;
            margin-top: 1rem;
        }
        
        .stat-item {
            text-align: center;
        }
        
        .stat-value {
            font-size: 1.5rem;
            font-weight: 700;
        }
        
        .stat-label {
            font-size: 0.875rem;
            opacity: 0.9;
        }
        
        .info-group {
            margin-bottom: 1.5rem;
        }
        
        .info-label {
            font-weight: 600;
            color: var(--dark-gray);
            margin-bottom: 0.25rem;
        }
        
        .info-value {
            color: #6c757d;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, var(--primary-green), var(--secondary-teal));
            border: none;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(45, 143, 68, 0.4);
        }
        
        .section-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--dark-gray);
            margin-bottom: var(--spacing-md);
            padding-bottom: 0.5rem;
            border-bottom: 2px solid var(--primary-green);
        }
        
        .activity-item {
            display: flex;
            align-items: center;
            padding: 0.75rem 0;
            border-bottom: 1px solid #f1f3f4;
        }
        
        .activity-item:last-child {
            border-bottom: none;
        }
        
        .activity-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: rgba(45, 143, 68, 0.1);
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 1rem;
            color: var(--primary-green);
        }
        
        .activity-content h6 {
            margin: 0 0 0.25rem 0;
            font-size: 0.95rem;
            font-weight: 500;
        }
        
        .activity-content p {
            margin: 0;
            font-size: 0.85rem;
            color: #6c757d;
        }
        
        .activity-time {
            margin-left: auto;
            font-size: 0.8rem;
            color: #6c757d;
        }
        
        footer {
            background: #2c3e50;
            color: #95a5a6;
            padding: 1.5rem 0;
            margin-top: auto;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        /* Navigation Styles */
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
        
        /* Hidden file input */
        .file-input {
            display: none;
        }
    </style>
</head>
<body class="profile-page">
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar Navigation -->
            <div class="col-lg-3">
                <div class="sidebar">
                    <div class="nav-header">
                        <h4>EcoLearn</h4>
                        <p>Teacher Portal</p>
                    </div>
                    <div class="nav-item" onclick="window.location.href='teacherdashboard.jsp'">
                        <i class="fas fa-tachometer-alt"></i>
                        <span>Dashboard</span>
                    </div>
                    <div class="nav-item" onclick="window.location.href='manage-lessons.jsp'">
                        <i class="fas fa-book-open"></i>
                        <span>Manage Lessons</span>
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
                    <div class="nav-item active" onclick="window.location.href='profile.jsp'">
                        <i class="fas fa-user"></i>
                        <span>Profile</span>
                    </div>
                    <div class="nav-item" onclick="window.location.href='settings.jsp'">
                        <i class="fas fa-cog"></i>
                        <span>Settings</span>
                    </div>
                    <div class="user-info">
                        <div class="user-avatar">
                            <% if (avatarPath != null && !avatarPath.isEmpty()) { %>
                                <img src="../<%= avatarPath %>" alt="Profile" style="width: 100%; height: 100%; border-radius: 50%; object-fit: cover;">
                            <% } else { %>
                                <i class="fas fa-user"></i>
                            <% } %>
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
                                    <i class="fas fa-user me-2"></i>Teacher Profile
                                </h1>
                                <p class="page-subtitle">
                                    View and manage your personal information
                                </p>
                            </div>
                        </div>
                    </div>

                    <!-- Profile Card -->
                    <div class="profile-card">
                        <div class="profile-header">
                            <div class="profile-avatar-container">
                                <div class="profile-avatar">
                                    <% if (avatarPath != null && !avatarPath.isEmpty()) { %>
                                        <img src="../<%= avatarPath %>" alt="Profile Photo">
                                    <% } else { %>
                                        <i class="fas fa-user"></i>
                                    <% } %>
                                </div>
                                <div class="change-photo-btn" onclick="document.getElementById('avatarInput').click()">
                                    <i class="fas fa-camera"></i>
                                </div>
                            </div>
                            <h2 class="profile-name"><%= displayName %></h2>
                            <div class="profile-role"><%= userType %></div>
                            <div class="profile-stats">
                                <div class="stat-item">
                                    <div class="stat-value">12</div>
                                    <div class="stat-label">Lessons</div>
                                </div>
                                <div class="stat-item">
                                    <div class="stat-value">8</div>
                                    <div class="stat-label">Quizzes</div>
                                </div>
                                <div class="stat-item">
                                    <div class="stat-value">42</div>
                                    <div class="stat-label">Students</div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="card-body">
                            <h5 class="section-title">Personal Information</h5>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="info-group">
                                        <div class="info-label">Full Name</div>
                                        <div class="info-value"><%= displayName %></div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="info-group">
                                        <div class="info-label">Username</div>
                                        <div class="info-value"><%= username %></div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="info-group">
                                        <div class="info-label">Email Address</div>
                                        <div class="info-value"><%= email %></div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="info-group">
                                        <div class="info-label">Role</div>
                                        <div class="info-value"><%= userType %></div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="d-flex justify-content-end">
                                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#editProfileModal">
                                    <i class="fas fa-edit me-2"></i>Edit Profile
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Recent Activity -->
                    <div class="profile-card">
                        <div class="card-header">
                            <h5><i class="fas fa-history me-2"></i>Recent Activity</h5>
                        </div>
                        <div class="card-body">
                            <div class="activity-item">
                                <div class="activity-icon">
                                    <i class="fas fa-book-open"></i>
                                </div>
                                <div class="activity-content">
                                    <h6>New lesson created</h6>
                                    <p>"Renewable Energy Sources" lesson was created</p>
                                </div>
                                <div class="activity-time">2 hours ago</div>
                            </div>
                            
                            <div class="activity-item">
                                <div class="activity-icon">
                                    <i class="fas fa-question-circle"></i>
                                </div>
                                <div class="activity-content">
                                    <h6>Quiz updated</h6>
                                    <p>"Climate Change Basics" quiz was updated</p>
                                </div>
                                <div class="activity-time">Yesterday</div>
                            </div>
                            
                            <div class="activity-item">
                                <div class="activity-icon">
                                    <i class="fas fa-user-plus"></i>
                                </div>
                                <div class="activity-content">
                                    <h6>New student enrollment</h6>
                                    <p>Priya Sharma joined your class</p>
                                </div>
                                <div class="activity-time">2 days ago</div>
                            </div>
                            
                            <div class="activity-item">
                                <div class="activity-icon">
                                    <i class="fas fa-chart-line"></i>
                                </div>
                                <div class="activity-content">
                                    <h6>Progress report generated</h6>
                                    <p>Weekly progress report for Grade 6 students</p>
                                </div>
                                <div class="activity-time">3 days ago</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Edit Profile Modal -->
    <div class="modal fade" id="editProfileModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <form id="editProfileForm" action="updateProfile.jsp" method="post" enctype="multipart/form-data">
                    <div class="modal-header">
                        <h5 class="modal-title">Edit Profile</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3 text-center">
                            <div class="profile-avatar-container">
                                <div class="profile-avatar mx-auto">
                                    <% if (avatarPath != null && !avatarPath.isEmpty()) { %>
                                        <img id="previewImage" src="../<%= avatarPath %>" alt="Profile Photo">
                                    <% } else { %>
                                        <i id="previewIcon" class="fas fa-user"></i>
                                    <% } %>
                                </div>
                                <div class="change-photo-btn" onclick="document.getElementById('avatarInput').click()">
                                    <i class="fas fa-camera"></i>
                                </div>
                            </div>
                            <input type="file" id="avatarInput" name="avatar" class="file-input" accept="image/*" onchange="previewImage(event)">
                            <div class="form-text">Click on the camera icon to change profile photo</div>
                            
                            <% if (avatarPath != null && !avatarPath.isEmpty()) { %>
                                <div class="mt-2">
                                    <button type="button" class="btn btn-sm btn-outline-danger" onclick="confirmRemoveAvatar()">
                                        <i class="fas fa-trash me-1"></i>Remove Photo
                                    </button>
                                </div>
                            <% } %>
                        </div>
                        
                        <div class="mb-3">
                            <label for="editFullName" class="form-label">Full Name</label>
                            <input type="text" class="form-control" id="editFullName" name="firstName" value="<%= displayName %>">
                        </div>
                        <div class="mb-3">
                            <label for="editEmail" class="form-label">Email Address</label>
                            <input type="email" class="form-control" id="editEmail" name="email" value="<%= email %>">
                        </div>
                        <div class="mb-3">
                            <label for="editUsername" class="form-label">Username</label>
                            <input type="text" class="form-control" id="editUsername" name="username" value="<%= username %>" readonly>
                        </div>
                        
                        <!-- Hidden field for remove avatar -->
                        <input type="hidden" id="removeAvatar" name="removeAvatar" value="false">
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Save Changes</button>
                    </div>
                </form>
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
    
    <script>
        function previewImage(event) {
            const file = event.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    const previewImg = document.getElementById('previewImage');
                    const previewIcon = document.getElementById('previewIcon');
                    
                    if (previewImg) {
                        previewImg.src = e.target.result;
                    } else {
                        // Replace icon with image
                        const avatarDiv = document.querySelector('#previewIcon').closest('.profile-avatar');
                        avatarDiv.innerHTML = '<img id="previewImage" src="' + e.target.result + '" alt="Profile Photo">';
                    }
                }
                reader.readAsDataURL(file);
            }
        }
        
        function confirmRemoveAvatar() {
            if (confirm("Are you sure you want to remove your profile photo?")) {
                // Set the hidden field to true
                document.getElementById('removeAvatar').value = 'true';
                // Submit the form
                document.getElementById('editProfileForm').submit();
            }
        }
    </script>
</body>
</html>