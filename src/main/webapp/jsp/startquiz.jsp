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
    <title>Quiz - <%= lesson != null ? lesson.getTitle() : "EcoLearn Platform" %></title>
    
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
            overflow-x: hidden;
        }
        
        .quiz-view {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            padding-top: 20px;
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
        
        /* Government Exam Style */
        .quiz-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-bottom: 1rem;
            border-bottom: 1px solid #e9ecef;
            margin-bottom: 1.5rem;
        }
        
        .question-text {
            font-size: 1.2rem;
            font-weight: 500;
            margin-bottom: 1rem;
        }
        
        .question-counter {
            font-weight: 500;
            color: #6c757d;
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
        
        .quiz-navigation {
            display: flex;
            justify-content: space-between;
            margin-top: 1rem;
        }
        
        .error-message {
            color: #dc3545;
            font-weight: 500;
            margin-top: 5px;
            display: none;
        }
        
        .result-section {
            display: none;
            text-align: center;
            padding: 2rem;
        }
        
        .result-title {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 1rem;
            color: var(--primary-green);
        }
        
        .points-display {
            font-size: 2rem;
            font-weight: 700;
            color: var(--accent-blue);
            margin: 1rem 0;
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
        
        /* Question Navigation Panel */
        .question-navigation-panel {
            position: fixed;
            left: 20px;
            top: 100px;
            background: linear-gradient(135deg, #3498db, #2c3e50);
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.3);
            z-index: 1000;
            min-height: 600px;
            height: auto;
            overflow-y: auto;
            width: 250px;
            color: white;
        }
        
        .navigation-title {
            text-align: center;
            font-weight: 700;
            margin-bottom: 20px;
            color: white;
            border-bottom: 2px solid rgba(255, 255, 255, 0.2);
            padding-bottom: 15px;
            font-size: 1.3rem;
        }
        
        /* Summary Section */
        .navigation-summary {
            margin-bottom: 20px;
            font-size: 0.9rem;
        }
        
        .summary-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 12px;
            padding: 8px 10px;
            border-radius: 8px;
            background: rgba(255, 255, 255, 0.1);
        }
        
        .summary-label {
            display: flex;
            align-items: center;
        }
        
        .summary-icon {
            margin-right: 8px;
            font-size: 1.1rem;
            width: 20px;
            text-align: center;
        }
        
        .summary-count {
            font-weight: 700;
            font-size: 1.1rem;
        }
        
        .not-answered-count { color: #ff6b6b; }
        .answered-count { color: #2ecc71; }
        .review-count { color: #f1c40f; }
        
        .question-nav-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 10px;
        }
        
        .question-nav-item {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            border: 3px solid #ddd;
            font-size: 1rem;
            position: relative;
            background: #f8f9fa;
            color: #333;
        }
        
        /* Status colors */
        .not-visited {
            background-color: #95a5a6;
            color: white;
            border-color: #95a5a6;
        }
        
        .not-answered {
            background-color: #e74c3c;
            color: white;
            border-color: #e74c3c;
        }
        
        .answered {
            background-color: #2ecc71;
            color: white;
            border-color: #2ecc71;
        }
        
        .marked-for-review {
            background-color: #f1c40f;
            color: #000;
            border-color: #f1c40f;
        }
        
        .current-question {
            background-color: #3498db;
            color: white;
            border-color: #fff;
            box-shadow: 0 0 0 3px #3498db, 0 0 0 6px rgba(255, 255, 255, 0.5);
            transform: scale(1.15);
        }
        
        /* Quiz-container */
        .quiz-container {
            background: white;
            border-radius: var(--border-radius-lg);
            box-shadow: var(--shadow-md);
            padding: var(--spacing-lg);
            margin-bottom: var(--spacing-lg);
            margin-left: 290px; /* Make space for navigation panel */
        }
    </style>
</head>
<body class="quiz-view">


    <div class="container main-content">
        <% if (errorMessage != null) { %>
        <!-- Error message -->
        <div class="page-header">
            <div class="row align-items-center">
                <div class="col-12">
                    <h1 class="page-title">
                        <i class="fas fa-exclamation-triangle me-2"></i>Error
                    </h1>
                    <p class="mb-0">
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
                    <p class="mb-0">
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
        <!-- Quiz content -->

        <!-- Question Navigation Panel -->
        <% if (questions != null && !questions.isEmpty()) { %>
        <div class="question-navigation-panel">
            <div class="navigation-title">Questions</div>
            
            <!-- Summary Section -->
            <div class="navigation-summary">
                <div class="summary-item">
                    <div class="summary-label">
                        <span class="summary-icon"><i class="fas fa-check"></i></span>
                        <span>Answered</span>
                    </div>
                    <span class="summary-count answered-count" id="answeredCount">0</span>
                </div>
                <div class="summary-item">
                    <div class="summary-label">
                        <span class="summary-icon"><i class="fas fa-times"></i></span>
                        <span>Not Answered</span>
                    </div>
                    <span class="summary-count not-answered-count" id="notAnsweredCount"><%= questions.size() %></span>
                </div>
                <div class="summary-item">
                    <div class="summary-label">
                        <span class="summary-icon"><i class="fas fa-flag"></i></span>
                        <span>Review</span>
                    </div>
                    <span class="summary-count review-count" id="reviewCount">0</span>
                </div>
            </div>
            
            <div class="question-nav-grid">
                <% for (int i = 0; i < questions.size(); i++) { %>
                <div class="question-nav-item not-visited" id="nav_<%= i %>" onclick="showQuestion(<%= i %>)">
                    <%= i + 1 %>
                </div>
                <% } %>
            </div>
        </div>
        <% } %>

        <!-- Quiz Container -->
        <% if (questions != null && !questions.isEmpty()) { %>
        <div class="quiz-container">
            <div class="quiz-header">
                <h2>
                    <i class="fas fa-question-circle me-2"></i>Quiz Questions
                </h2>
                <div class="question-counter">
                    Question <span id="currentQuestion">1</span> of <%= questions.size() %>
                </div>
            </div>
            
            <form id="quizForm">
                <% for (int i = 0; i < questions.size(); i++) {
                    Question question = questions.get(i);
                %>
                <div class="question-card" id="question_<%= i %>" style="<%= i > 0 ? "display: none;" : "" %>">
                    <div class="question-text">
                        <strong>Q<%= i + 1 %>.</strong> <%= question.getQuestionText() %>
                        <span class="float-end badge bg-primary"><%= questions != null && questions.size() > 0 ? (lesson != null && lesson.getPoints() != null ? Math.round((float)lesson.getPoints() / questions.size() * 100) / 100.0 : 1) : 1 %> points</span>
                    </div>
                    
                    <div class="mt-3">
                        <input type="radio" name="question_<%= question.getId() %>" id="q<%= question.getId() %>_a" value="A" class="option-input" required>
                        <label for="q<%= question.getId() %>_a" class="option-label">
                            (A) <%= question.getOption1() %>
                        </label>
                        
                        <input type="radio" name="question_<%= question.getId() %>" id="q<%= question.getId() %>_b" value="B" class="option-input">
                        <label for="q<%= question.getId() %>_b" class="option-label">
                            (B) <%= question.getOption2() %>
                        </label>
                        
                        <input type="radio" name="question_<%= question.getId() %>" id="q<%= question.getId() %>_c" value="C" class="option-input">
                        <label for="q<%= question.getId() %>_c" class="option-label">
                            (C) <%= question.getOption3() %>
                        </label>
                        
                        <input type="radio" name="question_<%= question.getId() %>" id="q<%= question.getId() %>_d" value="D" class="option-input">
                        <label for="q<%= question.getId() %>_d" class="option-label">
                            (D) <%= question.getOption4() %>
                        </label>
                    </div>
                    
                    <div class="error-message" id="error_<%= question.getId() %>">
                        Please select an answer before proceeding.
                    </div>
                    
                    <div class="quiz-navigation">
                        <% if (i > 0) { %>
                        <button type="button" class="btn btn-secondary" onclick="showQuestion(<%= i-1 %>)">
                            <i class="fas fa-arrow-left me-2"></i>Previous
                        </button>
                        <% } else { %>
                        <div></div> <!-- Empty div for spacing -->
                        <% } %>
                        
                        <% if (i < questions.size() - 1) { %>
                        <div>
                            <button type="button" class="btn btn-warning me-2" onclick="markForReview(<%= i %>, <%= i+1 %>)">
                                <i class="fas fa-bookmark me-1"></i>Mark Review
                            </button>
                            <button type="button" class="btn btn-primary" onclick="saveAndNext(<%= i %>, <%= i+1 %>)">
                                Save & Next<i class="fas fa-arrow-right ms-2"></i>
                            </button>
                        </div>
                        <% } else { %>
                        <div>
                            <button type="button" class="btn btn-warning me-2" onclick="markForReview(<%= i %>, -1)">
                                <i class="fas fa-bookmark me-1"></i>Mark Review
                            </button>
                            <button type="button" class="btn btn-success" onclick="saveAndNext(<%= i %>, -1)">
                                Save & Submit<i class="fas fa-paper-plane ms-2"></i>
                            </button>
                        </div>
                        <% } %>
                    </div>
                </div>
                <% } %>
                
                <!-- Result Section -->
                <div class="result-section" id="resultSection">
                    <h3 class="result-title">Quiz Completed</h3>
                    <p>You have successfully completed the quiz.</p>
                    <p>Your score:</p>
                    <div class="points-display">
                        <span id="pointsEarned">0</span> / <%= lesson != null && lesson.getPoints() != null ? lesson.getPoints() : questions.size() %> points
                    </div>
                    <p>Points per question: <%= questions != null && questions.size() > 0 ? (lesson != null && lesson.getPoints() != null ? Math.round((float)lesson.getPoints() / questions.size() * 100) / 100.0 : 1) : 1 %> points</p>
                    <div class="mt-4">
                        <a href="view-lesson.jsp?id=<%= lessonIdParam %>" class="btn btn-secondary me-2">
                            <i class="fas fa-arrow-left me-2"></i>Back to Lesson
                        </a>
                        <a href="lessons.jsp" class="btn btn-primary">
                            <i class="fas fa-graduation-cap me-2"></i>All Lessons
                        </a>
                    </div>
                </div>
            </form>
        </div>
        <% } else { %>
        <div class="alert alert-info text-center">
            <h4>No Quiz Available</h4>
            <p>This lesson does not have a quiz associated with it.</p>
            <a href="view-lesson.jsp?id=<%= lessonIdParam %>" class="btn btn-primary">
                <i class="fas fa-arrow-left me-2"></i>Back to Lesson
            </a>
        </div>
        <% } %>
        <% } %>
    </div>

    <!-- JavaScript Libraries -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Track answered questions and review questions
        let answeredQuestions = [];
        let reviewQuestions = [];
        let visitedQuestions = [];
        // Track selected answers for each question
        let selectedAnswers = {};
        

        
        // Show specific question
        function showQuestion(index) {
            // Hide all questions
            const questions = document.querySelectorAll('[id^="question_"]');
            questions.forEach(q => q.style.display = 'none');
            
            // Show the requested question
            const questionToShow = document.getElementById('question_' + index);
            if (questionToShow) {
                questionToShow.style.display = 'block';
                document.getElementById('currentQuestion').textContent = index + 1;
                
                // Mark as visited
                if (!visitedQuestions.includes(index)) {
                    visitedQuestions.push(index);
                }
                
                // Restore previously selected answer if exists
                if (selectedAnswers.hasOwnProperty('question_' + index)) {
                    const radioBtn = document.getElementById(selectedAnswers['question_' + index]);
                    if (radioBtn) {
                        radioBtn.checked = true;
                    }
                }
                
                // Force update navigation panel
                forceUpdateNavigationPanel(index);
            }
        }
        
        // Update navigation panel styles
        function updateNavigationPanel(currentIndex) {
            // This function is deprecated, use forceUpdateNavigationPanel instead
        }
        
        // Save and move to next question
        function saveAndNext(currentIndex, nextIndex) {
            const currentQuestionElement = document.querySelectorAll('[id^="question_"]')[currentIndex];
            const selectedOption = document.querySelector('input[name="question_' + 
                currentQuestionElement.querySelector('.option-input').name + '"]:checked');
            const errorElement = document.getElementById('error_' + 
                currentQuestionElement.querySelector('.option-input').name.split('_')[1]);
            
            // Hide any previous error messages
            if (errorElement) {
                errorElement.style.display = 'none';
            }
            
            // Mark as visited
            if (!visitedQuestions.includes(currentIndex)) {
                visitedQuestions.push(currentIndex);
            }
            
            // If an option is selected, save the answer
            if (selectedOption) {
                // Store the selected answer
                selectedAnswers['question_' + currentIndex] = selectedOption.id;
                if (!answeredQuestions.includes(currentIndex)) {
                    answeredQuestions.push(currentIndex);
                }
                console.log("Added question " + currentIndex + " to answeredQuestions. Size now: " + answeredQuestions.length);
                console.log("Answered questions array: ", answeredQuestions);
                // Remove from review if it was marked for review
                if (reviewQuestions.includes(currentIndex)) {
                    reviewQuestions = reviewQuestions.filter(q => q !== currentIndex);
                    console.log("Removed question " + currentIndex + " from reviewQuestions. Size now: " + reviewQuestions.length);
                }
            }
            // Note: We don't remove questions from answeredQuestions when no option is selected
            // because the question might have been answered previously and we don't want to
            // lose that status when navigating between questions
            
            // Force update navigation panel
            forceUpdateNavigationPanel(currentIndex);
            
            // If this is the last question, submit quiz
            if (nextIndex === -1) {
                submitQuiz();
            } else {
                // Show next question
                showQuestion(nextIndex);
            }
        }
        
        // Mark question for review and move to next
        function markForReview(currentIndex, nextIndex) {
            const currentQuestionElement = document.querySelectorAll('[id^="question_"]')[currentIndex];
            const selectedOption = document.querySelector('input[name="question_' + 
                currentQuestionElement.querySelector('.option-input').name + '"]:checked');
            
            // If an option is selected, save the answer
            if (selectedOption) {
                // Store the selected answer
                selectedAnswers['question_' + currentIndex] = selectedOption.id;
                if (!answeredQuestions.includes(currentIndex)) {
                    answeredQuestions.push(currentIndex);
                }
                console.log("Added question " + currentIndex + " to answeredQuestions. Size now: " + answeredQuestions.length);
                console.log("Answered questions array: ", answeredQuestions);
            }
            // Note: We don't remove questions from answeredQuestions when no option is selected
            // because the question might have been answered previously and we don't want to
            // lose that status when navigating between questions
            
            // Add to review set
            if (!reviewQuestions.includes(currentIndex)) {
                reviewQuestions.push(currentIndex);
            }
            console.log("Added question " + currentIndex + " to reviewQuestions. Size now: " + reviewQuestions.length);
            console.log("Review questions array: ", reviewQuestions);
            
            // Mark as visited
            if (!visitedQuestions.includes(currentIndex)) {
                visitedQuestions.push(currentIndex);
            }
            
            // Force update navigation panel
            forceUpdateNavigationPanel(currentIndex);
            
            // If this is the last question, submit quiz
            if (nextIndex === -1) {
                submitQuiz();
            } else {
                // Show next question
                showQuestion(nextIndex);
            }
        }
        
        // Force update navigation panel for all questions
        function forceUpdateNavigationPanel(currentIndex) {
            console.log("Updating navigation panel...");
            console.log("Answered questions: ", answeredQuestions);
            console.log("Review questions: ", reviewQuestions);
            console.log("Visited questions: ", visitedQuestions);
            
            // Get all navigation items
            const navItems = document.querySelectorAll('[id^="nav_"]');
            
            // Get current question index
            const currentQuestionIndex = typeof currentIndex !== 'undefined' ? currentIndex : 
                (document.getElementById('currentQuestion').textContent ? 
                 parseInt(document.getElementById('currentQuestion').textContent) - 1 : 0);
            console.log("Current question index: " + currentQuestionIndex);
            
            // Update each navigation item
            navItems.forEach((item, index) => {
                // Remove all status classes
                item.classList.remove('not-visited', 'not-answered', 'answered', 'marked-for-review', 'current-question');
                
                // Add appropriate class based on status
                // Order matters: current > answered > review > visited > not-visited
                if (index === currentQuestionIndex) {
                    item.classList.add('current-question');
                    console.log("Question " + index + " set to current (blue)");
                } else if (answeredQuestions.includes(index)) {
                    item.classList.add('answered');
                    console.log("Question " + index + " set to answered (green)");
                } else if (reviewQuestions.includes(index)) {
                    item.classList.add('marked-for-review');
                    console.log("Question " + index + " set to review (yellow)");
                } else if (visitedQuestions.includes(index)) {
                    item.classList.add('not-answered');
                    console.log("Question " + index + " set to not-answered (red)");
                } else {
                    item.classList.add('not-visited');
                    console.log("Question " + index + " set to not-visited (gray)");
                }
            });
            
            // Update summary counts
            document.getElementById('answeredCount').textContent = answeredQuestions.length;
            document.getElementById('notAnsweredCount').textContent = <%= questions != null ? questions.size() : 0 %> - answeredQuestions.length - reviewQuestions.length;
            document.getElementById('reviewCount').textContent = reviewQuestions.length;
            console.log("Summary updated - Answered: " + answeredQuestions.length + ", Not Answered: " + (<%= questions != null ? questions.size() : 0 %> - answeredQuestions.length - reviewQuestions.length) + ", Review: " + reviewQuestions.length);
        }
        
        // Submit quiz and show results
        function submitQuiz() {
            // Calculate points
            let points = 0;
            const totalQuestions = <%= questions != null ? questions.size() : 0 %>;
            
            // Calculate points per question
            const totalPoints = <%= lesson != null && lesson.getPoints() != null ? lesson.getPoints() : (questions != null ? questions.size() : 0) %>;
            const pointsPerQuestion = totalQuestions > 0 ? totalPoints / totalQuestions : 1;
            
            // Store correct answers (convert numeric to letter)
            const correctAnswers = {
                <% if (questions != null && !questions.isEmpty()) {
                    for (int i = 0; i < questions.size(); i++) {
                        Question question = questions.get(i);
                        // Convert numeric option to letter (1->A, 2->B, 3->C, 4->D)
                        int correctOption = question.getCorrectOption();
                        String correctOptionLetter = "";
                        if (correctOption == 1) correctOptionLetter = "A";
                        else if (correctOption == 2) correctOptionLetter = "B";
                        else if (correctOption == 3) correctOptionLetter = "C";
                        else if (correctOption == 4) correctOptionLetter = "D";
                %>
                'question_<%= question.getId() %>': '<%= correctOptionLetter %>',
                <% 
                    }
                } %>
            };
            
            // Check all answers
            for (let i = 0; i < totalQuestions; i++) {
                // Use stored answer if available, otherwise check currently selected
                let selectedOptionValue = null;
                
                if (selectedAnswers.hasOwnProperty('question_' + i)) {
                    // Get the value from the stored answer
                    const selectedId = selectedAnswers['question_' + i];
                    const selectedElement = document.getElementById(selectedId);
                    if (selectedElement) {
                        selectedOptionValue = selectedElement.value;
                    }
                } else {
                    // Check currently selected option
                    const questionElement = document.getElementById('question_' + i);
                    const questionName = questionElement.querySelector('.option-input').name;
                    const selectedOption = document.querySelector('input[name="' + questionName + '"]:checked');
                    if (selectedOption) {
                        selectedOptionValue = selectedOption.value;
                    }
                }
                
                const questionElement = document.getElementById('question_' + i);
                const questionName = questionElement.querySelector('.option-input').name;
                
                if (selectedOptionValue && selectedOptionValue === correctAnswers[questionName]) {
                    points += pointsPerQuestion; // Add points per question for correct answer
                }
            }
            
            // Round points to 2 decimal places
            points = Math.round(points * 100) / 100;
            
            // Show results
            document.querySelector('#quizForm > div:not(.result-section)').style.display = 'none';
            document.getElementById('resultSection').style.display = 'block';
            document.getElementById('pointsEarned').textContent = points;
            
            return true;
        }
        
        // Initialize the first question as current
        document.addEventListener('DOMContentLoaded', function() {
            // Mark the first question as visited
            if (!visitedQuestions.includes(0)) {
                visitedQuestions.push(0);
            }
            
            // Add event listeners to all radio buttons
            const radioButtons = document.querySelectorAll('.option-input');
            radioButtons.forEach(radio => {
                radio.addEventListener('change', function() {
                    // Find which question this radio button belongs to
                    const questionContainer = this.closest('.question-card');
                    if (questionContainer) {
                        const questionId = questionContainer.id;
                        const questionIndex = parseInt(questionId.split('_')[1]);
                        
                        // Mark as answered
                        if (!answeredQuestions.includes(questionIndex)) {
                            answeredQuestions.push(questionIndex);
                        }
                        
                        // Store the selected answer
                        selectedAnswers[questionId] = this.id;
                        
                        // Update navigation panel
                        forceUpdateNavigationPanel(questionIndex);
                    }
                });
            });
            
            showQuestion(0);
        });
    </script>
</body>
</html>