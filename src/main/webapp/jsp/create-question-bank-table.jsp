<%@ page import="java.sql.*" %>
<%@ page import="java.sql.DatabaseMetaData" %>
<%
    Connection con = null;
    Statement stmt = null;
    
    try {
        // Database connection
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/ecolearn";
        String username = "root";
        String password = "1234";
        con = DriverManager.getConnection(url, username, password);
        
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
        
        out.println("<h2>Question bank table created successfully!</h2>");
        out.println("<p>The question_bank table has been created in the database.</p>");
        
        // Insert sample data
        String[] insertSQLs = {
            "INSERT IGNORE INTO question_bank (category, question_text, option_a, option_b, option_c, option_d, correct_option, difficulty_level) VALUES ('Mathematics', 'What is the value of π (pi) approximately?', '3.14', '2.71', '1.61', '4.67', 'a', 'easy')",
            "INSERT IGNORE INTO question_bank (category, question_text, option_a, option_b, option_c, option_d, correct_option, difficulty_level) VALUES ('Mathematics', 'What is the derivative of x^2?', '2x', 'x^2', 'x', '2x^2', 'a', 'medium')",
            "INSERT IGNORE INTO question_bank (category, question_text, option_a, option_b, option_c, option_d, correct_option, difficulty_level) VALUES ('Mathematics', 'What is the integral of 2x dx?', 'x^2 + C', '2x^2 + C', 'x + C', '2x + C', 'a', 'medium')",
            "INSERT IGNORE INTO question_bank (category, question_text, option_a, option_b, option_c, option_d, correct_option, difficulty_level) VALUES ('Science', 'What is the chemical symbol for water?', 'H2O', 'CO2', 'NaCl', 'O2', 'a', 'easy')",
            "INSERT IGNORE INTO question_bank (category, question_text, option_a, option_b, option_c, option_d, correct_option, difficulty_level) VALUES ('Science', 'What is the speed of light in vacuum?', '3 x 10^8 m/s', '3 x 10^6 m/s', '3 x 10^10 m/s', '3 x 10^5 m/s', 'a', 'hard')",
            "INSERT IGNORE INTO question_bank (category, question_text, option_a, option_b, option_c, option_d, correct_option, difficulty_level) VALUES ('Science', 'What is the powerhouse of the cell?', 'Nucleus', 'Mitochondria', 'Ribosome', 'Endoplasmic reticulum', 'b', 'easy')",
            "INSERT IGNORE INTO question_bank (category, question_text, option_a, option_b, option_c, option_d, correct_option, difficulty_level) VALUES ('History', 'In which year did World War II end?', '1945', '1939', '1950', '1947', 'a', 'easy')",
            "INSERT IGNORE INTO question_bank (category, question_text, option_a, option_b, option_c, option_d, correct_option, difficulty_level) VALUES ('History', 'Who was the first President of the United States?', 'Thomas Jefferson', 'George Washington', 'Abraham Lincoln', 'John Adams', 'b', 'easy')",
            "INSERT IGNORE INTO question_bank (category, question_text, option_a, option_b, option_c, option_d, correct_option, difficulty_level) VALUES ('Geography', 'What is the capital of France?', 'London', 'Berlin', 'Paris', 'Rome', 'c', 'easy')",
            "INSERT IGNORE INTO question_bank (category, question_text, option_a, option_b, option_c, option_d, correct_option, difficulty_level) VALUES ('Geography', 'Which is the longest river in the world?', 'Amazon River', 'Nile River', 'Mississippi River', 'Yangtze River', 'b', 'medium')",
            "INSERT IGNORE INTO question_bank (category, question_text, option_a, option_b, option_c, option_d, correct_option, difficulty_level) VALUES ('Literature', 'Who wrote \"Romeo and Juliet\"?', 'Charles Dickens', 'William Shakespeare', 'Mark Twain', 'Jane Austen', 'b', 'easy')",
            "INSERT IGNORE INTO question_bank (category, question_text, option_a, option_b, option_c, option_d, correct_option, difficulty_level) VALUES ('Literature', 'What is the pen name of Samuel Clemens?', 'Mark Twain', 'George Eliot', 'Lewis Carroll', 'Oscar Wilde', 'a', 'medium')",
            "INSERT IGNORE INTO question_bank (category, question_text, option_a, option_b, option_c, option_d, correct_option, difficulty_level) VALUES ('Computer Science', 'What does CPU stand for?', 'Central Processing Unit', 'Computer Processing Unit', 'Central Processor Unit', 'Computer Processor Unit', 'a', 'easy')",
            "INSERT IGNORE INTO question_bank (category, question_text, option_a, option_b, option_c, option_d, correct_option, difficulty_level) VALUES ('Computer Science', 'Which programming language is known as the \"language of the web\"?', 'Python', 'Java', 'JavaScript', 'C++', 'c', 'easy')",
            "INSERT IGNORE INTO question_bank (category, question_text, option_a, option_b, option_c, option_d, correct_option, difficulty_level) VALUES ('Computer Science', 'What is the time complexity of binary search?', 'O(n)', 'O(log n)', 'O(n^2)', 'O(1)', 'b', 'hard')",
            "INSERT IGNORE INTO question_bank (category, question_text, option_a, option_b, option_c, option_d, correct_option, difficulty_level) VALUES ('Physics', 'What is the unit of force in SI system?', 'Joule', 'Watt', 'Newton', 'Pascal', 'c', 'easy')",
            "INSERT IGNORE INTO question_bank (category, question_text, option_a, option_b, option_c, option_d, correct_option, difficulty_level) VALUES ('Physics', 'What is the formula for kinetic energy?', 'KE = mv', 'KE = mv^2', 'KE = (1/2)mv^2', 'KE = (1/2)mv', 'c', 'medium')",
            "INSERT IGNORE INTO question_bank (category, question_text, option_a, option_b, option_c, option_d, correct_option, difficulty_level) VALUES ('Chemistry', 'What is the pH of pure water?', '0', '7', '14', '10', 'b', 'easy')",
            "INSERT IGNORE INTO question_bank (category, question_text, option_a, option_b, option_c, option_d, correct_option, difficulty_level) VALUES ('Chemistry', 'Which element has the chemical symbol \"Au\"?', 'Silver', 'Aluminum', 'Gold', 'Argon', 'c', 'medium')",
            "INSERT IGNORE INTO question_bank (category, question_text, option_a, option_b, option_c, option_d, correct_option, difficulty_level) VALUES ('Biology', 'How many bones are there in an adult human body?', '206', '300', '150', '250', 'a', 'medium')",
            "INSERT IGNORE INTO question_bank (category, question_text, option_a, option_b, option_c, option_d, correct_option, difficulty_level) VALUES ('Biology', 'What is the largest organ in the human body?', 'Liver', 'Brain', 'Skin', 'Heart', 'c', 'easy')",
            "INSERT IGNORE INTO question_bank (category, question_text, option_a, option_b, option_c, option_d, correct_option, difficulty_level) VALUES ('Economics', 'What does GDP stand for?', 'Gross Domestic Product', 'Gross Domestic Profit', 'Global Domestic Product', 'General Domestic Product', 'a', 'easy')",
            "INSERT IGNORE INTO question_bank (category, question_text, option_a, option_b, option_c, option_d, correct_option, difficulty_level) VALUES ('Economics', 'What is inflation?', 'Decrease in price level', 'Increase in price level', 'Stable price level', 'Fluctuating price level', 'b', 'easy')",
            "INSERT IGNORE INTO question_bank (category, question_text, option_a, option_b, option_c, option_d, correct_option, difficulty_level) VALUES ('Art', 'Who painted the Mona Lisa?', 'Vincent van Gogh', 'Pablo Picasso', 'Leonardo da Vinci', 'Michelangelo', 'c', 'easy')",
            "INSERT IGNORE INTO question_bank (category, question_text, option_a, option_b, option_c, option_d, correct_option, difficulty_level) VALUES ('Music', 'How many notes are there in a musical scale?', '7', '8', '12', '5', 'a', 'easy')"
        };
        
        int insertedCount = 0;
        for (String insertSQL : insertSQLs) {
            try {
                stmt.executeUpdate(insertSQL);
                insertedCount++;
            } catch (SQLException e) {
                // Ignore duplicate key errors
                if (e.getErrorCode() != 1062) { // 1062 is duplicate entry error
                    out.println("<p>Error inserting sample data: " + e.getMessage() + "</p>");
                }
            }
        }
        
        out.println("<p>Inserted " + insertedCount + " sample questions into the question bank.</p>");
        
    } catch (Exception e) {
        out.println("<h2>Error creating question bank table:</h2>");
        out.println("<p>" + e.getMessage() + "</p>");
        e.printStackTrace();
    } finally {
        try {
            if (stmt != null) stmt.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>