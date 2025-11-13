<%@ page import="com.mycompany.sih3.entity.Lesson" %>
<%@ page import="com.mycompany.sih3.repository.LessonRepository" %>
<%@ page import="com.mycompany.sih3.entity.Question" %>
<%@ page import="com.mycompany.sih3.repository.QuestionRepository" %>
<%@ page import="java.util.List" %>
<%
    // Get lesson ID from parameter
    String lessonIdParam = request.getParameter("id");
    Lesson lesson = null;
    List<Question> questions = null;
    String errorMessage = null;
    
    // Get user ID from session
    Integer userId = (Integer) session.getAttribute("userId");
    
    if (lessonIdParam != null && !lessonIdParam.isEmpty()) {
        try {
            int lessonId = Integer.parseInt(lessonIdParam);
            
            // Fetch lesson from database
            LessonRepository lessonRepository = new LessonRepository();
            lesson = lessonRepository.findById(lessonId);
            
            // Check if lesson exists
            if (lesson == null) {
                errorMessage = "Lesson with ID " + lessonId + " not found in the database.";
            } else {
                // Fetch questions for this lesson
                QuestionRepository questionRepository = new QuestionRepository();
                questions = questionRepository.findByLessonId(lessonId);
            }
        } catch (NumberFormatException e) {
            errorMessage = "Invalid lesson ID format: " + lessonIdParam;
        } catch (Exception e) {
            errorMessage = "Error retrieving lesson: " + e.getMessage();
            e.printStackTrace();
        }
    } else {
        errorMessage = "No lesson ID provided.";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= lesson != null ? lesson.getTitle() : "Lesson" %> - EcoLearn Platform</title>
    
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
            overflow-x: hidden; /* Prevent horizontal scrolling */
        }
        
        body.quiz-active {
            overflow: hidden; /* Prevent scrolling when quiz is active */
        }
        
        .lesson-view {
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
        
        .lesson-content-card {
            background: white;
            border-radius: var(--border-radius-lg);
            box-shadow: var(--shadow-md);
            padding: var(--spacing-lg);
            margin-bottom: var(--spacing-lg);
        }
        
        .video-container {
            position: relative;
            padding-bottom: 56.25%; /* 16:9 Aspect Ratio */
            height: 0;
            overflow: hidden;
            border-radius: var(--border-radius-lg);
            margin-bottom: var(--spacing-lg);
            background: #000;
        }
        
        .video-container iframe,
        .video-container video {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            border: none;
        }
        
        .lesson-description {
            font-size: 1.1rem;
            line-height: 1.6;
            color: #333;
            margin-bottom: var(--spacing-lg);
        }
        
        .quiz-section {
            background: white;
            border-radius: var(--border-radius-lg);
            box-shadow: var(--shadow-md);
            padding: var(--spacing-lg);
            margin-bottom: var(--spacing-lg);
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 90%;
            max-width: 800px;
            max-height: 90vh;
            z-index: 10000;
            overflow-y: auto;
            padding: 2rem;
            border: 2px solid var(--primary-green);
        }
        
        .overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.7);
            z-index: 9998;
            display: none;
        }
        
        .question-card {
            border: 1px solid #e9ecef;
            border-radius: var(--border-radius-lg);
            padding: var(--spacing-md);
            margin-bottom: var(--spacing-md);
        }
        
        .option-label {
            display: block;
            padding: 0.75rem;
            margin-bottom: 0.5rem;
            border: 1px solid #e9ecef;
            border-radius: 0.5rem;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        
        .option-label:hover {
            background-color: #f8f9fa;
            border-color: var(--primary-green);
        }
        
        .option-input:checked + .option-label {
            background-color: rgba(45, 143, 68, 0.1);
            border-color: var(--primary-green);
        }
        
        .btn-primary {
            background: linear-gradient(135deg, var(--primary-green), var(--secondary-teal));
            border: none;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
        }
        
        .points-badge {
            background: linear-gradient(135deg, var(--accent-blue), var(--primary-green));
            color: white;
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-weight: 600;
        }
        
        .progress-container {
            margin: 1rem 0;
        }
        
        .progress-bar {
            height: 10px;
            background-color: #e9ecef;
            border-radius: 5px;
            overflow: hidden;
        }
        
        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, var(--primary-green), var(--secondary-teal));
            width: 0%;
            transition: width 0.3s ease;
        }
        
        .progress-text {
            text-align: center;
            font-weight: 500;
            color: #6c757d;
            margin-top: 0.5rem;
        }
        
        .quiz-navigation {
            display: flex;
            justify-content: space-between;
            margin-top: 1rem;
        }
        
        .feedback {
            padding: 10px;
            margin: 10px 0;
            border-radius: 5px;
            display: none;
        }
        
        .correct {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .incorrect {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .close-btn {
            position: absolute;
            top: 10px;
            right: 10px;
            background: none;
            border: none;
            font-size: 1.5rem;
            cursor: pointer;
            color: #333;
        }
        
        .quiz-button-container {
            text-align: center;
            margin: 20px 0;
        }
        
        .quiz-button {
            background: linear-gradient(135deg, var(--primary-green), var(--secondary-teal));
            color: white;
            border: none;
            border-radius: 50px;
            padding: 12px 30px;
            font-size: 1.2rem;
            font-weight: 600;
            cursor: pointer;
            box-shadow: 0 4px 15px rgba(45, 143, 68, 0.3);
            transition: all 0.3s ease;
        }
        
        .quiz-button:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(45, 143, 68, 0.4);
        }
        
        .quiz-button:active {
            transform: translateY(1px);
        }
        
        .error-message {
            color: #dc3545;
            font-weight: 500;
            margin-top: 5px;
            display: none;
        }
    </style>
</head>
<body class="lesson-view">
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
                        <a class="nav-link" href="dashboard.jsp">
                            <i class="fas fa-tachometer-alt me-1"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="lessons.jsp">
                            <i class="fas fa-graduation-cap me-1"></i>Lessons
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="games.jsp">
                            <i class="fas fa-gamepad me-1"></i>Games
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="challenges.jsp">
                            <i class="fas fa-leaf me-1"></i>Challenges
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="leaderboard.jsp">
                            <i class="fas fa-trophy me-1"></i>Leaderboard
                        </a>
                    </li>
                </ul>
                
                <ul class="navbar-nav">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle d-flex align-items-center" href="#" role="button" data-bs-toggle="dropdown">
                            <div class="user-avatar me-2">
                                <div class="avatar-placeholder">
                                    U
                                </div>
                            </div>
                            <span class="user-name">User</span>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item" href="profile.jsp"><i class="fas fa-user me-2"></i>Profile</a></li>
                            <li><a class="dropdown-item" href="achievements.jsp"><i class="fas fa-medal me-2"></i>Achievements</a></li>
                            <li><a class="dropdown-item" href="settings.jsp"><i class="fas fa-cog me-2"></i>Settings</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="logout.jsp"><i class="fas fa-sign-out-alt me-2"></i>Logout</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Overlay for quiz modal -->
    <div class="overlay" id="quizOverlay"></div>

    <div class="container main-content">
        <% if (errorMessage != null) { %>
        <!-- Error message -->
        <div class="page-header">
            <div class="row align-items-center">
                <div class="col-12">
                    <h1 class="page-title">
                        <i class="fas fa-exclamation-triangle me-2"></i>Error
                    </h1>
                    <p class="page-subtitle">
                        <%= errorMessage %>
                    </p>
                </div>
            </div>
        </div>
        
        <div class="text-center">
            <a href="lessons.jsp" class="btn btn-primary">
                <i class="fas fa-arrow-left me-2"></i>Back to Lessons
            </a>
        </div>
        <% } else if (lesson == null) { %>
        <!-- Lesson not found -->
        <div class="page-header">
            <div class="row align-items-center">
                <div class="col-12">
                    <h1 class="page-title">
                        <i class="fas fa-exclamation-triangle me-2"></i>Lesson Not Found
                    </h1>
                    <p class="page-subtitle">
                        The requested lesson could not be found.
                    </p>
                </div>
            </div>
        </div>
        
        <div class="text-center">
            <a href="lessons.jsp" class="btn btn-primary">
                <i class="fas fa-arrow-left me-2"></i>Back to Lessons
            </a>
        </div>
        <% } else { %>
        <!-- Lesson content -->
        <div class="page-header">
            <div class="row align-items-center">
                <div class="col-lg-8">
                    <h1 class="page-title">
                        <i class="fas fa-graduation-cap me-2"></i><%= lesson.getTitle() %>
                    </h1>
                    <p class="page-subtitle">
                        <%= lesson.getCategory() != null ? lesson.getCategory() : "General" %> Lesson
                    </p>
                </div>
                <div class="col-lg-4 text-end">
                    <span class="points-badge">
                        <i class="fas fa-star me-1"></i><%= lesson.getPoints() != null ? lesson.getPoints() : 0 %> Points
                    </span>
                </div>
            </div>
        </div>

        <!-- Lesson Content -->
        <div class="lesson-content-card">
            <% if (lesson.getVideoUrl() != null && !lesson.getVideoUrl().isEmpty()) { %>
            <div class="video-container">
                <% if (lesson.getVideoUrl().contains("youtube.com") || lesson.getVideoUrl().contains("youtu.be")) { %>
                <!-- YouTube video -->
                <iframe id="videoPlayer" src="<%= lesson.getVideoUrl() %>" allowfullscreen></iframe>
                <% } else { %>
                <!-- Local video file -->
                <video id="videoPlayer" controls>
                    <source src="../<%= lesson.getVideoUrl() %>" type="video/mp4">
                    Your browser does not support the video tag.
                </video>
                <% } %>
            </div>
            
            <!-- Progress bar -->
            <div class="progress-container">
                <div class="progress-bar">
                    <div class="progress-fill" id="progressFill"></div>
                </div>
                <div class="progress-text" id="progressText">0% watched</div>
            </div>
            <% } %>
            
            <div class="lesson-description">
                <%= lesson.getDescription() != null ? lesson.getDescription() : "No description available for this lesson." %>
            </div>
            
            <!-- Quiz Button -->
            <div class="quiz-button-container">
                <button class="quiz-button" id="openQuizButton" disabled>
                    <i class="fas fa-question-circle me-2"></i>Quiz Locked
                </button>
                <!-- Snake and Ladder Game Button -->
                <button class="quiz-button mt-3" id="openSnakeLadderButton" onclick="window.location.href='snakeladder.jsp?lessonId=<%= lessonIdParam %>'">
                    <i class="fas fa-dice me-2"></i>Play Snake & Ladder Quiz
                </button>
            </div>
        </div>

        <!-- Quiz Section (Hidden by default, will show in modal) -->
        <% if (questions != null && !questions.isEmpty()) { %>
        <div class="quiz-section" id="quizSection">
            <button class="close-btn" onclick="closeQuiz()">&times;</button>
            <h2 class="mb-4">
                <i class="fas fa-question-circle me-2"></i>Lesson Quiz
            </h2>
            
            <form id="quizForm">
                <% for (int i = 0; i < questions.size(); i++) {
                    Question question = questions.get(i);
                %>
                <div class="question-card" id="question_<%= i %>" style="<%= i > 0 ? "display: none;" : "" %>">
                    <h5>Question <%= i + 1 %>: <%= question.getQuestionText() %></h5>
                    
                    <div class="mt-3">
                        <input type="radio" name="question_<%= question.getId() %>" id="q<%= question.getId() %>_a" value="A" class="option-input" required>
                        <label for="q<%= question.getId() %>_a" class="option-label">
                            A) <%= question.getOption1() %>
                        </label>
                        
                        <input type="radio" name="question_<%= question.getId() %>" id="q<%= question.getId() %>_b" value="B" class="option-input">
                        <label for="q<%= question.getId() %>_b" class="option-label">
                            B) <%= question.getOption2() %>
                        </label>
                        
                        <input type="radio" name="question_<%= question.getId() %>" id="q<%= question.getId() %>_c" value="C" class="option-input">
                        <label for="q<%= question.getId() %>_c" class="option-label">
                            C) <%= question.getOption3() %>
                        </label>
                        
                        <input type="radio" name="question_<%= question.getId() %>" id="q<%= question.getId() %>_d" value="D" class="option-input">
                        <label for="q<%= question.getId() %>_d" class="option-label">
                            D) <%= question.getOption4() %>
                        </label>
                    </div>
                    
                    <div class="error-message" id="error_<%= question.getId() %>">
                        Please select an answer before proceeding.
                    </div>
                    
                    <div class="feedback" id="feedback_<%= question.getId() %>"></div>
                    
                    <div class="quiz-navigation">
                        <% if (i > 0) { %>
                        <button type="button" class="btn btn-secondary" onclick="showQuestion(<%= i-1 %>)">
                            <i class="fas fa-arrow-left me-2"></i>Previous
                        </button>
                        <% } else { %>
                        <div></div> <!-- Empty div for spacing -->
                        <% } %>
                        
                        <% if (i < questions.size() - 1) { %>
                        <button type="button" class="btn btn-primary" onclick="checkAnswer(<%= i %>, <%= question.getId() %>, '<%= question.getCorrectOption() %>', <%= i+1 %>)">
                            Next<i class="fas fa-arrow-right ms-2"></i>
                        </button>
                        <% } else { %>
                        <button type="button" class="btn btn-success" onclick="checkAnswer(<%= i %>, <%= question.getId() %>, '<%= question.getCorrectOption() %>', -1)">
                            Submit Quiz<i class="fas fa-paper-plane ms-2"></i>
                        </button>
                        <% } %>
                    </div>
                </div>
                <% } %>
            </form>
        </div>
        <% } else { %>
        <div class="alert alert-info text-center">
            <h4>No Quiz Available</h4>
            <p>This lesson does not have a quiz associated with it.</p>
        </div>
        <% } %>
        
        <div class="text-center mt-4">
            <a href="lessons.jsp" class="btn btn-secondary">
                <i class="fas fa-arrow-left me-2"></i>Back to Lessons
            </a>
        </div>
        <% } %>
    </div>

    <!-- JavaScript Libraries -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Video player and progress tracking
        let videoPlayer = document.getElementById('videoPlayer');
        let progressFill = document.getElementById('progressFill');
        let progressText = document.getElementById('progressText');
        let maxVideoTime = 0;
        let quizUnlockShown = false;
        
        // Check if we're using a video element or iframe
        if (videoPlayer && videoPlayer.tagName === 'VIDEO') {
            // Local video file
            videoPlayer.addEventListener('timeupdate', updateProgress);
            videoPlayer.addEventListener('seeking', preventSkipping);
        } else if (videoPlayer) {
            // YouTube video - we'll use a simpler approach for progress tracking
            setInterval(updateProgressForIframe, 1000);
        }
        
        // Quiz button functionality
        document.getElementById('openQuizButton').addEventListener('click', function() {
            // Quiz is now disabled
            alert("Quiz is currently disabled.");
        });
        
        // Update progress for local video
        function updateProgress() {
            if (!videoPlayer) return;
            
            const currentTime = videoPlayer.currentTime;
            const duration = videoPlayer.duration;
            
            // Prevent skipping ahead
            if (currentTime > maxVideoTime + 2) { // Allow 2 seconds of flexibility
                videoPlayer.currentTime = maxVideoTime;
                return;
            }
            
            maxVideoTime = Math.max(maxVideoTime, currentTime);
            
            if (duration > 0) {
                const percent = (currentTime / duration) * 100;
                progressFill.style.width = percent + '%';
                progressText.textContent = Math.round(percent) + '% watched';
                
                // Commented out automatic quiz unlock
                // if (percent >= 85 && !quizUnlockShown) {
                //     quizUnlockShown = true;
                //     startQuiz();
                // }
            }
        }
        
        // Update progress for YouTube iframe (simplified)
        function updateProgressForIframe() {
            // Since we can't directly access YouTube iframe progress,
            // we'll just show a message that the feature works for local videos
            if (!quizUnlockShown) {
                console.log("For YouTube videos, please watch until the end to unlock the quiz");
            }
        }
        
        // Prevent skipping for local video
        function preventSkipping() {
            if (videoPlayer && videoPlayer.currentTime > maxVideoTime + 2) {
                videoPlayer.currentTime = maxVideoTime;
            }
        }
        
        // Start quiz when button is clicked or when 85% is reached
        function startQuiz() {
            const quizSection = document.getElementById('quizSection');
            const quizOverlay = document.getElementById('quizOverlay');
            
            if (quizSection && quizOverlay) {
                // Show quiz in modal
                quizSection.style.display = 'block';
                quizOverlay.style.display = 'block';
                
                // Add class to body to prevent scrolling
                document.body.classList.add('quiz-active');
                
                // Focus on the quiz window
                window.focus();
            }
        }
        
        // Close quiz modal
        function closeQuiz() {
            const quizSection = document.getElementById('quizSection');
            const quizOverlay = document.getElementById('quizOverlay');
            
            if (quizSection && quizOverlay) {
                quizSection.style.display = 'none';
                quizOverlay.style.display = 'none';
                
                // Remove class from body to re-enable scrolling
                document.body.classList.remove('quiz-active');
                
                // Log lesson completion if this is the end of the quiz
                const questions = document.querySelectorAll('[id^="question_"]');
                const isLastQuestion = Array.from(questions).every(q => 
                    q.style.display === 'none' || 
                    q === questions[questions.length - 1]
                );
                
                if (isLastQuestion) {
                    logLessonCompletion();
                }
            }
        }
        
        // Log lesson completion
        function logLessonCompletion() {
            // Get lesson information from the page
            const lessonTitle = document.querySelector('.page-title')?.textContent || 'Unknown Lesson';
            const lessonId = new URLSearchParams(window.location.search).get('id') || '0';
            
            // In a real application, you would make an AJAX call to log the completion
            // For now, we'll just show an alert
            console.log('Lesson completed:', lessonTitle);
            
            // Make AJAX call to log the lesson completion
            fetch('complete-lesson.jsp', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'lessonId=' + encodeURIComponent(lessonId) + 
                      '&lessonTitle=' + encodeURIComponent(lessonTitle) + 
                      '&points=100'
            })
            .then(response => response.json())
            .then(data => {
                if (data.status === 'success') {
                    console.log('Lesson completion logged successfully');
                    // Optionally show a notification to the user
                    showNotification('Lesson completed! Activity logged successfully.', 'success');
                } else {
                    console.error('Failed to log lesson completion:', data.message);
                }
            })
            .catch(error => {
                console.error('Error logging lesson completion:', error);
            });
        }
        
        // Show notification to user
        function showNotification(message, type) {
            // Create notification element
            const notification = document.createElement('div');
            notification.textContent = message;
            notification.style.position = 'fixed';
            notification.style.top = '20px';
            notification.style.right = '20px';
            notification.style.padding = '15px';
            notification.style.borderRadius = '5px';
            notification.style.color = 'white';
            notification.style.fontWeight = 'bold';
            notification.style.zIndex = '10000';
            notification.style.boxShadow = '0 4px 8px rgba(0,0,0,0.2)';
            
            if (type === 'success') {
                notification.style.backgroundColor = '#28a745';
            } else {
                notification.style.backgroundColor = '#dc3545';
            }
            
            // Add to document
            document.body.appendChild(notification);
            
            // Remove after 3 seconds
            setTimeout(() => {
                if (notification.parentNode) {
                    notification.parentNode.removeChild(notification);
                }
            }, 3000);
        }
        
        // Show specific question
        function showQuestion(index) {
            // Hide all questions
            const questions = document.querySelectorAll('[id^="question_"]');
            questions.forEach(q => q.style.display = 'none');
            
            // Show the requested question
            const questionToShow = document.getElementById('question_' + index);
            if (questionToShow) {
                questionToShow.style.display = 'block';
            }
        }
        
        // Check answer and provide immediate feedback
        function checkAnswer(questionIndex, questionId, correctOption, nextIndex) {
            const selectedOption = document.querySelector('input[name="question_' + questionId + '"]:checked');
            const errorElement = document.getElementById('error_' + questionId);
            const feedbackElement = document.getElementById('feedback_' + questionId);
            
            // Hide any previous error messages
            if (errorElement) {
                errorElement.style.display = 'none';
            }
            
            if (!selectedOption) {
                // Show error message instead of alert
                if (errorElement) {
                    errorElement.style.display = 'block';
                }
                return false;
            }
            
            // Hide error message if an option is selected
            if (errorElement) {
                errorElement.style.display = 'none';
            }
            
            if (feedbackElement) {
                // Convert numeric option to letter (1->A, 2->B, 3->C, 4->D)
                let correctOptionLetter = correctOption;
                if (correctOption === '1') correctOptionLetter = 'A';
                else if (correctOption === '2') correctOptionLetter = 'B';
                else if (correctOption === '3') correctOptionLetter = 'C';
                else if (correctOption === '4') correctOptionLetter = 'D';
                
                // Convert selected option letter to number for comparison
                let selectedOptionNumber = selectedOption.value;
                if (selectedOption.value === 'A') selectedOptionNumber = '1';
                else if (selectedOption.value === 'B') selectedOptionNumber = '2';
                else if (selectedOption.value === 'C') selectedOptionNumber = '3';
                else if (selectedOption.value === 'D') selectedOptionNumber = '4';
                
                // Check if the selected answer matches the correct answer
                if (selectedOptionNumber === correctOption) {
                    feedbackElement.textContent = 'Correct! Well done.';
                    feedbackElement.className = 'feedback correct';
                } else {
                    feedbackElement.textContent = 'Incorrect. The correct answer is option ' + correctOptionLetter + '.';
                    feedbackElement.className = 'feedback incorrect';
                }
                feedbackElement.style.display = 'block';
            }
            
            // Move to next question or submit quiz
            if (nextIndex === -1) {
                // Submit quiz
                setTimeout(() => {
                    // alert('Quiz completed! In a real application, your answers would be saved and graded.');
                    showNotification('Quiz completed! In a real application, your answers would be saved and graded.', 'success');
                    closeQuiz();
                }, 1500);
            } else if (nextIndex >= 0) {
                // Show next question after a short delay to show feedback
                setTimeout(() => {
                    showQuestion(nextIndex);
                }, 1000);
            }
            
            return true;
        }
        
        // Prevent window switching during quiz
        window.addEventListener('blur', function() {
            if (document.body.classList.contains('quiz-active')) {
                // Show a visual indicator instead of alert to avoid loops
                const quizSection = document.getElementById('quizSection');
                if (quizSection) {
                    quizSection.style.border = '3px solid #ff0000';
                    setTimeout(() => {
                        quizSection.style.border = '2px solid var(--primary-green)';
                    }, 1000);
                }
            }
        });
        
        // Quiz form submission (for the submit button)
        document.getElementById('quizForm')?.addEventListener('submit', function(e) {
            e.preventDefault();
            alert('Quiz submitted successfully! In a real application, your answers would be saved and graded.');
            closeQuiz();
        });
    </script>
</body>
</html>