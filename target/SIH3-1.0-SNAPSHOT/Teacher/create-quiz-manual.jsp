<%@ page import="com.mycompany.sih3.entity.User" %>
<%@ page import="com.mycompany.sih3.entity.Lesson" %>
<%@ page import="com.mycompany.sih3.repository.LessonRepository" %>
<%@ include file="auth_check.jsp" %>
<%
    User currentUser = (User) session.getAttribute("user");
    String displayName = currentUser.getFullName();
    if (displayName == null || displayName.trim().isEmpty()) {
        displayName = currentUser.getUsername();
    }
    
    // Get parameters
    String lessonIdParam = request.getParameter("lessonId");
    String numberOfQuestionsParam = request.getParameter("numberOfQuestions");
    
    // Validate lesson ID
    if (lessonIdParam == null || lessonIdParam.isEmpty()) {
        response.sendRedirect("manage-lessons.jsp");
        return;
    }
    
    int lessonId;
    int numberOfQuestions = 25; // Default
    
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
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manual Quiz Creation - EcoLearn Platform</title>
    
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
        
        .manual-quiz {
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
        
        .lesson-info {
            background: linear-gradient(135deg, #e9ecef, #f8f9fa);
            border-radius: var(--border-radius-lg);
            padding: var(--spacing-md);
            margin-bottom: var(--spacing-lg);
        }
        
        .question-form {
            background-color: #f8f9fa;
            border-radius: var(--border-radius-lg);
            padding: var(--spacing-md);
            margin-bottom: var(--spacing-md);
        }
        
        .question-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: var(--spacing-md);
        }
        
        .question-number {
            font-weight: 600;
            color: var(--primary-green);
        }
        
        .remove-question {
            color: #dc3545;
            cursor: pointer;
        }
        
        .form-group {
            margin-bottom: 1rem;
        }
        
        .form-label {
            font-weight: 500;
            color: var(--dark-gray);
            margin-bottom: 0.5rem;
        }
        
        .option-input {
            position: relative;
            padding-left: 2.5rem;
        }
        
        .option-input input[type="radio"] {
            position: absolute;
            left: 0;
            top: 0.5rem;
        }
        
        footer {
            background: #2c3e50;
            color: #95a5a6;
            padding: 1.5rem 0;
            margin-top: auto;
        }
    </style>
</head>
<body class="manual-quiz">
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
                        <i class="fas fa-edit me-2"></i>Manual Quiz Creation
                    </h1>
                    <p class="page-subtitle">
                        Create questions manually for "<%= lesson.getTitle() %>"
                    </p>
                </div>
                <div class="col-lg-4 text-end">
                    <button class="btn btn-light" onclick="window.location.href='manage-lessons.jsp'">
                        <i class="fas fa-arrow-left me-2"></i>Back to Lessons
                    </button>
                </div>
            </div>
        </div>

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
                    <p><strong>Questions to Create:</strong> <%= numberOfQuestions %></p>
                </div>
            </div>
            <% if (lesson.getDescription() != null && !lesson.getDescription().isEmpty()) { %>
                <p><strong>Description:</strong> <%= lesson.getDescription() %></p>
            <% } %>
        </div>

        <!-- Manual Quiz Creation Form -->
        <div class="section-card">
            <h2 class="section-title">Create Questions</h2>
            <p>Create <%= numberOfQuestions %> questions for your quiz. You can save your progress and come back later.</p>
            
            <form id="quizForm" method="post" action="save-quiz.jsp">
                <input type="hidden" name="lessonId" value="<%= lessonId %>">
                <input type="hidden" name="numberOfQuestions" value="<%= numberOfQuestions %>">
                
                <div id="questionsContainer">
                    <!-- Question forms will be dynamically added here -->
                </div>
                
                <div class="d-flex justify-content-between mt-4">
                    <button type="button" class="btn btn-secondary" onclick="addQuestion()">
                        <i class="fas fa-plus me-2"></i>Add Question
                    </button>
                    <div>
                        <button type="button" class="btn btn-secondary me-2" onclick="window.location.href='manage-lessons.jsp'">
                            <i class="fas fa-times me-2"></i>Cancel
                        </button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save me-2"></i>Save Quiz
                        </button>
                    </div>
                </div>
            </form>
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
            
            // Add initial questions
            for (let i = 1; i <= <%= numberOfQuestions %>; i++) {
                addQuestion();
            }
        });
        
        let questionCount = 0;
        
        function addQuestion() {
            questionCount++;
            const container = document.getElementById('questionsContainer');
            
            const questionForm = document.createElement('div');
            questionForm.className = 'question-form';
            questionForm.id = 'question-' + questionCount;
            
            questionForm.innerHTML = `
                <div class="question-header">
                    <div class="question-number">Question ${questionCount}</div>
                    ${questionCount > 1 ? '<div class="remove-question" onclick="removeQuestion(' + questionCount + ')"><i class="fas fa-trash"></i> Remove</div>' : ''}
                </div>
                
                <div class="form-group">
                    <label for="questionText${questionCount}" class="form-label">Question Text</label>
                    <textarea class="form-control" id="questionText${questionCount}" name="questionText${questionCount}" rows="2" placeholder="Enter your question" required></textarea>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Options</label>
                    <div class="option-input mb-2">
                        <input type="radio" name="correctOption${questionCount}" value="1" required>
                        <input type="text" class="form-control" name="option1_${questionCount}" placeholder="Option 1" required>
                    </div>
                    <div class="option-input mb-2">
                        <input type="radio" name="correctOption${questionCount}" value="2">
                        <input type="text" class="form-control" name="option2_${questionCount}" placeholder="Option 2" required>
                    </div>
                    <div class="option-input mb-2">
                        <input type="radio" name="correctOption${questionCount}" value="3">
                        <input type="text" class="form-control" name="option3_${questionCount}" placeholder="Option 3" required>
                    </div>
                    <div class="option-input mb-2">
                        <input type="radio" name="correctOption${questionCount}" value="4">
                        <input type="text" class="form-control" name="option4_${questionCount}" placeholder="Option 4" required>
                    </div>
                </div>
            `;
            
            container.appendChild(questionForm);
        }
        
        function removeQuestion(questionId) {
            const questionElement = document.getElementById('question-' + questionId);
            if (questionElement) {
                questionElement.remove();
                questionCount--;
            }
        }
    </script>
</body>
</html>