package com.mycompany.sih3.repository;

import com.mycompany.sih3.entity.Question;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.DriverManager;
import java.util.ArrayList;
import java.util.List;

public class QuestionRepository {
    
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
    
    public boolean save(Question question) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = getConnection();
            
            String sql = "INSERT INTO questions (lesson_id, question_text, option1, option2, option3, option4, correct_option) VALUES (?, ?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            
            stmt.setInt(1, question.getLessonId());
            stmt.setString(2, question.getQuestionText());
            stmt.setString(3, question.getOption1());
            stmt.setString(4, question.getOption2());
            stmt.setString(5, question.getOption3());
            stmt.setString(6, question.getOption4());
            stmt.setInt(7, question.getCorrectOption());
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    question.setId(generatedKeys.getInt(1));
                }
                return true;
            }
            
            return false;
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }
    
    public List<Question> findByLessonId(int lessonId) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Question> questions = new ArrayList<>();
        
        try {
            conn = getConnection();
            
            String sql = "SELECT * FROM questions WHERE lesson_id = ? ORDER BY id";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, lessonId);
            
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                Question question = new Question();
                question.setId(rs.getInt("id"));
                question.setLessonId(rs.getInt("lesson_id"));
                question.setQuestionText(rs.getString("question_text"));
                question.setOption1(rs.getString("option1"));
                question.setOption2(rs.getString("option2"));
                question.setOption3(rs.getString("option3"));
                question.setOption4(rs.getString("option4"));
                question.setCorrectOption(rs.getInt("correct_option"));
                
                questions.add(question);
            }
            
            return questions;
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }
    
    public List<Question> findAll() throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Question> questions = new ArrayList<>();
        
        try {
            conn = getConnection();
            
            String sql = "SELECT * FROM questions ORDER BY RAND()";
            stmt = conn.prepareStatement(sql);
            
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                Question question = new Question();
                question.setId(rs.getInt("id"));
                question.setLessonId(rs.getInt("lesson_id"));
                question.setQuestionText(rs.getString("question_text"));
                question.setOption1(rs.getString("option1"));
                question.setOption2(rs.getString("option2"));
                question.setOption3(rs.getString("option3"));
                question.setOption4(rs.getString("option4"));
                question.setCorrectOption(rs.getInt("correct_option"));
                
                questions.add(question);
            }
            
            return questions;
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }
    
    public Question findById(int id) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            
            String sql = "SELECT * FROM questions WHERE id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                Question question = new Question();
                question.setId(rs.getInt("id"));
                question.setLessonId(rs.getInt("lesson_id"));
                question.setQuestionText(rs.getString("question_text"));
                question.setOption1(rs.getString("option1"));
                question.setOption2(rs.getString("option2"));
                question.setOption3(rs.getString("option3"));
                question.setOption4(rs.getString("option4"));
                question.setCorrectOption(rs.getInt("correct_option"));
                
                return question;
            }
            
            return null;
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }
    
    public boolean update(Question question) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = getConnection();
            
            String sql = "UPDATE questions SET lesson_id = ?, question_text = ?, option1 = ?, option2 = ?, option3 = ?, option4 = ?, correct_option = ? WHERE id = ?";
            stmt = conn.prepareStatement(sql);
            
            stmt.setInt(1, question.getLessonId());
            stmt.setString(2, question.getQuestionText());
            stmt.setString(3, question.getOption1());
            stmt.setString(4, question.getOption2());
            stmt.setString(5, question.getOption3());
            stmt.setString(6, question.getOption4());
            stmt.setInt(7, question.getCorrectOption());
            stmt.setInt(8, question.getId());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }
    
    public boolean delete(int id) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = getConnection();
            
            String sql = "DELETE FROM questions WHERE id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }
    
    public boolean deleteByLessonId(int lessonId) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = getConnection();
            
            String sql = "DELETE FROM questions WHERE lesson_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, lessonId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected >= 0; // Allow 0 for lessons with no questions
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }
}