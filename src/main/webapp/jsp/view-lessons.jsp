<%@ page import="com.mycompany.sih3.entity.Lesson" %>
<%@ page import="com.mycompany.sih3.repository.LessonRepository" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>View Lessons</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h2>All Lessons</h2>
        <%
            try {
                LessonRepository lessonRepository = new LessonRepository();
                List<Lesson> lessons = lessonRepository.findAll();
                
                if (lessons.isEmpty()) {
                    out.println("<p>No lessons found in the database.</p>");
                } else {
                    out.println("<table class='table table-striped'>");
                    out.println("<thead><tr><th>ID</th><th>Title</th><th>Category</th><th>Points</th><th>Video URL</th></tr></thead>");
                    out.println("<tbody>");
                    for (Lesson lesson : lessons) {
                        out.println("<tr>");
                        out.println("<td>" + lesson.getId() + "</td>");
                        out.println("<td>" + lesson.getTitle() + "</td>");
                        out.println("<td>" + lesson.getCategory() + "</td>");
                        out.println("<td>" + lesson.getPoints() + "</td>");
                        out.println("<td>" + (lesson.getVideoUrl() != null ? lesson.getVideoUrl() : "N/A") + "</td>");
                        out.println("</tr>");
                    }
                    out.println("</tbody>");
                    out.println("</table>");
                }
                
            } catch (Exception e) {
                out.println("<div class='alert alert-danger'>Error retrieving lessons:</div>");
                out.println("<p>" + e.getMessage() + "</p>");
                e.printStackTrace();
            }
        %>
        <a href="test-lesson-save.jsp" class="btn btn-primary">Add Test Lesson</a>
        <a href="check-lessons-table.jsp" class="btn btn-secondary">Check Table Structure</a>
    </div>
</body>
</html>