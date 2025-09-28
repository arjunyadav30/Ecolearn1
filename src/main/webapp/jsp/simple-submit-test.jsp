<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String action = request.getParameter("action");
    String selectedOption = request.getParameter("selectedOption");
    String message = "";
    
    if ("submit".equals(action)) {
        if (selectedOption != null && !selectedOption.isEmpty()) {
            message = "SUCCESS: Form submitted correctly. Selected option: " + selectedOption;
        } else {
            message = "ERROR: No option selected.";
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Simple Submit Test</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }
        .container { background: white; padding: 20px; border-radius: 8px; max-width: 500px; margin: 0 auto; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .option { display: block; margin: 15px 0; padding: 12px; border: 2px solid #ddd; border-radius: 5px; cursor: pointer; }
        .option:hover { border-color: #007bff; background: #f8f9ff; }
        button { padding: 12px 25px; background: #007bff; color: white; border: none; border-radius: 5px; cursor: pointer; font-size: 16px; }
        button:hover { background: #0056b3; }
        .result { padding: 15px; margin: 20px 0; border-radius: 5px; }
        .success { background: #d4edda; border: 1px solid #c3e6cb; color: #155724; }
        .error { background: #f8d7da; border: 1px solid #f5c6cb; color: #721c24; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Simple Submit Test</h1>
        <p>This page tests if form submission works correctly without JavaScript.</p>
        
        <% if (!message.isEmpty()) { %>
        <div class="result <%= message.startsWith("SUCCESS") ? "success" : "error" %>">
            <strong><%= message %></strong>
        </div>
        <% } %>
        
        <form method="post">
            <input type="hidden" name="action" value="submit">
            
            <h3>Choose an option:</h3>
            <label class="option">
                <input type="radio" name="selectedOption" value="A" required> 
                Option A
            </label>
            <label class="option">
                <input type="radio" name="selectedOption" value="B" required> 
                Option B
            </label>
            <label class="option">
                <input type="radio" name="selectedOption" value="C" required> 
                Option C
            </label>
            <label class="option">
                <input type="radio" name="selectedOption" value="D" required> 
                Option D
            </label>
            
            <button type="submit">Submit Answer</button>
        </form>
        
        <br>
        <a href="snakeladder.jsp">Back to Snake Ladder Game</a>
    </div>
</body>
</html>