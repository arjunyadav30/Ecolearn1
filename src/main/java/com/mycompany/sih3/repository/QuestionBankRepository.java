package com.mycompany.sih3.repository;

import com.mycompany.sih3.entity.QuestionBank;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QuestionBankRepository {
    
    private Connection getConnection() throws SQLException {
        Connection con = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            // Updated to use the correct database name based on the test page
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ecolearn?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true", "root", "1234");
            // Ensure auto-commit is enabled
            con.setAutoCommit(true);
        } catch (Exception e) {
            throw new SQLException("Failed to establish database connection: " + e.getMessage(), e);
        }
        return con;
    }
    
    /**
     * Find questions by partial matching of category and lesson title/description
     * @param lessonTitle The title of the lesson
     * @param lessonDescription The description of the lesson
     * @param lessonCategory The category of the lesson
     * @param limit The maximum number of questions to return
     * @return List of QuestionBank objects
     * @throws SQLException
     */
    public List<QuestionBank> findQuestionsByPartialMatch(String lessonTitle, String lessonDescription, String lessonCategory, int limit) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<QuestionBank> questions = new ArrayList<>();
        
        try {
            conn = getConnection();
            
            // Extract keywords from lesson title, description, and category
            List<String> keywords = extractKeywords(lessonTitle, lessonDescription, lessonCategory);
            
            if (keywords.isEmpty()) {
                // If no keywords found, return random questions
                return findAll(limit);
            }
            
            // Build query with partial matching using LIKE for each keyword
            StringBuilder sql = new StringBuilder();
            sql.append("SELECT DISTINCT * FROM question_bank WHERE ");
            
            // Add conditions for each keyword
            for (int i = 0; i < keywords.size(); i++) {
                if (i > 0) {
                    sql.append(" OR ");
                }
                sql.append("(category LIKE ? OR question_text LIKE ? OR option_a LIKE ? OR option_b LIKE ? OR option_c LIKE ? OR option_d LIKE ?)");
            }
            
            sql.append(" ORDER BY RAND() LIMIT ?");
            
            stmt = conn.prepareStatement(sql.toString());
            
            // Set parameters for each keyword
            int paramIndex = 1;
            for (String keyword : keywords) {
                String searchKeyword = "%" + keyword + "%";
                stmt.setString(paramIndex++, searchKeyword); // category
                stmt.setString(paramIndex++, searchKeyword); // question_text
                stmt.setString(paramIndex++, searchKeyword); // option_a
                stmt.setString(paramIndex++, searchKeyword); // option_b
                stmt.setString(paramIndex++, searchKeyword); // option_c
                stmt.setString(paramIndex++, searchKeyword); // option_d
            }
            
            // Set limit
            stmt.setInt(paramIndex, limit);
            
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                questions.add(mapResultSetToQuestionBank(rs));
            }
            
            // If we didn't find enough questions, try a broader search
            if (questions.size() < limit) {
                // Add more general questions to reach the limit
                List<QuestionBank> additionalQuestions = findAdditionalQuestions(keywords, limit - questions.size(), questions);
                questions.addAll(additionalQuestions);
            }
            
            return questions;
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }
    
    /**
     * Extract keywords from lesson information (public for testing)
     * @param title Lesson title
     * @param description Lesson description
     * @param category Lesson category
     * @return List of keywords
     */
    public List<String> extractKeywords(String title, String description, String category) {
        List<String> keywords = new ArrayList<>();
        
        // Add keywords from title (split by spaces and take words with 4+ characters)
        if (title != null && !title.isEmpty()) {
            String[] titleWords = title.split("\\s+");
            for (String word : titleWords) {
                // Remove punctuation and convert to lowercase
                word = word.replaceAll("[^a-zA-Z0-9]", "").toLowerCase();
                if (word.length() >= 4) {
                    keywords.add(word);
                }
            }
        }
        
        // Add keywords from description (split by spaces and take words with 4+ characters)
        if (description != null && !description.isEmpty()) {
            String[] descWords = description.split("\\s+");
            for (String word : descWords) {
                // Remove punctuation and convert to lowercase
                word = word.replaceAll("[^a-zA-Z0-9]", "").toLowerCase();
                if (word.length() >= 4) {
                    keywords.add(word);
                }
            }
        }
        
        // Add category as keyword (if not already present)
        if (category != null && !category.isEmpty()) {
            String cleanCategory = category.replaceAll("[^a-zA-Z0-9]", "").toLowerCase();
            if (!keywords.contains(cleanCategory)) {
                keywords.add(cleanCategory);
            }
        }
        
        return keywords;
    }
    
    /**
     * Find additional questions to reach the required limit
     * @param keywords List of keywords
     * @param needed Number of questions needed
     * @param existingQuestions Already found questions to avoid duplicates
     * @return List of additional questions
     * @throws SQLException
     */
    private List<QuestionBank> findAdditionalQuestions(List<String> keywords, int needed, List<QuestionBank> existingQuestions) throws SQLException {
        List<QuestionBank> additionalQuestions = new ArrayList<>();
        if (needed <= 0) return additionalQuestions;
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            
            // Create a list of existing question IDs to avoid duplicates
            List<Integer> existingIds = new ArrayList<>();
            for (QuestionBank q : existingQuestions) {
                existingIds.add(q.getId());
            }
            
            // Build query for additional questions with shorter keywords
            StringBuilder sql = new StringBuilder();
            sql.append("SELECT DISTINCT * FROM question_bank WHERE ");
            
            // Add conditions for each keyword with shorter matching
            for (int i = 0; i < keywords.size(); i++) {
                if (i > 0) {
                    sql.append(" OR ");
                }
                sql.append("(category LIKE ? OR question_text LIKE ?)");
            }
            
            // Exclude existing questions
            if (!existingIds.isEmpty()) {
                sql.append(" AND id NOT IN (");
                for (int i = 0; i < existingIds.size(); i++) {
                    if (i > 0) sql.append(",");
                    sql.append("?");
                }
                sql.append(")");
            }
            
            sql.append(" ORDER BY RAND() LIMIT ?");
            
            stmt = conn.prepareStatement(sql.toString());
            
            // Set parameters for each keyword (shorter matching)
            int paramIndex = 1;
            for (String keyword : keywords) {
                String searchKeyword = "%" + keyword.substring(0, Math.min(keyword.length(), 3)) + "%";
                stmt.setString(paramIndex++, searchKeyword); // category
                stmt.setString(paramIndex++, searchKeyword); // question_text
            }
            
            // Set existing IDs to exclude
            for (Integer id : existingIds) {
                stmt.setInt(paramIndex++, id);
            }
            
            // Set limit
            stmt.setInt(paramIndex, needed);
            
            rs = stmt.executeQuery();
            
            while (rs.next() && additionalQuestions.size() < needed) {
                additionalQuestions.add(mapResultSetToQuestionBank(rs));
            }
            
            return additionalQuestions;
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }
    
    /**
     * Find questions by category with partial matching
     * @param category The category to search for
     * @param limit The maximum number of questions to return
     * @return List of QuestionBank objects
     * @throws SQLException
     */
    public List<QuestionBank> findQuestionsByCategory(String category, int limit) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<QuestionBank> questions = new ArrayList<>();
        
        try {
            conn = getConnection();
            
            String sql = "SELECT * FROM question_bank WHERE category LIKE ? ORDER BY RAND() LIMIT ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, "%" + category + "%");
            stmt.setInt(2, limit);
            
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                questions.add(mapResultSetToQuestionBank(rs));
            }
            
            return questions;
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }
    
    /**
     * Find questions by partial text matching in question text or category
     * @param searchText The text to search for
     * @param limit The maximum number of questions to return
     * @return List of QuestionBank objects
     * @throws SQLException
     */
    public List<QuestionBank> findQuestionsByPartialText(String searchText, int limit) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<QuestionBank> questions = new ArrayList<>();
        
        try {
            conn = getConnection();
            
            String sql = "SELECT * FROM question_bank WHERE (question_text LIKE ? OR category LIKE ?) ORDER BY RAND() LIMIT ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, "%" + searchText + "%");
            stmt.setString(2, "%" + searchText + "%");
            stmt.setInt(3, limit);
            
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                questions.add(mapResultSetToQuestionBank(rs));
            }
            
            return questions;
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }
    
    /**
     * Get all questions from the question bank
     * @param limit The maximum number of questions to return
     * @return List of QuestionBank objects
     * @throws SQLException
     */
    public List<QuestionBank> findAll(int limit) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<QuestionBank> questions = new ArrayList<>();
        
        try {
            conn = getConnection();
            
            String sql = "SELECT * FROM question_bank ORDER BY RAND() LIMIT ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, limit);
            
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                questions.add(mapResultSetToQuestionBank(rs));
            }
            
            return questions;
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }
    
    /**
     * Save a new question to the question bank
     * @param questionBank The question to save
     * @return true if successful, false otherwise
     * @throws SQLException
     */
    public boolean save(QuestionBank questionBank) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = getConnection();
            
            String sql = "INSERT INTO question_bank (category, question_text, option_a, option_b, option_c, option_d, correct_option, difficulty_level) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            
            stmt.setString(1, questionBank.getCategory());
            stmt.setString(2, questionBank.getQuestionText());
            stmt.setString(3, questionBank.getOptionA());
            stmt.setString(4, questionBank.getOptionB());
            stmt.setString(5, questionBank.getOptionC());
            stmt.setString(6, questionBank.getOptionD());
            stmt.setString(7, questionBank.getCorrectOption());
            stmt.setString(8, questionBank.getDifficultyLevel());
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    questionBank.setId(generatedKeys.getInt(1));
                }
                return true;
            }
            
            return false;
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }
    
    /**
     * Find a question by ID
     * @param id The ID of the question
     * @return QuestionBank object or null if not found
     * @throws SQLException
     */
    public QuestionBank findById(int id) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            
            String sql = "SELECT * FROM question_bank WHERE id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToQuestionBank(rs);
            }
            
            return null;
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }
    
    /**
     * Update an existing question in the question bank
     * @param questionBank The question to update
     * @return true if successful, false otherwise
     * @throws SQLException
     */
    public boolean update(QuestionBank questionBank) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = getConnection();
            
            String sql = "UPDATE question_bank SET category = ?, question_text = ?, option_a = ?, option_b = ?, option_c = ?, option_d = ?, correct_option = ?, difficulty_level = ? WHERE id = ?";
            stmt = conn.prepareStatement(sql);
            
            stmt.setString(1, questionBank.getCategory());
            stmt.setString(2, questionBank.getQuestionText());
            stmt.setString(3, questionBank.getOptionA());
            stmt.setString(4, questionBank.getOptionB());
            stmt.setString(5, questionBank.getOptionC());
            stmt.setString(6, questionBank.getOptionD());
            stmt.setString(7, questionBank.getCorrectOption());
            stmt.setString(8, questionBank.getDifficultyLevel());
            stmt.setInt(9, questionBank.getId());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }
    
    /**
     * Delete a question from the question bank
     * @param id The ID of the question to delete
     * @return true if successful, false otherwise
     * @throws SQLException
     */
    public boolean delete(int id) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = getConnection();
            
            String sql = "DELETE FROM question_bank WHERE id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }
    
    /**
     * Map ResultSet to QuestionBank object
     * @param rs ResultSet
     * @return QuestionBank object
     * @throws SQLException
     */
    private QuestionBank mapResultSetToQuestionBank(ResultSet rs) throws SQLException {
        QuestionBank question = new QuestionBank();
        question.setId(rs.getInt("id"));
        question.setCategory(rs.getString("category"));
        question.setQuestionText(rs.getString("question_text"));
        question.setOptionA(rs.getString("option_a"));
        question.setOptionB(rs.getString("option_b"));
        question.setOptionC(rs.getString("option_c"));
        question.setOptionD(rs.getString("option_d"));
        question.setCorrectOption(rs.getString("correct_option"));
        question.setDifficultyLevel(rs.getString("difficulty_level"));
        
        Timestamp createdTimestamp = rs.getTimestamp("created_at");
        if (createdTimestamp != null) {
            question.setCreatedAt(createdTimestamp.toLocalDateTime());
        }
        
        return question;
    }
}