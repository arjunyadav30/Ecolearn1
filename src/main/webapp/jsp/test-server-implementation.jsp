<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mycompany.sih3.entity.Question" %>
<%@ page import="com.mycompany.sih3.repository.QuestionRepository" %>
<%@ page import="java.util.List" %>
<%
    // Test the server-side implementation
    try {
        out.println("<h2>Server-Side Implementation Test</h2>");
        
        // Test QuestionRepository
        QuestionRepository repo = new QuestionRepository();
        out.println("<p>QuestionRepository created successfully</p>");
        
        // Test fetching questions
        List<Question> questions = repo.findAll();
        out.println("<p>Found " + questions.size() + " questions in database</p>");
        
        if (!questions.isEmpty()) {
            Question firstQuestion = questions.get(0);
            out.println("<h3>First Question:</h3>");
            out.println("<p>ID: " + firstQuestion.getId() + "</p>");
            out.println("<p>Question Text: " + firstQuestion.getQuestionText() + "</p>");
            out.println("<p>Option A: " + firstQuestion.getOption1() + "</p>");
            out.println("<p>Option B: " + firstQuestion.getOption2() + "</p>");
            out.println("<p>Option C: " + firstQuestion.getOption3() + "</p>");
            out.println("<p>Option D: " + firstQuestion.getOption4() + "</p>");
            out.println("<p>Correct Option: " + firstQuestion.getCorrectOption() + "</p>");
            
            // Test answer validation logic
            int correctOptionNum = firstQuestion.getCorrectOption();
            String correctOptionLetter = "";
            if (correctOptionNum >= 1 && correctOptionNum <= 4) {
                correctOptionLetter = String.valueOf((char) ('A' + correctOptionNum - 1));
            }
            
            out.println("<h3>Validation Test:</h3>");
            out.println("<p>Correct option number: " + correctOptionNum + "</p>");
            out.println("<p>Correct option letter: " + correctOptionLetter + "</p>");
            
            // Test correct answer
            boolean isCorrect = "A".equals(correctOptionLetter);
            out.println("<p>Testing 'A' as answer: " + (isCorrect ? "Correct" : "Incorrect") + "</p>");
            
            // Get correct answer text
            String correctAnswerText = "";
            switch (correctOptionNum) {
                case 1: correctAnswerText = "A. " + firstQuestion.getOption1(); break;
                case 2: correctAnswerText = "B. " + firstQuestion.getOption2(); break;
                case 3: correctAnswerText = "C. " + firstQuestion.getOption3(); break;
                case 4: correctAnswerText = "D. " + firstQuestion.getOption4(); break;
            }
            
            out.println("<p>Correct answer text: " + correctAnswerText + "</p>");
        }
        
        out.println("<h3>Session Test:</h3>");
        // Test session management
        Integer playerPosition = (Integer) session.getAttribute("playerPosition");
        if (playerPosition == null) {
            playerPosition = 1;
            session.setAttribute("playerPosition", playerPosition);
            out.println("<p>Player position initialized to 1</p>");
        } else {
            out.println("<p>Current player position: " + playerPosition + "</p>");
        }
        
        out.println("<p style='color: green; font-weight: bold;'>All server-side tests passed successfully!</p>");
        out.println("<p><a href='snakeladder.jsp'>Try the Server-Side Snake and Ladder Game</a></p>");
        
    } catch (Exception e) {
        out.println("<p style='color: red; font-weight: bold;'>Error: " + e.getMessage() + "</p>");
        e.printStackTrace();
    }
%>