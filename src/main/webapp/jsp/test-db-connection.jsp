<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mycompany.sih3.repository.QuestionRepository" %>
<%@ page import="com.mycompany.sih3.entity.Question" %>
<%@ page import="java.util.List" %>
<%
    try {
        out.println("<h2>Database Connection Test</h2>");
        
        QuestionRepository repo = new QuestionRepository();
        out.println("<p>Repository created successfully</p>");
        
        // Test findAll
        List<Question> questions = repo.findAll();
        out.println("<p>Found " + questions.size() + " questions</p>");
        
        if (!questions.isEmpty()) {
            out.println("<h3>First Question Details:</h3>");
            Question firstQuestion = questions.get(0);
            out.println("<p>ID: " + firstQuestion.getId() + "</p>");
            out.println("<p>Lesson ID: " + firstQuestion.getLessonId() + "</p>");
            out.println("<p>Question Text: " + firstQuestion.getQuestionText() + "</p>");
            out.println("<p>Option 1: " + firstQuestion.getOption1() + "</p>");
            out.println("<p>Option 2: " + firstQuestion.getOption2() + "</p>");
            out.println("<p>Option 3: " + firstQuestion.getOption3() + "</p>");
            out.println("<p>Option 4: " + firstQuestion.getOption4() + "</p>");
            out.println("<p>Correct Option: " + firstQuestion.getCorrectOption() + "</p>");
        }
        
        // Test findById
        if (!questions.isEmpty()) {
            int firstId = questions.get(0).getId();
            out.println("<h3>Find By ID Test (ID: " + firstId + "):</h3>");
            Question questionById = repo.findById(firstId);
            if (questionById != null) {
                out.println("<p>Found question by ID successfully</p>");
                out.println("<p>ID: " + questionById.getId() + "</p>");
                out.println("<p>Question Text: " + questionById.getQuestionText() + "</p>");
                out.println("<p>Correct Option: " + questionById.getCorrectOption() + "</p>");
            } else {
                out.println("<p>Failed to find question by ID</p>");
            }
        }
        
        out.println("<p style='color: green; font-weight: bold;'>All tests completed successfully!</p>");
    } catch (Exception e) {
        out.println("<p style='color: red; font-weight: bold;'>Error: " + e.getMessage() + "</p>");
        e.printStackTrace();
    }
%>