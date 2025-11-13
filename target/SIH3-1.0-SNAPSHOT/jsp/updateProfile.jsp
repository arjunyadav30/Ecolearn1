<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mycompany.sih3.entity.User" %>
<%@ page import="com.mycompany.sih3.repository.UserRepository" %>
<%@ page import="java.io.*, java.util.*, javax.servlet.*, javax.servlet.http.*, org.apache.commons.fileupload.*, org.apache.commons.fileupload.disk.*, org.apache.commons.fileupload.servlet.*" %>
<%
    // Log that we've reached this page
    System.out.println("=== UPDATE PROFILE JSP EXECUTED ===");
    
    // Check if user is logged in
    User currentUser = (User) session.getAttribute("user");
    System.out.println("Current user from session: " + currentUser);
    
    if (currentUser == null) {
        System.out.println("ERROR: User not logged in");
        response.sendRedirect("../Teacher/profile.jsp");
        return;
    }
    
    Integer userId = currentUser.getId();
    System.out.println("User ID from session: " + userId);
    
    // Initialize variables for form data
    String firstName = null;
    String lastName = null;
    String email = null;
    String username = null;
    String school = null;
    String grade = null;
    String avatarPath = null;
    boolean removeAvatar = false;
    
    // Check if this is a multipart request (file upload)
    boolean isMultipart = ServletFileUpload.isMultipartContent(request);
    System.out.println("Is multipart request: " + isMultipart);
    
    if (isMultipart) {
        // Handle multipart form data (with file upload)
        try {
            // Create a factory for disk-based file items
            DiskFileItemFactory factory = new DiskFileItemFactory();
            
            // Set size threshold - above which files are written directly to disk
            factory.setSizeThreshold(1024 * 1024 * 10); // 10MB
            
            // Set the temporary directory to store uploaded files
            factory.setRepository(new File(System.getProperty("java.io.tmpdir")));
            
            // Create a new file upload handler
            ServletFileUpload upload = new ServletFileUpload(factory);
            
            // Set maximum file size
            upload.setFileSizeMax(1024 * 1024 * 50); // 50MB
            
            // Set maximum request size
            upload.setSizeMax(1024 * 1024 * 50); // 50MB
            
            // Parse the request
            List<FileItem> items = upload.parseRequest(request);
            
            // Process the uploaded items
            for (FileItem item : items) {
                if (item.isFormField()) {
                    // Process regular form field
                    String fieldName = item.getFieldName();
                    String fieldValue = item.getString("UTF-8");
                    
                    System.out.println("Form field: " + fieldName + " = " + fieldValue);
                    
                    switch (fieldName) {
                        case "firstName":
                            firstName = fieldValue;
                            break;
                        case "lastName":
                            lastName = fieldValue;
                            break;
                        case "email":
                            email = fieldValue;
                            break;
                        case "username":
                            username = fieldValue;
                            break;
                        case "school":
                            school = fieldValue;
                            break;
                        case "grade":
                            grade = fieldValue;
                            break;
                        case "removeAvatar":
                            removeAvatar = "true".equals(fieldValue);
                            break;
                    }
                } else {
                    // Process file upload
                    if (!item.getName().isEmpty()) {
                        System.out.println("Processing file upload: " + item.getName());
                        
                        // Handle file upload - save to a specific directory
                        String fileName = item.getName();
                        String uploadPath = application.getRealPath("/") + "uploads/avatars/";
                        
                        // Create upload directory if it doesn't exist
                        File uploadDir = new File(uploadPath);
                        if (!uploadDir.exists()) {
                            uploadDir.mkdirs();
                        }
                        
                        // Create a unique file name
                        String uniqueFileName = userId + "_" + System.currentTimeMillis() + "_" + fileName;
                        File uploadedFile = new File(uploadPath + uniqueFileName);
                        item.write(uploadedFile);
                        
                        // Store the relative path to save in database
                        avatarPath = "uploads/avatars/" + uniqueFileName;
                        System.out.println("File uploaded: " + uploadedFile.getAbsolutePath());
                        System.out.println("Avatar path: " + avatarPath);
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("ERROR: File upload failed - " + e.getMessage());
            e.printStackTrace();
        }
    } else {
        // Handle regular form data (no file upload)
        firstName = request.getParameter("firstName");
        lastName = request.getParameter("lastName");
        email = request.getParameter("email");
        username = request.getParameter("username");
        school = request.getParameter("school");
        grade = request.getParameter("grade");
        removeAvatar = "true".equals(request.getParameter("removeAvatar"));
        
        System.out.println("Regular form data received");
    }
    
    System.out.println("Received parameters:");
    System.out.println("- First Name: " + firstName);
    System.out.println("- Last Name: " + lastName);
    System.out.println("- Email: " + email);
    System.out.println("- Username: " + username);
    System.out.println("- School: " + school);
    System.out.println("- Grade: " + grade);
    System.out.println("- Remove Avatar: " + removeAvatar);
    System.out.println("- Avatar Path: " + avatarPath);
    
    // Validate required fields
    if (firstName == null || firstName.trim().isEmpty()) {
        System.out.println("ERROR: Missing first name");
        response.sendRedirect("../Teacher/profile.jsp?error=missing_firstname");
        return;
    }
    
    if (email == null || email.trim().isEmpty()) {
        System.out.println("ERROR: Missing email");
        response.sendRedirect("../Teacher/profile.jsp?error=missing_email");
        return;
    }
    
    if (username == null || username.trim().isEmpty()) {
        System.out.println("ERROR: Missing username");
        response.sendRedirect("../Teacher/profile.jsp?error=missing_username");
        return;
    }
    
    try {
        System.out.println("Fetching user from database with ID: " + userId);
        // Fetch user from database
        UserRepository userRepository = new UserRepository();
        User user = userRepository.findById(userId);
        
        if (user == null) {
            System.out.println("ERROR: User not found in database");
            response.sendRedirect("../Teacher/profile.jsp?error=user_not_found");
            return;
        }
        
        System.out.println("User found: " + user.getFullName() + " (" + user.getId() + ")");
        
        // Update user information
        String fullName = firstName;
        if (lastName != null && !lastName.trim().isEmpty()) {
            fullName += " " + lastName;
        }
        
        System.out.println("Updating user information:");
        System.out.println("- Full Name: " + fullName);
        System.out.println("- Email: " + email);
        System.out.println("- Username: " + username);
        
        user.setFullName(fullName);
        user.setEmail(email);
        user.setUsername(username);
        user.setSchoolId(1); // Default school ID
        user.setClassGrade(grade);
        
        // Handle avatar removal or update
        if (removeAvatar) {
            // If user wants to remove avatar, delete the file and set avatar to null
            String oldAvatarPath = user.getAvatar();
            if (oldAvatarPath != null && !oldAvatarPath.isEmpty()) {
                String fullPath = application.getRealPath("/") + oldAvatarPath;
                File oldAvatarFile = new File(fullPath);
                if (oldAvatarFile.exists()) {
                    oldAvatarFile.delete();
                }
            }
            user.setAvatar(null);
            System.out.println("Avatar removed");
        } else if (avatarPath != null && !avatarPath.isEmpty()) {
            // Update avatar if a new one was uploaded
            user.setAvatar(avatarPath);
            System.out.println("Avatar updated: " + avatarPath);
        }
        
        System.out.println("Calling userRepository.update()");
        // Save updated user
        userRepository.update(user);
        
        // Update user in session
        session.setAttribute("user", user);
        
        System.out.println("SUCCESS: User updated successfully");
        
        // Redirect to profile page with success message
        response.sendRedirect("../Teacher/profile.jsp?updated=true");
    } catch (Exception e) {
        // Log the error and redirect with error message
        System.out.println("ERROR: Failed to update user - " + e.getMessage());
        e.printStackTrace();
        response.sendRedirect("../Teacher/profile.jsp?error=update_failed");
    }
    
    System.out.println("=== UPDATE PROFILE JSP FINISHED ===");
%>