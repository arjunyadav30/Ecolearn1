<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Test Get Question</title>
</head>
<body>
    <h2>Test Get Question Endpoint</h2>
    
    <button onclick="testGetQuestion()">Test Get Question</button>
    <div id="result"></div>
    
    <script>
        function testGetQuestion() {
            fetch('get-question.jsp')
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