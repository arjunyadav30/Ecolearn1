package com.mycompany.sih3.repository;

import com.mycompany.sih3.entity.Lesson;
import java.sql.*;
import java.sql.DatabaseMetaData;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class LessonRepository {
    
    public LessonRepository() {
        // Default constructor
    }
    
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
    
    public void save(Lesson lesson) throws SQLException {
        Connection con = null;
        PreparedStatement stmt = null;
        
        try {
            con = getConnection();
            
            // Use a simpler INSERT statement that matches the actual table structure
            String sql = "INSERT INTO lessons (title, description, category, video_url, points, created_at) VALUES (?, ?, ?, ?, ?, ?)";
            
            stmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setString(1, lesson.getTitle());
            stmt.setString(2, lesson.getDescription());
            stmt.setString(3, lesson.getCategory());
            stmt.setString(4, lesson.getVideoUrl());
            stmt.setObject(5, lesson.getPoints(), Types.INTEGER);
            stmt.setObject(6, lesson.getCreatedAt());
            
            int rowsAffected = stmt.executeUpdate();
            
            // Get generated ID for new records
            if (lesson.getId() == null && rowsAffected > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    lesson.setId(rs.getInt(1));
                }
                rs.close();
            }
        } catch (SQLException e) {
            System.out.println("Error saving lesson: " + e.getMessage());
            e.printStackTrace();
            throw e; // Re-throw the exception so calling code can handle it
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                System.out.println(e.getMessage());
            }
        }
    }
    
    public Lesson findById(Integer id) {
        Connection con = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        Lesson lesson = null;
        
        try {
            con = getConnection();
            String sql = "SELECT id, title, description, category, video_url, points, created_at FROM lessons WHERE id = ?";
            stmt = con.prepareStatement(sql);
            stmt.setInt(1, id);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                lesson = mapResultSetToLesson(rs);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                System.out.println(e.getMessage());
            }
        }
        
        return lesson;
    }
    
    public List<Lesson> findAll() {
        Connection con = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Lesson> lessons = new ArrayList<>();
        
        try {
            con = getConnection();
            String sql = "SELECT id, title, description, category, video_url, points, created_at FROM lessons ORDER BY created_at DESC";
            stmt = con.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                lessons.add(mapResultSetToLesson(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error in findAll: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                System.out.println(e.getMessage());
            }
        }
        
        return lessons;
    }
    
    public List<Lesson> findByCategory(String category) {
        Connection con = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Lesson> lessons = new ArrayList<>();
        
        try {
            con = getConnection();
            String sql = "SELECT id, title, description, category, video_url, points, created_at FROM lessons WHERE category = ? ORDER BY created_at DESC";
            stmt = con.prepareStatement(sql);
            stmt.setString(1, category);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                lessons.add(mapResultSetToLesson(rs));
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                System.out.println(e.getMessage());
            }
        }
        
        return lessons;
    }
    
    public void delete(Lesson lesson) {
        Connection con = null;
        PreparedStatement stmt = null;
        
        try {
            con = getConnection();
            String sql = "DELETE FROM lessons WHERE id = ?";
            stmt = con.prepareStatement(sql);
            stmt.setInt(1, lesson.getId());
            stmt.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                System.out.println(e.getMessage());
            }
        }
    }
    
    public void update(Lesson lesson) {
        Connection con = null;
        PreparedStatement stmt = null;
        
        try {
            con = getConnection();
            String sql = "UPDATE lessons SET title=?, description=?, category=?, video_url=?, points=? WHERE id=?";
            
            stmt = con.prepareStatement(sql);
            stmt.setString(1, lesson.getTitle());
            stmt.setString(2, lesson.getDescription());
            stmt.setString(3, lesson.getCategory());
            stmt.setString(4, lesson.getVideoUrl());
            stmt.setObject(5, lesson.getPoints(), Types.INTEGER);
            stmt.setInt(6, lesson.getId());
            
            stmt.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                System.out.println(e.getMessage());
            }
        }
    }
    
    private Lesson mapResultSetToLesson(ResultSet rs) throws SQLException {
        Lesson lesson = new Lesson();
        lesson.setId(rs.getInt("id"));
        lesson.setTitle(rs.getString("title"));
        lesson.setDescription(rs.getString("description"));
        lesson.setCategory(rs.getString("category"));
        lesson.setVideoUrl(rs.getString("video_url"));
        lesson.setPoints(rs.getObject("points", Integer.class));
        
        Timestamp createdTimestamp = rs.getTimestamp("created_at");
        if (createdTimestamp != null) {
            lesson.setCreatedAt(createdTimestamp.toLocalDateTime());
        }
        
        // Since updated_at column doesn't exist, we'll use created_at for updated_at as well
        lesson.setUpdatedAt(lesson.getCreatedAt());
        
        return lesson;
    }
}