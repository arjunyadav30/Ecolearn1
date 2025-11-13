<%@ page import="com.mycompany.sih3.entity.User" %>
<%@ page import="com.mycompany.sih3.entity.Lesson" %>
<%@ page import="com.mycompany.sih3.entity.Question" %>
<%@ page import="com.mycompany.sih3.repository.LessonRepository" %>
<%@ page import="com.mycompany.sih3.repository.QuestionRepository" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ include file="auth_check.jsp" %>
<%
    User currentUser = (User) session.getAttribute("user");
    
    // Get parameters
    String lessonIdParam = request.getParameter("lessonId");
    String numberOfQuestionsParam = request.getParameter("numberOfQuestions");
    
    // Validate lesson ID
    if (lessonIdParam == null || lessonIdParam.isEmpty()) {
        response.sendRedirect("manage-lessons.jsp");
        return;
    }
    
    int lessonId;
    int numberOfQuestions = 0;
    
    try {
        lessonId = Integer.parseInt(lessonIdParam);
        if (numberOfQuestionsParam != null && !numberOfQuestionsParam.isEmpty()) {
            numberOfQuestions = Integer.parseInt(numberOfQuestionsParam);
        }
    } catch (NumberFormatException e) {
        response.sendRedirect("manage-lessons.jsp");
        return;
    }
    
    // Get lesson details
    LessonRepository lessonRepository = new LessonRepository();
    Lesson lesson = lessonRepository.findById(lessonId);
    
    if (lesson == null) {
        response.sendRedirect("manage-lessons.jsp");
        return;
    }
    
    // Handle form submission for saving questions
    String message = "";
    String messageType = "";
    
    if ("POST".equals(request.getMethod())) {
        try {
            QuestionRepository questionRepository = new QuestionRepository();
            
            // Get all parameter names
            java.util.Enumeration<String> paramNames = request.getParameterNames();
            
            // Process questions
            int questionCount = 0;
            
            // We'll process questions by looking for questionText parameters
            for (int i = 1; i <= 100; i++) { // Assuming max 100 questions
                String questionTextParam = request.getParameter("questionText" + i);
                
                if (questionTextParam != null && !questionTextParam.trim().isEmpty()) {
                    // Create a new question
                    Question question = new Question();
                    question.setLessonId(lessonId);
                    question.setQuestionText(questionTextParam);
                    
                    // Get options
                    String option1 = request.getParameter("option1_" + i);
                    String option2 = request.getParameter("option2_" + i);
                    String option3 = request.getParameter("option3_" + i);
                    String option4 = request.getParameter("option4_" + i);
                    
                    if (option1 != null) question.setOption1(option1);
                    if (option2 != null) question.setOption2(option2);
                    if (option3 != null) question.setOption3(option3);
                    if (option4 != null) question.setOption4(option4);
                    
                    // Get correct option
                    String correctOptionParam = request.getParameter("correctOption" + i);
                    if (correctOptionParam != null && !correctOptionParam.isEmpty()) {
                        try {
                            int correctOption = Integer.parseInt(correctOptionParam);
                            question.setCorrectOption(Integer.valueOf(correctOption));
                        } catch (NumberFormatException e) {
                            // Default to option 1 if invalid
                            question.setCorrectOption(Integer.valueOf(1));
                        }
                    } else {
                        question.setCorrectOption(Integer.valueOf(1));
                    }
                    
                    // Save question
                    questionRepository.save(question);
                    questionCount++;
                }
            }
            
            message = questionCount + " questions successfully saved for the quiz!";
            messageType = "success";
        } catch (Exception e) {
            message = "Error saving questions: " + e.getMessage();
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
    <title>Quiz Saved - EcoLearn Platform</title>
    
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
        
        .quiz-saved {
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
        
        .success-message {
            text-align: center;
            padding: 2rem;
        }
        
        .lesson-info {
            background: linear-gradient(135deg, #e9ecef, #f8f9fa);
            border-radius: var(--border-radius-lg);
            padding: var(--spacing-md);
            margin-bottom: var(--spacing-lg);
        }
        
        footer {
            background: #2c3e50;
            color: #95a5a6;
            padding: 1.5rem 0;
            margin-top: auto;
        }
    </style>
</head>
<body class="quiz-saved">
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
                            <span class="user-name"><%= currentUser.getFullName() != null && !currentUser.getFullName().trim().isEmpty() ? currentUser.getFullName() : currentUser.getUsername() %></span>
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
                        <i class="fas fa-check-circle me-2"></i>Quiz Saved Successfully
                    </h1>
                    <p class="page-subtitle">
                        Your quiz for "<%= lesson.getTitle() %>" has been saved
                    </p>
                </div>
                <div class="col-lg-4 text-end">
                    <button class="btn btn-light" onclick="window.location.href='manage-lessons.jsp'">
                        <i class="fas fa-arrow-left me-2"></i>Back to Lessons
                    </button>
                </div>
            </div>
        </div>

        <!-- Display messages -->
        <% if (!message.isEmpty()) { %>
            <div class="alert alert-<%= messageType.equals("success") ? "success" : "danger" %> alert-dismissible fade show" role="alert">
                <%= message %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>

        <!-- Lesson Information -->
        <div class="lesson-info">
            <h5>Lesson Details</h5>
            <div class="row">
                <div class="col-md-6">
                    <p><strong>Title:</strong> <%= lesson.getTitle() %></p>
                    <p><strong>Category:</strong> <%= lesson.getCategory() %></p>
                </div>
                <div class="col-md-6">
                    <p><strong>Points:</strong> <%= lesson.getPoints() %></p>
                </div>
            </div>
            <% if (lesson.getDescription() != null && !lesson.getDescription().isEmpty()) { %>
                <p><strong>Description:</strong> <%= lesson.getDescription() %></p>
            <% } %>
        </div>

        <!-- Success Message -->
        <div class="section-card">
            <div class="success-message">
                <div class="text-success">
                    <i class="fas fa-check-circle fa-3x mb-3"></i>
                    <h2>Quiz Saved Successfully!</h2>
                    <p>Your questions have been saved to the question bank and associated with this lesson.</p>
                    <% if (numberOfQuestions > 0) { %>
                        <p>Successfully saved <%= numberOfQuestions %> questions for the quiz.</p>
                    <% } %>
                </div>
                
                <div class="d-flex justify-content-center mt-4">
                    <button class="btn btn-secondary me-2" onclick="window.location.href='manage-lessons.jsp'">
                        <i class="fas fa-arrow-left me-2"></i>Back to Lessons
                    </button>
                    <button class="btn btn-primary" onclick="window.location.href='manage-quizzes.jsp'">
                        <i class="fas fa-question-circle me-2"></i>Manage Quizzes
                    </button>
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