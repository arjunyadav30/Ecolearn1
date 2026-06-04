<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mycompany.sih3.entity.User" %>
<%@ page import="com.mycompany.sih3.repository.UserRepository" %>
<%@ page import="java.util.List" %>
<%
    // Include admin authentication check
    // Note: In a real implementation, this would be included as a separate file
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    User currentUser = (User) session.getAttribute("user");
    if (!"Admin".equals(currentUser.getUserType().toString())) {
        response.sendError(HttpServletResponse.SC_FORBIDDEN);
        return;
    }
    
    // Get all users for user management
    UserRepository userRepository = new UserRepository();
    List<User> allUsers = userRepository.findAll();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - EcoLearn Platform</title>
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
            background-color: #f5f7fa;
            margin: 0;
            padding-top: 70px;
        }
        
        .navbar {
            background: linear-gradient(135deg, var(--primary-green), #1e6b30);
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .sidebar {
            background: white;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.05);
            height: calc(100vh - 70px);
            position: fixed;
            top: 70px;
            left: 0;
            width: 250px;
            overflow-y: auto;
            z-index: 1000;
        }
        
        .main-content {
            margin-left: 250px;
            padding: 2rem;
        }
        
        .nav-item {
            padding: 0.75rem 1.5rem;
            cursor: pointer;
            transition: all 0.3s ease;
            border-left: 3px solid transparent;
        }
        
        .nav-item:hover {
            background-color: rgba(45, 143, 68, 0.1);
            border-left: 3px solid var(--primary-green);
        }
        
        .nav-item.active {
            background-color: rgba(45, 143, 68, 0.15);
            border-left: 3px solid var(--primary-green);
            color: var(--primary-green);
            font-weight: 500;
        }
        
        .card {
            border-radius: var(--border-radius-lg);
            box-shadow: var(--shadow-md);
            border: none;
            margin-bottom: 1.5rem;
            transition: transform 0.3s ease;
        }
        
        .card:hover {
            transform: translateY(-5px);
        }
        
        .stat-card {
            text-align: center;
            padding: 1.5rem;
        }
        
        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            color: var(--primary-green);
            margin: 0.5rem 0;
        }
        
        .section-title {
            color: var(--dark-gray);
            font-weight: 600;
            margin-bottom: 1.5rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid var(--primary-green);
        }
        
        .user-table th {
            background-color: var(--primary-green);
            color: white;
        }
        
        .action-btn {
            margin: 0 0.25rem;
        }
        
        .feature-icon {
            font-size: 2rem;
            color: var(--primary-green);
            margin-bottom: 1rem;
        }
        
        .feature-card {
            text-align: center;
            padding: 2rem 1rem;
            height: 100%;
        }
        
        .feature-title {
            font-weight: 600;
            margin-bottom: 0.5rem;
        }
        
        .feature-desc {
            color: #6c757d;
            font-size: 0.9rem;
        }
        
        .chart-container {
            height: 300px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .chart-placeholder {
            text-align: center;
            color: #6c757d;
        }
        
        .chart-placeholder i {
            font-size: 3rem;
            margin-bottom: 1rem;
            color: #ced4da;
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark fixed-top">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">
                <i class="fas fa-leaf me-2"></i>EcoLearn Admin
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle d-flex align-items-center" href="#" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-user-circle fa-lg me-2"></i>
                            <span><%= currentUser.getFullName() != null ? currentUser.getFullName() : currentUser.getUsername() %></span>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item" href="#"><i class="fas fa-user me-2"></i>Profile</a></li>
                            <li><a class="dropdown-item" href="#"><i class="fas fa-cog me-2"></i>Settings</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="logout.jsp"><i class="fas fa-sign-out-alt me-2"></i>Logout</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Sidebar -->
    <div class="sidebar">
        <div class="nav flex-column">
            <div class="nav-item active" onclick="showSection('dashboard')">
                <i class="fas fa-tachometer-alt me-3"></i>Dashboard
            </div>
            <div class="nav-item" onclick="showSection('users')">
                <i class="fas fa-users me-3"></i>User Management
            </div>
            <div class="nav-item" onclick="showSection('content')">
                <i class="fas fa-book-open me-3"></i>Content Management
            </div>
            <div class="nav-item" onclick="window.location.href='../admin/analytics'">
                <i class="fas fa-chart-line me-3"></i>Platform Analytics
            </div>
            <div class="nav-item" onclick="showSection('settings')">
                <i class="fas fa-cog me-3"></i>System Settings
            </div>
            <div class="nav-item" onclick="window.location.href='../admin/backup'">
                <i class="fas fa-database me-3"></i>Backup & Recovery
            </div>
        </div>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <!-- Dashboard Section -->
        <div id="dashboard-section">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h1 class="h3 mb-0">Admin Dashboard</h1>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item"><a href="#">Home</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Dashboard</li>
                    </ol>
                </nav>
            </div>

            <!-- Stats Cards -->
            <div class="row">
                <div class="col-md-3">
                    <div class="card stat-card">
                        <i class="fas fa-users feature-icon"></i>
                        <div>Total Users</div>
                        <div class="stat-number">1,248</div>
                        <div class="text-success"><i class="fas fa-arrow-up me-1"></i>12% from last month</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card stat-card">
                        <i class="fas fa-graduation-cap feature-icon"></i>
                        <div>Active Students</div>
                        <div class="stat-number">892</div>
                        <div class="text-success"><i class="fas fa-arrow-up me-1"></i>8% from last month</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card stat-card">
                        <i class="fas fa-chalkboard-teacher feature-icon"></i>
                        <div>Active Teachers</div>
                        <div class="stat-number">42</div>
                        <div class="text-danger"><i class="fas fa-arrow-down me-1"></i>2% from last month</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card stat-card">
                        <i class="fas fa-chart-bar feature-icon"></i>
                        <div>Avg. Engagement</div>
                        <div class="stat-number">78%</div>
                        <div class="text-success"><i class="fas fa-arrow-up me-1"></i>5% from last month</div>
                    </div>
                </div>
            </div>

            <!-- Charts Row -->
            <div class="row">
                <div class="col-md-8">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">User Growth</h5>
                        </div>
                        <div class="card-body">
                            <div class="chart-container">
                                <div class="chart-placeholder">
                                    <i class="fas fa-chart-line"></i>
                                    <p>User Growth Chart</p>
                                    <small class="text-muted">Visualization of user registration over time</small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">User Distribution</h5>
                        </div>
                        <div class="card-body">
                            <div class="chart-container">
                                <div class="chart-placeholder">
                                    <i class="fas fa-chart-pie"></i>
                                    <p>User Type Distribution</p>
                                    <small class="text-muted">Students, Teachers, Admins</small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Recent Activity -->
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">Recent Activity</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>User</th>
                                    <th>Action</th>
                                    <th>Resource</th>
                                    <th>Time</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>John Smith</td>
                                    <td>Created</td>
                                    <td>New Lesson: "Climate Change"</td>
                                    <td>2 hours ago</td>
                                </tr>
                                <tr>
                                    <td>Sarah Johnson</td>
                                    <td>Completed</td>
                                    <td>Quiz: "Biodiversity"</td>
                                    <td>4 hours ago</td>
                                </tr>
                                <tr>
                                    <td>Michael Brown</td>
                                    <td>Uploaded</td>
                                    <td>Video: "Renewable Energy"</td>
                                    <td>1 day ago</td>
                                </tr>
                                <tr>
                                    <td>Emily Davis</td>
                                    <td>Updated</td>
                                    <td>Profile Information</td>
                                    <td>2 days ago</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- User Management Section -->
        <div id="users-section" style="display: none;">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h1 class="h3 mb-0">User Management</h1>
                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addUserModal">
                    <i class="fas fa-plus me-2"></i>Add New User
                </button>
            </div>

            <!-- User Filters -->
            <div class="card mb-4">
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="form-label">User Type</label>
                            <select class="form-select">
                                <option>All Users</option>
                                <option>Students</option>
                                <option>Teachers</option>
                                <option>Admins</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Status</label>
                            <select class="form-select">
                                <option>All Statuses</option>
                                <option>Active</option>
                                <option>Inactive</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Search</label>
                            <input type="text" class="form-control" placeholder="Search by name, email, or username">
                        </div>
                        <div class="col-md-2 d-flex align-items-end">
                            <button class="btn btn-outline-secondary w-100">
                                <i class="fas fa-filter me-1"></i>Filter
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Users Table -->
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">All Users</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-striped user-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th>Username</th>
                                    <th>Email</th>
                                    <th>Role</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (User user : allUsers) { %>
                                <tr>
                                    <td><%= user.getId() %></td>
                                    <td><%= user.getFullName() != null ? user.getFullName() : "N/A" %></td>
                                    <td><%= user.getUsername() %></td>
                                    <td><%= user.getEmail() %></td>
                                    <td>
                                        <span class="badge bg-<%= "Admin".equals(user.getUserType().toString()) ? "danger" : 
                                            "Teacher".equals(user.getUserType().toString()) ? "success" : "primary" %>">
                                            <%= user.getUserType().toString() %>
                                        </span>
                                    </td>
                                    <td><span class="badge bg-success">Active</span></td>
                                    <td>
                                        <button class="btn btn-sm btn-outline-primary action-btn" title="Edit">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <button class="btn btn-sm btn-outline-info action-btn" title="View">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                        <button class="btn btn-sm btn-outline-danger action-btn" title="Delete">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Content Management Section -->
        <div id="content-section" style="display: none;">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h1 class="h3 mb-0">Content Management</h1>
                <div>
                    <button class="btn btn-success me-2">
                        <i class="fas fa-plus me-2"></i>Add New Lesson
                    </button>
                    <button class="btn btn-primary">
                        <i class="fas fa-plus me-2"></i>Add New Quiz
                    </button>
                </div>
            </div>

            <!-- Content Stats -->
            <div class="row mb-4">
                <div class="col-md-3">
                    <div class="card stat-card">
                        <i class="fas fa-book feature-icon"></i>
                        <div>Total Lessons</div>
                        <div class="stat-number">126</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card stat-card">
                        <i class="fas fa-question-circle feature-icon"></i>
                        <div>Total Quizzes</div>
                        <div class="stat-number">84</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card stat-card">
                        <i class="fas fa-video feature-icon"></i>
                        <div>Video Content</div>
                        <div class="stat-number">68</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card stat-card">
                        <i class="fas fa-images feature-icon"></i>
                        <div>Games</div>
                        <div class="stat-number">12</div>
                    </div>
                </div>
            </div>

            <!-- Content Categories -->
            <div class="row">
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">Lessons by Category</h5>
                        </div>
                        <div class="card-body">
                            <div class="chart-container">
                                <div class="chart-placeholder">
                                    <i class="fas fa-chart-bar"></i>
                                    <p>Lessons Distribution</p>
                                    <small class="text-muted">By subject category</small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">Recent Content</h5>
                        </div>
                        <div class="card-body">
                            <ul class="list-group list-group-flush">
                                <li class="list-group-item">
                                    <div class="d-flex justify-content-between">
                                        <div>
                                            <h6 class="mb-1">Renewable Energy Sources</h6>
                                            <small class="text-muted">New lesson added by Teacher Smith</small>
                                        </div>
                                        <span class="badge bg-success">Published</span>
                                    </div>
                                </li>
                                <li class="list-group-item">
                                    <div class="d-flex justify-content-between">
                                        <div>
                                            <h6 class="mb-1">Biodiversity Quiz</h6>
                                            <small class="text-muted">New quiz added by Teacher Johnson</small>
                                        </div>
                                        <span class="badge bg-warning">Draft</span>
                                    </div>
                                </li>
                                <li class="list-group-item">
                                    <div class="d-flex justify-content-between">
                                        <div>
                                            <h6 class="mb-1">Ocean Conservation Game</h6>
                                            <small class="text-muted">New game added to platform</small>
                                        </div>
                                        <span class="badge bg-success">Published</span>
                                    </div>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Platform Analytics Section -->
        <div id="analytics-section" style="display: none;">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h1 class="h3 mb-0">Platform Analytics</h1>
                <div>
                    <button class="btn btn-primary" onclick="window.location.href='admin/analytics'">
                        <i class="fas fa-chart-line me-2"></i>View Detailed Analytics
                    </button>
                </div>
            </div>

            <!-- Analytics Cards -->
            <div class="row mb-4">
                <div class="col-md-3">
                    <div class="card stat-card">
                        <i class="fas fa-user-graduate feature-icon"></i>
                        <div>Active Users</div>
                        <div class="stat-number">1,842</div>
                        <div class="text-success"><i class="fas fa-arrow-up me-1"></i>15% increase</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card stat-card">
                        <i class="fas fa-book-open feature-icon"></i>
                        <div>Lessons Completed</div>
                        <div class="stat-number">5,287</div>
                        <div class="text-success"><i class="fas fa-arrow-up me-1"></i>22% increase</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card stat-card">
                        <i class="fas fa-gamepad feature-icon"></i>
                        <div>Games Played</div>
                        <div class="stat-number">3,156</div>
                        <div class="text-success"><i class="fas fa-arrow-up me-1"></i>18% increase</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card stat-card">
                        <i class="fas fa-clock feature-icon"></i>
                        <div>Avg. Session Time</div>
                        <div class="stat-number">24m</div>
                        <div class="text-success"><i class="fas fa-arrow-up me-1"></i>3m increase</div>
                    </div>
                </div>
            </div>

            <!-- Charts -->
            <div class="row">
                <div class="col-md-8">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">User Activity Over Time</h5>
                        </div>
                        <div class="card-body">
                            <div class="chart-container">
                                <div class="chart-placeholder">
                                    <i class="fas fa-chart-area"></i>
                                    <p>User Activity Chart</p>
                                    <small class="text-muted">Daily active users over the selected period</small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">Popular Content</h5>
                        </div>
                        <div class="card-body">
                            <div class="chart-container">
                                <div class="chart-placeholder">
                                    <i class="fas fa-chart-bar"></i>
                                    <p>Top Lessons</p>
                                    <small class="text-muted">Most accessed educational content</small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- System Settings Section -->
        <div id="settings-section" style="display: none;">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h1 class="h3 mb-0">System Settings</h1>
                <button class="btn btn-success">
                    <i class="fas fa-save me-2"></i>Save Changes
                </button>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">General Settings</h5>
                        </div>
                        <div class="card-body">
                            <div class="mb-3">
                                <label class="form-label">Platform Name</label>
                                <input type="text" class="form-control" value="EcoLearn Platform">
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Contact Email</label>
                                <input type="email" class="form-control" value="admin@ecolearn.com">
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Timezone</label>
                                <select class="form-select">
                                    <option>UTC</option>
                                    <option selected>IST (UTC+5:30)</option>
                                    <option>EST (UTC-5)</option>
                                    <option>PST (UTC-8)</option>
                                </select>
                            </div>
                            <div class="form-check form-switch mb-3">
                                <input class="form-check-input" type="checkbox" id="maintenanceMode" checked>
                                <label class="form-check-label" for="maintenanceMode">Maintenance Mode</label>
                            </div>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">Security Settings</h5>
                        </div>
                        <div class="card-body">
                            <div class="mb-3">
                                <label class="form-label">Password Minimum Length</label>
                                <input type="number" class="form-control" value="8">
                            </div>
                            <div class="form-check form-switch mb-3">
                                <input class="form-check-input" type="checkbox" id="twoFactorAuth">
                                <label class="form-check-label" for="twoFactorAuth">Require Two-Factor Authentication</label>
                            </div>
                            <div class="form-check form-switch mb-3">
                                <input class="form-check-input" type="checkbox" id="sessionTimeout" checked>
                                <label class="form-check-label" for="sessionTimeout">Session Timeout</label>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">Email Settings</h5>
                        </div>
                        <div class="card-body">
                            <div class="mb-3">
                                <label class="form-label">SMTP Host</label>
                                <input type="text" class="form-control" value="smtp.ecolearn.com">
                            </div>
                            <div class="mb-3">
                                <label class="form-label">SMTP Port</label>
                                <input type="number" class="form-control" value="587">
                            </div>
                            <div class="mb-3">
                                <label class="form-label">SMTP Username</label>
                                <input type="text" class="form-control" value="admin@ecolearn.com">
                            </div>
                            <div class="mb-3">
                                <label class="form-label">SMTP Password</label>
                                <input type="password" class="form-control" value="••••••••">
                            </div>
                            <button class="btn btn-outline-primary">Test Email Configuration</button>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">Notification Settings</h5>
                        </div>
                        <div class="card-body">
                            <div class="form-check mb-3">
                                <input class="form-check-input" type="checkbox" id="emailNotifications" checked>
                                <label class="form-check-label" for="emailNotifications">Email Notifications</label>
                            </div>
                            <div class="form-check mb-3">
                                <input class="form-check-input" type="checkbox" id="systemAlerts" checked>
                                <label class="form-check-label" for="systemAlerts">System Alerts</label>
                            </div>
                            <div class="form-check mb-3">
                                <input class="form-check-input" type="checkbox" id="userActivity" checked>
                                <label class="form-check-label" for="userActivity">User Activity Reports</label>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Backup & Recovery Section -->
        <div id="backup-section" style="display: none;">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h1 class="h3 mb-0">Backup & Recovery</h1>
                <button class="btn btn-primary" onclick="window.location.href='admin/backup'">
                    <i class="fas fa-database me-2"></i>Manage Backups
                </button>
            </div>

            <div class="row">
                <div class="col-md-8">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">Backup History</h5>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>Backup Name</th>
                                            <th>Date</th>
                                            <th>Size</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>ecolearn_backup_20251120.sql</td>
                                            <td>Nov 20, 2025, 02:30 AM</td>
                                            <td>125 MB</td>
                                            <td><span class="badge bg-success">Completed</span></td>
                                            <td>
                                                <button class="btn btn-sm btn-outline-primary">Download</button>
                                                <button class="btn btn-sm btn-outline-info">Restore</button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>ecolearn_backup_20251119.sql</td>
                                            <td>Nov 19, 2025, 02:30 AM</td>
                                            <td>124 MB</td>
                                            <td><span class="badge bg-success">Completed</span></td>
                                            <td>
                                                <button class="btn btn-sm btn-outline-primary">Download</button>
                                                <button class="btn btn-sm btn-outline-info">Restore</button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>ecolearn_backup_20251118.sql</td>
                                            <td>Nov 18, 2025, 02:30 AM</td>
                                            <td>123 MB</td>
                                            <td><span class="badge bg-success">Completed</span></td>
                                            <td>
                                                <button class="btn btn-sm btn-outline-primary">Download</button>
                                                <button class="btn btn-sm btn-outline-info">Restore</button>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">Backup Settings</h5>
                        </div>
                        <div class="card-body">
                            <div class="mb-3">
                                <label class="form-label">Backup Frequency</label>
                                <select class="form-select">
                                    <option>Daily</option>
                                    <option selected>Weekly</option>
                                    <option>Monthly</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Retention Period</label>
                                <select class="form-select">
                                    <option>1 Week</option>
                                    <option>1 Month</option>
                                    <option selected>3 Months</option>
                                    <option>1 Year</option>
                                </select>
                            </div>
                            <div class="form-check form-switch mb-3">
                                <input class="form-check-input" type="checkbox" id="autoBackup" checked>
                                <label class="form-check-label" for="autoBackup">Enable Automatic Backups</label>
                            </div>
                            <div class="form-check form-switch mb-3">
                                <input class="form-check-input" type="checkbox" id="cloudBackup">
                                <label class="form-check-label" for="cloudBackup">Cloud Backup</label>
                            </div>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">Storage Information</h5>
                        </div>
                        <div class="card-body">
                            <div class="mb-3">
                                <div class="d-flex justify-content-between">
                                    <span>Database Size</span>
                                    <span>2.4 GB</span>
                                </div>
                                <div class="progress">
                                    <div class="progress-bar" role="progressbar" style="width: 65%"></div>
                                </div>
                            </div>
                            <div class="mb-3">
                                <div class="d-flex justify-content-between">
                                    <span>Backup Storage</span>
                                    <span>1.2 GB</span>
                                </div>
                                <div class="progress">
                                    <div class="progress-bar bg-success" role="progressbar" style="width: 30%"></div>
                                </div>
                            </div>
                            <button class="btn btn-outline-danger w-100">
                                <i class="fas fa-trash-alt me-2"></i>Clean Old Backups
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Add User Modal -->
    <div class="modal fade" id="addUserModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Add New User</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form>
                        <div class="mb-3">
                            <label class="form-label">Full Name</label>
                            <input type="text" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Username</label>
                            <input type="text" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Email</label>
                            <input type="email" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Password</label>
                            <input type="password" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">User Role</label>
                            <select class="form-select">
                                <option>Student</option>
                                <option>Teacher</option>
                                <option>Admin</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">School</label>
                            <select class="form-select">
                                <option>Punjab School 1</option>
                                <option>Punjab School 2</option>
                                <option>Other</option>
                            </select>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary">Create User</button>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript Libraries -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom JavaScript -->
    <script>
        // Function to show/hide sections
        function showSection(sectionName) {
            // Hide all sections
            document.getElementById('dashboard-section').style.display = 'none';
            document.getElementById('users-section').style.display = 'none';
            document.getElementById('content-section').style.display = 'none';
            document.getElementById('analytics-section').style.display = 'none';
            document.getElementById('settings-section').style.display = 'none';
            document.getElementById('backup-section').style.display = 'none';
            
            // Show selected section
            document.getElementById(sectionName + '-section').style.display = 'block';
            
            // Update active nav item
            const navItems = document.querySelectorAll('.nav-item');
            navItems.forEach(item => {
                item.classList.remove('active');
            });
            event.currentTarget.classList.add('active');
        }
        
        // Initialize dashboard as active section
        document.addEventListener('DOMContentLoaded', function() {
            // Set dashboard as active by default
            document.querySelector('.nav-item').classList.add('active');
        });
    </script>
</body>
</html>