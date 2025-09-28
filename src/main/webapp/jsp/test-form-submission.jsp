<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Process form submission
    String action = request.getParameter("action");
    String selectedOption = request.getParameter("selectedOption");
    String result = "";
    
    if ("submit".equals(action)) {
        if (selectedOption != null && !selectedOption.isEmpty()) {
            result = "Success! You selected option: " + selectedOption;
        } else {
            result = "Error: Please select an option.";
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Form Submission Test</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f0f0f0; }
        .container { background: white; padding: 20px; border-radius: 5px; max-width: 600px; margin: 0 auto; }
        .option { display: block; margin: 10px 0; padding: 10px; background: #e9e9e9; border-radius: 3px; }
        button { padding: 10px 20px; background: #007bff; color: white; border: none; border-radius: 3px; cursor: pointer; }
        button:hover { background: #0056b3; }
        .result { padding: 15px; margin: 20px 0; background: #d4edda; border: 1px solid #c3e6cb; border-radius: 3px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Form Submission Test</h1>
        
        <% if (!result.isEmpty()) { %>
        <div class="result">
            <strong>Result:</strong> <%= result %>
        </div>
        <% } %>
        
        <form method="post">
            <input type="hidden" name="action" value="submit">
            
            <h3>Select an option:</h3>
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
        <a href="snake-ladder-pure-jsp.jsp">Back to Snake Ladder Game</a>
    </div>
</body>
</html>