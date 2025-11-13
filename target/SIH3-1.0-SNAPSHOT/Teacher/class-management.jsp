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
    <title>Class Management - EcoLearn Platform</title>
    
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
        
        .class-management-page {
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
        
        .card {
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
        
        .class-card {
            border: 1px solid #e9ecef;
            border-radius: var(--border-radius-lg);
            padding: 1.5rem;
            margin-bottom: 1rem;
            transition: all 0.3s ease;
        }
        
        .class-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        
        .class-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }
        
        .class-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--dark-gray);
            margin: 0;
        }
        
        .class-code {
            background: rgba(45, 143, 68, 0.1);
            color: var(--primary-green);
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 500;
        }
        
        .class-details {
            display: flex;
            gap: 1.5rem;
            margin-bottom: 1rem;
        }
        
        .class-detail-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .class-detail-item i {
            color: var(--primary-green);
        }
        
        .btn-primary {
            background: linear-gradient(135deg, var(--primary-green), var(--secondary-teal));
            border: none;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(45, 143, 68, 0.4);
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body class="class-management-page">
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
                    <div class="nav-item active" onclick="window.location.href='class-management.jsp'">
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
                                    <i class="fas fa-users-class me-2"></i>Class Management
                                </h1>
                                <p class="page-subtitle">
                                    Manage your classes and student enrollments
                                </p>
                            </div>
                            <div class="col-lg-4 text-end">
                                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#createClassModal">
                                    <i class="fas fa-plus me-2"></i>Create New Class
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Classes List -->
                    <div class="card">
                        <div class="card-header">
                            <h5><i class="fas fa-list me-2"></i>Your Classes</h5>
                        </div>
                        <div class="card-body">
                            <div class="class-card">
                                <div class="class-header">
                                    <h3 class="class-title">Grade 6 Environmental Science</h3>
                                    <span class="class-code">ENV6A</span>
                                </div>
                                <div class="class-details">
                                    <div class="class-detail-item">
                                        <i class="fas fa-users"></i>
                                        <span>24 Students</span>
                                    </div>
                                    <div class="class-detail-item">
                                        <i class="fas fa-book"></i>
                                        <span>12 Lessons</span>
                                    </div>
                                    <div class="class-detail-item">
                                        <i class="fas fa-question-circle"></i>
                                        <span>8 Quizzes</span>
                                    </div>
                                </div>
                                <div class="d-flex justify-content-end gap-2">
                                    <button class="btn btn-outline-primary">
                                        <i class="fas fa-eye me-2"></i>View Class
                                    </button>
                                    <button class="btn btn-primary">
                                        <i class="fas fa-edit me-2"></i>Manage
                                    </button>
                                </div>
                            </div>
                            
                            <div class="class-card">
                                <div class="class-header">
                                    <h3 class="class-title">Grade 7 Climate Change</h3>
                                    <span class="class-code">CC7B</span>
                                </div>
                                <div class="class-details">
                                    <div class="class-detail-item">
                                        <i class="fas fa-users"></i>
                                        <span>18 Students</span>
                                    </div>
                                    <div class="class-detail-item">
                                        <i class="fas fa-book"></i>
                                        <span>9 Lessons</span>
                                    </div>
                                    <div class="class-detail-item">
                                        <i class="fas fa-question-circle"></i>
                                        <span>6 Quizzes</span>
                                    </div>
                                </div>
                                <div class="d-flex justify-content-end gap-2">
                                    <button class="btn btn-outline-primary">
                                        <i class="fas fa-eye me-2"></i>View Class
                                    </button>
                                    <button class="btn btn-primary">
                                        <i class="fas fa-edit me-2"></i>Manage
                                    </button>
                                </div>
                            </div>
                            
                            <div class="class-card">
                                <div class="class-header">
                                    <h3 class="class-title">Grade 8 Renewable Energy</h3>
                                    <span class="class-code">RE8C</span>
                                </div>
                                <div class="class-details">
                                    <div class="class-detail-item">
                                        <i class="fas fa-users"></i>
                                        <span>21 Students</span>
                                    </div>
                                    <div class="class-detail-item">
                                        <i class="fas fa-book"></i>
                                        <span>15 Lessons</span>
                                    </div>
                                    <div class="class-detail-item">
                                        <i class="fas fa-question-circle"></i>
                                        <span>10 Quizzes</span>
                                    </div>
                                </div>
                                <div class="d-flex justify-content-end gap-2">
                                    <button class="btn btn-outline-primary">
                                        <i class="fas fa-eye me-2"></i>View Class
                                    </button>
                                    <button class="btn btn-primary">
                                        <i class="fas fa-edit me-2"></i>Manage
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Create Class Modal -->
    <div class="modal fade" id="createClassModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Create New Class</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form>
                        <div class="mb-3">
                            <label for="className" class="form-label">Class Name</label>
                            <input type="text" class="form-control" id="className" placeholder="Enter class name">
                        </div>
                        <div class="mb-3">
                            <label for="classDescription" class="form-label">Description</label>
                            <textarea class="form-control" id="classDescription" rows="3" placeholder="Enter class description"></textarea>
                        </div>
                        <div class="mb-3">
                            <label for="classGrade" class="form-label">Grade Level</label>
                            <select class="form-select" id="classGrade">
                                <option selected>Select grade level</option>
                                <option value="6">Grade 6</option>
                                <option value="7">Grade 7</option>
                                <option value="8">Grade 8</option>
                                <option value="9">Grade 9</option>
                                <option value="10">Grade 10</option>
                                <option value="11">Grade 11</option>
                                <option value="12">Grade 12</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="classSubject" class="form-label">Subject</label>
                            <input type="text" class="form-control" id="classSubject" placeholder="Enter subject">
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary">Create Class</button>
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