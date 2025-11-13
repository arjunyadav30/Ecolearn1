# Snake and Ladder Quiz - Debugging Guide

## Overview
This guide explains the changes made to implement server-side answer validation and provides steps to debug any remaining issues.

## Changes Made

### 1. Server-Side Validation Endpoint
- Created `validate-answer.jsp` to handle answer validation on the server
- This endpoint receives question ID, selected option, and player position
- Fetches the question from the database and validates the answer
- Returns detailed JSON response with validation results

### 2. Client-Side Modifications
- Updated `snake-ladder-quiz.jsp` to send validation requests to the server
- Removed client-side answer validation logic
- Added better error handling and debugging logs

### 3. Enhanced Logging
- Added comprehensive logging to both `get-question.jsp` and `validate-answer.jsp`
- Added debugging information to help identify issues

## Testing Steps

### 1. Test Database Connection
Navigate to `test-db-connection.jsp` to verify:
- Database connection is working
- Questions can be fetched from the database
- QuestionRepository methods are functioning correctly

### 2. Test Question Fetching
Navigate to `test-get-question.jsp` to verify:
- `get-question.jsp` endpoint is returning valid JSON
- Question data includes all required fields (including ID)

### 3. Test Direct Validation
Navigate to `test-direct-validation.jsp` to verify:
- Question data can be processed correctly
- Validation logic works as expected
- Correct option text can be retrieved

### 4. Test Validation Endpoint
Navigate to `test-validate-answer.jsp` to verify:
- `validate-answer.jsp` endpoint accepts parameters correctly
- Validation logic works with real data
- JSON response is properly formatted

### 5. Test Full Game Flow
Play the Snake and Ladder quiz game:
- Start the game
- Answer questions
- Verify that:
  - Correct answers move player forward 5 steps
  - Incorrect answers move player back 3 steps
  - Popup shows correct answer from database
  - Snakes and ladders work correctly

## Common Issues and Solutions

### 1. "Question not found" Error
- Check that questions exist in the database
- Verify that question IDs are being passed correctly
- Check database connection settings in QuestionRepository

### 2. "Missing question ID" Error
- Verify that `get-question.jsp` is returning the question ID
- Check browser console for JavaScript errors
- Ensure `currentQuestion.id` is properly set

### 3. "Invalid correct option" Error
- Check that correctOption field in database contains valid values (1-4)
- Verify that database records are properly formatted

### 4. Correct Answer Not Displaying
- Check that option text fields are populated in the database
- Verify that the correct option number maps to the correct option text
- Check browser console for JavaScript errors

## Debugging Tools

### 1. Browser Developer Tools
- Open browser console to see JavaScript logs
- Check network tab to see requests and responses
- Look for any error messages

### 2. Server Logs
- Check Tomcat logs for any error messages
- Look for stack traces in the console output
- Check System.out.println statements in JSP files

### 3. Database Verification
- Verify that questions table contains data
- Check that correctOption field contains valid values (1-4)
- Ensure option1-option4 fields contain text

## Files Created for Testing

1. `debug-question.jsp` - Simple question fetch test
2. `test-db-connection.jsp` - Database connection and repository test
3. `test-direct-validation.jsp` - Direct validation logic test
4. `test-get-question.jsp` - Test get-question endpoint
5. `test-validate-answer.jsp` - Test validate-answer endpoint

## Expected Behavior

When everything is working correctly:
- Questions should load when starting the game
- Correct answers should move player forward 5 steps
- Incorrect answers should move player back 3 steps
- Popup should always show the correct answer text from the database
- Snakes should move player backward
- Ladders should move player forward
- Player position should be updated in session