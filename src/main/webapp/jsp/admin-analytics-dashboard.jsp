<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mycompany.sih3.entity.User" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.HashMap" %>
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
    
    Map<String, Object> analyticsData = (Map<String, Object>) request.getAttribute("analyticsData");
    if (analyticsData == null) {
        analyticsData = new HashMap<>();
    }
    
    // Get data from analyticsData or use defaults
    int totalUsers = (Integer) analyticsData.getOrDefault("totalUsers", 0);
    int studentCount = (Integer) analyticsData.getOrDefault("studentCount", 0);
    int teacherCount = (Integer) analyticsData.getOrDefault("teacherCount", 0);
    int adminCount = (Integer) analyticsData.getOrDefault("adminCount", 0);
    int activeUsers = (Integer) analyticsData.getOrDefault("activeUsers", 0);
    int lessonsCompleted = (Integer) analyticsData.getOrDefault("lessonsCompleted", 0);
    int gamesPlayed = (Integer) analyticsData.getOrDefault("gamesPlayed", 0);
    String avgSessionTime = (String) analyticsData.getOrDefault("avgSessionTime", "0m");
    
    List<Map<String, Object>> userGrowthData = (List<Map<String, Object>>) analyticsData.getOrDefault("userGrowthData", new java.util.ArrayList<>());
    List<Map<String, Object>> popularContent = (List<Map<String, Object>>) analyticsData.getOrDefault("popularContent", new java.util.ArrayList<>());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Platform Analytics - EcoLearn Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
        
        .chart-container {
            height: 300px;
            position: relative;
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
            <div class="nav-item active" onclick="window.location.href='../admin/analytics'">
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
            <h1 class="h3 mb-0">Platform Analytics</h1>
            <div>
                <select class="form-select d-inline-block w-auto">
                    <option>Last 7 Days</option>
                    <option selected>Last 30 Days</option>
                    <option>Last 90 Days</option>
                    <option>This Year</option>
                </select>
            </div>
        </div>

        <!-- Analytics Cards -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card stat-card">
                    <i class="fas fa-users feature-icon"></i>
                    <div>Total Users</div>
                    <div class="stat-number"><%= totalUsers %></div>
                    <div class="text-success"><i class="fas fa-arrow-up me-1"></i>12% from last month</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card">
                    <i class="fas fa-graduation-cap feature-icon"></i>
                    <div>Active Students</div>
                    <div class="stat-number"><%= studentCount %></div>
                    <div class="text-success"><i class="fas fa-arrow-up me-1"></i>8% from last month</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card">
                    <i class="fas fa-chalkboard-teacher feature-icon"></i>
                    <div>Active Teachers</div>
                    <div class="stat-number"><%= teacherCount %></div>
                    <div class="text-danger"><i class="fas fa-arrow-down me-1"></i>2% from last month</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card">
                    <i class="fas fa-user-graduate feature-icon"></i>
                    <div>Active Users</div>
                    <div class="stat-number"><%= activeUsers %></div>
                    <div class="text-success"><i class="fas fa-arrow-up me-1"></i>15% increase</div>
                </div>
            </div>
        </div>
        
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card stat-card">
                    <i class="fas fa-book-open feature-icon"></i>
                    <div>Lessons Completed</div>
                    <div class="stat-number"><%= lessonsCompleted %></div>
                    <div class="text-success"><i class="fas fa-arrow-up me-1"></i>22% increase</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card">
                    <i class="fas fa-gamepad feature-icon"></i>
                    <div>Games Played</div>
                    <div class="stat-number"><%= gamesPlayed %></div>
                    <div class="text-success"><i class="fas fa-arrow-up me-1"></i>18% increase</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card">
                    <i class="fas fa-clock feature-icon"></i>
                    <div>Avg. Session Time</div>
                    <div class="stat-number"><%= avgSessionTime %></div>
                    <div class="text-success"><i class="fas fa-arrow-up me-1"></i>3m increase</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card">
                    <i class="fas fa-chart-bar feature-icon"></i>
                    <div>Admin Users</div>
                    <div class="stat-number"><%= adminCount %></div>
                    <div class="text-muted">No change</div>
                </div>
            </div>
        </div>

        <!-- Charts -->
        <div class="row">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">User Growth</h5>
                    </div>
                    <div class="card-body">
                        <div class="chart-container">
                            <canvas id="userGrowthChart"></canvas>
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
                            <canvas id="userDistributionChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row mt-4">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">User Activity Over Time</h5>
                    </div>
                    <div class="card-body">
                        <div class="chart-container">
                            <canvas id="userActivityChart"></canvas>
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
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>Content</th>
                                        <th>Views</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Map<String, Object> content : popularContent) { %>
                                    <tr>
                                        <td><%= content.get("title") %></td>
                                        <td><%= content.get("views") %></td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript Libraries -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Chart.js Scripts -->
    <script>
        // User Growth Chart
        const userGrowthCtx = document.getElementById('userGrowthChart').getContext('2d');
        const userGrowthChart = new Chart(userGrowthCtx, {
            type: 'line',
            data: {
                labels: [<%= 
                    StringBuilder labels = new StringBuilder();
                    for (int i = 0; i < userGrowthData.size(); i++) {
                        Map<String, Object> dataPoint = userGrowthData.get(i);
                        labels.append("\"").append(dataPoint.get("date")).append("\"");
                        if (i < userGrowthData.size() - 1) {
                            labels.append(",");
                        }
                    }
                    out.print(labels.toString());
                %>],
                datasets: [{
                    label: 'User Growth',
                    data: [<%= 
                        StringBuilder values = new StringBuilder();
                        for (int i = 0; i < userGrowthData.size(); i++) {
                            Map<String, Object> dataPoint = userGrowthData.get(i);
                            values.append(dataPoint.get("users"));
                            if (i < userGrowthData.size() - 1) {
                                values.append(",");
                            }
                        }
                        out.print(values.toString());
                    %>],
                    borderColor: '#2d8f44',
                    backgroundColor: 'rgba(45, 143, 68, 0.1)',
                    tension: 0.4,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
        
        // User Distribution Chart
        const userDistributionCtx = document.getElementById('userDistributionChart').getContext('2d');
        const userDistributionChart = new Chart(userDistributionCtx, {
            type: 'pie',
            data: {
                labels: ['Students', 'Teachers', 'Admins'],
                datasets: [{
                    data: [<%= studentCount %>, <%= teacherCount %>, <%= adminCount %>],
                    backgroundColor: [
                        '#20c997',
                        '#3498db',
                        '#dc3545'
                    ]
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false
            }
        });
        
        // User Activity Chart
        const userActivityCtx = document.getElementById('userActivityChart').getContext('2d');
        const userActivityChart = new Chart(userActivityCtx, {
            type: 'bar',
            data: {
                labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                datasets: [{
                    label: 'Active Users',
                    data: [1200, 1900, 1500, 1800, 2200, 2500, 2000],
                    backgroundColor: '#2d8f44'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    </script>
</body>
</html>