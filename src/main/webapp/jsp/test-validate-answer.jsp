<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Test Validate Answer</title>
</head>
<body>
    <h2>Test Validate Answer Endpoint</h2>
    
    <form action="validate-answer.jsp" method="post">
        <label for="questionId">Question ID:</label>
        <input type="text" id="questionId" name="questionId" value="1"><br><br>
        
        <label for="selectedOption">Selected Option:</label>
        <input type="text" id="selectedOption" name="selectedOption" value="A"><br><br>
        
        <label for="playerPosition">Player Position:</label>
        <input type="text" id="playerPosition" name="playerPosition" value="1"><br><br>
        
        <input type="submit" value="Test Validation">
    </form>
    
    <h3>Test with JavaScript Fetch</h3>
    <button onclick="testValidation()">Test with Fetch</button>
    <div id="result"></div>
    
    <script>
        function testValidation() {
            fetch('validate-answer.jsp', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'questionId=1&selectedOption=A&playerPosition=1'
            })
            .then(response => response.json())
            .then(data => {
                document.getElementById('result').innerHTML = '<pre>' + JSON.stringify(data, null, 2) + '</pre>';
            })
            .catch(error => {
                document.getElementById('result').innerHTML = '<p>Error: ' + error + '</p>';
            });
        }
    </script>
</body>
</html>