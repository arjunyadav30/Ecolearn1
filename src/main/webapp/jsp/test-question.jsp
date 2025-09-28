<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mycompany.sih3.entity.Question" %>
<%@ page import="com.mycompany.sih3.repository.QuestionRepository" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="com.google.gson.GsonBuilder" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Random" %>
<%
    response.setCharacterEncoding("UTF-8");
    response.setContentType("application/json; charset=UTF-8");
    
    try {
        QuestionRepository questionRepository = new QuestionRepository();
        List<Question> questions = questionRepository.findAll();
        
        if (questions != null && !questions.isEmpty()) {
            // Select a random question from the list
            Random random = new Random();
            Question question = questions.get(random.nextInt(questions.size()));
            
            out.println("<h2>Question Debug Info:</h2>");
            out.println("<p>ID: " + question.getId() + "</p>");
            out.println("<p>Lesson ID: " + question.getLessonId() + "</p>");
            out.println("<p>Question Text: " + question.getQuestionText() + "</p>");
            out.println("<p>Option 1: " + question.getOption1() + "</p>");
            out.println("<p>Option 2: " + question.getOption2() + "</p>");
            out.println("<p>Option 3: " + question.getOption3() + "</p>");
            out.println("<p>Option 4: " + question.getOption4() + "</p>");
            out.println("<p>Correct Option: " + question.getCorrectOption() + "</p>");
            
            // Use Gson for proper JSON serialization with encoding handling
            Gson gson = new GsonBuilder().create();
            String jsonResponse = gson.toJson(question);
            out.println("<h3>JSON Response:</h3>");
            out.println("<pre>" + jsonResponse + "</pre>");
        } else {
            out.println("<p>No questions available</p>");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<p>Database error: " + e.getMessage() + "</p>");
    }
%>