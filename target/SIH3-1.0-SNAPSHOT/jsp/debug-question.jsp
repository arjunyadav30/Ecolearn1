<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mycompany.sih3.entity.Question" %>
<%@ page import="com.mycompany.sih3.repository.QuestionRepository" %>
<%
    // Test fetching a question by ID
    try {
        QuestionRepository repo = new QuestionRepository();
        // Try to fetch the first question
        Question question = repo.findById(1);
        
        if (question != null) {
            out.println("<h2>Question Debug Info</h2>");
            out.println("<p>ID: " + question.getId() + "</p>");
            out.println("<p>Lesson ID: " + question.getLessonId() + "</p>");
            out.println("<p>Question Text: " + question.getQuestionText() + "</p>");
            out.println("<p>Option 1: " + question.getOption1() + "</p>");
            out.println("<p>Option 2: " + question.getOption2() + "</p>");
            out.println("<p>Option 3: " + question.getOption3() + "</p>");
            out.println("<p>Option 4: " + question.getOption4() + "</p>");
            out.println("<p>Correct Option: " + question.getCorrectOption() + "</p>");
        } else {
            out.println("<p>No question found with ID 1</p>");
        }
    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
        e.printStackTrace();
    }
%>