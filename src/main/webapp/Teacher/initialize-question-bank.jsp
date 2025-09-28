<%@ page import="com.mycompany.sih3.repository.QuestionBankRepository" %>
<%@ page import="com.mycompany.sih3.entity.QuestionBank" %>
<%@ page import="java.util.List" %>
<%@ include file="auth_check.jsp" %>
<%
    String message = "";
    String messageType = "";
    int questionsAdded = 0;
    
    try {
        QuestionBankRepository repo = new QuestionBankRepository();
        
        // Check how many questions are currently in the database
        List<QuestionBank> existingQuestions = repo.findAll(1000);
        int existingCount = existingQuestions.size();
        
        if (existingCount > 0) {
            message = "Database already contains " + existingCount + " questions. No initialization needed.";
            messageType = "info";
        } else {
            // Add sample questions
            String[][] sampleQuestions = {
                {"Climate", "What is the main greenhouse gas responsible for global warming?", "Oxygen", "Nitrogen", "Carbon Dioxide", "Methane", "c", "medium"},
                {"Climate", "What is the term for the long-term weather patterns in a region?", "Weather", "Climate", "Season", "Temperature", "b", "easy"},
                {"Climate", "Which of the following is a renewable energy source?", "Coal", "Natural Gas", "Solar Power", "Oil", "c", "easy"},
                {"Biodiversity", "What is the term for the variety of life in a particular habitat?", "Ecosystem", "Biodiversity", "Biome", "Population", "b", "easy"},
                {"Biodiversity", "Which layer of the atmosphere contains the ozone layer?", "Troposphere", "Stratosphere", "Mesosphere", "Thermosphere", "b", "medium"},
                {"Energy", "What is the primary source of energy for most ecosystems?", "Wind", "Water", "Sun", "Geothermal", "c", "easy"},
                {"Energy", "Which of the following is the most efficient energy source?", "Coal", "Natural Gas", "Nuclear", "Solar", "c", "hard"},
                {"Waste Management", "What does the 'R' in the 3 R's of waste management stand for?", "Recycle", "Reduce", "Reuse", "Remove", "b", "easy"},
                {"Waste Management", "Which of the following is biodegradable waste?", "Plastic", "Glass", "Food scraps", "Metal", "c", "easy"},
                {"Water Conservation", "What percentage of Earth's water is freshwater?", "1%", "3%", "10%", "25%", "b", "medium"},
                {"Water Conservation", "What is the process of removing salt from seawater called?", "Evaporation", "Condensation", "Desalination", "Precipitation", "c", "medium"}
            };
            
            for (String[] qData : sampleQuestions) {
                QuestionBank question = new QuestionBank();
                question.setCategory(qData[0]);
                question.setQuestionText(qData[1]);
                question.setOptionA(qData[2]);
                question.setOptionB(qData[3]);
                question.setOptionC(qData[4]);
                question.setOptionD(qData[5]);
                question.setCorrectOption(qData[6]);
                question.setDifficultyLevel(qData[7]);
                
                if (repo.save(question)) {
                    questionsAdded++;
                }
            }
            
            message = "Successfully added " + questionsAdded + " sample questions to the question bank.";
            messageType = "success";
        }
    } catch (Exception e) {
        message = "Error initializing question bank: " + e.getMessage();
        messageType = "danger";
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Initialize Question Bank</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h1>Initialize Question Bank</h1>
        
        <div class="alert alert-<%= messageType %>" role="alert">
            <%= message %>
        </div>
        
        <div class="mt-3">
            <a href="manage-lessons.jsp" class="btn btn-primary">Back to Manage Lessons</a>
            <a href="test-db-connection.jsp" class="btn btn-secondary">Test Database Connection</a>
        </div>
    </div>
</body>
</html>