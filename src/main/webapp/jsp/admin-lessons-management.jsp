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
    <title>Lessons Management - EcoLearn Admin</title>
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
        
        .table th {
            background-color: var(--primary-green);
            color: white;
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
            <h1 class="h3 mb-0">Lessons Management</h1>
            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addLessonModal">
                <i class="fas fa-plus me-2"></i>Add New Lesson
            </button>
        </div>

        <!-- Success Message -->
        <% if (successMessage != null) { %>
            <% if (successMessage.equals("created")) { %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i>Lesson created successfully!
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } else if (successMessage.equals("updated")) { %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i>Lesson updated successfully!
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } else if (successMessage.equals("deleted")) { %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i>Lesson deleted successfully!
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>
        <% } %>

        <!-- Error Message -->
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i><%= request.getAttribute("errorMessage") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <!-- Lessons Table -->
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0">All Lessons</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Title</th>
                                <th>Category</th>
                                <th>Points</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>1</td>
                                <td>Introduction to Climate Change</td>
                                <td>Environmental Science</td>
                                <td>50</td>
                                <td><span class="badge bg-success">Published</span></td>
                                <td>
                                    <button class="btn btn-sm btn-outline-primary" title="Edit">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button class="btn btn-sm btn-outline-info" title="View">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                    <button class="btn btn-sm btn-outline-danger" title="Delete">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </td>
                            </tr>
                            <tr>
                                <td>2</td>
                                <td>Biodiversity Conservation</td>
                                <td>Biology</td>
                                <td>75</td>
                                <td><span class="badge bg-warning">Draft</span></td>
                                <td>
                                    <button class="btn btn-sm btn-outline-primary" title="Edit">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button class="btn btn-sm btn-outline-info" title="View">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                    <button class="btn btn-sm btn-outline-danger" title="Delete">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </td>
                            </tr>
                            <tr>
                                <td>3</td>
                                <td>Renewable Energy Sources</td>
                                <td>Physics</td>
                                <td>100</td>
                                <td><span class="badge bg-success">Published</span></td>
                                <td>
                                    <button class="btn btn-sm btn-outline-primary" title="Edit">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button class="btn btn-sm btn-outline-info" title="View">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                    <button class="btn btn-sm btn-outline-danger" title="Delete">
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

    <!-- Add Lesson Modal -->
    <div class="modal fade" id="addLessonModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Add New Lesson</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form action="admin/content/lessons/create" method="POST">
                        <div class="mb-3">
                            <label class="form-label">Lesson Title</label>
                            <input type="text" class="form-control" name="title" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Description</label>
                            <textarea class="form-control" name="description" rows="3"></textarea>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Category</label>
                            <select class="form-select" name="category">
                                <option value="">Select Category</option>
                                <option value="Environmental Science">Environmental Science</option>
                                <option value="Biology">Biology</option>
                                <option value="Chemistry">Chemistry</option>
                                <option value="Physics">Physics</option>
                                <option value="Geography">Geography</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Video URL</label>
                            <input type="text" class="form-control" name="videoUrl">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Points</label>
                            <input type="number" class="form-control" name="points" min="0" value="50">
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" onclick="document.querySelector('#addLessonModal form').submit()">Create Lesson</button>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript Libraries -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>