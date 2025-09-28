<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Test Question Data</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h2>Test Question Data</h2>
        <button class="btn btn-primary" onclick="fetchQuestion()">Fetch Question Data</button>
        <div id="result" class="mt-3"></div>
    </div>

    <script>
        function fetchQuestion() {
            fetch('get-question.jsp')
                .then(response => response.json())
                .then(data => {
                    console.log('Received data:', data);
                    
                    // Helper function to get option letter from option number
                    function getOptionLetter(optionNumber) {
                        const letters = ['', 'A', 'B', 'C', 'D'];
                        return letters[optionNumber] || 'Unknown';
                    }
                    
                    // Helper function to get option text from option number
                    function getOptionText(optionNumber) {
                        switch(optionNumber) {
                            case 1: return data.option1 || '';
                            case 2: return data.option2 || '';
                            case 3: return data.option3 || '';
                            case 4: return data.option4 || '';
                            default: return '';
                        }
                    }
                    
                    // Get the correct option text
                    const correctOptionText = getOptionText(data.correctOption);
                    const correctOptionLetter = getOptionLetter(data.correctOption);
                    
                    document.getElementById('result').innerHTML = `
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">Question Data</h5>
                                <p><strong>Question:</strong> ${data.questionText}</p>
                                <p><strong>Option A:</strong> ${data.option1}</p>
                                <p><strong>Option B:</strong> ${data.option2}</p>
                                <p><strong>Option C:</strong> ${data.option3}</p>
                                <p><strong>Option D:</strong> ${data.option4}</p>
                                <p><strong>Correct Option (number):</strong> ${data.correctOption}</p>
                                <p><strong>Correct Option (letter):</strong> ${correctOptionLetter}</p>
                                <p><strong>Correct Option (text):</strong> ${correctOptionText}</p>
                            </div>
                        </div>
                    `;
                })
                .catch(error => {
                    console.error('Error:', error);
                    document.getElementById('result').innerHTML = `<div class="alert alert-danger">Error: ${error.message}</div>`;
                });
        }
    </script>
</body>
</html>