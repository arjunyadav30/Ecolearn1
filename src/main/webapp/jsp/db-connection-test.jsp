<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mycompany.sih3.repository.QuestionRepository" %>
<%@ page import="com.mycompany.sih3.entity.Question" %>
<%@ page import="java.util.List" %>
<%
    String result = "";
    try {
        QuestionRepository repo = new QuestionRepository();
        List<Question> questions = repo.findAll();
        result = "Database connection successful! Found " + questions.size() + " questions.";
        
        if (!questions.isEmpty()) {
            Question firstQuestion = questions.get(0);
            result += "<br><br><strong>First Question:</strong><br>";
            result += "ID: " + firstQuestion.getId() + "<br>";
            result += "Question: " + firstQuestion.getQuestionText() + "<br>";
            result += "Option 1: " + firstQuestion.getOption1() + "<br>";
            result += "Option 2: " + firstQuestion.getOption2() + "<br>";
            result += "Option 3: " + firstQuestion.getOption3() + "<br>";
            result += "Option 4: " + firstQuestion.getOption4() + "<br>";
            result += "Correct Option: " + firstQuestion.getCorrectOption() + "<br>";
        }
    } catch (Exception e) {
        result = "Database connection failed: " + e.getMessage();
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Database Connection Test</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f0f0f0; }
        .container { background: white; padding: 20px; border-radius: 5px; max-width: 800px; margin: 0 auto; }
        .result { padding: 15px; margin: 20px 0; background: #d4edda; border: 1px solid #c3e6cb; border-radius: 3px; }
        .error { background: #f8d7da; border: 1px solid #f5c6cb; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Database Connection Test</h1>
        
        <div class="result <%= result.contains("failed") ? "error" : "" %>">
            <%= result %>
        </div>
        
        <a href="snake-ladder-pure-jsp.jsp">Back to Snake Ladder Game</a>
    </div>
</body>
</html>