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
    <title>Student Progress - EcoLearn Platform</title>
    
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
        
        .student-progress {
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
        
        .section-card {
            background: white;
            border-radius: var(--border-radius-lg);
            box-shadow: var(--shadow-md);
            padding: var(--spacing-lg);
            margin-bottom: var(--spacing-lg);
            animation: fadeIn 0.6s ease-out;
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
            box-shadow: 0 5px 15px rgba(45, 143, 68, 0.4);
        }
        
        .progress-table th {
            background-color: var(--primary-green);
            color: white;
        }
        
        .progress-bar-container {
            height: 10px;
            background-color: #e9ecef;
            border-radius: 5px;
            overflow: hidden;
        }
        
        .progress-bar-fill {
            height: 100%;
            background: linear-gradient(90deg, var(--primary-green), var(--secondary-teal));
            border-radius: 5px;
        }
        
        .student-search {
            max-width: 300px;
            margin-bottom: 1rem;
            border-radius: var(--border-radius-lg);
        }
        
        .class-filter {
            max-width: 200px;
            margin-bottom: 1rem;
            border-radius: var(--border-radius-lg);
        }
        
        .overall-stats {
            display: flex;
            gap: 1rem;
            margin-bottom: 1rem;
        }
        
        .stat-card {
            flex: 1;
            background: linear-gradient(135deg, #3498db, #2c3e50);
            color: white;
            padding: 1rem;
            border-radius: var(--border-radius-lg);
            text-align: center;
            transition: transform 0.3s ease;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
        }
        
        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            margin: 0.5rem 0;
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
<body class="student-progress">
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
                    <div class="nav-item active" onclick="window.location.href='student-progress.jsp'">
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
                                    <i class="fas fa-chart-line me-2"></i>Student Progress
                                </h1>
                                <p class="page-subtitle">
                                    Track and analyze your students' learning progress
                                </p>
                            </div>
                            <div class="col-lg-4 text-end">
                                <div class="d-flex justify-content-end gap-2">
                                    <input type="text" class="form-control student-search" placeholder="Search students...">
                                    <select class="form-select class-filter">
                                        <option selected>All Classes</option>
                                        <option>Grade 5</option>
                                        <option>Grade 6</option>
                                        <option>Grade 7</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Overall Stats -->
                    <div class="overall-stats">
                        <div class="stat-card">
                            <div>Total Students</div>
                            <div class="stat-number">42</div>
                            <div>In Your Classes</div>
                        </div>
                        <div class="stat-card">
                            <div>Avg. Completion</div>
                            <div class="stat-number">72%</div>
                            <div>Lessons Completed</div>
                        </div>
                        <div class="stat-card">
                            <div>Avg. Quiz Score</div>
                            <div class="stat-number">81%</div>
                            <div>Across All Quizzes</div>
                        </div>
                    </div>

                    <!-- Progress Section -->
                    <div class="section-card">
                        <h2 class="section-title">Student Progress Overview</h2>
                        
                        <div class="table-responsive">
                            <table class="table table-striped progress-table">
                                <thead>
                                    <tr>
                                        <th>Student Name</th>
                                        <th>Class</th>
                                        <th>Lessons Completed</th>
                                        <th>Quiz Average</th>
                                        <th>Points Earned</th>
                                        <th>Last Active</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>Priya Sharma</td>
                                        <td>Grade 6</td>
                                        <td>
                                            <div class="progress-bar-container">
                                                <div class="progress-bar-fill" style="width: 85%"></div>
                                            </div>
                                            <small>17/20 lessons</small>
                                        </td>
                                        <td>88%</td>
                                        <td>1,250</td>
                                        <td>Today</td>
                                    </tr>
                                    <tr>
                                        <td>Rahul Verma</td>
                                        <td>Grade 6</td>
                                        <td>
                                            <div class="progress-bar-container">
                                                <div class="progress-bar-fill" style="width: 70%"></div>
                                            </div>
                                            <small>14/20 lessons</small>
                                        </td>
                                        <td>76%</td>
                                        <td>980</td>
                                        <td>Yesterday</td>
                                    </tr>
                                    <tr>
                                        <td>Ananya Patel</td>
                                        <td>Grade 5</td>
                                        <td>
                                            <div class="progress-bar-container">
                                                <div class="progress-bar-fill" style="width: 95%"></div>
                                            </div>
                                            <small>19/20 lessons</small>
                                        </td>
                                        <td>92%</td>
                                        <td>1,420</td>
                                        <td>Today</td>
                                    </tr>
                                    <tr>
                                        <td>Amit Gupta</td>
                                        <td>Grade 7</td>
                                        <td>
                                            <div class="progress-bar-container">
                                                <div class="progress-bar-fill" style="width: 60%"></div>
                                            </div>
                                            <small>12/20 lessons</small>
                                        </td>
                                        <td>68%</td>
                                        <td>820</td>
                                        <td>2 days ago</td>
                                    </tr>
                                    <tr>
                                        <td>Sneha Reddy</td>
                                        <td>Grade 5</td>
                                        <td>
                                            <div class="progress-bar-container">
                                                <div class="progress-bar-fill" style="width: 80%"></div>
                                            </div>
                                            <small>16/20 lessons</small>
                                        </td>
                                        <td>85%</td>
                                        <td>1,180</td>
                                        <td>Today</td>
                                    </tr>
                                </tbody>
                            </table>
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