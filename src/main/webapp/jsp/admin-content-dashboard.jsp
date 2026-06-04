<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mycompany.sih3.entity.User" %>
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
    
    String successMessage = request.getParameter("success");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Content Management - EcoLearn Admin</title>
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
        
        .feature-card {
            text-align: center;
            padding: 2rem;
            height: 100%;
            transition: transform 0.3s ease;
        }
        
        .feature-card:hover {
            transform: translateY(-5px);
        }
        
        .feature-icon {
            font-size: 3rem;
            color: var(--primary-green);
            margin-bottom: 1rem;
        }
        
        .feature-title {
            font-weight: 600;
            margin-bottom: 0.5rem;
        }
        
        .feature-desc {
            color: #6c757d;
            font-size: 0.9rem;
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
            <div class="nav-item active" onclick="window.location.href='admin-content-dashboard.jsp'">
                <i class="fas fa-book-open me-3"></i>Content Management
            </div>
            <div class="nav-item" onclick="window.location.href='#'">
                <i class="fas fa-chart-line me-3"></i>Platform Analytics
            </div>
            <div class="nav-item" onclick="window.location.href='#'">
                <i class="fas fa-cog me-3"></i>System Settings
            </div>
            <div class="nav-item" onclick="window.location.href='#'">
                <i class="fas fa-database me-3"></i>Backup & Recovery
            </div>
        </div>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1 class="h3 mb-0">Content Management</h1>
        </div>

        <!-- Success Message -->
        <% if (successMessage != null) { %>
            <% if (successMessage.equals("created")) { %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i>Content created successfully!
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } else if (successMessage.equals("updated")) { %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i>Content updated successfully!
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } else if (successMessage.equals("deleted")) { %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i>Content deleted successfully!
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>
        <% } %>

        <!-- Content Stats -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card">
                    <div class="card-body text-center">
                        <i class="fas fa-book feature-icon"></i>
                        <div class="stat-number">126</div>
                        <div>Total Lessons</div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card">
                    <div class="card-body text-center">
                        <i class="fas fa-question-circle feature-icon"></i>
                        <div class="stat-number">84</div>
                        <div>Total Quizzes</div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card">
                    <div class="card-body text-center">
                        <i class="fas fa-video feature-icon"></i>
                        <div class="stat-number">68</div>
                        <div>Video Content</div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card">
                    <div class="card-body text-center">
                        <i class="fas fa-images feature-icon"></i>
                        <div class="stat-number">12</div>
                        <div>Games</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Content Management Options -->
        <div class="row">
            <div class="col-md-4 mb-4">
                <div class="card feature-card">
                    <i class="fas fa-book-open feature-icon"></i>
                    <h5 class="feature-title">Manage Lessons</h5>
                    <p class="feature-desc">Create, edit, and organize educational lessons</p>
                    <button class="btn btn-primary" onclick="window.location.href='admin/content/lessons'">
                        <i class="fas fa-cog me-2"></i>Manage
                    </button>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="card feature-card">
                    <i class="fas fa-question-circle feature-icon"></i>
                    <h5 class="feature-title">Manage Quizzes</h5>
                    <p class="feature-desc">Create and manage quizzes for lessons</p>
                    <button class="btn btn-primary" onclick="window.location.href='admin/content/quizzes'">
                        <i class="fas fa-cog me-2"></i>Manage
                    </button>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="card feature-card">
                    <i class="fas fa-gamepad feature-icon"></i>
                    <h5 class="feature-title">Manage Games</h5>
                    <p class="feature-desc">Add and configure educational games</p>
                    <button class="btn btn-primary" onclick="window.location.href='admin/content/games'">
                        <i class="fas fa-cog me-2"></i>Manage
                    </button>
                </div>
            </div>
        </div>

        <!-- Recent Content -->
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0">Recent Content</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Title</th>
                                <th>Type</th>
                                <th>Author</th>
                                <th>Date</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>Renewable Energy Sources</td>
                                <td>Lesson</td>
                                <td>Teacher Smith</td>
                                <td>2025-11-20</td>
                                <td><span class="badge bg-success">Published</span></td>
                                <td>
                                    <button class="btn btn-sm btn-outline-primary">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button class="btn btn-sm btn-outline-danger">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </td>
                            </tr>
                            <tr>
                                <td>Biodiversity Quiz</td>
                                <td>Quiz</td>
                                <td>Teacher Johnson</td>
                                <td>2025-11-19</td>
                                <td><span class="badge bg-warning">Draft</span></td>
                                <td>
                                    <button class="btn btn-sm btn-outline-primary">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button class="btn btn-sm btn-outline-danger">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </td>
                            </tr>
                            <tr>
                                <td>Ocean Conservation Game</td>
                                <td>Game</td>
                                <td>Admin Team</td>
                                <td>2025-11-18</td>
                                <td><span class="badge bg-success">Published</span></td>
                                <td>
                                    <button class="btn btn-sm btn-outline-primary">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button class="btn btn-sm btn-outline-danger">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript Libraries -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>