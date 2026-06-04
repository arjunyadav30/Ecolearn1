package com.mycompany.sih3.servlet;

import com.mycompany.sih3.entity.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "AdminContentManagementServlet", urlPatterns = {"/admin/content/*"})
public class AdminContentManagementServlet extends HttpServlet {
    
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
            // Show content management dashboard
            showContentDashboard(request, response);
        } else if (action.equals("/lessons")) {
            // Show lessons management
            showLessonsManagement(request, response);
        } else if (action.equals("/quizzes")) {
            // Show quizzes management
            showQuizzesManagement(request, response);
        } else if (action.equals("/games")) {
            // Show games management
            showGamesManagement(request, response);
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
            // Show content management dashboard
            showContentDashboard(request, response);
        } else if (action.equals("/lessons/create")) {
            // Create new lesson
            createLesson(request, response);
        } else if (action.equals("/lessons/update")) {
            // Update existing lesson
            updateLesson(request, response);
        } else if (action.equals("/lessons/delete")) {
            // Delete lesson
            deleteLesson(request, response);
        } else if (action.equals("/quizzes/create")) {
            // Create new quiz
            createQuiz(request, response);
        } else if (action.equals("/quizzes/update")) {
            // Update existing quiz
            updateQuiz(request, response);
        } else if (action.equals("/quizzes/delete")) {
            // Delete quiz
            deleteQuiz(request, response);
        } else if (action.equals("/games/create")) {
            // Create new game
            createGame(request, response);
        } else if (action.equals("/games/update")) {
            // Update existing game
            updateGame(request, response);
        } else if (action.equals("/games/delete")) {
            // Delete game
            deleteGame(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    private void showContentDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("activeSection", "content");
        request.getRequestDispatcher("/jsp/admin-content-dashboard.jsp").forward(request, response);
    }
    
    private void showLessonsManagement(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // In a real implementation, we would fetch lessons from the database
        // For now, we'll just forward to the lessons management page
        request.setAttribute("activeSection", "content");
        request.getRequestDispatcher("/jsp/admin-lessons-management.jsp").forward(request, response);
    }
    
    private void showQuizzesManagement(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // In a real implementation, we would fetch quizzes from the database
        // For now, we'll just forward to the quizzes management page
        request.setAttribute("activeSection", "content");
        request.getRequestDispatcher("/jsp/admin-quizzes-management.jsp").forward(request, response);
    }
    
    private void createQuiz(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Implementation for creating a new quiz
        try {
            // Get form parameters
            String title = request.getParameter("title");
            String lessonIdStr = request.getParameter("lessonId");
            String description = request.getParameter("description");
            String timeLimitStr = request.getParameter("timeLimit");
            String passingScoreStr = request.getParameter("passingScore");
            
            // Validate required fields
            if (title == null || title.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Quiz title is required");
                showQuizzesManagement(request, response);
                return;
            }
            
            if (lessonIdStr == null || lessonIdStr.isEmpty()) {
                request.setAttribute("errorMessage", "Associated lesson is required");
                showQuizzesManagement(request, response);
                return;
            }
            
            // Parse lesson ID
            int lessonId;
            try {
                lessonId = Integer.parseInt(lessonIdStr);
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid lesson ID");
                showQuizzesManagement(request, response);
                return;
            }
            
            // Parse time limit
            int timeLimit = 30; // Default value
            if (timeLimitStr != null && !timeLimitStr.isEmpty()) {
                try {
                    timeLimit = Integer.parseInt(timeLimitStr);
                } catch (NumberFormatException e) {
                    request.setAttribute("errorMessage", "Invalid time limit value");
                    showQuizzesManagement(request, response);
                    return;
                }
            }
            
            // Parse passing score
            int passingScore = 70; // Default value
            if (passingScoreStr != null && !passingScoreStr.isEmpty()) {
                try {
                    passingScore = Integer.parseInt(passingScoreStr);
                    if (passingScore < 0 || passingScore > 100) {
                        request.setAttribute("errorMessage", "Passing score must be between 0 and 100");
                        showQuizzesManagement(request, response);
                        return;
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("errorMessage", "Invalid passing score value");
                    showQuizzesManagement(request, response);
                    return;
                }
            }
            
            // In a real implementation, we would save the quiz to the database
            // For now, we'll just simulate the operation
            request.setAttribute("successMessage", "Quiz created successfully");
            showQuizzesManagement(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error creating quiz: " + e.getMessage());
            showQuizzesManagement(request, response);
        }
    }
    
    private void updateQuiz(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Implementation for updating an existing quiz
        try {
            // Get form parameters
            String quizIdStr = request.getParameter("id");
            String title = request.getParameter("title");
            String lessonIdStr = request.getParameter("lessonId");
            String description = request.getParameter("description");
            String timeLimitStr = request.getParameter("timeLimit");
            String passingScoreStr = request.getParameter("passingScore");
            
            // Validate required fields
            if (quizIdStr == null || quizIdStr.isEmpty()) {
                request.setAttribute("errorMessage", "Quiz ID is required");
                showQuizzesManagement(request, response);
                return;
            }
            
            if (title == null || title.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Quiz title is required");
                showQuizzesManagement(request, response);
                return;
            }
            
            if (lessonIdStr == null || lessonIdStr.isEmpty()) {
                request.setAttribute("errorMessage", "Associated lesson is required");
                showQuizzesManagement(request, response);
                return;
            }
            
            // Parse quiz ID
            int quizId;
            try {
                quizId = Integer.parseInt(quizIdStr);
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid quiz ID");
                showQuizzesManagement(request, response);
                return;
            }
            
            // Parse lesson ID
            int lessonId;
            try {
                lessonId = Integer.parseInt(lessonIdStr);
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid lesson ID");
                showQuizzesManagement(request, response);
                return;
            }
            
            // Parse time limit
            int timeLimit = 30; // Default value
            if (timeLimitStr != null && !timeLimitStr.isEmpty()) {
                try {
                    timeLimit = Integer.parseInt(timeLimitStr);
                } catch (NumberFormatException e) {
                    request.setAttribute("errorMessage", "Invalid time limit value");
                    showQuizzesManagement(request, response);
                    return;
                }
            }
            
            // Parse passing score
            int passingScore = 70; // Default value
            if (passingScoreStr != null && !passingScoreStr.isEmpty()) {
                try {
                    passingScore = Integer.parseInt(passingScoreStr);
                    if (passingScore < 0 || passingScore > 100) {
                        request.setAttribute("errorMessage", "Passing score must be between 0 and 100");
                        showQuizzesManagement(request, response);
                        return;
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("errorMessage", "Invalid passing score value");
                    showQuizzesManagement(request, response);
                    return;
                }
            }
            
            // In a real implementation, we would update the quiz in the database
            // For now, we'll just simulate the operation
            request.setAttribute("successMessage", "Quiz updated successfully");
            showQuizzesManagement(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error updating quiz: " + e.getMessage());
            showQuizzesManagement(request, response);
        }
    }
    
    private void deleteQuiz(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Implementation for deleting a quiz
        try {
            // Get quiz ID parameter
            String quizIdStr = request.getParameter("id");
            
            // Validate required field
            if (quizIdStr == null || quizIdStr.isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Quiz ID is required");
                return;
            }
            
            // Parse quiz ID
            int quizId;
            try {
                quizId = Integer.parseInt(quizIdStr);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid quiz ID");
                return;
            }
            
            // In a real implementation, we would delete the quiz from the database
            // For now, we'll just simulate the operation
            response.sendRedirect(request.getContextPath() + "/admin/content/quizzes?success=deleted");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error deleting quiz: " + e.getMessage());
        }
    }
    
    private void showGamesManagement(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // In a real implementation, we would fetch games from the database
        // For now, we'll just forward to the games management page
        request.setAttribute("activeSection", "content");
        request.getRequestDispatcher("/jsp/admin-games-management.jsp").forward(request, response);
    }
    
    private void createGame(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Implementation for creating a new game
        try {
            // Get form parameters
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String category = request.getParameter("category");
            String pointsStr = request.getParameter("points");
            
            // Validate required fields
            if (name == null || name.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Game name is required");
                showGamesManagement(request, response);
                return;
            }
            
            // Parse points
            int points = 50; // Default value
            if (pointsStr != null && !pointsStr.isEmpty()) {
                try {
                    points = Integer.parseInt(pointsStr);
                } catch (NumberFormatException e) {
                    request.setAttribute("errorMessage", "Invalid points value");
                    showGamesManagement(request, response);
                    return;
                }
            }
            
            // In a real implementation, we would save the game to the database
            // For now, we'll just simulate the operation
            request.setAttribute("successMessage", "Game created successfully");
            showGamesManagement(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error creating game: " + e.getMessage());
            showGamesManagement(request, response);
        }
    }
    
    private void updateGame(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Implementation for updating an existing game
        try {
            // Get form parameters
            String gameIdStr = request.getParameter("id");
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String category = request.getParameter("category");
            String pointsStr = request.getParameter("points");
            
            // Validate required fields
            if (gameIdStr == null || gameIdStr.isEmpty()) {
                request.setAttribute("errorMessage", "Game ID is required");
                showGamesManagement(request, response);
                return;
            }
            
            if (name == null || name.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Game name is required");
                showGamesManagement(request, response);
                return;
            }
            
            // Parse game ID
            int gameId;
            try {
                gameId = Integer.parseInt(gameIdStr);
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid game ID");
                showGamesManagement(request, response);
                return;
            }
            
            // Parse points
            int points = 50; // Default value
            if (pointsStr != null && !pointsStr.isEmpty()) {
                try {
                    points = Integer.parseInt(pointsStr);
                } catch (NumberFormatException e) {
                    request.setAttribute("errorMessage", "Invalid points value");
                    showGamesManagement(request, response);
                    return;
                }
            }
            
            // In a real implementation, we would update the game in the database
            // For now, we'll just simulate the operation
            request.setAttribute("successMessage", "Game updated successfully");
            showGamesManagement(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error updating game: " + e.getMessage());
            showGamesManagement(request, response);
        }
    }
    
    private void deleteGame(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Implementation for deleting a game
        try {
            // Get game ID parameter
            String gameIdStr = request.getParameter("id");
            
            // Validate required field
            if (gameIdStr == null || gameIdStr.isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Game ID is required");
                return;
            }
            
            // Parse game ID
            int gameId;
            try {
                gameId = Integer.parseInt(gameIdStr);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid game ID");
                return;
            }
            
            // In a real implementation, we would delete the game from the database
            // For now, we'll just simulate the operation
            response.sendRedirect(request.getContextPath() + "/admin/content/games?success=deleted");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error deleting game: " + e.getMessage());
        }
    }
    
    private void createLesson(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Implementation for creating a new lesson
        // This would involve saving lesson data to the database
        try {
            // Get form parameters
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String category = request.getParameter("category");
            String videoUrl = request.getParameter("videoUrl");
            String pointsStr = request.getParameter("points");
            
            // Validate required fields
            if (title == null || title.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Lesson title is required");
                showLessonsManagement(request, response);
                return;
            }
            
            // Parse points
            int points = 0;
            if (pointsStr != null && !pointsStr.isEmpty()) {
                try {
                    points = Integer.parseInt(pointsStr);
                } catch (NumberFormatException e) {
                    request.setAttribute("errorMessage", "Invalid points value");
                    showLessonsManagement(request, response);
                    return;
                }
            }
            
            // In a real implementation, we would save the lesson to the database
            // For now, we'll just simulate the operation
            request.setAttribute("successMessage", "Lesson created successfully");
            showLessonsManagement(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error creating lesson: " + e.getMessage());
            showLessonsManagement(request, response);
        }
    }
    
    private void updateLesson(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Implementation for updating an existing lesson
        try {
            // Get form parameters
            String lessonIdStr = request.getParameter("id");
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String category = request.getParameter("category");
            String videoUrl = request.getParameter("videoUrl");
            String pointsStr = request.getParameter("points");
            
            // Validate required fields
            if (lessonIdStr == null || lessonIdStr.isEmpty()) {
                request.setAttribute("errorMessage", "Lesson ID is required");
                showLessonsManagement(request, response);
                return;
            }
            
            if (title == null || title.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Lesson title is required");
                showLessonsManagement(request, response);
                return;
            }
            
            // Parse lesson ID
            int lessonId;
            try {
                lessonId = Integer.parseInt(lessonIdStr);
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid lesson ID");
                showLessonsManagement(request, response);
                return;
            }
            
            // Parse points
            int points = 0;
            if (pointsStr != null && !pointsStr.isEmpty()) {
                try {
                    points = Integer.parseInt(pointsStr);
                } catch (NumberFormatException e) {
                    request.setAttribute("errorMessage", "Invalid points value");
                    showLessonsManagement(request, response);
                    return;
                }
            }
            
            // In a real implementation, we would update the lesson in the database
            // For now, we'll just simulate the operation
            request.setAttribute("successMessage", "Lesson updated successfully");
            showLessonsManagement(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error updating lesson: " + e.getMessage());
            showLessonsManagement(request, response);
        }
    }
    
    private void deleteLesson(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Implementation for deleting a lesson
        try {
            // Get lesson ID parameter
            String lessonIdStr = request.getParameter("id");
            
            // Validate required field
            if (lessonIdStr == null || lessonIdStr.isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Lesson ID is required");
                return;
            }
            
            // Parse lesson ID
            int lessonId;
            try {
                lessonId = Integer.parseInt(lessonIdStr);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid lesson ID");
                return;
            }
            
            // In a real implementation, we would delete the lesson from the database
            // For now, we'll just simulate the operation
            response.sendRedirect(request.getContextPath() + "/admin/content/lessons?success=deleted");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error deleting lesson: " + e.getMessage());
        }
    }
}