<%@ page import="java.io.*, java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>View Uploaded Videos</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h2>Uploaded Videos</h2>
        <%
            // Helper method to check if file is a video
            boolean isVideoFile(String fileName) {
                String[] videoExtensions = {".mp4", ".avi", ".mov", ".wmv", ".flv", ".webm"};
                String lowerFileName = fileName.toLowerCase();
                for (String ext : videoExtensions) {
                    if (lowerFileName.endsWith(ext)) {
                        return true;
                    }
                }
                return false;
            }
            
            // Helper method to format file size
            String formatFileSize(long size) {
                if (size < 1024) {
                    return size + " bytes";
                } else if (size < 1024 * 1024) {
                    return String.format("%.2f KB", size / 1024.0);
                } else if (size < 1024 * 1024 * 1024) {
                    return String.format("%.2f MB", size / (1024.0 * 1024.0));
                } else {
                    return String.format("%.2f GB", size / (1024.0 * 1024.0 * 1024.0));
                }
            }
            
            String uploadPath = application.getRealPath("/") + "uploads" + File.separator + "videos";
            File uploadDir = new File(uploadPath);
            
            if (!uploadDir.exists()) {
                out.println("<p>No videos uploaded yet.</p>");
            } else {
                File[] files = uploadDir.listFiles();
                if (files == null || files.length == 0) {
                    out.println("<p>No videos uploaded yet.</p>");
                } else {
                    out.println("<div class='row'>");
                    for (File file : files) {
                        if (file.isFile() && isVideoFile(file.getName())) {
                            String videoUrl = "uploads/videos/" + file.getName();
                            out.println("<div class='col-md-4 mb-4'>");
                            out.println("  <div class='card'>");
                            out.println("    <div class='card-body'>");
                            out.println("      <h5 class='card-title'>" + file.getName() + "</h5>");
                            out.println("      <p class='card-text'>Size: " + formatFileSize(file.length()) + "</p>");
                            out.println("      <a href='" + videoUrl + "' class='btn btn-primary' target='_blank'>View Video</a>");
                            out.println("    </div>");
                            out.println("  </div>");
                            out.println("</div>");
                        }
                    }
                    out.println("</div>");
                }
            }
        %>
    </div>
</body>
</html>