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
        
        // Check if video_url column already exists
        java.sql.DatabaseMetaData metaData = con.getMetaData();
        ResultSet rs = metaData.getColumns(null, null, "lessons", "video_url");
        boolean columnExists = rs.next();
        rs.close();
        
        if (!columnExists) {
            // Add video_url column to lessons table
            stmt = con.createStatement();
            String alterTableSQL = "ALTER TABLE lessons ADD COLUMN video_url VARCHAR(500) NULL DEFAULT NULL AFTER category";
            stmt.executeUpdate(alterTableSQL);
            
            // Add index for video_url column
            String createIndexSQL = "CREATE INDEX idx_lessons_video_url ON lessons (video_url)";
            stmt.executeUpdate(createIndexSQL);
            
            out.println("<h2>Database changes applied successfully!</h2>");
            out.println("<p>The video_url column has been added to the lessons table.</p>");
        } else {
            out.println("<h2>Database column already exists!</h2>");
            out.println("<p>The video_url column already exists in the lessons table.</p>");
        }
        
    } catch (Exception e) {
        out.println("<h2>Error applying database changes:</h2>");
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