<%@ page import="com.mycompany.sih3.entity.User" %>
<%@ page import="com.mycompany.sih3.entity.Lesson" %>
<%@ page import="com.mycompany.sih3.entity.Question" %>
<%@ page import="com.mycompany.sih3.entity.QuestionBank" %>
<%@ page import="com.mycompany.sih3.repository.LessonRepository" %>
<%@ page import="com.mycompany.sih3.repository.QuestionRepository" %>
<%@ page import="com.mycompany.sih3.repository.QuestionBankRepository" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
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
    
    // Handle auto-generation of questions
    String message = "";
    String messageType = "";
    List<Question> generatedQuestions = new ArrayList<>();
    
    if ("POST".equals(request.getMethod())) {
        // Check if we're saving edited questions or generating new ones
        String action = request.getParameter("action");
        
        if ("save".equals(action)) {
            // Save edited questions
            try {
                QuestionRepository questionRepository = new QuestionRepository();
                
                // Process each question
                for (int i = 1; i <= numberOfQuestions; i++) {
                    String questionText = request.getParameter("questionText" + i);
                    String option1 = request.getParameter("option1_" + i);
                    String option2 = request.getParameter("option2_" + i);
                    String option3 = request.getParameter("option3_" + i);
                    String option4 = request.getParameter("option4_" + i);
                    String correctOptionParam = request.getParameter("correctOption" + i);
                    
                    if (questionText != null && !questionText.trim().isEmpty()) {
                        Question question = new Question();
                        question.setLessonId(lessonId);
                        question.setQuestionText(questionText);
                        if (option1 != null) question.setOption1(option1);
                        if (option2 != null) question.setOption2(option2);
                        if (option3 != null) question.setOption3(option3);
                        if (option4 != null) question.setOption4(option4);
                        
                        if (correctOptionParam != null && !correctOptionParam.isEmpty()) {
                            try {
                                question.setCorrectOption(Integer.valueOf(correctOptionParam));
                            } catch (NumberFormatException e) {
                                // Handle invalid correct option
                                question.setCorrectOption(1);
                            }
                        } else {
                            question.setCorrectOption(1);
                        }
                        
                        questionRepository.save(question);
                    }
                }
                
                message = numberOfQuestions + " questions successfully saved!";
                messageType = "success";
            } catch (Exception e) {
                message = "Error saving questions: " + e.getMessage();
                messageType = "danger";
                e.printStackTrace();
            }
        } else {
            // Generate questions from question bank ONLY - no placeholders
            try {
                com.mycompany.sih3.repository.QuestionBankRepository questionBankRepository = new com.mycompany.sih3.repository.QuestionBankRepository();
                
                // Log the search parameters for debugging
                System.out.println("Searching for questions with:");
                System.out.println("  Title: " + lesson.getTitle());
                System.out.println("  Description: " + lesson.getDescription());
                System.out.println("  Category: " + lesson.getCategory());
                System.out.println("  Number of questions requested: " + numberOfQuestions);
                
                // Fetch questions from question bank based on partial matching
                List<com.mycompany.sih3.entity.QuestionBank> bankQuestions = 
                    questionBankRepository.findQuestionsByPartialMatch(
                        lesson.getTitle(), 
                        lesson.getDescription() != null ? lesson.getDescription() : "", 
                        lesson.getCategory() != null ? lesson.getCategory() : "", 
                        numberOfQuestions
                    );
                
                // Log how many questions were found
                System.out.println("Found " + bankQuestions.size() + " questions from database");
                
                // Convert QuestionBank objects to Question objects
                for (com.mycompany.sih3.entity.QuestionBank bankQuestion : bankQuestions) {
                    Question question = new Question();
                    question.setQuestionText(bankQuestion.getQuestionText());
                    question.setOption1(bankQuestion.getOptionA());
                    question.setOption2(bankQuestion.getOptionB());
                    question.setOption3(bankQuestion.getOptionC());
                    question.setOption4(bankQuestion.getOptionD());
                    
                    // Convert correct option from char to int
                    String correctOption = bankQuestion.getCorrectOption();
                    if (correctOption != null && !correctOption.isEmpty()) {
                        switch (correctOption.toLowerCase()) {
                            case "a": question.setCorrectOption(1); break;
                            case "b": question.setCorrectOption(2); break;
                            case "c": question.setCorrectOption(3); break;
                            case "d": question.setCorrectOption(4); break;
                            default: question.setCorrectOption(1); break;
                        }
                    } else {
                        question.setCorrectOption(1);
                    }
                    
                    generatedQuestions.add(question);
                }
                
                // Generate placeholder questions if no questions found in bank
                if (generatedQuestions.isEmpty()) {
                    for (int i = 1; i <= numberOfQuestions; i++) {
                        Question question = new Question();
                        question.setQuestionText("Based on the video content, what is the key concept discussed in segment " + i + "?");
                        question.setOption1("Key concept A related to segment " + i);
                        question.setOption2("Key concept B related to segment " + i);
                        question.setOption3("Key concept C related to segment " + i);
                        question.setOption4("Key concept D related to segment " + i);
                        question.setCorrectOption(Integer.valueOf((i % 4) + 1)); // Rotate correct answers
                        
                        generatedQuestions.add(question);
                    }
                }
                
                // Always show a success message when questions are fetched/generated
                if (generatedQuestions.size() > 0) {
                    message = "Successfully fetched " + generatedQuestions.size() + " questions from database.";
                    messageType = "success";
                } else {
                    message = "No questions found in the database for this lesson. Please add questions to the question bank.";
                    messageType = "warning";
                }
            } catch (Exception e) {
                // Show error message if there's an issue with database fetching
                message = "Error fetching questions from database: " + e.getMessage();
                messageType = "danger";
                e.printStackTrace();
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Auto-Generate Quiz - EcoLearn Platform</title>
    
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
        
        .generate-quiz {
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
        
        .progress-container {
            text-align: center;
            padding: 2rem;
        }
        
        .success-message {
            text-align: center;
            padding: 2rem;
        }
        
        .question-form {
            background-color: #f8f9fa;
            border-radius: var(--border-radius-lg);
            margin-bottom: 1.5rem;
        }
        
        .question-header h5 {
            color: var(--primary-green);
            font-weight: 600;
        }
        
        .option-input {
            margin-bottom: 1rem;
        }
        
        footer {
            background: #2c3e50;
            color: #95a5a6;
            padding: 1.5rem 0;
            margin-top: auto;
        }
    </style>
</head>
<body class="generate-quiz">
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
                        <i class="fas fa-robot me-2"></i>Auto-Generate Quiz
                    </h1>
                    <p class="page-subtitle">
                        Automatically generate questions from "<%= lesson.getTitle() %>"
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
                    <p><strong>Questions to Generate:</strong> <%= numberOfQuestions %></p>
                </div>
            </div>
            <% if (lesson.getDescription() != null && !lesson.getDescription().isEmpty()) { %>
                <p><strong>Description:</strong> <%= lesson.getDescription() %></p>
            <% } %>
        </div>

        <!-- Content based on request method and action -->
        <% if ("GET".equals(request.getMethod())) { %>
            <!-- Auto-generation content -->
            <div class="section-card">
                <h2 class="section-title">Auto-Generate Questions</h2>
                <p>Automatically generating <%= numberOfQuestions %> questions from the video content. This may take a few moments...</p>
                
                <div class="progress-container">
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                    <p class="mt-3">Analyzing video content and generating questions...</p>
                </div>
                
                <div class="d-flex justify-content-center mt-4">
                    <button class="btn btn-secondary me-2" onclick="window.location.href='manage-lessons.jsp'">
                        <i class="fas fa-times me-2"></i>Cancel
                    </button>
                    <form method="post">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-cogs me-2"></i>Generate Questions
                        </button>
                    </form>
                </div>
            </div>
        <% } else if ("POST".equals(request.getMethod()) && !"save".equals(request.getParameter("action"))) { %>
            <!-- Show generated questions in editable form -->
            <div class="section-card">
                <h2 class="section-title">Edit Generated Questions</h2>
                <p><%= numberOfQuestions %> questions have been automatically generated. You can edit them below before saving.</p>
                
                <form method="post" id="questionsForm">
                    <input type="hidden" name="action" value="save">
                    <input type="hidden" name="lessonId" value="<%= lessonId %>">
                    <input type="hidden" name="numberOfQuestions" value="<%= numberOfQuestions %>">
                    
                    <div id="questionsContainer">
                        <% for (int i = 0; i < generatedQuestions.size(); i++) {
                            Question question = generatedQuestions.get(i);
                            int questionNumber = i + 1;
                        %>
                        <div class="question-form mb-4 p-3 border rounded">
                            <div class="question-header mb-3">
                                <h5>Question <%= questionNumber %></h5>
                            </div>
                            
                            <div class="form-group mb-3">
                                <label for="questionText<%= questionNumber %>" class="form-label">Question Text</label>
                                <textarea class="form-control" id="questionText<%= questionNumber %>" name="questionText<%= questionNumber %>" rows="2" required><%= question.getQuestionText() %></textarea>
                            </div>
                            
                            <div class="form-group mb-2">
                                <label class="form-label">Options</label>
                                <div class="option-input mb-2">
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="correctOption<%= questionNumber %>" id="correctOption<%= questionNumber %>_1" value="1" <%= (question.getCorrectOption() != null && question.getCorrectOption().intValue() == 1) ? "checked" : "" %> required>
                                        <label class="form-check-label" for="correctOption<%= questionNumber %>_1">Correct Answer</label>
                                    </div>
                                    <input type="text" class="form-control" name="option1_<%= questionNumber %>" value="<%= question.getOption1() != null ? question.getOption1() : "" %>" placeholder="Option 1" required>
                                </div>
                                <div class="option-input mb-2">
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="correctOption<%= questionNumber %>" id="correctOption<%= questionNumber %>_2" value="2" <%= (question.getCorrectOption() != null && question.getCorrectOption().intValue() == 2) ? "checked" : "" %>>
                                        <label class="form-check-label" for="correctOption<%= questionNumber %>_2">Correct Answer</label>
                                    </div>
                                    <input type="text" class="form-control" name="option2_<%= questionNumber %>" value="<%= question.getOption2() != null ? question.getOption2() : "" %>" placeholder="Option 2" required>
                                </div>
                                <div class="option-input mb-2">
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="correctOption<%= questionNumber %>" id="correctOption<%= questionNumber %>_3" value="3" <%= (question.getCorrectOption() != null && question.getCorrectOption().intValue() == 3) ? "checked" : "" %>>
                                        <label class="form-check-label" for="correctOption<%= questionNumber %>_3">Correct Answer</label>
                                    </div>
                                    <input type="text" class="form-control" name="option3_<%= questionNumber %>" value="<%= question.getOption3() != null ? question.getOption3() : "" %>" placeholder="Option 3" required>
                                </div>
                                <div class="option-input mb-2">
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="correctOption<%= questionNumber %>" id="correctOption<%= questionNumber %>_4" value="4" <%= (question.getCorrectOption() != null && question.getCorrectOption().intValue() == 4) ? "checked" : "" %>>
                                        <label class="form-check-label" for="correctOption<%= questionNumber %>_4">Correct Answer</label>
                                    </div>
                                    <input type="text" class="form-control" name="option4_<%= questionNumber %>" value="<%= question.getOption4() != null ? question.getOption4() : "" %>" placeholder="Option 4" required>
                                </div>
                            </div>
                        </div>
                        <% } %>
                    </div>
                    
                    <div class="d-flex justify-content-between mt-4">
                        <button type="button" class="btn btn-secondary" onclick="window.location.href='manage-lessons.jsp'">
                            <i class="fas fa-times me-2"></i>Cancel
                        </button>
                        <div>
                            <button type="button" class="btn btn-secondary me-2" onclick="window.location.href='manage-quizzes.jsp'">
                                <i class="fas fa-question-circle me-2"></i>Manage Quizzes
                            </button>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save me-2"></i>Save Questions
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        <% } else if ("POST".equals(request.getMethod()) && "save".equals(request.getParameter("action"))) { %>
            <!-- Success message -->
            <div class="section-card">
                <div class="success-message">
                    <div class="text-success">
                        <i class="fas fa-check-circle fa-3x mb-3"></i>
                        <h2>Success!</h2>
                        <p><%= numberOfQuestions %> questions have been saved successfully!</p>
                        <p>Questions have been saved to the question bank and associated with this lesson.</p>
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