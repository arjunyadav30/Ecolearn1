# Server-Side Answer Validation for Snake and Ladder Quiz

## Changes Made

1. **Created `validate-answer.jsp`**:
   - This new file handles answer validation on the server side
   - Receives question ID, selected option, and player position
   - Fetches the question from the database using QuestionRepository
   - Validates the answer by comparing with the correct option in the database
   - Calculates new player position based on correct/incorrect answer
   - Checks for snakes and ladders
   - Returns JSON response with validation results and correct answer text

2. **Modified `snake-ladder-quiz.jsp`**:
   - Updated the `submitAnswer()` function to send validation requests to the server
   - Removed client-side answer validation logic
   - The JavaScript now sends the selected option and question ID to the server
   - Displays popup with correct answer text from the database response

## How It Works

1. When a user selects an answer and clicks "Submit":
   - The JavaScript sends a POST request to `validate-answer.jsp`
   - The request includes:
     - `questionId`: The ID of the current question
     - `selectedOption`: The option selected by the user (A, B, C, or D)
     - `playerPosition`: Current position of the player on the board

2. Server-side validation in `validate-answer.jsp`:
   - Fetches the question from the database using QuestionRepository
   - Compares the selected option with the correct option from the database
   - Handles both number (1-4) and letter (A-D) formats for correctOption
   - Calculates new player position (±5 for correct, ±3 for incorrect)
   - Checks for snakes and ladders at the new position
   - Retrieves the correct option text from the database
   - Returns JSON response with:
     - `isCorrect`: Boolean indicating if the answer was correct
     - `newPosition`: The calculated new player position
     - `correctOptionLetter`: The letter of the correct option (A-D)
     - `correctOptionText`: The text of the correct option from the database
     - `message`: "Correct Answer!" or "Wrong Answer!"

3. Client-side response handling:
   - Updates the player position on the board
   - Shows a popup with the validation result and correct answer text
   - Moves to the next question after a delay

## Benefits

- **Security**: Answer validation happens on the server, preventing cheating
- **Accuracy**: Correct answers are fetched directly from the database
- **Consistency**: All validation logic is centralized on the server
- **Reliability**: No dependency on client-side JavaScript for critical game logic

## Testing

To test this implementation:

1. Deploy the application to a Tomcat server
2. Navigate to the snake-ladder-quiz.jsp page
3. Start the game and answer questions
4. Verify that:
   - Correct answers move the player forward 5 steps
   - Incorrect answers move the player back 3 steps
   - The popup always shows the correct answer text from the database
   - Snakes and ladders are properly handled
   - Player position is correctly updated in the session

## Files Modified

- `src/main/webapp/jsp/validate-answer.jsp` (new file)
- `src/main/webapp/jsp/snake-ladder-quiz.jsp` (modified)