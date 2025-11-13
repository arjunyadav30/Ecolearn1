<%@ page import="java.sql.*" %>
<%
    Connection con = null;
    Statement stmt = null;
    
    try {
        out.println("<h2>Database Setup</h2>");
        
        // First, connect without specifying a database to create the ecolearn database
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/mysql"; // Connect to mysql database first
        String username = "root";
        String password = "1234";
        con = DriverManager.getConnection(url, username, password);
        
        out.println("<p>Connected to MySQL server successfully.</p>");
        
        // Create the ecolearn database
        stmt = con.createStatement();
        stmt.executeUpdate("CREATE DATABASE IF NOT EXISTS ecolearn");
        
        out.println("<p style='color: green;'>✓ Database 'ecolearn' created or already exists.</p>");
        
        // Now connect to the ecolearn database to create the table
        con.close();
        stmt.close();
        
        url = "jdbc:mysql://localhost:3306/ecolearn";
        con = DriverManager.getConnection(url, username, password);
        
        out.println("<p>Connected to 'ecolearn' database.</p>");
        
        // Create question_bank table
        stmt = con.createStatement();
        String createTableSQL = "CREATE TABLE IF NOT EXISTS question_bank (" +
            "id INT AUTO_INCREMENT PRIMARY KEY, " +
            "category VARCHAR(100) NOT NULL, " +
            "question_text TEXT NOT NULL, " +
            "option_a VARCHAR(500) NOT NULL, " +
            "option_b VARCHAR(500) NOT NULL, " +
            "option_c VARCHAR(500) NOT NULL, " +
            "option_d VARCHAR(500) NOT NULL, " +
            "correct_option CHAR(1) NOT NULL, " +
            "difficulty_level ENUM('easy', 'medium', 'hard') DEFAULT 'medium', " +
            "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
            "INDEX idx_question_bank_category (category), " +
            "INDEX idx_question_bank_difficulty (difficulty_level)" +
            ")";
        stmt.executeUpdate(createTableSQL);
        
        out.println("<p style='color: green;'>✓ Table 'question_bank' created or already exists.</p>");
        
        // Insert sample data
        String[] insertSQLs = {
            "INSERT IGNORE INTO question_bank (category, question_text, option_a, option_b, option_c, option_d, correct_option, difficulty_level) VALUES ('Environmental Science', 'What is the primary greenhouse gas?', 'Oxygen', 'Nitrogen', 'Carbon Dioxide', 'Methane', 'c', 'easy')",
            "INSERT IGNORE INTO question_bank (category, question_text, option_a, option_b, option_c, option_d, correct_option, difficulty_level) VALUES ('Environmental Science', 'What is the term for the variety of life in a particular habitat?', 'Ecosystem', 'Biodiversity', 'Biome', 'Population', 'b', 'easy')",
            "INSERT IGNORE INTO question_bank (category, question_text, option_a, option_b, option_c, option_d, correct_option, difficulty_level) VALUES ('Environmental Science', 'Which layer of the atmosphere contains the ozone layer?', 'Troposphere', 'Stratosphere', 'Mesosphere', 'Thermosphere', 'b', 'medium')",
            "INSERT IGNORE INTO question_bank (category, question_text, option_a, option_b, option_c, option_d, correct_option, difficulty_level) VALUES ('Environmental Science', 'What is the process of converting waste materials into reusable objects?', 'Incineration', 'Landfilling', 'Recycling', 'Composting', 'c', 'easy')",
            "INSERT IGNORE INTO question_bank (category, question_text, option_a, option_b, option_c, option_d, correct_option, difficulty_level) VALUES ('Environmental Science', 'What is the main cause of acid rain?', 'Deforestation', 'Overfishing', 'Air pollution', 'Soil erosion', 'c', 'easy')"
        };
        
        int insertedCount = 0;
        for (String insertSQL : insertSQLs) {
            try {
                stmt.executeUpdate(insertSQL);
                insertedCount++;
            } catch (SQLException e) {
                // Ignore duplicate key errors
                if (e.getErrorCode() != 1062) { // 1062 is duplicate entry error
                    out.println("<p style='color: orange;'>Warning: " + e.getMessage() + "</p>");
                }
            }
        }
        
        out.println("<p style='color: green;'>✓ Inserted " + insertedCount + " sample questions into the question bank.</p>");
        
        // Test the table
        ResultSet rs = stmt.executeQuery("SELECT COUNT(*) as count FROM question_bank");
        if (rs.next()) {
            int count = rs.getInt("count");
            out.println("<p style='color: green;'>✓ Total questions in question bank: " + count + "</p>");
        }
        
        out.println("<h3 style='color: green;'>✓ Database setup completed successfully!</h3>");
        out.println("<p><a href='test-database-connection.jsp'>Test database connection</a></p>");
        out.println("<p><a href='snakeladder.jsp'>Play Snake and Ladder Quiz</a></p>");
        
    } catch (Exception e) {
        out.println("<h2 style='color: red;'>Error setting up database:</h2>");
        out.println("<p>" + e.getMessage() + "</p>");
        e.printStackTrace(new java.io.PrintWriter(out));
    } finally {
        try {
            if (stmt != null) stmt.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>