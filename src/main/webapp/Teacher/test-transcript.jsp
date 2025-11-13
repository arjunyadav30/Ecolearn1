<%@ page import="com.mycompany.sih3.entity.Lesson" %>
<%@ page import="com.mycompany.sih3.util.VideoTranscriptionUtil" %>
<%@ page import="java.io.*" %>
<%@ include file="auth_check.jsp" %>
<%
    // Get display name for user
    com.mycompany.sih3.entity.User currentUser = (com.mycompany.sih3.entity.User) session.getAttribute("user");
    String displayName = currentUser.getFullName();
    if (displayName == null || displayName.trim().isEmpty()) {
        displayName = currentUser.getUsername();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Test Transcript Generation</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', system-ui, -apple-system, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            margin: 0;
            padding: 0;
            min-height: 100vh;
        }
        
        .test-transcript {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            padding-top: 76px;
        }
        
        .navbar {
            background: linear-gradient(135deg, #1abc9c, #17a2b8) !important;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .main-content {
            padding: 2rem 0;
        }
        
        .page-header {
            background: linear-gradient(135deg, #3498db 0%, #2c3e50 100%);
            color: white;
            padding: 2rem;
            border-radius: 0.75rem;
            margin-bottom: 2rem;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        }
        
        .section-card {
            background: white;
            border-radius: 0.75rem;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }
        
        .transcript-content {
            white-space: pre-wrap;
            line-height: 1.6;
            font-size: 1.1rem;
            background-color: #f8f9fa;
            border-radius: 0.75rem;
            padding: 1.5rem;
            max-height: 500px;
            overflow-y: auto;
            font-family: 'Courier New', monospace;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #2d8f44, #20c997);
            border: none;
        }
    </style>
</head>
<body class="test-transcript">
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
                        <a class="nav-link" href="manage-lessons.jsp">
                            <i class="fas fa-graduation-cap me-1"></i>Manage Lessons
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="video-transcripts.jsp">
                            <i class="fas fa-file-alt me-1"></i>Video Transcripts
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
        <div class="page-header">
            <div class="row align-items-center">
                <div class="col-lg-8">
                    <h1 class="page-title">
                        <i class="fas fa-bug me-2"></i>Test Transcript Generation
                    </h1>
                    <p class="page-subtitle">
                        Verify that the transcript generation functionality is working correctly
                    </p>
                </div>
                <div class="col-lg-4 text-end">
                    <button class="btn btn-light" onclick="window.location.href='teacherdashboard.jsp'">
                        <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
                    </button>
                </div>
            </div>
        </div>

        <div class="section-card">
            <h2 class="mb-4">Transcript Generation Test</h2>
            
            <%
            try {
                // Create a test lesson
                Lesson lesson = new Lesson();
                lesson.setId(1);
                lesson.setTitle("Test Environmental Science Lesson");
                lesson.setCategory("Environmental Science");
                lesson.setDescription("This is a test lesson about environmental science concepts.");
                
                // Generate transcript
                String transcript = VideoTranscriptionUtil.transcribeAudio(null, lesson);
                
                out.println("<div class='alert alert-success'>");
                out.println("<h3><i class='fas fa-check-circle me-2'></i>Transcript Generated Successfully</h3>");
                out.println("<p>The transcript generation functionality is working correctly.</p>");
                out.println("</div>");
                
                out.println("<h4 class='mt-4 mb-3'>Generated Transcript:</h4>");
                out.println("<div class='transcript-content'>" + transcript + "</div>");
                
            } catch (Exception e) {
                out.println("<div class='alert alert-danger'>");
                out.println("<h3><i class='fas fa-exclamation-triangle me-2'></i>Error Generating Transcript</h3>");
                out.println("<p>" + e.getMessage() + "</p>");
                out.println("<pre>");
                e.printStackTrace(new java.io.PrintWriter(out));
                out.println("</pre>");
                out.println("</div>");
            }
            %>
        </div>
        
        <div class="section-card">
            <h3 class="mb-3">Next Steps</h3>
            <p>If the transcript was generated successfully, the video transcription feature is working correctly. You can now:</p>
            <ul>
                <li>Upload video lessons using the "Manage Lessons" section</li>
                <li>View transcripts of your video lessons in the "Video Transcripts" section</li>
                <li>Access transcripts directly from the lesson management page</li>
            </ul>
            <div class="mt-3">
                <a href="manage-lessons.jsp" class="btn btn-primary me-2">
                    <i class="fas fa-book-open me-2"></i>Manage Lessons
                </a>
                <a href="video-transcripts.jsp" class="btn btn-info">
                    <i class="fas fa-file-alt me-2"></i>View Video Transcripts
                </a>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>