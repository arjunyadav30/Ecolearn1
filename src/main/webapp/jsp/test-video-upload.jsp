<%@ page import="java.io.*, java.util.*, javax.servlet.*, javax.servlet.http.*, org.apache.commons.fileupload.*, org.apache.commons.fileupload.disk.*, org.apache.commons.fileupload.servlet.*" %>
<%
    // Check if this is a multipart request (file upload)
    boolean isMultipart = ServletFileUpload.isMultipartContent(request);
    
    if (!isMultipart) {
%>
<!DOCTYPE html>
<html>
<head>
    <title>Test Video Upload</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h2>Test Video Upload</h2>
        <form method="post" enctype="multipart/form-data">
            <div class="mb-3">
                <label for="videoFile" class="form-label">Select Video File:</label>
                <input type="file" class="form-control" id="videoFile" name="videoFile" accept="video/*" required>
            </div>
            <button type="submit" class="btn btn-primary">Upload Video</button>
        </form>
    </div>
</body>
</html>
<%
    } else {
        try {
            // Create a factory for disk-based file items
            DiskFileItemFactory factory = new DiskFileItemFactory();
            
            // Set the temporary directory to store uploaded files
            factory.setRepository(new File(System.getProperty("java.io.tmpdir")));
            
            // Create a new file upload handler
            ServletFileUpload upload = new ServletFileUpload(factory);
            
            // Parse the request
            List<FileItem> items = upload.parseRequest(request);
            
            // Process the uploaded items
            for (FileItem item : items) {
                if (!item.isFormField()) {
                    String fieldName = item.getFieldName();
                    if ("videoFile".equals(fieldName)) {
                        String fileName = item.getName();
                        if (fileName != null && !fileName.isEmpty()) {
                            // Save file to uploads directory
                            String uploadPath = application.getRealPath("/") + "uploads" + File.separator + "videos";
                            File uploadDir = new File(uploadPath);
                            if (!uploadDir.exists()) {
                                uploadDir.mkdirs();
                            }
                            
                            File uploadedFile = new File(uploadPath + File.separator + fileName);
                            item.write(uploadedFile);
                            
                            out.println("<h2>Upload Successful!</h2>");
                            out.println("<p>File saved to: " + uploadedFile.getAbsolutePath() + "</p>");
                            out.println("<a href='test-video-upload.jsp' class='btn btn-primary'>Upload Another File</a>");
                            return;
                        }
                    }
                }
            }
            
            out.println("<h2>No file uploaded</h2>");
            out.println("<a href='test-video-upload.jsp' class='btn btn-primary'>Try Again</a>");
            
        } catch (Exception e) {
            out.println("<h2>Error uploading file:</h2>");
            out.println("<p>" + e.getMessage() + "</p>");
            e.printStackTrace();
            out.println("<a href='test-video-upload.jsp' class='btn btn-primary'>Try Again</a>");
        }
    }
%>