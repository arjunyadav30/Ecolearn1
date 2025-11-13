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
    <title>Settings - EcoLearn Platform</title>
    
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
        
        .settings-page {
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
        
        .section-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--dark-gray);
            margin-bottom: var(--spacing-md);
            padding-bottom: 0.5rem;
            border-bottom: 2px solid var(--primary-green);
        }
        
        .form-group {
            margin-bottom: 1.5rem;
        }
        
        .form-label {
            font-weight: 500;
            color: var(--dark-gray);
            margin-bottom: 0.5rem;
        }
        
        .form-check {
            margin-bottom: 1rem;
        }
        
        .form-check-label {
            color: var(--dark-gray);
        }
        
        .btn-primary {
            background: linear-gradient(135deg, var(--primary-green), var(--secondary-teal));
            border: none;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(45, 143, 68, 0.4);
        }
        
        .btn-danger {
            background: linear-gradient(135deg, #e74c3c, #c0392b);
            border: none;
        }
        
        .btn-danger:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(231, 76, 60, 0.4);
        }
        
        .btn-outline-danger {
            border: 2px solid #dc3545;
            color: #dc3545;
        }
        
        .btn-outline-danger:hover {
            background: #dc3545;
            color: white;
        }
        
        .theme-option {
            display: flex;
            align-items: center;
            padding: 1rem;
            border: 1px solid #ddd;
            border-radius: var(--border-radius-lg);
            margin-bottom: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .theme-option:hover {
            border-color: var(--primary-green);
            box-shadow: 0 0 0 3px rgba(45, 143, 68, 0.2);
        }
        
        .theme-option.active {
            border-color: var(--primary-green);
            box-shadow: 0 0 0 3px rgba(45, 143, 68, 0.2);
        }
        
        .theme-preview {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            margin-right: 1rem;
        }
        
        .theme-info h5 {
            margin: 0 0 0.25rem 0;
            font-weight: 600;
        }
        
        .theme-info p {
            margin: 0;
            color: #6c757d;
            font-size: 0.9rem;
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
        
        .alert {
            border-radius: var(--border-radius-lg);
            margin-bottom: var(--spacing-lg);
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
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body class="settings-page">
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
                    <div class="nav-item" onclick="window.location.href='profile.jsp'">
                        <i class="fas fa-user"></i>
                        <span>Profile</span>
                    </div>
                    <div class="nav-item active" onclick="window.location.href='settings.jsp'">
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
                                    <i class="fas fa-cog me-2"></i>Settings
                                </h1>
                                <p class="page-subtitle">
                                    Customize your experience and manage account settings
                                </p>
                            </div>
                        </div>
                    </div>

                    <!-- Account Settings -->
                    <div class="settings-card">
                        <div class="card-header">
                            <h5>Account Settings</h5>
                        </div>
                        <div class="card-body">
                            <form id="accountSettingsForm">
                                <div class="form-group">
                                    <label for="currentPassword" class="form-label">Current Password</label>
                                    <input type="password" class="form-control" id="currentPassword" placeholder="Enter current password">
                                </div>
                                
                                <div class="form-group">
                                    <label for="newPassword" class="form-label">New Password</label>
                                    <input type="password" class="form-control" id="newPassword" placeholder="Enter new password">
                                </div>
                                
                                <div class="form-group">
                                    <label for="confirmPassword" class="form-label">Confirm New Password</label>
                                    <input type="password" class="form-control" id="confirmPassword" placeholder="Confirm new password">
                                </div>
                                
                                <div class="d-flex justify-content-end">
                                    <button type="button" class="btn btn-primary" id="updatePasswordBtn">
                                        <i class="fas fa-save me-2"></i>Update Password
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Notification Settings -->
                    <div class="settings-card">
                        <div class="card-header">
                            <h5>Notification Preferences</h5>
                        </div>
                        <div class="card-body">
                            <div class="alert alert-info">
                                <i class="fas fa-bell me-2"></i>
                                Customize how you receive notifications about your teaching activities.
                            </div>
                            
                            <div class="setting-item">
                                <div>
                                    <h6 class="mb-1">Student Quiz Submissions</h6>
                                    <p class="mb-0 text-muted">Get notified when students submit quizzes</p>
                                </div>
                                <div class="form-check form-switch">
                                    <input class="form-check-input" type="checkbox" id="quizSubmissions" checked>
                                </div>
                            </div>
                            
                            <div class="setting-item">
                                <div>
                                    <h6 class="mb-1">Lesson Progress Updates</h6>
                                    <p class="mb-0 text-muted">Receive updates on student lesson completion</p>
                                </div>
                                <div class="form-check form-switch">
                                    <input class="form-check-input" type="checkbox" id="lessonProgress" checked>
                                </div>
                            </div>
                            
                            <div class="setting-item">
                                <div>
                                    <h6 class="mb-1">New Student Enrollments</h6>
                                    <p class="mb-0 text-muted">Notifications when students join your classes</p>
                                </div>
                                <div class="form-check form-switch">
                                    <input class="form-check-input" type="checkbox" id="studentEnrollments" checked>
                                </div>
                            </div>
                            
                            <div class="setting-item">
                                <div>
                                    <h6 class="mb-1">Platform Announcements</h6>
                                    <p class="mb-0 text-muted">Important updates about EcoLearn platform</p>
                                </div>
                                <div class="form-check form-switch">
                                    <input class="form-check-input" type="checkbox" id="platformAnnouncements" checked>
                                </div>
                            </div>
                            
                            <div class="setting-item">
                                <div>
                                    <h6 class="mb-1">Weekly Progress Reports</h6>
                                    <p class="mb-0 text-muted">Receive weekly summaries of class performance</p>
                                </div>
                                <div class="form-check form-switch">
                                    <input class="form-check-input" type="checkbox" id="weeklyReports">
                                </div>
                            </div>
                            
                            <div class="d-flex justify-content-end mt-3">
                                <button type="button" class="btn btn-primary" id="saveNotificationsBtn">
                                    <i class="fas fa-save me-2"></i>Save Preferences
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Email Communication -->
                    <div class="settings-card">
                        <div class="card-header">
                            <h5>Email Communication</h5>
                        </div>
                        <div class="card-body">
                            <div class="setting-item">
                                <div>
                                    <h6 class="mb-1">Newsletter</h6>
                                    <p class="mb-0 text-muted">Receive educational tips and platform updates</p>
                                </div>
                                <div class="form-check form-switch">
                                    <input class="form-check-input" type="checkbox" id="newsletter" checked>
                                </div>
                            </div>
                            
                            <div class="setting-item">
                                <div>
                                    <h6 class="mb-1">Research Surveys</h6>
                                    <p class="mb-0 text-muted">Participate in educational research surveys</p>
                                </div>
                                <div class="form-check form-switch">
                                    <input class="form-check-input" type="checkbox" id="researchSurveys">
                                </div>
                            </div>
                            
                            <div class="setting-item">
                                <div>
                                    <h6 class="mb-1">Marketing Emails</h6>
                                    <p class="mb-0 text-muted">Information about new features and promotions</p>
                                </div>
                                <div class="form-check form-switch">
                                    <input class="form-check-input" type="checkbox" id="marketingEmails">
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Theme Settings -->
                    <div class="settings-card">
                        <div class="card-header">
                            <h5>Theme Preferences</h5>
                        </div>
                        <div class="card-body">
                            <div class="alert alert-info">
                                <i class="fas fa-palette me-2"></i>
                                Choose a theme that best suits your teaching environment.
                            </div>
                            
                            <div class="theme-option active" data-theme="eco-green">
                                <div class="theme-preview" style="background: linear-gradient(135deg, #2d8f44, #20c997);"></div>
                                <div class="theme-info">
                                    <h5>Eco Green</h5>
                                    <p>Default environmental theme with green accents</p>
                                </div>
                            </div>
                            
                            <div class="theme-option" data-theme="ocean-blue">
                                <div class="theme-preview" style="background: linear-gradient(135deg, #3498db, #2c3e50);"></div>
                                <div class="theme-info">
                                    <h5>Ocean Blue</h5>
                                    <p>Calm blue theme inspired by ocean conservation</p>
                                </div>
                            </div>
                            
                            <div class="theme-option" data-theme="purple-haze">
                                <div class="theme-preview" style="background: linear-gradient(135deg, #9b59b6, #8e44ad);"></div>
                                <div class="theme-info">
                                    <h5>Purple Haze</h5>
                                    <p>Creative purple theme for a unique experience</p>
                                </div>
                            </div>
                            
                            <div class="theme-option" data-theme="mixable">
                                <div class="theme-preview" style="background: linear-gradient(135deg, #2d8f44, #3498db, #9b59b6);"></div>
                                <div class="theme-info">
                                    <h5>Mixable</h5>
                                    <p>Combination of all themes for a vibrant look</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Danger Zone -->
                    <div class="settings-card">
                        <div class="card-header">
                            <h5>Danger Zone</h5>
                        </div>
                        <div class="card-body">
                            <div class="alert alert-danger">
                                <h5><i class="fas fa-exclamation-triangle me-2"></i>Account Deletion</h5>
                                <p>Deleting your account will permanently remove all your data. This action cannot be undone.</p>
                                <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#deleteAccountModal">
                                    <i class="fas fa-trash me-2"></i>Delete Account
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Delete Account Modal -->
    <div class="modal fade" id="deleteAccountModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Confirm Account Deletion</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="alert alert-warning">
                        <i class="fas fa-exclamation-circle me-2"></i>
                        <strong>Warning:</strong> This action is irreversible!
                    </div>
                    <p>Are you sure you want to delete your account? This action is irreversible and will permanently remove:</p>
                    <ul>
                        <li>Your profile information</li>
                        <li>All created lessons and quizzes</li>
                        <li>Student progress data associated with your classes</li>
                        <li>All settings and preferences</li>
                    </ul>
                    <p class="text-danger"><strong>Type "DELETE" to confirm:</strong></p>
                    <input type="text" class="form-control" id="deleteConfirmation" placeholder="Type DELETE to confirm">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-danger" id="confirmDeleteBtn">
                        <i class="fas fa-trash me-2"></i>Delete Account
                    </button>
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
    
    <script>
        // Theme selection
        document.querySelectorAll('.theme-option').forEach(option => {
            option.addEventListener('click', function() {
                document.querySelectorAll('.theme-option').forEach(opt => {
                    opt.classList.remove('active');
                });
                this.classList.add('active');
                
                // In a real application, this would save the theme preference
                const theme = this.getAttribute('data-theme');
                alert('Theme changed to ' + theme.replace('-', ' ') + '. In a real application, this would be saved to your preferences.');
            });
        });
        
        // Password update
        document.getElementById('updatePasswordBtn').addEventListener('click', function() {
            const currentPassword = document.getElementById('currentPassword').value;
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (!currentPassword || !newPassword || !confirmPassword) {
                alert('Please fill in all password fields.');
                return;
            }
            
            if (newPassword !== confirmPassword) {
                alert('New passwords do not match.');
                return;
            }
            
            // In a real application, this would send data to the server
            alert('Password updated successfully!');
            // Reset form
            document.getElementById('accountSettingsForm').reset();
        });
        
        // Save notification preferences
        document.getElementById('saveNotificationsBtn').addEventListener('click', function() {
            // In a real application, this would save the notification preferences
            alert('Notification preferences saved successfully!');
        });
        
        // Account deletion
        document.getElementById('confirmDeleteBtn').addEventListener('click', function() {
            const confirmation = document.getElementById('deleteConfirmation').value;
            if (confirmation !== 'DELETE') {
                alert('Please type "DELETE" to confirm account deletion.');
                return;
            }
            
            // In a real application, this would send a request to delete the account
            alert('Account deletion request submitted. In a real application, your account would be permanently deleted.');
            // Close modal
            bootstrap.Modal.getInstance(document.getElementById('deleteAccountModal')).hide();
            // Reset confirmation field
            document.getElementById('deleteConfirmation').value = '';
        });
    </script>
</body>
</html>