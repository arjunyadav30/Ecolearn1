<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Test Activity Logging</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h1>Test Activity Logging</h1>
        
        <div class="row">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h5>Complete Lesson</h5>
                    </div>
                    <div class="card-body">
                        <button class="btn btn-primary" onclick="testLessonCompletion()">Complete Sample Lesson</button>
                    </div>
                </div>
            </div>
            
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h5>Complete Challenge</h5>
                    </div>
                    <div class="card-body">
                        <button class="btn btn-success" onclick="testChallengeCompletion()">Complete Sample Challenge</button>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row mt-4">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h5>Complete Game</h5>
                    </div>
                    <div class="card-body">
                        <button class="btn btn-info" onclick="testGameCompletion()">Complete Sample Game</button>
                    </div>
                </div>
            </div>
            
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h5>View Recent Activity</h5>
                    </div>
                    <div class="card-body">
                        <a href="dashboard.jsp" class="btn btn-secondary">View Dashboard</a>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row mt-4">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5>Response Log</h5>
                    </div>
                    <div class="card-body">
                        <div id="responseLog" style="min-height: 100px; background-color: #f8f9fa; padding: 10px; border-radius: 5px;">
                            Click buttons above to test activity logging...
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function logResponse(message) {
            const logElement = document.getElementById('responseLog');
            const timestamp = new Date().toLocaleTimeString();
            logElement.innerHTML += `<div>[${timestamp}] ${message}</div>`;
            logElement.scrollTop = logElement.scrollHeight;
        }
        
        function testLessonCompletion() {
            logResponse('Completing sample lesson...');
            
            fetch('complete-lesson.jsp', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'lessonId=1&lessonTitle=Renewable Energy Sources&points=100'
            })
            .then(response => response.json())
            .then(data => {
                if (data.status === 'success') {
                    logResponse('✓ Lesson completion logged successfully: ' + data.message);
                } else {
                    logResponse('✗ Failed to log lesson completion: ' + data.message);
                }
            })
            .catch(error => {
                logResponse('✗ Error logging lesson completion: ' + error.message);
            });
        }
        
        function testChallengeCompletion() {
            logResponse('Completing sample challenge...');
            
            fetch('complete-challenge.jsp', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'challengeTitle=Plastic-Free Week&points=150'
            })
            .then(response => response.json())
            .then(data => {
                if (data.status === 'success') {
                    logResponse('✓ Challenge completion logged successfully: ' + data.message);
                } else {
                    logResponse('✗ Failed to log challenge completion: ' + data.message);
                }
            })
            .catch(error => {
                logResponse('✗ Error logging challenge completion: ' + error.message);
            });
        }
        
        function testGameCompletion() {
            logResponse('Completing sample game...');
            
            fetch('complete-game.jsp', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'gameTitle=Eco Sorting Challenge&points=50'
            })
            .then(response => response.json())
            .then(data => {
                if (data.status === 'success') {
                    logResponse('✓ Game completion logged successfully: ' + data.message);
                } else {
                    logResponse('✗ Failed to log game completion: ' + data.message);
                }
            })
            .catch(error => {
                logResponse('✗ Error logging game completion: ' + error.message);
            });
        }
    </script>
</body>
</html>