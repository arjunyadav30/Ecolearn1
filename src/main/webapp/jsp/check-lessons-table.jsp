<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Check Lessons Table</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h2>Lessons Table Check</h2>
        <%
            Connection con = null;
            try {
                // Database connection
                Class.forName("com.mysql.cj.jdbc.Driver");
                String url = "jdbc:mysql://localhost:3306/ecolearn";
                String username = "root";
                String password = "1234";
                con = DriverManager.getConnection(url, username, password);
                
                out.println("<div class='alert alert-success'>Database connection successful!</div>");
                
                // Check if lessons table exists and has video_url column
                DatabaseMetaData metaData = con.getMetaData();
                ResultSet rs = metaData.getColumns(null, null, "lessons", "video_url");
                
                if (rs.next()) {
                    out.println("<div class='alert alert-success'>The 'video_url' column exists in the 'lessons' table.</div>");
                } else {
                    out.println("<div class='alert alert-warning'>The 'video_url' column does not exist in the 'lessons' table.</div>");
                    out.println("<p>You need to run the database update script to add this column.</p>");
                }
                rs.close();
                
                // Display some information about the lessons table
                out.println("<h3>Lessons Table Structure</h3>");
                rs = metaData.getColumns(null, null, "lessons", null);
                out.println("<table class='table table-striped'>");
                out.println("<thead><tr><th>Column Name</th><th>Data Type</th><th>Nullable</th></tr></thead>");
                out.println("<tbody>");
                while (rs.next()) {
                    String columnName = rs.getString("COLUMN_NAME");
                    String dataType = rs.getString("TYPE_NAME");
                    String nullable = rs.getString("IS_NULLABLE");
                    out.println("<tr><td>" + columnName + "</td><td>" + dataType + "</td><td>" + nullable + "</td></tr>");
                }
                out.println("</tbody></table>");
                rs.close();
                
            } catch (Exception e) {
                out.println("<div class='alert alert-danger'>Database connection failed:</div>");
                out.println("<p>" + e.getMessage() + "</p>");
                e.printStackTrace();
            } finally {
                try {
                    if (con != null) con.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        %>
        <a href="apply-database-changes.jsp" class="btn btn-primary">Apply Database Changes</a>
    </div>
</body>
</html>