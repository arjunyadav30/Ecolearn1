<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mycompany.sih3.entity.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.DecimalFormat" %>
<%
    // Include admin authentication check
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    User currentUser = (User) session.getAttribute("user");
    if (!"Admin".equals(currentUser.getUserType().toString())) {
        response.sendError(HttpServletResponse.SC_FORBIDDEN);
        return;
    }
    
    List<Map<String, Object>> backups = (List<Map<String, Object>>) request.getAttribute("backups");
    String backupPath = (String) request.getAttribute("backupPath");
    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");
    
    DecimalFormat df = new DecimalFormat("#,##0.00");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Backup & Recovery - EcoLearn Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-green: #2d8f44;
            --secondary-teal: #20c997;
            --accent-blue: #3498db;
            --light-gray: #f8f9fa;
            --dark-gray: #343a40;
        }
        
        body {
            background-color: #f5f7fa;
            font-family: 'Poppins', sans-serif;
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
            border-radius: 0.75rem;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            border: none;
            margin-bottom: 1.5rem;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, var(--primary-green), #1e6b30);
            border: none;
        }
        
        .btn-primary:hover {
            background: linear-gradient(135deg, #1e6b30, var(--primary-green));
        }
        
        .btn-success {
            background: linear-gradient(135deg, var(--secondary-teal), #198754);
            border: none;
        }
        
        .btn-success:hover {
            background: linear-gradient(135deg, #198754, var(--secondary-teal));
        }
        
        .progress {
            height: 10px;
            border-radius: 5px;
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
            <div class="nav-item" onclick="window.location.href='admin-dashboard.jsp'">
                <i class="fas fa-tachometer-alt me-3"></i>Dashboard
            </div>
            <div class="nav-item" onclick="window.location.href='admin-users.jsp'">
                <i class="fas fa-users me-3"></i>User Management
            </div>
            <div class="nav-item" onclick="window.location.href='admin-content-dashboard.jsp'">
                <i class="fas fa-book-open me-3"></i>Content Management
            </div>
            <div class="nav-item" onclick="window.location.href='../admin/analytics'">
                <i class="fas fa-chart-line me-3"></i>Platform Analytics
            </div>
            <div class="nav-item" onclick="window.location.href='#'">
                <i class="fas fa-cog me-3"></i>System Settings
            </div>
            <div class="nav-item active" onclick="window.location.href='../admin/backup'">
                <i class="fas fa-database me-3"></i>Backup & Recovery
            </div>
        </div>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1 class="h3 mb-0">Backup & Recovery</h1>
            <form action="admin/backup/create" method="POST">
                <button type="submit" class="btn btn-success">
                    <i class="fas fa-download me-2"></i>Create Backup
                </button>
            </form>
        </div>

        <!-- Success Message -->
        <% if (successMessage != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i><%= successMessage %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <!-- Error Message -->
        <% if (errorMessage != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i><%= errorMessage %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="row">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">Backup History</h5>
                    </div>
                    <div class="card-body">
                        <% if (backups != null && !backups.isEmpty()) { %>
                            <div class="table-responsive">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>Backup Name</th>
                                            <th>Date</th>
                                            <th>Size</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (Map<String, Object> backup : backups) { %>
                                        <tr>
                                            <td><%= backup.get("name") %></td>
                                            <td><%= backup.get("date") %></td>
                                            <td><%= df.format(((Long) backup.get("size")) / 1024.0) %> KB</td>
                                            <td>
                                                <form action="admin/backup/restore" method="POST" style="display: inline;">
                                                    <input type="hidden" name="backupFile" value="<%= backup.get("name") %>">
                                                    <button type="submit" class="btn btn-sm btn-outline-info" 
                                                            onclick="return confirm('Are you sure you want to restore this backup? This will overwrite current data.')">
                                                        Restore
                                                    </button>
                                                </form>
                                                <a href="backups/<%= backup.get("name") %>" class="btn btn-sm btn-outline-primary" download>
                                                    Download
                                                </a>
                                            </td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        <% } else { %>
                            <div class="text-center py-5">
                                <i class="fas fa-database fa-3x text-muted mb-3"></i>
                                <p class="text-muted">No backups found. Create your first backup to get started.</p>
                            </div>
                        <% } %>
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

    <!-- JavaScript Libraries -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>