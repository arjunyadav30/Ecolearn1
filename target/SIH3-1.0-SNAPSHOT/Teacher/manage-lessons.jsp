
<%@ page import="com.mycompany.sih3.entity.User" %>
<%@ page import="com.mycompany.sih3.entity.Lesson" %>
<%@ page import="com.mycompany.sih3.repository.LessonRepository" %>
<%@ page import="java.io.*, java.util.*, javax.servlet.*, javax.servlet.http.*, org.apache.commons.fileupload.*, org.apache.commons.fileupload.disk.*, org.apache.commons.fileupload.servlet.*" %>
<%@ page import="java.nio.file.*, java.time.LocalDateTime, java.sql.SQLException" %>
<%@ include file="auth_check.jsp" %>
<%
    User currentUser = (User) session.getAttribute("user");
    String displayName = currentUser.getFullName();
    if (displayName == null || displayName.trim().isEmpty()) {
        displayName = currentUser.getUsername();
    }
    
    // Handle form submission for adding a lesson
    String message = "";
    String messageType = "";
    
    // Check for delete request
    String deleteId = request.getParameter("deleteId");
    if (deleteId != null && !deleteId.isEmpty()) {
        try {
            int id = Integer.parseInt(deleteId);
            LessonRepository lessonRepository = new LessonRepository();
            Lesson lessonToDelete = lessonRepository.findById(id);
            if (lessonToDelete != null) {
                lessonRepository.delete(lessonToDelete);
                message = "Lesson deleted successfully!";
                messageType = "success";
            } else {
                message = "Lesson not found!";
                messageType = "danger";
            }
        } catch (NumberFormatException e) {
            message = "Invalid lesson ID!";
            messageType = "danger";
        } catch (Exception e) {
            message = "Error deleting lesson: " + e.getMessage();
            messageType = "danger";
            e.printStackTrace();
        }
    }
    
    // Check if this is a multipart request (file upload for add/edit)
    boolean isMultipart = ServletFileUpload.isMultipartContent(request);
    
    if (isMultipart) {
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
            String title = "";
            String description = "";
            String category = "";
            Integer points = 0;
            String videoFileName = "";
            String action = "";
            Integer lessonId = null;
            
            for (FileItem item : items) {
                if (item.isFormField()) {
                    // Process form fields
                    String fieldName = item.getFieldName();
                    String fieldValue = item.getString("UTF-8");
                    
                    if ("lessonTitle".equals(fieldName)) {
                        title = fieldValue;
                    } else if ("lessonDescription".equals(fieldName)) {
                        description = fieldValue;
                    } else if ("lessonCategory".equals(fieldName)) {
                        category = fieldValue;
                    } else if ("lessonPoints".equals(fieldName)) {
                        points = Integer.parseInt(fieldValue);
                    } else if ("action".equals(fieldName)) {
                        action = fieldValue;
                    } else if ("lessonId".equals(fieldName)) {
                        if (fieldValue != null && !fieldValue.isEmpty()) {
                            lessonId = Integer.parseInt(fieldValue);
                        }
                    }
                } else {
                    // Process uploaded file
                    String fieldName = item.getFieldName();
                    if ("lessonVideo".equals(fieldName)) {
                        String fileName = item.getName();
                        if (fileName != null && !fileName.isEmpty()) {
                            // Generate unique file name
                            String fileExtension = "";
                            int dotIndex = fileName.lastIndexOf('.');
                            if (dotIndex > 0) {
                                fileExtension = fileName.substring(dotIndex);
                            }
                            // Use a safer filename generation that doesn't depend on title
                            videoFileName = "lesson_" + System.currentTimeMillis() + fileExtension;
                            
                            // Save file to uploads directory
                            String uploadPath = application.getRealPath("/") + "uploads" + File.separator + "videos";
                            File uploadDir = new File(uploadPath);
                            if (!uploadDir.exists()) {
                                uploadDir.mkdirs();
                            }
                            
                            File uploadedFile = new File(uploadPath + File.separator + videoFileName);
                            item.write(uploadedFile);
                        }
                    }
                }
            }
            
            // Save or update lesson to database
            if (!title.isEmpty()) {
                Lesson lesson = new Lesson();
                lesson.setTitle(title);
                lesson.setDescription(description);
                lesson.setCategory(category);
                lesson.setPoints(points);
                lesson.setCreatedAt(LocalDateTime.now());
                lesson.setUpdatedAt(LocalDateTime.now());
                
                // If editing existing lesson
                if ("edit".equals(action) && lessonId != null) {
                    lesson.setId(lessonId);
                    // If new video was uploaded, use it; otherwise keep existing video
                    if (!videoFileName.isEmpty()) {
                        lesson.setVideoUrl("uploads/videos/" + videoFileName);
                    } else {
                        // Keep existing video URL
                        LessonRepository lessonRepository = new LessonRepository();
                        Lesson existingLesson = lessonRepository.findById(lessonId);
                        if (existingLesson != null) {
                            lesson.setVideoUrl(existingLesson.getVideoUrl());
                        }
                    }
                    LessonRepository lessonRepository = new LessonRepository();
                    lessonRepository.update(lesson);
                    message = "Lesson updated successfully!";
                } else {
                    // Adding new lesson
                    if (!videoFileName.isEmpty()) {
                        lesson.setVideoUrl("uploads/videos/" + videoFileName);
                    }
                    LessonRepository lessonRepository = new LessonRepository();
                    lessonRepository.save(lesson);
                    message = "Lesson added successfully!";
                }
                
                messageType = "success";
            }
        } catch (SQLException e) {
            message = "Database error: " + e.getMessage();
            messageType = "danger";
            e.printStackTrace();
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
            messageType = "danger";
            e.printStackTrace();
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Lessons - EcoLearn Platform</title>
    
    <!-- CSS Libraries -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --primary-green: #2d8f44;
            --secondary-teal: #20c997;
            --accent-blue: #3498db;
            --light-gray: #f8f9fa;
            --dark-gray: #343a40;
            --border-radius-lg: 0.75rem;
            --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            --spacing-md: 1rem;
            --spacing-lg: 1.5rem;
            --spacing-xl: 2rem;
        }
        
        body {
            font-family: 'Poppins', system-ui, -apple-system, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            margin: 0;
            padding: 0;
            min-height: 100vh;
        }
        
        .manage-lessons {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            padding-top: 76px;
        }
        
        .navbar {
            background: linear-gradient(135deg, #1abc9c, #17a2b8) !important;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .main-content {
            padding: var(--spacing-xl) 0;
        }
        
        .page-header {
            background: linear-gradient(135deg, #3498db 0%, #2c3e50 100%);
            color: white;
            padding: var(--spacing-xl);
            border-radius: var(--border-radius-lg);
            margin-bottom: var(--spacing-xl);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            position: relative;
            overflow: hidden;
        }
        
        .page-title {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
        
        .page-subtitle {
            font-size: 1.125rem;
            opacity: 0.9;
            margin-bottom: 0;
        }
        
        .section-card {
            background: white;
            border-radius: var(--border-radius-lg);
            box-shadow: var(--shadow-md);
            padding: var(--spacing-lg);
            margin-bottom: var(--spacing-lg);
        }
        
        .section-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--dark-gray);
            margin-bottom: var(--spacing-md);
            padding-bottom: 0.5rem;
            border-bottom: 2px solid var(--primary-green);
        }
        
        .btn-primary {
            background: linear-gradient(135deg, var(--primary-green), var(--secondary-teal));
            border: none;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
        }
        
        .lesson-table th {
            background-color: var(--primary-green);
            color: white;
        }
        
        .action-buttons .btn {
            margin-right: 0.5rem;
        }
        
        footer {
            background: #2c3e50;
            color: #95a5a6;
            padding: 1.5rem 0;
            margin-top: auto;
        }
    </style>
</head>
<body class="manage-lessons">
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary fixed-top">
        <div class="container-fluid">
            <a class="navbar-brand" href="../index.jsp">
                <i class="fas fa-leaf me-2"></i>EcoLearn
            </a>
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="teacherdashboard.jsp">
                            <i class="fas fa-tachometer-alt me-1"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="manage-lessons.jsp">
                            <i class="fas fa-graduation-cap me-1"></i>Manage Lessons
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="manage-quizzes.jsp">
                            <i class="fas fa-question-circle me-1"></i>Manage Quizzes
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="student-progress.jsp">
                            <i class="fas fa-chart-line me-1"></i>Student Progress
                        </a>
                    </li>
                </ul>
                
                <ul class="navbar-nav">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle d-flex align-items-center" href="#" role="button" data-bs-toggle="dropdown">
                            <div class="user-avatar me-2">
                                <i class="fas fa-user-circle fa-lg"></i>
                            </div>
                            <span class="user-name"><%= displayName %></span>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item" href="profile.jsp"><i class="fas fa-user me-2"></i>Profile</a></li>
                            <li><a class="dropdown-item" href="settings.jsp"><i class="fas fa-cog me-2"></i>Settings</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="../jsp/logout.jsp"><i class="fas fa-sign-out-alt me-2"></i>Logout</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container main-content">
        <!-- Page Header -->
        <div class="page-header">
            <div class="row align-items-center">
                <div class="col-lg-8">
                    <h1 class="page-title">
                        <i class="fas fa-graduation-cap me-2"></i>Manage Lessons
                    </h1>
                    <p class="page-subtitle">
                        Create, edit, and organize your educational lessons
                    </p>
                </div>
                <div class="col-lg-4 text-end">
                    <button class="btn btn-light" onclick="window.location.href='add-lesson-unified.jsp'">
                        <i class="fas fa-plus me-2"></i>Add New Lesson
                    </button>
                </div>
            </div>
        </div>

        <!-- Display messages -->
        <% if (!message.isEmpty()) { %>
            <div class="alert alert-<%= messageType.equals("success") ? "success" : "danger" %> alert-dismissible fade show" role="alert">
                <%= message %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>

        <!-- Lessons Section -->
        <div class="section-card">
            <h2 class="section-title">Your Lessons</h2>
            
            <div class="table-responsive">
                <table class="table table-striped lesson-table">
                    <thead>
                        <tr>
                            <th>Title</th>
                            <th>Category</th>
                            <th>Points</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            LessonRepository lessonRepository = new LessonRepository();
                            java.util.List<com.mycompany.sih3.entity.Lesson> lessons = lessonRepository.findAll();
                            
                            if (lessons.isEmpty()) {
                        %>
                        <tr>
                            <td colspan="4" class="text-center">No lessons found. Add your first lesson using the "Add New Lesson" button.</td>
                        </tr>
                        <%
                            } else {
                                for (com.mycompany.sih3.entity.Lesson lesson : lessons) {
                        %>
                        <tr>
                            <td><%= lesson.getTitle() %></td>
                            <td><%= lesson.getCategory() %></td>
                            <td><%= lesson.getPoints() %></td>
                            <td class="action-buttons">
                                <button class="btn btn-sm btn-outline-primary edit-btn" 
                                        data-id="<%= lesson.getId() %>" 
                                        data-title="<%= lesson.getTitle() %>" 
                                        data-description="<%= lesson.getDescription() != null ? lesson.getDescription() : "" %>" 
                                        data-category="<%= lesson.getCategory() %>" 
                                        data-points="<%= lesson.getPoints() %>" 
                                        data-video="<%= lesson.getVideoUrl() != null ? lesson.getVideoUrl() : "" %>">
                                    <i class="fas fa-edit"></i> Edit
                                </button>
                                <% if (lesson.getVideoUrl() != null && !lesson.getVideoUrl().isEmpty()) { %>
                                    <a href="video-transcript.jsp?lessonId=<%= lesson.getId() %>" class="btn btn-sm btn-outline-info">
                                        <i class="fas fa-file-alt"></i> Transcript
                                    </a>
                                <% } %>
                                <button class="btn btn-sm btn-outline-danger delete-btn" 
                                        data-id="<%= lesson.getId() %>" 
                                        data-title="<%= lesson.getTitle() %>">
                                    <i class="fas fa-trash"></i> Delete
                                </button>
                            </td>
                        </tr>
                        <%
                                }
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Edit Lesson Modal -->
    <div class="modal fade" id="editLessonModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Edit Lesson</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form method="post" enctype="multipart/form-data" id="editLessonForm">
                        <input type="hidden" id="editLessonId" name="lessonId">
                        <input type="hidden" name="action" value="edit">
                        <div class="mb-3">
                            <label for="editLessonTitle" class="form-label">Lesson Title</label>
                            <input type="text" class="form-control" id="editLessonTitle" name="lessonTitle" placeholder="Enter lesson title" required>
                        </div>
                        <div class="mb-3">
                            <label for="editLessonCategory" class="form-label">Category</label>
                            <select class="form-select" id="editLessonCategory" name="lessonCategory" required>
                                <option value="">Select category</option>
                                <option>Climate</option>
                                <option>Biodiversity</option>
                                <option>Energy</option>
                                <option>Waste Management</option>
                                <option>Water Conservation</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="editLessonPoints" class="form-label">Points</label>
                            <input type="number" class="form-control" id="editLessonPoints" name="lessonPoints" placeholder="Enter points value" required>
                        </div>
                        <div class="mb-3">
                            <label for="editLessonDescription" class="form-label">Description</label>
                            <textarea class="form-control" id="editLessonDescription" name="lessonDescription" rows="3" placeholder="Enter lesson description"></textarea>
                        </div>
                        <div class="mb-3">
                            <label for="editLessonVideo" class="form-label">Video Upload (Leave blank to keep current video)</label>
                            <input type="file" class="form-control" id="editLessonVideo" name="lessonVideo" accept="video/*">
                            <div class="form-text">Current video: <span id="currentVideo"></span></div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary" form="editLessonForm">Update Lesson</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteLessonModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Confirm Delete</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete the lesson "<span id="deleteLessonTitle"></span>"?</p>
                    <p class="text-danger">This action cannot be undone.</p>
                    <form method="post" id="deleteLessonForm">
                        <input type="hidden" id="deleteLessonId" name="deleteId">
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-danger" form="deleteLessonForm">Delete Lesson</button>
                </div>
            </div>
        </div>
    </div>

    <footer class="text-center">
        <div class="container">
            <p>&copy; 2025 EcoLearn Platform. All rights reserved.</p>
        </div>
    </footer>

    <!-- JavaScript Libraries -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom JavaScript for Edit and Delete functionality -->
    <script>
        // Edit button click handler
        document.querySelectorAll('.edit-btn').forEach(button => {
            button.addEventListener('click', function() {
                const id = this.getAttribute('data-id');
                const title = this.getAttribute('data-title');
                const description = this.getAttribute('data-description');
                const category = this.getAttribute('data-category');
                const points = this.getAttribute('data-points');
                const video = this.getAttribute('data-video');
                
                // Populate the edit form with existing lesson data
                document.getElementById('editLessonId').value = id;
                document.getElementById('editLessonTitle').value = title;
                document.getElementById('editLessonDescription').value = description;
                document.getElementById('editLessonCategory').value = category;
                document.getElementById('editLessonPoints').value = points;
                document.getElementById('currentVideo').textContent = video ? video : 'No video uploaded';
                
                // Show the edit modal
                var editModal = new bootstrap.Modal(document.getElementById('editLessonModal'));
                editModal.show();
            });
        });
        
        // Delete button click handler
        document.querySelectorAll('.delete-btn').forEach(button => {
            button.addEventListener('click', function() {
                const id = this.getAttribute('data-id');
                const title = this.getAttribute('data-title');
                
                // Populate the delete confirmation modal
                document.getElementById('deleteLessonId').value = id;
                document.getElementById('deleteLessonTitle').textContent = title;
                
                // Show the delete confirmation modal
                var deleteModal = new bootstrap.Modal(document.getElementById('deleteLessonModal'));
                deleteModal.show();
            });
        });
        
        // Reset forms when modals are closed
        document.getElementById('editLessonModal').addEventListener('hidden.bs.modal', function () {
            document.getElementById('editLessonForm').reset();
            document.getElementById('currentVideo').textContent = '';
        });
    </script>
</body>
</html>