<%@ page import="com.mycompany.sih3.entity.User" %>
<%@ page import="com.mycompany.sih3.entity.QuestionBank" %>
<%@ page import="com.mycompany.sih3.repository.QuestionBankRepository" %>
<%@ page import="java.util.List" %>
<%@ include file="auth_check.jsp" %>
<%
    User currentUser = (User) session.getAttribute("user");
    String displayName = currentUser.getFullName();
    if (displayName == null || displayName.trim().isEmpty()) {
        displayName = currentUser.getUsername();
    }
    
    // Get search parameter
    String searchTitle = request.getParameter("title");
    List<QuestionBank> questions = null;
    String message = "";
    String messageType = "";
    int questionCount = 0;
    
    if (searchTitle != null && !searchTitle.trim().isEmpty()) {
        try {
            QuestionBankRepository repository = new QuestionBankRepository();
            
            // Search for questions by partial match in title, category, or question text
            questions = repository.findQuestionsByPartialText(searchTitle, 50); // Limit to 50 questions
            questionCount = questions.size();
            
            if (questionCount > 0) {
                message = "Found " + questionCount + " questions related to '" + searchTitle + "'";
                messageType = "success";
            } else {
                message = "No questions found related to '" + searchTitle + "'";
                messageType = "warning";
            }
        } catch (Exception e) {
            message = "Error searching questions: " + e.getMessage();
            messageType = "danger";
            e.printStackTrace();
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Questions by Title - EcoLearn Platform</title>
    
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
            /* Theme variables that will be overridden by theme.js */
            --primary-teal: #1abc9c;
            --secondary-cyan: #17a2b8;
            --accent-green: #20c997;
        }
        
        body {
            font-family: 'Poppins', system-ui, -apple-system, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            margin: 0;
            padding: 0;
            min-height: 100vh;
        }
        
        .search-questions {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            padding-top: 76px;
        }
        
        .navbar {
            background: linear-gradient(135deg, var(--primary-teal), var(--secondary-cyan)) !important;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .main-content {
            padding: var(--spacing-xl) 0;
        }
        
        .page-header {
            background: linear-gradient(135deg, var(--primary-teal), var(--secondary-cyan));
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
        
        .btn-secondary {
            background: linear-gradient(135deg, #6c757d, #495057);
            border: none;
        }
        
        .btn-secondary:hover {
            transform: translateY(-2px);
        }
        
        .search-form {
            background: linear-gradient(135deg, #e9ecef, #f8f9fa);
            border-radius: var(--border-radius-lg);
            padding: var(--spacing-lg);
            margin-bottom: var(--spacing-lg);
        }
        
        .question-card {
            border: 1px solid #e9ecef;
            border-radius: var(--border-radius-lg);
            padding: var(--spacing-md);
            margin-bottom: var(--spacing-md);
            transition: all 0.3s ease;
        }
        
        .question-card:hover {
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            transform: translateY(-2px);
        }
        
        .question-text {
            font-weight: 500;
            color: var(--dark-gray);
            margin-bottom: var(--spacing-md);
        }
        
        .options-container {
            background-color: #f8f9fa;
            border-radius: var(--border-radius-lg);
            padding: var(--spacing-md);
        }
        
        .option {
            margin-bottom: 0.5rem;
            padding: 0.5rem;
            border-radius: 0.5rem;
        }
        
        .correct-option {
            background-color: rgba(45, 143, 68, 0.1);
            border: 1px solid var(--primary-green);
        }
        
        .category-badge {
            background: linear-gradient(135deg, var(--primary-teal), var(--secondary-cyan));
            color: white;
            padding: 0.25rem 0.75rem;
            border-radius: 2rem;
            font-size: 0.875rem;
            font-weight: 500;
        }
        
        footer {
            background: #2c3e50;
            color: #95a5a6;
            padding: 1.5rem 0;
            margin-top: auto;
        }
    </style>
</head>
<body class="search-questions">
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
                        <a class="nav-link" href="manage-quizzes.jsp">
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
                        <i class="fas fa-search me-2"></i>Search Questions
                    </h1>
                    <p class="page-subtitle">
                        Find questions related to your lesson title
                    </p>
                </div>
                <div class="col-lg-4 text-end">
                    <button class="btn btn-light" onclick="window.location.href='manage-lessons.jsp'">
                        <i class="fas fa-arrow-left me-2"></i>Back to Lessons
                    </button>
                </div>
            </div>
        </div>

        <!-- Search Form -->
        <div class="section-card">
            <h2 class="section-title">Search Questions</h2>
            
            <div class="search-form">
                <form method="get">
                    <div class="row">
                        <div class="col-md-9">
                            <div class="form-group">
                                <label for="title" class="form-label">Enter Lesson Title or Keyword</label>
                                <input type="text" class="form-control" id="title" name="title" placeholder="Enter title or keyword to search questions" value="<%= searchTitle != null ? searchTitle : "" %>">
                            </div>
                        </div>
                        <div class="col-md-3 d-flex align-items-end">
                            <div class="form-group w-100">
                                <button type="submit" class="btn btn-primary w-100">
                                    <i class="fas fa-search me-2"></i>Search
                                </button>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <!-- Display messages -->
        <% if (!message.isEmpty()) { %>
            <div class="alert alert-<%= messageType %> alert-dismissible fade show" role="alert">
                <%= message %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>

        <!-- Display questions -->
        <% if (questions != null && !questions.isEmpty()) { %>
            <div class="section-card">
                <h2 class="section-title">Related Questions</h2>
                
                <div class="mb-3">
                    <p class="text-muted"><%= questionCount %> questions found</p>
                </div>
                
                <div class="questions-container">
                    <% for (int i = 0; i < questions.size(); i++) {
                        QuestionBank question = questions.get(i);
                    %>
                    <div class="question-card">
                        <div class="d-flex justify-content-between align-items-start mb-3">
                            <h5>Question #<%= i + 1 %></h5>
                            <span class="category-badge"><%= question.getCategory() %></span>
                        </div>
                        
                        <div class="question-text">
                            <p><%= question.getQuestionText() %></p>
                        </div>
                        
                        <div class="options-container">
                            <div class="option <%= "a".equalsIgnoreCase(question.getCorrectOption()) ? "correct-option" : "" %>">
                                <strong>A.</strong> <%= question.getOptionA() %>
                                <% if ("a".equalsIgnoreCase(question.getCorrectOption())) { %>
                                    <span class="badge bg-success float-end">Correct</span>
                                <% } %>
                            </div>
                            <div class="option <%= "b".equalsIgnoreCase(question.getCorrectOption()) ? "correct-option" : "" %>">
                                <strong>B.</strong> <%= question.getOptionB() %>
                                <% if ("b".equalsIgnoreCase(question.getCorrectOption())) { %>
                                    <span class="badge bg-success float-end">Correct</span>
                                <% } %>
                            </div>
                            <div class="option <%= "c".equalsIgnoreCase(question.getCorrectOption()) ? "correct-option" : "" %>">
                                <strong>C.</strong> <%= question.getOptionC() %>
                                <% if ("c".equalsIgnoreCase(question.getCorrectOption())) { %>
                                    <span class="badge bg-success float-end">Correct</span>
                                <% } %>
                            </div>
                            <div class="option <%= "d".equalsIgnoreCase(question.getCorrectOption()) ? "correct-option" : "" %>">
                                <strong>D.</strong> <%= question.getOptionD() %>
                                <% if ("d".equalsIgnoreCase(question.getCorrectOption())) { %>
                                    <span class="badge bg-success float-end">Correct</span>
                                <% } %>
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>
            </div>
        <% } else if (searchTitle != null && !searchTitle.trim().isEmpty()) { %>
            <div class="section-card">
                <h2 class="section-title">No Questions Found</h2>
                <p>No questions were found related to "<%= searchTitle %>". Try using different keywords or add questions to the question bank.</p>
            </div>
        <% } %>
    </div>

    <footer class="text-center">
        <div class="container">
            <p>&copy; 2025 EcoLearn Platform. All rights reserved.</p>
        </div>
    </footer>

    <!-- JavaScript Libraries -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="../js/theme.js"></script>
    
    <script>
        // Initialize theme
        document.addEventListener('DOMContentLoaded', function() {
            if (typeof loadSavedTheme === 'function') {
                loadSavedTheme();
            }
        });
    </script>
</body>
</html>