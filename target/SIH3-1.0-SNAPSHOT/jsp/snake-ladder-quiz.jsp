<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    // Set encoding explicitly
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");
    
    // Get lesson ID from parameter
    String lessonIdParam = request.getParameter("lessonId");
    Integer lessonId = null;
    if (lessonIdParam != null && !lessonIdParam.isEmpty()) {
        try {
            lessonId = Integer.parseInt(lessonIdParam);
        } catch (NumberFormatException e) {
            // Invalid lesson ID, will be handled in JavaScript
        }
    }
    
    // Initialize player position in session if not already set
    if (session.getAttribute("playerPosition") == null) {
        session.setAttribute("playerPosition", 1);
    }
    
    // Get player position from session
    Integer playerPosition = (Integer) session.getAttribute("playerPosition");
    
    // Check win condition
    boolean hasWon = playerPosition >= 100;
    if (hasWon) {
        session.setAttribute("playerPosition", 1); // Reset for next game
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
        
        .board-cell:hover {
            transform: scale(1.05);
            z-index: 1;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
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
            display: none;
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
        
        .option-label.selected {
            border-color: var(--player-color);
            background: rgba(52, 152, 219, 0.2);
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
            display: none;
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
        
        /* Start Game Button */
        #startGameBtn {
            background: linear-gradient(135deg, #27ae60, #2ecc71);
            border: none;
            padding: 12px 30px;
            font-size: 1.2rem;
            font-weight: bold;
            border-radius: 50px;
            box-shadow: 0 4px 15px rgba(39, 174, 96, 0.3);
            transition: all 0.3s ease;
        }
        
        #startGameBtn:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(39, 174, 96, 0.4);
        }
        
        #startGameBtn:active {
            transform: translateY(1px);
        }
    </style>
</head>
<body>
    <div class="game-container">
        <div class="game-header text-center">
            <h1><i class="fas fa-dice me-2"></i>Snake and Ladder Quiz Game</h1>
            <p class="lead">Answer questions correctly to move forward. Land on ladders to climb up, avoid snakes!</p>
            <!-- Welcome Message -->
            <div class="alert alert-info mt-3" id="welcomeMessage">
                <h4>Welcome to the Snake and Ladder Quiz Game!</h4>
                <p>Test your knowledge by answering questions correctly to move forward on the board.</p>
                <p>Click the "Start Game" button below to begin your adventure!</p>
                <% if (lessonId != null) { %>
                <p><strong>Lesson ID:</strong> <%= lessonId %></p>
                <% } %>
            </div>
            <!-- Start Game Button -->
            <button class="btn btn-primary btn-lg mt-3" id="startGameBtn" onclick="startGame()">
                <i class="fas fa-play me-2"></i>Start Game
            </button>
        </div>
        
        <% if (hasWon) { %>
        <div class="win-message" id="winMessage" style="display: block;">
            <h2><i class="fas fa-trophy me-2"></i>Congratulations! You Win!</h2>
            <p class="fs-4">You've successfully reached the end of the board!</p>
            <button class="btn btn-light btn-lg" onclick="restartGame()">
                <i class="fas fa-redo me-2"></i>Play Again
            </button>
        </div>
        <% } %>
        
        <div class="board-container">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h3>Game Board</h3>
                <div class="position-indicator">
                    <i class="fas fa-user me-2"></i>Position: <span id="playerPosition"><%= playerPosition %></span>/100
                </div>
            </div>
            
            <div class="game-board" id="gameBoard">
                <!-- Board will be generated by JavaScript -->
            </div>
        </div>
        
        <div class="question-container" id="questionContainer" style="display: none;">
            <div class="question-card">
                <h4 id="questionText" class="mb-4"></h4>
                <div id="optionsContainer">
                    <!-- Options will be populated by JavaScript -->
                </div>
                <div class="text-center mt-4">
                    <button class="btn btn-primary btn-lg" id="submitAnswer" disabled onclick="submitAnswer()">
                        <i class="fas fa-paper-plane me-2"></i>Submit Answer
                    </button>
                </div>
            </div>
        </div>
        
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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Game state
        let currentPlayerPosition = <%= playerPosition %>;
        let currentQuestion = null;
        let selectedOption = null;
        let gameStarted = false; // Track if game has started
        let lessonId = <%= lessonId != null ? lessonId : "null" %>; // Lesson ID from parameter
        
        // Snakes and ladders mappings
        const snakes = {
            99: 54,
            70: 55,
            52: 42,
            25: 2
        };
        
        const ladders = {
            6: 25,
            11: 40,
            60: 85,
            46: 90
        };
        
        // Start the game
        function startGame() {
            gameStarted = true;
            document.getElementById('startGameBtn').style.display = 'none';
            document.getElementById('welcomeMessage').style.display = 'none';
            initializeBoard();
            
            // Only show question if player hasn't won
            if (<%= !hasWon %>) {
                fetchQuestion();
            }
        }
        
        // Initialize the game board
        function initializeBoard() {
            const board = document.getElementById('gameBoard');
            board.innerHTML = '';
            
            // Create board cells (100 to 1)
            for (let row = 9; row >= 0; row--) {
                for (let col = 0; col < 10; col++) {
                    // Alternate row direction for snake and ladder board layout
                    let cellNumber;
                    if (row % 2 === 0) {
                        // Even rows: left to right
                        cellNumber = row * 10 + col + 1;
                    } else {
                        // Odd rows: right to left
                        cellNumber = row * 10 + (9 - col) + 1;
                    }
                    
                    const cell = document.createElement('div');
                    cell.className = 'board-cell';
                    cell.id = 'cell-' + cellNumber;
                    cell.innerHTML = '<span>' + cellNumber + '</span>';
                    
                    // Add snake or ladder indicators
                    if (snakes[cellNumber]) {
                        cell.classList.add('snake-cell');
                        cell.innerHTML += '<i class="fas fa-skull snake-icon"></i>';
                    } else if (ladders[cellNumber]) {
                        cell.classList.add('ladder-cell');
                        cell.innerHTML += '<i class="fas fa-arrow-up ladder-icon"></i>';
                    }
                    
                    // Add player indicator if this is the current position
                    if (cellNumber === currentPlayerPosition) {
                        const playerIndicator = document.createElement('div');
                        playerIndicator.className = 'player-position';
                        cell.appendChild(playerIndicator);
                    }
                    
                    board.appendChild(cell);
                }
            }
        }
        
        // Fetch a random question
        function fetchQuestion() {
            // Only fetch question if game has started
            if (!gameStarted) return;
            
            // Build URL with lesson ID if available
            let url = 'get-question.jsp';
            if (lessonId !== null) {
                url += '?lessonId=' + lessonId;
            }
            
            fetch(url)
                .then(response => {
                    // Log response details for debugging
                    console.log('Response status:', response.status);
                    console.log('Response headers:', [...response.headers.entries()]);
                    
                    if (!response.ok) {
                        throw new Error('HTTP error! status: ' + response.status);
                    }
                    return response.json();
                })
                .then(data => {
                    // Log received data for debugging
                    console.log('Received data:', data);
                    
                    if (data.error) {
                        alert('Error fetching question: ' + data.error);
                        console.error('Server error:', data.error);
                        return;
                    }
                    
                    // Ensure we have all required fields
                    if (!data.id) {
                        console.error('Missing question ID in response:', data);
                        alert('Error: Question data is incomplete. Please try again.');
                        return;
                    }
                    
                    // Ensure correctOption is a number
                    if (data.correctOption) {
                        data.correctOption = parseInt(data.correctOption);
                    }
                    
                    currentQuestion = data;
                    console.log('Current question set:', currentQuestion);
                    displayQuestion();
                    document.getElementById('questionContainer').style.display = 'block';
                })
                .catch(error => {
                    console.error('Fetch error:', error);
                    alert('Error fetching question. Please try again. Details: ' + error.message);
                });
        }
        
        // Display the question and options
        function displayQuestion() {
            console.log('Displaying question:', currentQuestion);
            
            // Check if we have all required data
            if (!currentQuestion) {
                console.error('No current question to display');
                return;
            }
            
            if (!currentQuestion.id) {
                console.error('Current question missing ID:', currentQuestion);
            }
            
            document.getElementById('questionText').textContent = currentQuestion.questionText;
            
            // Store the question ID for validation
            if (currentQuestion.id) {
                console.log('Question ID:', currentQuestion.id);
            }
            
            const optionsContainer = document.getElementById('optionsContainer');
            optionsContainer.innerHTML = '';
            
            // Log each option value for debugging
            console.log('Option1:', currentQuestion.option1);
            console.log('Option2:', currentQuestion.option2);
            console.log('Option3:', currentQuestion.option3);
            console.log('Option4:', currentQuestion.option4);
            
            // Also log the entire object structure to see what properties are available
            console.log('Full question object keys:', Object.keys(currentQuestion));
            
            const options = [
                { label: 'A', value: currentQuestion.option1 },
                { label: 'B', value: currentQuestion.option2 },
                { label: 'C', value: currentQuestion.option3 },
                { label: 'D', value: currentQuestion.option4 }
            ];
            
            options.forEach(option => {
                // Show all options, even if they appear empty (for debugging)
                const displayValue = option.value || '(empty option)';
                
                const label = document.createElement('label');
                label.className = 'option-label';
                // Use textContent for better encoding handling
                label.textContent = option.label + '. ' + displayValue;
                label.onclick = () => {
                    console.log('Option clicked:', option.label);
                    selectOption(label, option.label);
                };
                optionsContainer.appendChild(label);
            });
            
            selectedOption = null;
            document.getElementById('submitAnswer').disabled = true;
        }
        
        // Select an option
        function selectOption(label, option) {
            // Remove selected class from all labels
            document.querySelectorAll('.option-label').forEach(lbl => {
                lbl.classList.remove('selected');
            });
            
            // Add selected class to clicked label
            label.classList.add('selected');
            
            selectedOption = option;
            console.log('Option selected:', selectedOption);
            document.getElementById('submitAnswer').disabled = false;
        }
        
        // Submit the answer
        function submitAnswer() {
            if (!selectedOption) return;
            
            // Debug: Check if we have the question ID
            console.log('Current question object:', currentQuestion);
            if (!currentQuestion || !currentQuestion.id) {
                alert('Error: Question data is missing. Please try again.');
                return;
            }
            
            console.log('Sending validation request with:');
            console.log('Question ID:', currentQuestion.id);
            console.log('Selected option:', selectedOption);
            console.log('Player position:', currentPlayerPosition);
            
            // Properly encode parameters for URL
            const params = new URLSearchParams();
            params.append('questionId', currentQuestion.id);
            params.append('selectedOption', selectedOption);
            params.append('playerPosition', currentPlayerPosition);
            
            // Send the answer to the server for validation
            fetch('validate-answer.jsp', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: params.toString()
            })
            .then(response => {
                console.log('Validation response status:', response.status);
                return response.json();
            })
            .then(data => {
                console.log('Validation response data:', data);
                if (data.error) {
                    alert('Error: ' + data.error);
                    return;
                }
                
                // Update player position
                currentPlayerPosition = data.newPosition;
                document.getElementById('playerPosition').textContent = currentPlayerPosition;
                
                // Update session
                const sessionParams = new URLSearchParams();
                sessionParams.append('position', currentPlayerPosition);
                
                fetch('../updatePosition', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: sessionParams.toString()
                });
                
                // Hide question container
                document.getElementById('questionContainer').style.display = 'none';
                
                // Show popup message with correct answer from database
                const popupMessage = `
                    <div class="popup-overlay" style="position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); display: flex; justify-content: center; align-items: center; z-index: 10000;">
                        <div class="popup-content" style="background: white; padding: 30px; border-radius: 10px; max-width: 500px; text-align: center; box-shadow: 0 4px 20px rgba(0,0,0,0.3);">
                            <h3 style="margin-top: 0; color: ${data.isCorrect ? '#27ae60' : '#e74c3c'};">
                                ${data.message}
                            </h3>
                            <p><strong>Correct Answer:</strong> ${data.correctOptionLetter}. ${data.correctOptionText}</p>
                            <p>${data.isCorrect ? 
                                'You move forward 5 steps!' : 
                                'You move back 3 steps!'}</p>
                            <button onclick="this.closest('.popup-overlay').remove()" 
                                    style="background: #3498db; color: white; border: none; padding: 10px 20px; border-radius: 5px; cursor: pointer; margin-top: 20px;">
                                Continue
                            </button>
                        </div>
                    </div>
                `;
                
                // Add popup to document
                document.body.insertAdjacentHTML('beforeend', popupMessage);
                
                // Reinitialize board with new position after popup is closed
                setTimeout(() => {
                    // Remove popup if still exists
                    const popup = document.querySelector('.popup-overlay');
                    if (popup) {
                        popup.remove();
                    }
                    
                    initializeBoard();
                    
                    // Check win condition
                    if (currentPlayerPosition >= 100) {
                        setTimeout(() => {
                            location.reload(); // Reload to show win message
                        }, 2000);
                    } else {
                        // Fetch next question after a short delay
                        setTimeout(() => {
                            fetchQuestion();
                        }, 3000);
                    }
                }, 3000);
            })
            .catch(error => {
                console.error('Validation error:', error);
                alert('Error validating answer. Please try again.');
            });
        }
        
        // Restart the game
        function restartGame() {
            fetch('../updatePosition', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'position=1'
            }).then(() => {
                location.reload();
            });
        }
        
        // Initialize the game
        document.addEventListener('DOMContentLoaded', function() {
            // Initialize board but don't start game yet
            initializeBoard();
        });
    </script>
</body>
</html>
