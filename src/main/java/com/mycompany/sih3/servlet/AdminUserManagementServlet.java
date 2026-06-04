package com.mycompany.sih3.servlet;

import com.mycompany.sih3.entity.User;
import com.mycompany.sih3.entity.UserType;
import com.mycompany.sih3.repository.UserRepository;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "AdminUserManagementServlet", urlPatterns = {"/admin/users/*"})
public class AdminUserManagementServlet extends HttpServlet {
    
    private UserRepository userRepository;
    
    @Override
    public void init() throws ServletException {
        userRepository = new UserRepository();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is admin
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }
        
        User currentUser = (User) session.getAttribute("user");
        if (!"Admin".equals(currentUser.getUserType().toString())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        String action = request.getPathInfo();
        
        if (action == null || action.equals("/")) {
            // List all users
            listUsers(request, response);
        } else if (action.equals("/add")) {
            // Show add user form
            showAddUserForm(request, response);
        } else if (action.equals("/edit")) {
            // Show edit user form
            showEditUserForm(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is admin
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }
        
        User currentUser = (User) session.getAttribute("user");
        if (!"Admin".equals(currentUser.getUserType().toString())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        String action = request.getPathInfo();
        
        if (action == null || action.equals("/")) {
            // List all users (default action)
            listUsers(request, response);
        } else if (action.equals("/create")) {
            // Create new user
            createUser(request, response);
        } else if (action.equals("/update")) {
            // Update existing user
            updateUser(request, response);
        } else if (action.equals("/delete")) {
            // Delete user
            deleteUser(request, response);
        } else if (action.equals("/bulk-delete")) {
            // Bulk delete users
            bulkDeleteUsers(request, response);
        } else if (action.equals("/bulk-update-role")) {
            // Bulk update user roles
            bulkUpdateUserRoles(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            List<User> users = userRepository.findAll();
            request.setAttribute("users", users);
            request.getRequestDispatcher("/jsp/admin-users.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error retrieving users: " + e.getMessage());
            request.getRequestDispatcher("/jsp/error/500.jsp").forward(request, response);
        }
    }
    
    private void showAddUserForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/jsp/admin-add-user.jsp").forward(request, response);
    }
    
    private void showEditUserForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String userIdParam = request.getParameter("id");
            if (userIdParam == null || userIdParam.isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "User ID is required");
                return;
            }
            
            Integer userId = Integer.parseInt(userIdParam);
            User user = userRepository.findById(userId);
            
            if (user == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found");
                return;
            }
            
            request.setAttribute("user", user);
            request.getRequestDispatcher("/jsp/admin-edit-user.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid user ID format");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error retrieving user: " + e.getMessage());
            request.getRequestDispatcher("/jsp/error/500.jsp").forward(request, response);
        }
    }
    
    private void createUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Get form parameters
            String fullName = request.getParameter("fullName");
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String userTypeStr = request.getParameter("userType");
            String schoolIdStr = request.getParameter("schoolId");
            String ageStr = request.getParameter("age");
            String classGrade = request.getParameter("classGrade");
            
            // Validate required fields
            if (username == null || username.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                password == null || password.isEmpty() ||
                userTypeStr == null || userTypeStr.trim().isEmpty()) {
                
                request.setAttribute("errorMessage", "Required fields are missing");
                request.getRequestDispatcher("/jsp/admin-add-user.jsp").forward(request, response);
                return;
            }
            
            // Validate user type
            UserType userType;
            try {
                userType = UserType.valueOf(userTypeStr);
            } catch (IllegalArgumentException e) {
                request.setAttribute("errorMessage", "Invalid user type");
                request.getRequestDispatcher("/jsp/admin-add-user.jsp").forward(request, response);
                return;
            }
            
            // Check if username or email already exists
            User existingUserByUsername = userRepository.findByUsername(username.trim());
            if (existingUserByUsername != null) {
                request.setAttribute("errorMessage", "Username already exists");
                request.getRequestDispatcher("/jsp/admin-add-user.jsp").forward(request, response);
                return;
            }
            
            User existingUserByEmail = userRepository.findByEmail(email.trim());
            if (existingUserByEmail != null) {
                request.setAttribute("errorMessage", "Email already registered");
                request.getRequestDispatcher("/jsp/admin-add-user.jsp").forward(request, response);
                return;
            }
            
            // Create new user
            User user = new User();
            user.setFullName(fullName != null ? fullName.trim() : null);
            user.setUsername(username.trim());
            user.setEmail(email.trim());
            user.setPassword(hashPassword(password));
            user.setUserType(userType);
            
            // Handle optional fields
            if (schoolIdStr != null && !schoolIdStr.isEmpty()) {
                try {
                    user.setSchoolId(Integer.parseInt(schoolIdStr));
                } catch (NumberFormatException e) {
                    // Ignore invalid school ID
                }
            }
            
            if (ageStr != null && !ageStr.isEmpty()) {
                try {
                    user.setAge(Integer.parseInt(ageStr));
                } catch (NumberFormatException e) {
                    // Ignore invalid age
                }
            }
            
            user.setClassGrade(classGrade != null ? classGrade.trim() : null);
            
            // Save user
            userRepository.save(user);
            
            // Redirect to user list with success message
            response.sendRedirect(request.getContextPath() + "/admin/users?success=created");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error creating user: " + e.getMessage());
            request.getRequestDispatcher("/jsp/admin-add-user.jsp").forward(request, response);
        }
    }
    
    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Get form parameters
            String userIdParam = request.getParameter("id");
            if (userIdParam == null || userIdParam.isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "User ID is required");
                return;
            }
            
            Integer userId = Integer.parseInt(userIdParam);
            
            String fullName = request.getParameter("fullName");
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String userTypeStr = request.getParameter("userType");
            String schoolIdStr = request.getParameter("schoolId");
            String ageStr = request.getParameter("age");
            String classGrade = request.getParameter("classGrade");
            
            // Find existing user
            User user = userRepository.findById(userId);
            if (user == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found");
                return;
            }
            
            // Validate required fields
            if (username == null || username.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                userTypeStr == null || userTypeStr.trim().isEmpty()) {
                
                request.setAttribute("errorMessage", "Required fields are missing");
                request.setAttribute("user", user);
                request.getRequestDispatcher("/jsp/admin-edit-user.jsp").forward(request, response);
                return;
            }
            
            // Validate user type
            UserType userType;
            try {
                userType = UserType.valueOf(userTypeStr);
            } catch (IllegalArgumentException e) {
                request.setAttribute("errorMessage", "Invalid user type");
                request.setAttribute("user", user);
                request.getRequestDispatcher("/jsp/admin-edit-user.jsp").forward(request, response);
                return;
            }
            
            // Check if username or email already exists (excluding current user)
            User existingUserByUsername = userRepository.findByUsername(username.trim());
            if (existingUserByUsername != null && !existingUserByUsername.getId().equals(userId)) {
                request.setAttribute("errorMessage", "Username already exists");
                request.setAttribute("user", user);
                request.getRequestDispatcher("/jsp/admin-edit-user.jsp").forward(request, response);
                return;
            }
            
            User existingUserByEmail = userRepository.findByEmail(email.trim());
            if (existingUserByEmail != null && !existingUserByEmail.getId().equals(userId)) {
                request.setAttribute("errorMessage", "Email already registered");
                request.setAttribute("user", user);
                request.getRequestDispatcher("/jsp/admin-edit-user.jsp").forward(request, response);
                return;
            }
            
            // Update user
            user.setFullName(fullName != null ? fullName.trim() : null);
            user.setUsername(username.trim());
            user.setEmail(email.trim());
            user.setUserType(userType);
            
            // Update password only if provided
            if (password != null && !password.isEmpty()) {
                user.setPassword(hashPassword(password));
            }
            
            // Handle optional fields
            if (schoolIdStr != null && !schoolIdStr.isEmpty()) {
                try {
                    user.setSchoolId(Integer.parseInt(schoolIdStr));
                } catch (NumberFormatException e) {
                    // Ignore invalid school ID
                }
            } else {
                user.setSchoolId(null);
            }
            
            if (ageStr != null && !ageStr.isEmpty()) {
                try {
                    user.setAge(Integer.parseInt(ageStr));
                } catch (NumberFormatException e) {
                    // Ignore invalid age
                }
            } else {
                user.setAge(null);
            }
            
            user.setClassGrade(classGrade != null ? classGrade.trim() : null);
            
            // Save user
            userRepository.update(user);
            
            // Redirect to user list with success message
            response.sendRedirect(request.getContextPath() + "/admin/users?success=updated");
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid user ID format");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error updating user: " + e.getMessage());
            request.getRequestDispatcher("/jsp/error/500.jsp").forward(request, response);
        }
    }
    
    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String userIdParam = request.getParameter("id");
            if (userIdParam == null || userIdParam.isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "User ID is required");
                return;
            }
            
            Integer userId = Integer.parseInt(userIdParam);
            
            // Find existing user
            User user = userRepository.findById(userId);
            if (user == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found");
                return;
            }
            
            // Prevent deleting the current admin user
            HttpSession session = request.getSession(false);
            User currentUser = (User) session.getAttribute("user");
            if (currentUser.getId().equals(userId)) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Cannot delete your own account");
                return;
            }
            
            // Delete user
            userRepository.delete(user);
            
            // Redirect to user list with success message
            response.sendRedirect(request.getContextPath() + "/admin/users?success=deleted");
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid user ID format");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error deleting user: " + e.getMessage());
        }
    }
    
    private void bulkDeleteUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String[] userIds = request.getParameterValues("userIds");
            if (userIds == null || userIds.length == 0) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "No users selected");
                return;
            }
            
            HttpSession session = request.getSession(false);
            User currentUser = (User) session.getAttribute("user");
            
            int deletedCount = 0;
            List<String> errors = new ArrayList<>();
            
            for (String userIdParam : userIds) {
                try {
                    Integer userId = Integer.parseInt(userIdParam);
                    
                    // Prevent deleting the current admin user
                    if (currentUser.getId().equals(userId)) {
                        errors.add("Cannot delete your own account (ID: " + userId + ")");
                        continue;
                    }
                    
                    // Find existing user
                    User user = userRepository.findById(userId);
                    if (user == null) {
                        errors.add("User not found (ID: " + userId + ")");
                        continue;
                    }
                    
                    // Delete user
                    userRepository.delete(user);
                    deletedCount++;
                } catch (NumberFormatException e) {
                    errors.add("Invalid user ID format: " + userIdParam);
                }
            }
            
            // Redirect to user list with success message
            String redirectUrl = request.getContextPath() + "/admin/users?success=bulk_deleted&deletedCount=" + deletedCount;
            if (!errors.isEmpty()) {
                redirectUrl += "&errorCount=" + errors.size();
            }
            response.sendRedirect(redirectUrl);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error deleting users: " + e.getMessage());
        }
    }
    
    private void bulkUpdateUserRoles(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String[] userIds = request.getParameterValues("userIds");
            String newUserTypeStr = request.getParameter("newUserType");
            
            if (userIds == null || userIds.length == 0) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "No users selected");
                return;
            }
            
            if (newUserTypeStr == null || newUserTypeStr.trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "New user type is required");
                return;
            }
            
            // Validate user type
            UserType newUserType;
            try {
                newUserType = UserType.valueOf(newUserTypeStr);
            } catch (IllegalArgumentException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid user type");
                return;
            }
            
            HttpSession session = request.getSession(false);
            User currentUser = (User) session.getAttribute("user");
            
            int updatedCount = 0;
            List<String> errors = new ArrayList<>();
            
            for (String userIdParam : userIds) {
                try {
                    Integer userId = Integer.parseInt(userIdParam);
                    
                    // Prevent updating the current admin user to a different role
                    if (currentUser.getId().equals(userId) && !newUserType.toString().equals("Admin")) {
                        errors.add("Cannot change your own role to non-admin (ID: " + userId + ")");
                        continue;
                    }
                    
                    // Find existing user
                    User user = userRepository.findById(userId);
                    if (user == null) {
                        errors.add("User not found (ID: " + userId + ")");
                        continue;
                    }
                    
                    // Update user role
                    user.setUserType(newUserType);
                    userRepository.update(user);
                    updatedCount++;
                } catch (NumberFormatException e) {
                    errors.add("Invalid user ID format: " + userIdParam);
                }
            }
            
            // Redirect to user list with success message
            String redirectUrl = request.getContextPath() + "/admin/users?success=bulk_updated&updatedCount=" + updatedCount;
            if (!errors.isEmpty()) {
                redirectUrl += "&errorCount=" + errors.size();
            }
            response.sendRedirect(redirectUrl);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error updating users: " + e.getMessage());
        }
    }
    
    // Method to hash password using SHA-256
    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            // This should never happen as SHA-256 is a standard algorithm
            throw new RuntimeException("SHA-256 algorithm not found", e);
        }
    }
}