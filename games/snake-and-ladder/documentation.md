# Snake and Ladder Quiz Game - Implementation Documentation

## Project Overview
This document describes the implementation of the Snake and Ladder Quiz Game, which integrates educational quizzes with the classic board game mechanics.

## Requirements Implementation

### 1. Game Structure
✅ **Implemented**: Traditional Snake and Ladder board (1-100 squares) styled with CSS Grid
✅ **Implemented**: Players move forward only if they answer quiz questions correctly
✅ **Implemented**: Snake and ladder mechanics
✅ **Implemented**: No dice used - quiz answers determine movement

### 2. Quiz Functionality
✅ **Implemented**: Questions stored in MySQL database (question_bank table)
✅ **Implemented**: Random question fetching via QuestionServlet
✅ **Implemented**: Question display in JSP
✅ **Implemented**: Answer checking with movement logic (+5 for correct, -3 for wrong)

### 3. Snakes & Ladders Rules
✅ **Implemented**: Snake mappings: 99→54, 70→55, 52→42, 25→2
✅ **Implemented**: Ladder mappings: 6→25, 11→40, 60→85, 46→90
✅ **Implemented**: Position checking after each move
✅ **Implemented**: Automatic position updates for snakes/ladders

### 4. Player System
✅ **Implemented**: Single-player mode
✅ **Implemented**: Player position tracking in HttpSession
✅ **Implemented**: Win condition at position 100

### 5. Frontend Implementation
✅ **Implemented**: JSP for dynamic question and game state rendering
✅ **Implemented**: Game board UI with player position highlighting
✅ **Implemented**: CSS Grid layout for 10x10 board
✅ **Implemented**: Question pop-up each turn

## Technical Architecture

### Servlets
1. **QuestionServlet** (`/question`)
   - Fetches random questions from database
   - Returns JSON response with question data
   - Handles error cases

2. **UpdatePositionServlet** (`/updatePosition`)
   - Updates player position in HttpSession
   - Handles POST requests with position parameter

### JSP Pages
1. **snake-ladder-quiz.jsp**
   - Main game interface
   - Board rendering with CSS Grid
   - Question display and interaction
   - Game state management

2. **games.jsp**
   - Game listing with Snake and Ladder Quiz card
   - Link to the main game page

### JavaScript Game Logic
- Board initialization with alternating row directions
- Snake and ladder visualization
- Player position tracking
- AJAX communication with servlets
- Move calculation and validation
- Win condition checking

### CSS Styling
- Responsive design with Bootstrap
- Custom styling for game elements
- Snake/ladder visual indicators
- Player position highlighting

## Database Schema

### question_bank Table
```sql
CREATE TABLE IF NOT EXISTS question_bank (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category VARCHAR(100) NOT NULL,
    question_text TEXT NOT NULL,
    option_a VARCHAR(500) NOT NULL,
    option_b VARCHAR(500) NOT NULL,
    option_c VARCHAR(500) NOT NULL,
    option_d VARCHAR(500) NOT NULL,
    correct_option CHAR(1) NOT NULL,
    difficulty_level ENUM('easy', 'medium', 'hard') DEFAULT 'medium',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_question_bank_category (category),
    INDEX idx_question_bank_difficulty (difficulty_level)
);
```

## Game Flow

1. **Initialization**
   - Player position set to 1 in session
   - Board rendered with CSS Grid
   - First question fetched automatically

2. **Game Loop**
   - Player answers question
   - Answer submitted via AJAX
   - Server validates answer
   - Position updated based on correctness
   - Snake/ladder checks performed
   - Board re-rendered with new position
   - Next question fetched

3. **Win Condition**
   - Player reaches position 100
   - Win message displayed
   - Option to restart game

## Movement Logic

### Correct Answer
1. Move player forward 5 positions
2. Check for snake head at new position
3. If snake found, move to tail position
4. Check for ladder base at new position
5. If ladder found, move to top position
6. Update session with final position

### Incorrect Answer
1. Move player backward 3 positions
2. Ensure position doesn't go below 1
3. Check for snake head at new position
4. If snake found, move to tail position
5. Check for ladder base at new position
6. If ladder found, move to top position
7. Update session with final position

## Error Handling

### Database Errors
- Connection failures logged and displayed to user
- Graceful degradation when questions unavailable

### Network Errors
- AJAX error handling with user notifications
- Retry mechanisms for failed requests

### Input Validation
- Position parameter validation
- Session state management
- Boundary checking for board positions

## Testing

### Unit Tests
- Question fetching from repository
- Snake/ladder position mapping
- Movement calculation logic
- Win condition detection

### Integration Tests
- Servlet request/response handling
- Session management
- Database connectivity
- Frontend-backend communication

## Deployment

### Dependencies
- MySQL Connector/J 8.0.33
- Gson 2.8.9
- Jakarta EE API
- Bootstrap 5
- Font Awesome 6.4.0

### Build Process
1. Compile Java sources
2. Package WAR file
3. Deploy to Tomcat server
4. Configure database connection
5. Verify servlet mappings

## Maintenance

### Adding New Questions
1. Insert into question_bank table
2. Ensure correct_option matches one of a/b/c/d
3. Set appropriate difficulty level
4. Assign relevant category

### Modifying Snakes/Ladders
1. Update JavaScript mappings in snake-ladder-quiz.jsp
2. Update informational display in game-info section
3. Test new positions don't conflict

### Customizing Game Rules
1. Modify movement values in submitAnswer function
2. Adjust win condition in JavaScript
3. Update UI text to reflect changes