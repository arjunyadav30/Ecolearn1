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
    <title>Manage Quizzes - EcoLearn Platform</title>
    
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
        
        .manage-quizzes {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            padding-top: 76px;
        }
        
        .navbar {
            background: linear-gradient(135deg, #1abc9c, #17a2b8) !important;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
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
        }
        
        .quiz-table th {
            background-color: var(--primary-green);
            color: white;
        }
        
        .action-buttons .btn {
            margin-right: 0.5rem;
        }
        
        .quiz-stats {
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
    </style>
</head>
<body class="manage-quizzes">
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary fixed-top">
        <div class="container-fluid">
            <a class="navbar-brand" href="../index.jsp">
                <i class="fas fa-leaf me-2"></i>EcoLearn
            </a>
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="teacherdashboard.jsp">
                            <i class="fas fa-tachometer-alt me-1"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="manage-lessons.jsp">
                            <i class="fas fa-graduation-cap me-1"></i>Manage Lessons
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="manage-quizzes.jsp">
                            <i class="fas fa-question-circle me-1"></i>Manage Quizzes
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="student-progress.jsp">
                            <i class="fas fa-chart-line me-1"></i>Student Progress
                        </a>
                    </li>
                </ul>
                
                <ul class="navbar-nav">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle d-flex align-items-center" href="#" role="button" data-bs-toggle="dropdown">
                            <div class="user-avatar me-2">
                                <i class="fas fa-user-circle fa-lg"></i>
                            </div>
                            <span class="user-name"><%= displayName %></span>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item" href="profile.jsp"><i class="fas fa-user me-2"></i>Profile</a></li>
                            <li><a class="dropdown-item" href="settings.jsp"><i class="fas fa-cog me-2"></i>Settings</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="../jsp/logout.jsp"><i class="fas fa-sign-out-alt me-2"></i>Logout</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container main-content">
        <!-- Page Header -->
        <div class="page-header">
            <div class="row align-items-center">
                <div class="col-lg-8">
                    <h1 class="page-title">
                        <i class="fas fa-question-circle me-2"></i>Manage Quizzes
                    </h1>
                    <p class="page-subtitle">
                        Create and manage quizzes for your lessons
                    </p>
                </div>
                <div class="col-lg-4 text-end">
                    <button class="btn btn-light" data-bs-toggle="modal" data-bs-target="#createQuizModal">
                        <i class="fas fa-plus me-2"></i>Create New Quiz
                    </button>
                </div>
            </div>
        </div>

        <!-- Quiz Stats -->
        <div class="quiz-stats">
            <div class="stat-card">
                <div>Total Quizzes</div>
                <div class="stat-number">12</div>
                <div>Active</div>
            </div>
            <div class="stat-card">
                <div>Total Questions</div>
                <div class="stat-number">144</div>
                <div>In Database</div>
            </div>
            <div class="stat-card">
                <div>Avg. Score</div>
                <div class="stat-number">78%</div>
                <div>Across Students</div>
            </div>
        </div>

        <!-- Quizzes Section -->
        <div class="section-card">
            <h2 class="section-title">Your Quizzes</h2>
            
            <div class="table-responsive">
                <table class="table table-striped quiz-table">
                    <thead>
                        <tr>
                            <th>Quiz Title</th>
                            <th>Lesson</th>
                            <th>Questions</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>Climate Change Basics</td>
                            <td>Introduction to Climate Change</td>
                            <td>10</td>
                            <td><span class="badge bg-success">Active</span></td>
                            <td class="action-buttons">
                                <button class="btn btn-sm btn-outline-primary">
                                    <i class="fas fa-edit"></i> Edit
                                </button>
                                <button class="btn btn-sm btn-outline-info">
                                    <i class="fas fa-question-circle"></i> Questions
                                </button>
                                <button class="btn btn-sm btn-outline-danger">
                                    <i class="fas fa-trash"></i> Delete
                                </button>
                            </td>
                        </tr>
                        <tr>
                            <td>Biodiversity Quiz</td>
                            <td>Biodiversity Conservation</td>
                            <td>15</td>
                            <td><span class="badge bg-success">Active</span></td>
                            <td class="action-buttons">
                                <button class="btn btn-sm btn-outline-primary">
                                    <i class="fas fa-edit"></i> Edit
                                </button>
                                <button class="btn btn-sm btn-outline-info">
                                    <i class="fas fa-question-circle"></i> Questions
                                </button>
                                <button class="btn btn-sm btn-outline-danger">
                                    <i class="fas fa-trash"></i> Delete
                                </button>
                            </td>
                        </tr>
                        <tr>
                            <td>Renewable Energy Test</td>
                            <td>Renewable Energy Sources</td>
                            <td>12</td>
                            <td><span class="badge bg-warning">Draft</span></td>
                            <td class="action-buttons">
                                <button class="btn btn-sm btn-outline-primary">
                                    <i class="fas fa-edit"></i> Edit
                                </button>
                                <button class="btn btn-sm btn-outline-info">
                                    <i class="fas fa-question-circle"></i> Questions
                                </button>
                                <button class="btn btn-sm btn-outline-danger">
                                    <i class="fas fa-trash"></i> Delete
                                </button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Create Quiz Modal -->
    <div class="modal fade" id="createQuizModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Create New Quiz</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form>
                        <div class="mb-3">
                            <label for="quizTitle" class="form-label">Quiz Title</label>
                            <input type="text" class="form-control" id="quizTitle" placeholder="Enter quiz title">
                        </div>
                        <div class="mb-3">
                            <label for="quizLesson" class="form-label">Associated Lesson</label>
                            <select class="form-select" id="quizLesson">
                                <option selected>Select a lesson</option>
                                <option>Introduction to Climate Change</option>
                                <option>Biodiversity Conservation</option>
                                <option>Renewable Energy Sources</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="quizDescription" class="form-label">Description</label>
                            <textarea class="form-control" id="quizDescription" rows="3" placeholder="Enter quiz description"></textarea>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Quiz Generation Method</label>
                            <div class="form-check" style="display: none;">
                                <input class="form-check-input" type="radio" name="generationMethod" id="autoGenerate" checked>
                                <label class="form-check-label" for="autoGenerate">
                                    Auto-Generate Questions
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="generationMethod" id="manualCreate" checked>
                                <label class="form-check-label" for="manualCreate">
                                    Manually Create Questions
                                </label>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary">Create Quiz</button>
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