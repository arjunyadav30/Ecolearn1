<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mycompany.sih3.entity.Question" %>
<%@ page import="com.mycompany.sih3.repository.QuestionRepository" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="com.google.gson.GsonBuilder" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Random" %>
<%
    // Set response encoding explicitly
    response.setCharacterEncoding("UTF-8");
    response.setContentType("application/json; charset=UTF-8");
    
    // Disable caching
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
    
    try {
        // Log request for debugging
        System.out.println("=== get-question.jsp called ===");
        System.out.println("Request parameters: " + request.getQueryString());
        
        // Get lesson ID from parameter
        String lessonIdParam = request.getParameter("lessonId");
        Integer lessonId = null;
        
        if (lessonIdParam != null && !lessonIdParam.isEmpty()) {
            try {
                lessonId = Integer.parseInt(lessonIdParam);
                System.out.println("Lesson ID parsed: " + lessonId);
            } catch (NumberFormatException e) {
                System.out.println("Invalid lesson ID format: " + lessonIdParam);
                // Invalid lesson ID
            }
        } else {
            System.out.println("No lesson ID provided in request");
        }
        
        QuestionRepository questionRepository = new QuestionRepository();
        List<Question> questions = null;
        
        if (lessonId != null) {
            // Fetch questions for specific lesson
            System.out.println("Fetching questions for lesson ID: " + lessonId);
            questions = questionRepository.findByLessonId(lessonId);
        } else {
            // Fetch all questions
            System.out.println("Fetching all questions");
            questions = questionRepository.findAll();
        }
        
        System.out.println("Number of questions found: " + (questions != null ? questions.size() : "null"));
        
        if (questions != null && !questions.isEmpty()) {
            // Select a random question from the list
            Random random = new Random();
            Question question = questions.get(random.nextInt(questions.size()));
            
            System.out.println("Selected question:");
            System.out.println("  ID: " + question.getId());
            System.out.println("  Lesson ID: " + question.getLessonId());
            System.out.println("  Question text: " + question.getQuestionText());
            System.out.println("  Option 1: " + question.getOption1());
            System.out.println("  Option 2: " + question.getOption2());
            System.out.println("  Option 3: " + question.getOption3());
            System.out.println("  Option 4: " + question.getOption4());
            System.out.println("  Correct option: " + question.getCorrectOption());
            
            // Use Gson for proper JSON serialization with encoding handling
            Gson gson = new GsonBuilder().create();
            String jsonResponse = gson.toJson(question);
            System.out.println("Sending JSON response: " + jsonResponse);
            out.print(jsonResponse);
            out.flush(); // Ensure the output is flushed
        } else {
            System.out.println("No questions available");
            out.print("{\"error\":\"No questions available\"}");
            out.flush(); // Ensure the output is flushed
        }
    } catch (Exception e) {
        e.printStackTrace();
        System.out.println("Database error: " + e.getMessage());
        out.print("{\"error\":\"Database error: " + e.getMessage() + "\"}");
        out.flush(); // Ensure the output is flushed
    }
    
    System.out.println("=== get-question.jsp completed ===");
%>