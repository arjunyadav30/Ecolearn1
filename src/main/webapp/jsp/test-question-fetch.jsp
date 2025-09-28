<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Test Question Fetching</title>
</head>
<body>
    <h2>Test Question Fetching</h2>
    <button onclick="fetchQuestion()">Fetch Question</button>
    <div id="result"></div>

    <script>
        function fetchQuestion() {
            fetch('get-question.jsp')
                .then(response => response.json())
                .then(data => {
                    document.getElementById('result').innerHTML = '<pre>' + JSON.stringify(data, null, 2) + '</pre>';
                    console.log('Data received:', data);
                })
                .catch(error => {
                    console.error('Error:', error);
                    document.getElementById('result').innerHTML = '<p>Error: ' + error.message + '</p>';
                });
        }
    </script>
</body>
</html>