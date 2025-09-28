<%@ page import="com.mycompany.sih3.repository.QuestionBankRepository" %>
<%@ page import="com.mycompany.sih3.entity.QuestionBank" %>
<%@ page import="java.util.List" %>
<%
    try {
        out.println("<h2>Testing QuestionBankRepository</h2>");
        
        QuestionBankRepository repo = new QuestionBankRepository();
        
        // Test findAll
        out.println("<h3>Testing findAll(10):</h3>");
        List<QuestionBank> allQuestions = repo.findAll(10);
        out.println("<p>Found " + allQuestions.size() + " questions</p>");
        
        if (!allQuestions.isEmpty()) {
            for (QuestionBank q : allQuestions) {
                out.println("<p>[" + q.getId() + "] " + q.getCategory() + ": " + q.getQuestionText() + "</p>");
            }
        }
        
        // Test findQuestionsByCategory
        out.println("<h3>Testing findQuestionsByCategory('Science', 5):</h3>");
        List<QuestionBank> scienceQuestions = repo.findQuestionsByCategory("Science", 5);
        out.println("<p>Found " + scienceQuestions.size() + " Science questions</p>");
        
        if (!scienceQuestions.isEmpty()) {
            for (QuestionBank q : scienceQuestions) {
                out.println("<p>[" + q.getId() + "] " + q.getCategory() + ": " + q.getQuestionText() + "</p>");
            }
        }
        
        // Test findQuestionsByPartialMatch
        out.println("<h3>Testing findQuestionsByPartialMatch('Science', '', 'Science', 5):</h3>");
        List<QuestionBank> partialMatchQuestions = repo.findQuestionsByPartialMatch("Science", "", "Science", 5);
        out.println("<p>Found " + partialMatchQuestions.size() + " partial match questions</p>");
        
        if (!partialMatchQuestions.isEmpty()) {
            for (QuestionBank q : partialMatchQuestions) {
                out.println("<p>[" + q.getId() + "] " + q.getCategory() + ": " + q.getQuestionText() + "</p>");
            }
        }
        
        out.println("<h3 style='color: green;'>✓ All tests completed successfully!</h3>");
        
    } catch (Exception e) {
        out.println("<h2 style='color: red;'>Error testing QuestionBankRepository:</h2>");
        out.println("<p>" + e.getMessage() + "</p>");
        e.printStackTrace(new java.io.PrintWriter(out));
    }
%>