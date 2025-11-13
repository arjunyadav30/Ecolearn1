 ,<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.mycompany.sih3.entity.Question" %>
<%@ page import="com.mycompany.sih3.repository.QuestionRepository" %>
<%
    // Set encoding explicitly
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");
    
    // Game state variables
    Integer playerPosition = (Integer) session.getAttribute("playerPosition");
    if (playerPosition == null) {
        playerPosition = 1;
        session.setAttribute("playerPosition", playerPosition);
    }
    
    // Check win condition
    boolean hasWon = playerPosition >= 100;
    if (hasWon) {
        session.setAttribute("playerPosition", 1); // Reset for next game
    }
    
    // Get lesson ID from parameter
    String lessonIdParam = request.getParameter("lessonId");
    Integer lessonId = null;
    if (lessonIdParam != null && !lessonIdParam.isEmpty()) {
        try {
            lessonId = Integer.parseInt(lessonIdParam);
        } catch (NumberFormatException e) {
            // Invalid lesson ID
        }
    }
    
    // Handle form submission
    String action = request.getParameter("action");
    Question currentQuestion = null;
    String errorMessage = null;
    String successMessage = null;
    String correctAnswerText = null;
    boolean showMessagePopup = false;
    boolean showContinueButton = false;
    
    // Snakes and ladders mappings
    Map<Integer, Integer> snakes = new HashMap<Integer, Integer>();
    snakes.put(99, 54);
    snakes.put(70, 55);
    snakes.put(52, 42);
    snakes.put(25, 2);
    
    Map<Integer, Integer> ladders = new HashMap<Integer, Integer>();
    ladders.put(6, 25);
    ladders.put(11, 40);
    ladders.put(60, 85);
    ladders.put(46, 90);
    
    if ("start".equals(action) && !hasWon) {
        // Fetch a random question
        try {
            QuestionRepository questionRepository = new QuestionRepository();
            List<Question> questions = null;
            
            if (lessonId != null) {
                questions = questionRepository.findByLessonId(lessonId);
            } else {
                questions = questionRepository.findAll();
            }
            
            if (questions != null && !questions.isEmpty()) {
                Random random = new Random();
                currentQuestion = questions.get(random.nextInt(questions.size()));
                session.setAttribute("currentQuestion", currentQuestion);
            } else {
                errorMessage = "No questions available.";
            }
        } catch (Exception e) {
            errorMessage = "Error fetching question: " + e.getMessage();
            e.printStackTrace();
        }
    } else if ("submit".equals(action)) {
        // Process answer submission
        try {
            currentQuestion = (Question) session.getAttribute("currentQuestion");
            String selectedOption = request.getParameter("selectedOption");
            
            // Debug information
            System.out.println("Submit action triggered");
            System.out.println("Current question: " + (currentQuestion != null ? currentQuestion.getId() : "null"));
            System.out.println("Selected option: " + selectedOption);
            
            // Validate input
            if (currentQuestion == null) {
                errorMessage = "No question found. Please start the game again.";
            } else if (selectedOption == null || selectedOption.trim().isEmpty()) {
                errorMessage = "Please select an option before submitting.";
            } else {
                // Validate the answer
                int correctOptionNum = currentQuestion.getCorrectOption();
                String correctOptionLetter = "";
                
                // Convert correct option number to letter
                if (correctOptionNum >= 1 && correctOptionNum <= 4) {
                    correctOptionLetter = String.valueOf((char) ('A' + correctOptionNum - 1));
                }
                
                System.out.println("Correct option number: " + correctOptionNum);
                System.out.println("Correct option letter: " + correctOptionLetter);
                
                // Check if answer is correct
                boolean isCorrect = false;
                if (selectedOption.matches("[A-D]")) {
                    // Selected option is a letter
                    isCorrect = selectedOption.equals(correctOptionLetter);
                } else if (selectedOption.matches("[1-4]")) {
                    // Selected option is a number
                    int selectedNum = Integer.parseInt(selectedOption);
                    isCorrect = (selectedNum == correctOptionNum);
                }
                
                System.out.println("Selected option: " + selectedOption);
                System.out.println("Is correct: " + isCorrect);
                
                // Calculate new position
                int newPosition = playerPosition;
                if (isCorrect) {
                    newPosition += 5; // Move forward 5 steps for correct answer
                    successMessage = "Correct Answer! You move forward 5 steps!";
                } else {
                    newPosition -= 3; // Move backward 3 steps for wrong answer
                    successMessage = "Wrong Answer! You move back 3 steps!";
                }
                
                // Ensure position is within bounds
                newPosition = Math.max(1, Math.min(100, newPosition));
                
                // Check for snakes or ladders
                if (snakes.containsKey(newPosition)) {
                    int snakeEnd = snakes.get(newPosition);
                    successMessage += " Oh no! You landed on a snake and moved from " + newPosition + " to " + snakeEnd + "!";
                    newPosition = snakeEnd;
                } else if (ladders.containsKey(newPosition)) {
                    int ladderEnd = ladders.get(newPosition);
                    successMessage += " Great! You climbed a ladder from " + newPosition + " to " + ladderEnd + "!";
                    newPosition = ladderEnd;
                }
                
                // Update player position
                playerPosition = newPosition;
                session.setAttribute("playerPosition", playerPosition);
                
                // Get correct answer text
                switch (correctOptionNum) {
                    case 1: correctAnswerText = "A. " + currentQuestion.getOption1(); break;
                    case 2: correctAnswerText = "B. " + currentQuestion.getOption2(); break;
                    case 3: correctAnswerText = "C. " + currentQuestion.getOption3(); break;
                    case 4: correctAnswerText = "D. " + currentQuestion.getOption4(); break;
                    default: correctAnswerText = "Unknown option";
                }
                
                System.out.println("Correct answer text: " + correctAnswerText);
                
                // Set flag to show popup message
                showMessagePopup = true;
                showContinueButton = true;
                
                // Clear current question from session
                session.removeAttribute("currentQuestion");
            }
        } catch (Exception e) {
            errorMessage = "Error processing answer: " + e.getMessage();
            e.printStackTrace();
        }
    } else if ("continue".equals(action)) {
        // Continue to next question after viewing popup
        showMessagePopup = false;
        showContinueButton = false;
        
        // Fetch next question if not won and player position < 100
        if (playerPosition < 100) {
            try {
                QuestionRepository questionRepository = new QuestionRepository();
                List<Question> questions = null;
                
                if (lessonId != null) {
                    questions = questionRepository.findByLessonId(lessonId);
                } else {
                    questions = questionRepository.findAll();
                }
                
                if (questions != null && !questions.isEmpty()) {
                    Random random = new Random();
                    Question nextQuestion = questions.get(random.nextInt(questions.size()));
                    session.setAttribute("currentQuestion", nextQuestion);
                    currentQuestion = nextQuestion;
                }
            } catch (Exception e) {
                errorMessage = "Error fetching next question: " + e.getMessage();
                e.printStackTrace();
            }
        }
    } else if ("restart".equals(action)) {
        // Restart game
        session.setAttribute("playerPosition", 1);
        session.removeAttribute("currentQuestion");
        response.sendRedirect("snakeladder.jsp" + (lessonId != null ? "?lessonId=" + lessonId : ""));
        return;
    } else {
        // Load current question from session if exists
        currentQuestion = (Question) session.getAttribute("currentQuestion");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Snake and Ladder Quiz Game</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --snake-color: #e74c3c;
            --ladder-color: #27ae60;
            --player-color: #3498db;
            --board-bg: #f8f9fa;
            --cell-bg: #ffffff;
            --cell-border: #dee2e6;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .game-container {
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .game-header {
            background: rgba(255, 255, 255, 0.9);
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
        }
        
        .board-container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }
        
        .game-board {
            display: grid;
            grid-template-columns: repeat(10, 1fr);
            gap: 2px;
            background-color: var(--board-bg);
            border: 2px solid var(--cell-border);
            border-radius: 10px;
            overflow: hidden;
            margin: 0 auto;
            max-width: 600px;
        }
        
        .board-cell {
            aspect-ratio: 1;
            background-color: var(--cell-bg);
            border: 1px solid var(--cell-border);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            position: relative;
            transition: all 0.3s ease;
        }
        
        .snake-cell {
            background-color: rgba(231, 76, 60, 0.2);
        }
        
        .ladder-cell {
            background-color: rgba(39, 174, 96, 0.2);
        }
        
        .player-position {
            position: absolute;
            width: 20px;
            height: 20px;
            background-color: var(--player-color);
            border-radius: 50%;
            border: 2px solid white;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
            z-index: 2;
        }
        
        .question-container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 20px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }
        
        .question-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }
        
        .option-label {
            display: block;
            padding: 12px;
            margin: 10px 0;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            background: white;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .option-label:hover {
            border-color: var(--player-color);
            background: rgba(52, 152, 219, 0.1);
        }
        
        .game-info {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }
        
        .win-message {
            background: linear-gradient(135deg, #27ae60, #2ecc71);
            color: white;
            border-radius: 15px;
            padding: 40px;
            text-align: center;
            margin: 20px 0;
        }
        
        .snake-icon, .ladder-icon {
            position: absolute;
            font-size: 12px;
            bottom: 2px;
            right: 2px;
        }
        
        .snake-icon {
            color: var(--snake-color);
        }
        
        .ladder-icon {
            color: var(--ladder-color);
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea, #764ba2);
            border: none;
            padding: 10px 20px;
            font-weight: bold;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }
        
        .position-indicator {
            font-size: 1.2rem;
            font-weight: bold;
            color: var(--player-color);
        }
        
        .message {
            padding: 15px;
            margin: 15px 0;
            border-radius: 5px;
        }
        
        .error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        /* Popup Styles */
        .popup-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 10000;
        }
        
        .popup-content {
            background: white;
            padding: 30px;
            border-radius: 10px;
            max-width: 500px;
            text-align: center;
            box-shadow: 0 4px 20px rgba(0,0,0,0.3);
        }
        
        .popup-content h3 {
            margin-top: 0;
        }
        
        .correct {
            color: #27ae60;
        }
        
        .wrong {
            color: #e74c3c;
        }
        
        .btn-continue {
            margin-top: 20px;
            padding: 10px 20px;
            background: #3498db;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }
        
        .btn-continue:hover {
            background: #2980b9;
        }
    </style>
</head>
<body>
    <div class="game-container">
        <div class="game-header text-center">
            <h1><i class="fas fa-dice me-2"></i>Snake and Ladder Quiz Game</h1>
            <p class="lead">Answer questions correctly to move forward. Land on ladders to climb up, avoid snakes!</p>
            
            <!-- Welcome Message -->
            <div class="alert alert-info mt-3">
                <h4>Welcome to the Snake and Ladder Quiz Game!</h4>
                <p>Test your knowledge by answering questions correctly to move forward on the board.</p>
                <% if (lessonId != null) { %>
                <p><strong>Lesson ID:</strong> <%= lessonId %></p>
                <% } %>
            </div>
            
            <!-- Messages -->
            <% if (errorMessage != null) { %>
            <div class="message error">
                <strong>Error:</strong> <%= errorMessage %>
            </div>
            <% } %>
            
            <!-- Start Game Button -->
            <% if (playerPosition < 100 && currentQuestion == null && !showMessagePopup) { %>
            <form method="post" style="display: inline;">
                <input type="hidden" name="action" value="start">
                <% if (lessonId != null) { %>
                <input type="hidden" name="lessonId" value="<%= lessonId %>">
                <% } %>
                <button class="btn btn-primary btn-lg mt-3" type="submit">
                    <i class="fas fa-play me-2"></i>Start Game
                </button>
            </form>
            <% } %>
        </div>
        
        <% if (hasWon) { %>
        <div class="win-message">
            <h2><i class="fas fa-trophy me-2"></i>Congratulations! You Win!</h2>
            <p class="fs-4">You've successfully reached the end of the board!</p>
            <form method="post">
                <input type="hidden" name="action" value="restart">
                <% if (lessonId != null) { %>
                <input type="hidden" name="lessonId" value="<%= lessonId %>">
                <% } %>
                <button class="btn btn-light btn-lg" type="submit">
                    <i class="fas fa-redo me-2"></i>Play Again
                </button>
            </form>
        </div>
        <% } %>
        
        <!-- Popup Message -->
        <% if (showMessagePopup && successMessage != null) { %>
        <div class="popup-overlay">
            <div class="popup-content">
                <h3 class="<%= successMessage.startsWith("Correct") ? "correct" : "wrong" %>">
                    <%= successMessage %>
                </h3>
                <% if (correctAnswerText != null) { %>
                <p><strong>Correct Answer:</strong> <%= correctAnswerText %></p>
                <% } %>
                
                <form method="post">
                    <input type="hidden" name="action" value="continue">
                    <% if (lessonId != null) { %>
                    <input type="hidden" name="lessonId" value="<%= lessonId %>">
                    <% } %>
                    <button class="btn-continue" type="submit">Continue to Next Question</button>
                </form>
            </div>
        </div>
        <% } %>
        
        <div class="board-container">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h3>Game Board</h3>
                <div class="position-indicator">
                    <i class="fas fa-user me-2"></i>Position: <span id="playerPosition"><%= playerPosition %></span>/100
                </div>
            </div>
            
            <div class="game-board">
                <% 
                // Create board cells (100 to 1)
                for (int row = 9; row >= 0; row--) {
                    for (int col = 0; col < 10; col++) {
                        // Alternate row direction for snake and ladder board layout
                        int cellNumber;
                        if (row % 2 == 0) {
                            // Even rows: left to right
                            cellNumber = row * 10 + col + 1;
                        } else {
                            // Odd rows: right to left
                            cellNumber = row * 10 + (9 - col) + 1;
                        }
                        
                        // Add snake or ladder indicators
                        boolean isSnake = snakes.containsKey(cellNumber);
                        boolean isLadder = ladders.containsKey(cellNumber);
                        boolean isPlayerHere = (cellNumber == playerPosition);
                %>
                <div class="board-cell <%= isSnake ? "snake-cell" : "" %> <%= isLadder ? "ladder-cell" : "" %>" id="cell-<%= cellNumber %>">
                    <span><%= cellNumber %></span>
                    <% if (isSnake) { %>
                    <i class="fas fa-skull snake-icon"></i>
                    <% } else if (isLadder) { %>
                    <i class="fas fa-arrow-up ladder-icon"></i>
                    <% } %>
                    
                    <% if (isPlayerHere) { %>
                    <div class="player-position"></div>
                    <% } %>
                </div>
                <% 
                    }
                }
                %>
            </div>
        </div>
        
        <% if (playerPosition < 100 && currentQuestion != null && !showMessagePopup) { %>
        <div class="question-container">
            <div class="question-card">
                <h4 class="mb-4"><%= currentQuestion.getQuestionText() %></h4>
                <form method="post">
                    <input type="hidden" name="action" value="submit">
                    <% if (lessonId != null) { %>
                    <input type="hidden" name="lessonId" value="<%= lessonId %>">
                    <% } %>
                    
                    <div>
                        <label class="option-label">
                            <input type="radio" name="selectedOption" value="A" required> 
                            A. <%= currentQuestion.getOption1() %>
                        </label>
                        <label class="option-label">
                            <input type="radio" name="selectedOption" value="B" required> 
                            B. <%= currentQuestion.getOption2() %>
                        </label>
                        <label class="option-label">
                            <input type="radio" name="selectedOption" value="C" required> 
                            C. <%= currentQuestion.getOption3() %>
                        </label>
                        <label class="option-label">
                            <input type="radio" name="selectedOption" value="D" required> 
                            D. <%= currentQuestion.getOption4() %>
                        </label>
                    </div>
                    
                    <div class="text-center mt-4">
                        <button class="btn btn-primary btn-lg" type="submit">
                            <i class="fas fa-paper-plane me-2"></i>Submit Answer
                        </button>
                    </div>
                </form>
            </div>
        </div>
        <% } %>
        
        <div class="game-info">
            <div class="row">
                <div class="col-md-4 mb-3 mb-md-0">
                    <div class="card h-100">
                        <div class="card-body text-center">
                            <i class="fas fa-question-circle fa-2x text-primary mb-2"></i>
                            <h5>How to Play</h5>
                            <p class="mb-0">Answer questions correctly to move +5 steps. Wrong answers move you -3 steps.</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 mb-3 mb-md-0">
                    <div class="card h-100">
                        <div class="card-body text-center">
                            <i class="fas fa-arrow-up fa-2x text-success mb-2"></i>
                            <h5>Ladders</h5>
                            <p class="mb-0">Land on 6→25, 11→40, 46→90, 60→85</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card h-100">
                        <div class="card-body text-center">
                            <i class="fas fa-arrow-down fa-2x text-danger mb-2"></i>
                            <h5>Snakes</h5>
                            <p class="mb-0">Land on 25→2, 52→42, 70→55, 99→54</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>