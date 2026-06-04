package com.mycompany.sih3.repository;

import com.mycompany.sih3.entity.User;
import com.mycompany.sih3.entity.UserType;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class UserRepository {
    
    public UserRepository() {
        // Default constructor
    }
    
    private Connection getConnection() {
        Connection con = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ecolearn?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true", "root", "1234");
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return con;
    }
    
    public void save(User user) {
        Connection con = null;
        PreparedStatement stmt = null;
        
        try {
            con = getConnection();
            if (con == null) {
                System.out.println("Failed to establish database connection");
                return;
            }
            
            String sql = "INSERT INTO users (full_name, username, email, password, user_type, school_id, age, class_grade, avatar) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE full_name=?, username=?, email=?, password=?, user_type=?, school_id=?, age=?, class_grade=?, avatar=?";
            
            stmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getUsername());
            stmt.setString(3, user.getEmail());
            stmt.setString(4, user.getPassword());
            stmt.setString(5, user.getUserType().name());
            stmt.setObject(6, user.getSchoolId(), Types.INTEGER);
            stmt.setObject(7, user.getAge(), Types.INTEGER);
            stmt.setString(8, user.getClassGrade());
            stmt.setString(9, user.getAvatar());
            
            // For UPDATE part
            stmt.setString(10, user.getFullName());
            stmt.setString(11, user.getUsername());
            stmt.setString(12, user.getEmail());
            stmt.setString(13, user.getPassword());
            stmt.setString(14, user.getUserType().name());
            stmt.setObject(15, user.getSchoolId(), Types.INTEGER);
            stmt.setObject(16, user.getAge(), Types.INTEGER);
            stmt.setString(17, user.getClassGrade());
            stmt.setString(18, user.getAvatar());
            
            int rowsAffected = stmt.executeUpdate();
            System.out.println("Rows affected: " + rowsAffected);
            
            // Get generated ID for new records
            if (user.getId() == null) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    user.setId(rs.getInt(1));
                    System.out.println("Generated user ID: " + user.getId());
                }
                rs.close();
            }
        } catch (SQLException e) {
            System.out.println("SQL Error in save method: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                System.out.println("Error closing resources: " + e.getMessage());
            }
        }
    }
    
    public User findById(Integer id) {
        Connection con = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        User user = null;
        
        try {
            con = getConnection();
            String sql = "SELECT * FROM users WHERE id = ?";
            stmt = con.prepareStatement(sql);
            stmt.setInt(1, id);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                user = mapResultSetToUser(rs);
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
        
        return user;
    }
    
    public User findByUsername(String username) {
        Connection con = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        User user = null;
        
        try {
            con = getConnection();
            String sql = "SELECT * FROM users WHERE username = ?";
            stmt = con.prepareStatement(sql);
            stmt.setString(1, username);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                user = mapResultSetToUser(rs);
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
        
        return user;
    }
    
    public User findByEmail(String email) {
        Connection con = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        User user = null;
        
        try {
            con = getConnection();
            String sql = "SELECT * FROM users WHERE email = ?";
            stmt = con.prepareStatement(sql);
            stmt.setString(1, email);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                user = mapResultSetToUser(rs);
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
        
        return user;
    }
    
    public List<User> findAll() {
        Connection con = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<User> users = new ArrayList<>();
        
        try {
            con = getConnection();
            String sql = "SELECT * FROM users";
            stmt = con.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
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
        
        return users;
    }
    
    public List<User> findByUserType(UserType userType) {
        Connection con = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<User> users = new ArrayList<>();
        
        try {
            con = getConnection();
            String sql = "SELECT * FROM users WHERE user_type = ?";
            stmt = con.prepareStatement(sql);
            stmt.setString(1, userType.name());
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
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
        
        return users;
    }
    
    public void delete(User user) {
        Connection con = null;
        PreparedStatement stmt = null;
        
        try {
            con = getConnection();
            String sql = "DELETE FROM users WHERE id = ?";
            stmt = con.prepareStatement(sql);
            stmt.setInt(1, user.getId());
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
    
    public void update(User user) {
        Connection con = null;
        PreparedStatement stmt = null;
        
        try {
            con = getConnection();
            String sql = "UPDATE users SET full_name=?, username=?, email=?, password=?, user_type=?, school_id=?, age=?, class_grade=?, avatar=? WHERE id=?";
            
            stmt = con.prepareStatement(sql);
            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getUsername());
            stmt.setString(3, user.getEmail());
            stmt.setString(4, user.getPassword());
            stmt.setString(5, user.getUserType().name());
            stmt.setObject(6, user.getSchoolId(), Types.INTEGER);
            stmt.setObject(7, user.getAge(), Types.INTEGER);
            stmt.setString(8, user.getClassGrade());
            stmt.setString(9, user.getAvatar());
            stmt.setInt(10, user.getId());
            
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
    
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setFullName(rs.getString("full_name"));
        user.setUsername(rs.getString("username"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        String userTypeStr = rs.getString("user_type");
        if (userTypeStr != null && !userTypeStr.isEmpty()) {
            try {
                user.setUserType(UserType.valueOf(userTypeStr));
            } catch (IllegalArgumentException e) {
                // Default to Student if invalid user type
                user.setUserType(UserType.Student);
                System.out.println("Invalid user type found in database: " + userTypeStr);
            }
        } else {
            // Default to Student if user type is null or empty
            user.setUserType(UserType.Student);
        }
        user.setSchoolId(rs.getObject("school_id", Integer.class));
        user.setAge(rs.getObject("age", Integer.class));
        user.setClassGrade(rs.getString("class_grade"));
        user.setAvatar(rs.getString("avatar"));
        
        Timestamp timestamp = rs.getTimestamp("registration_date");
        if (timestamp != null) {
            user.setRegistrationDate(timestamp.toLocalDateTime());
        }
        
        return user;
    }
}