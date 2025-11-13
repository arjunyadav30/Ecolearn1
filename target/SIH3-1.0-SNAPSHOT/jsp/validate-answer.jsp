<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mycompany.sih3.entity.Question" %>
<%@ page import="com.mycompany.sih3.repository.QuestionRepository" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="com.google.gson.GsonBuilder" %>
<%
    // Set response encoding explicitly
    response.setCharacterEncoding("UTF-8");
    response.setContentType("application/json; charset=UTF-8");
    
    // Disable caching
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
    
    try {
        // Get parameters
        String questionIdParam = request.getParameter("questionId");
        String selectedOptionParam = request.getParameter("selectedOption");
        String playerPositionParam = request.getParameter("playerPosition");
        
        System.out.println("=== Validate Answer Called ===");
        System.out.println("Question ID: " + questionIdParam);
        System.out.println("Selected option: " + selectedOptionParam);
        System.out.println("Player position: " + playerPositionParam);
        
        // Validate parameters
        if (questionIdParam == null || questionIdParam.isEmpty()) {
            System.out.println("ERROR: Missing questionId parameter");
            out.print("{\"error\":\"Missing question ID parameter\"}");
            out.flush();
            return;
        }
        
        if (selectedOptionParam == null || selectedOptionParam.isEmpty()) {
            System.out.println("ERROR: Missing selectedOption parameter");
            out.print("{\"error\":\"Missing selected option parameter\"}");
            out.flush();
            return;
        }
        
        int questionId = 0;
        try {
            questionId = Integer.parseInt(questionIdParam);
        } catch (NumberFormatException e) {
            System.out.println("ERROR: Invalid question ID format: " + questionIdParam);
            out.print("{\"error\":\"Invalid question ID format\"}");
            out.flush();
            return;
        }
        
        String selectedOption = selectedOptionParam.trim().toUpperCase();
        int playerPosition = 1;
        if (playerPositionParam != null && !playerPositionParam.isEmpty()) {
            try {
                playerPosition = Integer.parseInt(playerPositionParam);
            } catch (NumberFormatException e) {
                System.out.println("WARNING: Invalid player position format, using default value 1");
                playerPosition = 1;
            }
        }
        
        System.out.println("Parsed values - Question ID: " + questionId + ", Selected option: " + selectedOption + ", Player position: " + playerPosition);
        
        // Fetch question from database
        QuestionRepository questionRepository = new QuestionRepository();
        System.out.println("Fetching question with ID: " + questionId);
        Question question = questionRepository.findById(questionId);
        
        if (question == null) {
            System.out.println("ERROR: Question not found with ID: " + questionId);
            out.print("{\"error\":\"Question not found with ID: " + questionId + "\"}");
            out.flush();
            return;
        }
        
        System.out.println("Question found:");
        System.out.println("  ID: " + question.getId());
        System.out.println("  Lesson ID: " + question.getLessonId());
        System.out.println("  Question text: " + question.getQuestionText());
        System.out.println("  Correct option: " + question.getCorrectOption());
        System.out.println("  Option 1: " + question.getOption1());
        System.out.println("  Option 2: " + question.getOption2());
        System.out.println("  Option 3: " + question.getOption3());
        System.out.println("  Option 4: " + question.getOption4());
        
        // Validate the answer
        boolean isCorrect = false;
        int correctOptionNum = question.getCorrectOption();
        String correctOptionLetter = "";
        
        // Convert correct option number to letter
        if (correctOptionNum >= 1 && correctOptionNum <= 4) {
            correctOptionLetter = String.valueOf((char) ('A' + correctOptionNum - 1));
        } else {
            System.out.println("ERROR: Invalid correct option number: " + correctOptionNum);
            out.print("{\"error\":\"Invalid correct option in database\"}");
            out.flush();
            return;
        }
        
        System.out.println("Correct option letter: " + correctOptionLetter);
        System.out.println("Selected option: " + selectedOption);
        
        // Check if answer is correct (handle both number and letter formats)
        if (selectedOption.matches("[A-D]")) {
            // Selected option is a letter
            isCorrect = selectedOption.equals(correctOptionLetter);
            System.out.println("Comparing letters: " + selectedOption + " == " + correctOptionLetter + " = " + isCorrect);
        } else if (selectedOption.matches("[1-4]")) {
            // Selected option is a number
            int selectedNum = Integer.parseInt(selectedOption);
            isCorrect = (selectedNum == correctOptionNum);
            System.out.println("Comparing numbers: " + selectedNum + " == " + correctOptionNum + " = " + isCorrect);
        } else {
            System.out.println("ERROR: Invalid selected option format: " + selectedOption);
            out.print("{\"error\":\"Invalid selected option format\"}");
            out.flush();
            return;
        }
        
        System.out.println("Is correct: " + isCorrect);
        
        // Calculate new position
        int newPosition = playerPosition;
        if (isCorrect) {
            newPosition += 5; // Move forward 5 steps for correct answer
            System.out.println("Correct answer! Moving from " + playerPosition + " to " + newPosition);
        } else {
            newPosition -= 3; // Move backward 3 steps for wrong answer
            System.out.println("Wrong answer! Moving from " + playerPosition + " to " + newPosition);
        }
        
        // Ensure position is within bounds
        newPosition = Math.max(1, Math.min(100, newPosition));
        System.out.println("Position after bounds check: " + newPosition);
        
        // Define snakes and ladders
        int[] snakesFrom = {99, 70, 52, 25};
        int[] snakesTo = {54, 55, 42, 2};
        int[] laddersFrom = {6, 11, 60, 46};
        int[] laddersTo = {25, 40, 85, 90};
        
        // Check for snakes or ladders
        boolean movedBySnakeOrLadder = false;
        for (int i = 0; i < snakesFrom.length; i++) {
            if (newPosition == snakesFrom[i]) {
                System.out.println("Landed on snake at " + snakesFrom[i] + ", moving to " + snakesTo[i]);
                newPosition = snakesTo[i];
                movedBySnakeOrLadder = true;
                break;
            }
        }
        
        if (!movedBySnakeOrLadder) {
            for (int i = 0; i < laddersFrom.length; i++) {
                if (newPosition == laddersFrom[i]) {
                    System.out.println("Landed on ladder at " + laddersFrom[i] + ", moving to " + laddersTo[i]);
                    newPosition = laddersTo[i];
                    break;
                }
            }
        }
        
        // Get the correct option text
        String correctOptionText = "";
        switch (correctOptionNum) {
            case 1: correctOptionText = question.getOption1(); break;
            case 2: correctOptionText = question.getOption2(); break;
            case 3: correctOptionText = question.getOption3(); break;
            case 4: correctOptionText = question.getOption4(); break;
            default: correctOptionText = "Unknown option";
        }
        
        System.out.println("Correct option text: " + correctOptionText);
        
        // Prepare response
        StringBuilder jsonResponse = new StringBuilder();
        jsonResponse.append("{");
        jsonResponse.append("\"isCorrect\":").append(isCorrect).append(",");
        jsonResponse.append("\"newPosition\":").append(newPosition).append(",");
        jsonResponse.append("\"correctOptionLetter\":\"").append(correctOptionLetter).append("\",");
        jsonResponse.append("\"correctOptionText\":\"").append(correctOptionText != null ? correctOptionText : "").append("\",");
        jsonResponse.append("\"message\":\"").append(isCorrect ? "Correct Answer!" : "Wrong Answer!").append("\"");
        jsonResponse.append("}");
        
        System.out.println("Sending JSON response: " + jsonResponse.toString());
        out.print(jsonResponse.toString());
        out.flush();
        
    } catch (Exception e) {
        e.printStackTrace();
        System.out.println("Validation error: " + e.getMessage());
        out.print("{\"error\":\"Validation error: " + e.getMessage() + "\"}");
        out.flush();
    }
    
    System.out.println("=== Validate Answer Completed ===");
%>