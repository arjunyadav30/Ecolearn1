<%@ page import="com.mycompany.sih3.entity.User" %>
<%@ page import="com.mycompany.sih3.entity.Lesson" %>
<%@ page import="com.mycompany.sih3.repository.LessonRepository" %>
<%@ page import="java.io.*, java.util.*, javax.servlet.*, javax.servlet.http.*, org.apache.commons.fileupload.*, org.apache.commons.fileupload.disk.*, org.apache.commons.fileupload.servlet.*" %>
<%@ page import="java.nio.file.*, java.time.LocalDateTime, java.sql.SQLException" %>
<%@ include file="auth_check.jsp" %>
<%
    User currentUser = (User) session.getAttribute("user");
    String displayName = currentUser.getFullName();
    if (displayName == null || displayName.trim().isEmpty()) {
        displayName = currentUser.getUsername();
    }
    
    // Handle form submission for adding a lesson
    String message = "";
    String messageType = "";
    
    // Check if this is a multipart request (file upload for add/edit)
    boolean isMultipart = ServletFileUpload.isMultipartContent(request);
    
    if (isMultipart) {
        try {
            // Create a factory for disk-based file items
            DiskFileItemFactory factory = new DiskFileItemFactory();
            
            // Set the temporary directory to store uploaded files
            factory.setRepository(new File(System.getProperty("java.io.tmpdir")));
            
            // Create a new file upload handler
            ServletFileUpload upload = new ServletFileUpload(factory);
            
            // Parse the request
            List<FileItem> items = upload.parseRequest(request);
            
            // Process the uploaded items
            String title = "";
            String description = "";
            String category = "";
            String customCategory = "";
            Integer points = 0;
            String videoFileName = "";
            String quizOption = "noQuiz"; // Default to no quiz
            Integer numberOfQuestions = 25; // Default number of questions
            
            for (FileItem item : items) {
                if (item.isFormField()) {
                    // Process form fields
                    String fieldName = item.getFieldName();
                    String fieldValue = item.getString("UTF-8");
                    
                    if ("lessonTitle".equals(fieldName)) {
                        title = fieldValue;
                    } else if ("lessonDescription".equals(fieldName)) {
                        description = fieldValue;
                    } else if ("lessonCategory".equals(fieldName)) {
                        category = fieldValue;
                    } else if ("customCategory".equals(fieldName)) {
                        customCategory = fieldValue;
                    } else if ("lessonPoints".equals(fieldName)) {
                        points = Integer.parseInt(fieldValue);
                    } else if ("quizOption".equals(fieldName)) {
                        quizOption = fieldValue;
                    } else if ("numberOfQuestions".equals(fieldName)) {
                        numberOfQuestions = Integer.parseInt(fieldValue);
                    }
                } else {
                    // Process uploaded file
                    String fieldName = item.getFieldName();
                    if ("lessonVideo".equals(fieldName)) {
                        String fileName = item.getName();
                        if (fileName != null && !fileName.isEmpty()) {
                            // Generate unique file name
                            String fileExtension = "";
                            int dotIndex = fileName.lastIndexOf('.');
                            if (dotIndex > 0) {
                                fileExtension = fileName.substring(dotIndex);
                            }
                            // Use a safer filename generation that doesn't depend on title
                            videoFileName = "lesson_" + System.currentTimeMillis() + fileExtension;
                            
                            // Save file to uploads directory
                            String uploadPath = application.getRealPath("/") + "uploads" + File.separator + "videos";
                            File uploadDir = new File(uploadPath);
                            if (!uploadDir.exists()) {
                                uploadDir.mkdirs();
                            }
                            
                            File uploadedFile = new File(uploadPath + File.separator + videoFileName);
                            item.write(uploadedFile);
                        }
                    }
                }
            }
            
            // Use custom category if "other" was selected
            if ("other".equals(category) && customCategory != null && !customCategory.isEmpty()) {
                category = customCategory;
            }
            
            // Save lesson to database
            if (!title.isEmpty() && !category.isEmpty()) {
                Lesson lesson = new Lesson();
                lesson.setTitle(title);
                lesson.setDescription(description);
                lesson.setCategory(category);
                lesson.setPoints(points);
                lesson.setCreatedAt(LocalDateTime.now());
                lesson.setUpdatedAt(LocalDateTime.now());
                
                // Adding new lesson
                if (!videoFileName.isEmpty()) {
                    lesson.setVideoUrl("uploads/videos/" + videoFileName);
                }
                LessonRepository lessonRepository = new LessonRepository();
                lessonRepository.save(lesson);
                
                // Ensure the lesson was saved and has an ID
                if (lesson.getId() != null) {
                    message = "Lesson added successfully!";
                    messageType = "success";
                    
                    // Redirect to appropriate page based on quiz option
                    if ("autoGenerate".equals(quizOption)) {
                        // Redirect to auto-generate quiz page with lesson ID
                        response.sendRedirect("generate-quiz-auto.jsp?lessonId=" + lesson.getId() + "&numberOfQuestions=" + numberOfQuestions);
                        return;
                    } else if ("manualCreate".equals(quizOption)) {
                        // Redirect to manual quiz creation page with lesson ID
                        response.sendRedirect("create-quiz-manual.jsp?lessonId=" + lesson.getId() + "&numberOfQuestions=" + numberOfQuestions);
                        return;
                    } else {
                        // No quiz option selected, redirect to manage lessons
                        response.sendRedirect("manage-lessons.jsp");
                        return;
                    }
                } else {
                    message = "Error: Lesson was not saved properly.";
                    messageType = "danger";
                }
            } else {
                message = "Error: Lesson title and category are required.";
                messageType = "danger";
            }
        } catch (SQLException e) {
            message = "Database error: " + e.getMessage();
            messageType = "danger";
            e.printStackTrace();
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
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
    <title>Add Lesson - EcoLearn Platform</title>
    
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
        
        .add-lesson {
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
        
        .form-group {
            margin-bottom: 1.5rem;
        }
        
        .form-label {
            font-weight: 500;
            color: var(--dark-gray);
            margin-bottom: 0.5rem;
        }
        
        .quiz-options {
            background-color: #f8f9fa;
            border-radius: var(--border-radius-lg);
            padding: 1.5rem;
            margin-top: 1rem;
        }
        
        .quiz-option-card {
            border: 2px solid #e9ecef;
            border-radius: var(--border-radius-lg);
            padding: 1.5rem;
            margin-bottom: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .quiz-option-card:hover {
            border-color: var(--primary-green);
            box-shadow: 0 0 0 3px rgba(45, 143, 68, 0.2);
        }
        
        .quiz-option-card.selected {
            border-color: var(--primary-green);
            background-color: rgba(45, 143, 68, 0.05);
            box-shadow: 0 0 0 3px rgba(45, 143, 68, 0.2);
        }
        
        .quiz-option-icon {
            font-size: 2rem;
            color: var(--primary-green);
            margin-bottom: 1rem;
        }
        
        .quiz-option-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--dark-gray);
            margin-bottom: 0.5rem;
        }
        
        .quiz-option-desc {
            color: #6c757d;
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
<body class="add-lesson">
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
                        <a class="nav-link active" href="manage-lessons.jsp">
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
                        <i class="fas fa-book-open me-2"></i>Add New Lesson
                    </h1>
                    <p class="page-subtitle">
                        Create a new educational lesson and optionally generate a quiz
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

        <!-- Add Lesson Form -->
        <div class="section-card">
            <h2 class="section-title">Lesson Details</h2>
            
            <form method="post" enctype="multipart/form-data" id="addLessonForm">
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="lessonTitle" class="form-label">Lesson Title</label>
                            <input type="text" class="form-control" id="lessonTitle" name="lessonTitle" placeholder="Enter lesson title" required>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="lessonCategory" class="form-label">Category</label>
                            <select class="form-select" id="lessonCategory" name="lessonCategory" required onchange="toggleCustomCategory()">
                                <option value="">Select category</option>
                                <option>Climate</option>
                                <option>Biodiversity</option>
                                <option>Energy</option>
                                <option>Waste Management</option>
                                <option>Water Conservation</option>
                                
                                <option value="other">Other (specify below)</option>
                            </select>
                            <input type="text" class="form-control mt-2" id="customCategory" name="customCategory" placeholder="Enter custom category" style="display: none;">
                        </div>
                    </div>
                </div>
                
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="lessonPoints" class="form-label">Points</label>
                            <input type="number" class="form-control" id="lessonPoints" name="lessonPoints" placeholder="Enter points value" required>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="lessonVideo" class="form-label">Video Upload</label>
                            <input type="file" class="form-control" id="lessonVideo" name="lessonVideo" accept="video/*" required>
                        </div>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="lessonDescription" class="form-label">Description</label>
                    <textarea class="form-control" id="lessonDescription" name="lessonDescription" rows="4" placeholder="Enter lesson description"></textarea>
                </div>
                
                <!-- Quiz Generation Options -->
                <div class="quiz-options">
                    <h3 class="section-title">Quiz Options</h3>
                    <p class="text-muted">After saving the lesson, you can generate a quiz based on the lesson content.</p>
                    
                    <input type="hidden" id="selectedQuizOption" name="quizOption" value="noQuiz">
                    <input type="hidden" id="numberOfQuestions" name="numberOfQuestions" value="25">
                    
                    <div class="quiz-option-card" onclick="selectQuizOption('noQuiz')">
                        <div class="quiz-option-icon">
                            <i class="fas fa-times-circle"></i>
                        </div>
                        <h4 class="quiz-option-title">No Quiz</h4>
                        <p class="quiz-option-desc">Save the lesson without creating a quiz. You can create a quiz later.</p>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="quizOptionRadio" id="noQuiz" value="noQuiz" checked>
                            <label class="form-check-label" for="noQuiz">
                                Select this option
                            </label>
                        </div>
                    </div>
                    
                    <div class="quiz-option-card" onclick="selectQuizOption('autoGenerate')">
                        <div class="quiz-option-icon">
                            <i class="fas fa-robot"></i>
                        </div>
                        <h4 class="quiz-option-title">Auto-Generate Quiz</h4>
                        <p class="quiz-option-desc">Automatically generate questions from the database based on lesson title, category, and description. You can review and edit the questions later.</p>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="quizOptionRadio" id="autoGenerate" value="autoGenerate">
                            <label class="form-check-label" for="autoGenerate">
                                Select this option
                            </label>
                        </div>
                        <div class="mt-3">
                            <label for="autoQuestions" class="form-label">Number of Questions:</label>
                            <select class="form-select" id="autoQuestions" onchange="updateQuestionCount(this.value)">
                                <option value="5">5 Questions</option>
                                <option value="10">10 Questions</option>
                                <option value="15">15 Questions</option>
                                <option value="20">20 Questions</option>
                                <option value="25" selected>25 Questions</option>
                                <option value="30">30 Questions</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="quiz-option-card" onclick="selectQuizOption('manualCreate')">
                        <div class="quiz-option-icon">
                            <i class="fas fa-edit"></i>
                        </div>
                        <h4 class="quiz-option-title">Manual Quiz Creation</h4>
                        <p class="quiz-option-desc">Create questions manually after saving the lesson. You'll be redirected to the quiz editor.</p>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="quizOptionRadio" id="manualCreate" value="manualCreate">
                            <label class="form-check-label" for="manualCreate">
                                Select this option
                            </label>
                        </div>
                        <div class="mt-3">
                            <label for="manualQuestions" class="form-label">Number of Questions:</label>
                            <select class="form-select" id="manualQuestions" onchange="updateQuestionCount(this.value)">
                                <option value="5">5 Questions</option>
                                <option value="10">10 Questions</option>
                                <option value="15">15 Questions</option>
                                <option value="20">20 Questions</option>
                                <option value="25" selected>25 Questions</option>
                                <option value="30">30 Questions</option>
                            </select>
                        </div>
                    </div>
                </div>
                
                <!-- Form Actions -->
                <div class="d-flex justify-content-between mt-4">
                    <button type="button" class="btn btn-secondary" onclick="window.location.href='manage-lessons.jsp'">
                        <i class="fas fa-arrow-left me-2"></i>Cancel
                    </button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save me-2"></i>Save Lesson and Continue
                    </button>
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
        // Function to toggle custom category field
        function toggleCustomCategory() {
            var categorySelect = document.getElementById('lessonCategory');
            var customCategoryField = document.getElementById('customCategory');
            
            if (categorySelect.value === 'other') {
                customCategoryField.style.display = 'block';
                customCategoryField.required = true;
            } else {
                customCategoryField.style.display = 'none';
                customCategoryField.required = false;
            }
        }
        
        // Function to select quiz option
        function selectQuizOption(option) {
            // Update hidden input
            document.getElementById('selectedQuizOption').value = option;
            
            // Update radio buttons
            document.querySelectorAll('input[name="quizOptionRadio"]').forEach(radio => {
                radio.checked = radio.value === option;
            });
            
            // Update card selection
            document.querySelectorAll('.quiz-option-card').forEach(card => {
                card.classList.remove('selected');
            });
            
            // Add selected class to clicked card
            event.currentTarget.classList.add('selected');
        }
        
        // Function to update question count
        function updateQuestionCount(count) {
            document.getElementById('numberOfQuestions').value = count;
        }
        
        // Initialize theme
        document.addEventListener('DOMContentLoaded', function() {
            if (typeof loadSavedTheme === 'function') {
                loadSavedTheme();
            }
        });
    </script>
</body>
</html>