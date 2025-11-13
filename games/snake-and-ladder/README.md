# Snake and Ladder Quiz Game

## Overview
A fun educational game that combines the classic Snake and Ladder board game with quiz questions. Players answer questions to move around the board, with snakes sending them backward and ladders helping them advance.

## Features
- Traditional 1-100 board layout
- Quiz questions from database
- Snake and ladder mechanics
- Single-player mode
- Win condition at position 100

## Setup Instructions

### 1. Database Setup
1. Make sure MySQL is running
2. Access `http://localhost:8080/SIH3/jsp/create-database.jsp` to create the database and table
3. This will create the `ecolearn` database and `question_bank` table with sample questions

### 2. Verify Setup
1. Access `http://localhost:8080/SIH3/jsp/test-database-connection.jsp` to verify database connectivity
2. Access `http://localhost:8080/SIH3/jsp/test-game-components.jsp` to test all components

### 3. Play the Game
1. Access `http://localhost:8080/SIH3/jsp/snake-ladder-quiz.jsp` to play
2. Or go to `http://localhost:8080/SIH3/jsp/games.jsp` and click on the Snake and Ladder Quiz card

## Game Rules
1. Answer questions correctly to move +5 steps
2. Answer questions incorrectly to move -3 steps
3. Landing on a snake head sends you down
4. Landing on a ladder base sends you up
5. First to reach position 100 wins

## Troubleshooting
If you encounter issues:
1. Check `TROUBLESHOOTING.md` for common solutions
2. Verify database connection
3. Ensure all dependencies are installed
4. Check Tomcat logs for detailed error information

## Files
- `src/main/java/com/mycompany/sih3/servlet/QuestionServlet.java` - Fetches random questions
- `src/main/java/com/mycompany/sih3/servlet/UpdatePositionServlet.java` - Manages player position
- `src/main/webapp/jsp/snake-ladder-quiz.jsp` - Main game interface
- `src/main/webapp/jsp/games.jsp` - Game listing page

## Dependencies
- MySQL Connector/J
- Gson library
- Bootstrap 5
- Font Awesome