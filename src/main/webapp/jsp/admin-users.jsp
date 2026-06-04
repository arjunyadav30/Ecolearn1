<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mycompany.sih3.entity.User" %>
<%@ page import="java.util.List" %>
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
    
    List<User> users = (List<User>) request.getAttribute("users");
    String successMessage = request.getParameter("success");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management - EcoLearn Admin</title>
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
        
        .badge-admin {
            background-color: #dc3545;
        }
        
        .badge-teacher {
            background-color: #28a745;
        }
        
        .badge-student {
            background-color: #17a2b8;
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
            <div class="nav-item active" onclick="window.location.href='admin-users.jsp'">
                <i class="fas fa-users me-3"></i>User Management
            </div>
            <div class="nav-item" onclick="window.location.href='#'">
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
            <h1 class="h3 mb-0">User Management</h1>
            <button class="btn btn-primary" onclick="window.location.href='admin/users/add'">
                <i class="fas fa-plus me-2"></i>Add New User
            </button>
        </div>

        <!-- Success Message -->
        <% if (successMessage != null) { %>
            <% if (successMessage.equals("created")) { %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i>User created successfully!
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } else if (successMessage.equals("updated")) { %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i>User updated successfully!
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } else if (successMessage.equals("deleted")) { %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i>User deleted successfully!
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } else if (successMessage.equals("bulk_deleted")) { %>
                <% int deletedCount = Integer.parseInt(request.getParameter("deletedCount") != null ? request.getParameter("deletedCount") : "0"); %>
                <% int errorCount = Integer.parseInt(request.getParameter("errorCount") != null ? request.getParameter("errorCount") : "0"); %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i><%= deletedCount %> user(s) deleted successfully!
                    <% if (errorCount > 0) { %>
                        <br><span class="text-warning"><%= errorCount %> operation(s) failed.</span>
                    <% } %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } else if (successMessage.equals("bulk_updated")) { %>
                <% int updatedCount = Integer.parseInt(request.getParameter("updatedCount") != null ? request.getParameter("updatedCount") : "0"); %>
                <% int errorCount = Integer.parseInt(request.getParameter("errorCount") != null ? request.getParameter("errorCount") : "0"); %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i><%= updatedCount %> user(s) updated successfully!
                    <% if (errorCount > 0) { %>
                        <br><span class="text-warning"><%= errorCount %> operation(s) failed.</span>
                    <% } %>
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

        <!-- Bulk Operations Bar -->
        <div class="card mb-3" id="bulkOperationsBar" style="display: none;">
            <div class="card-body">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <span id="selectedCount">0</span> user(s) selected
                    </div>
                    <div>
                        <div class="btn-group">
                            <button type="button" class="btn btn-outline-primary dropdown-toggle" data-bs-toggle="dropdown">
                                <i class="fas fa-user-edit me-1"></i>Change Role
                            </button>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item" href="#" onclick="bulkUpdateRole('Student')">Student</a></li>
                                <li><a class="dropdown-item" href="#" onclick="bulkUpdateRole('Teacher')">Teacher</a></li>
                                <li><a class="dropdown-item" href="#" onclick="bulkUpdateRole('Admin')">Admin</a></li>
                            </ul>
                        </div>
                        <button class="btn btn-outline-danger ms-2" onclick="confirmBulkDelete()">
                            <i class="fas fa-trash-alt me-1"></i>Delete Selected
                        </button>
                        <button class="btn btn-outline-secondary ms-2" onclick="clearSelection()">
                            <i class="fas fa-times me-1"></i>Clear Selection
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
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>
                                    <input type="checkbox" id="selectAllCheckbox" onchange="toggleAllCheckboxes(this)">
                                </th>
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
                            <% if (users != null) { %>
                                <% for (User user : users) { %>
                                <tr>
                                    <td>
                                        <input type="checkbox" class="user-checkbox" 
                                               value="<%= user.getId() %>" 
                                               onchange="updateBulkOperationsBar()">
                                    </td>
                                    <td><%= user.getId() %></td>
                                    <td><%= user.getFullName() != null ? user.getFullName() : "N/A" %></td>
                                    <td><%= user.getUsername() %></td>
                                    <td><%= user.getEmail() %></td>
                                    <td>
                                        <span class="badge 
                                            <%= "Admin".equals(user.getUserType().toString()) ? "bg-danger" : 
                                               "Teacher".equals(user.getUserType().toString()) ? "bg-success" : 
                                               "bg-primary" %>">
                                            <%= user.getUserType().toString() %>
                                        </span>
                                    </td>
                                    <td><span class="badge bg-success">Active</span></td>
                                    <td>
                                        <a href="admin/users/edit?id=<%= user.getId() %>" class="btn btn-sm btn-outline-primary" title="Edit">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <button class="btn btn-sm btn-outline-info" title="View">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                        <button class="btn btn-sm btn-outline-danger" title="Delete" 
                                                onclick="confirmDelete(<%= user.getId() %>, '<%= user.getUsername() %>')">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </td>
                                </tr>
                                <% } %>
                            <% } else { %>
                                <tr>
                                    <td colspan="8" class="text-center">No users found</td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Confirm Delete</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete user <strong id="deleteUserName"></strong>?</p>
                    <p class="text-danger">This action cannot be undone.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-danger" id="confirmDeleteBtn">Delete</button>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript Libraries -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom JavaScript -->
    <script>
        let userIdToDelete = null;
        
        function confirmDelete(userId, username) {
            userIdToDelete = userId;
            document.getElementById('deleteUserName').textContent = username;
            const deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
            deleteModal.show();
        }
        
        document.getElementById('confirmDeleteBtn').addEventListener('click', function() {
            if (userIdToDelete) {
                // Create a form to submit the delete request
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = 'admin/users/delete';
                
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'id';
                input.value = userIdToDelete;
                
                form.appendChild(input);
                document.body.appendChild(form);
                form.submit();
            }
        });
        
        // Bulk operations functions
        function toggleAllCheckboxes(selectAllCheckbox) {
            const checkboxes = document.querySelectorAll('.user-checkbox');
            checkboxes.forEach(checkbox => {
                checkbox.checked = selectAllCheckbox.checked;
            });
            updateBulkOperationsBar();
        }
        
        function updateBulkOperationsBar() {
            const checkboxes = document.querySelectorAll('.user-checkbox:checked');
            const bulkOperationsBar = document.getElementById('bulkOperationsBar');
            const selectedCount = document.getElementById('selectedCount');
            
            if (checkboxes.length > 0) {
                bulkOperationsBar.style.display = 'block';
                selectedCount.textContent = checkboxes.length;
            } else {
                bulkOperationsBar.style.display = 'none';
                selectedCount.textContent = '0';
            }
        }
        
        function clearSelection() {
            const checkboxes = document.querySelectorAll('.user-checkbox');
            const selectAllCheckbox = document.getElementById('selectAllCheckbox');
            
            checkboxes.forEach(checkbox => {
                checkbox.checked = false;
            });
            selectAllCheckbox.checked = false;
            updateBulkOperationsBar();
        }
        
        function confirmBulkDelete() {
            const checkboxes = document.querySelectorAll('.user-checkbox:checked');
            if (checkboxes.length === 0) return;
            
            const confirmMessage = `Are you sure you want to delete ${checkboxes.length} selected user(s)? This action cannot be undone.`;
            if (confirm(confirmMessage)) {
                // Create a form to submit the bulk delete request
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = 'admin/users/bulk-delete';
                
                checkboxes.forEach(checkbox => {
                    const input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = 'userIds';
                    input.value = checkbox.value;
                    form.appendChild(input);
                });
                
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        function bulkUpdateRole(newRole) {
            const checkboxes = document.querySelectorAll('.user-checkbox:checked');
            if (checkboxes.length === 0) return;
            
            const confirmMessage = `Are you sure you want to change the role of ${checkboxes.length} selected user(s) to ${newRole}?`;
            if (confirm(confirmMessage)) {
                // Create a form to submit the bulk update role request
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = 'admin/users/bulk-update-role';
                
                checkboxes.forEach(checkbox => {
                    const input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = 'userIds';
                    input.value = checkbox.value;
                    form.appendChild(input);
                });
                
                const roleInput = document.createElement('input');
                roleInput.type = 'hidden';
                roleInput.name = 'newUserType';
                roleInput.value = newRole;
                form.appendChild(roleInput);
                
                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
</body>
</html>