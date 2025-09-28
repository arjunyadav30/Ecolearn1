<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mycompany.sih3.entity.Question" %>
<%@ page import="com.mycompany.sih3.repository.QuestionRepository" %>
<%
    try {
        out.println("<h2>Direct Validation Test</h2>");
        
        // Fetch a question
        QuestionRepository repo = new QuestionRepository();
        Question question = repo.findById(1);
        
        if (question != null) {
            out.println("<h3>Question Details:</h3>");
            out.println("<p>ID: " + question.getId() + "</p>");
            out.println("<p>Question Text: " + question.getQuestionText() + "</p>");
            out.println("<p>Option 1: " + question.getOption1() + "</p>");
            out.println("<p>Option 2: " + question.getOption2() + "</p>");
            out.println("<p>Option 3: " + question.getOption3() + "</p>");
            out.println("<p>Option 4: " + question.getOption4() + "</p>");
            out.println("<p>Correct Option: " + question.getCorrectOption() + "</p>");
            
            // Validate answer
            int correctOptionNum = question.getCorrectOption();
            String correctOptionLetter = "";
            if (correctOptionNum >= 1 && correctOptionNum <= 4) {
                correctOptionLetter = String.valueOf((char) ('A' + correctOptionNum - 1));
            }
            
            out.println("<h3>Validation Logic:</h3>");
            out.println("<p>Correct option number: " + correctOptionNum + "</p>");
            out.println("<p>Correct option letter: " + correctOptionLetter + "</p>");
            
            // Test correct answer
            String selectedOption = correctOptionLetter; // Assume user selected correct option
            boolean isCorrect = selectedOption.equals(correctOptionLetter);
            out.println("<p>Selected option: " + selectedOption + "</p>");
            out.println("<p>Is correct: " + isCorrect + "</p>");
            
            // Get correct option text
            String correctOptionText = "";
            switch (correctOptionNum) {
                case 1: correctOptionText = question.getOption1(); break;
                case 2: correctOptionText = question.getOption2(); break;
                case 3: correctOptionText = question.getOption3(); break;
                case 4: correctOptionText = question.getOption4(); break;
            }
            
            out.println("<p>Correct option text: " + correctOptionText + "</p>");
            
            out.println("<p style='color: green; font-weight: bold;'>Direct validation test completed successfully!</p>");
        } else {
            out.println("<p style='color: red; font-weight: bold;'>No question found with ID 1</p>");
        }
    } catch (Exception e) {
        out.println("<p style='color: red; font-weight: bold;'>Error: " + e.getMessage() + "</p>");
        e.printStackTrace();
    }
%>