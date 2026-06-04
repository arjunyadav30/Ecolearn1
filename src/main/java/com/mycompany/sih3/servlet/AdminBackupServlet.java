package com.mycompany.sih3.servlet;

import com.mycompany.sih3.entity.User;
import com.mycompany.sih3.service.BackupService;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "AdminBackupServlet", urlPatterns = {"/admin/backup/*"})
public class AdminBackupServlet extends HttpServlet {
    
    private BackupService backupService;
    private String backupPath;
    
    @Override
    public void init() throws ServletException {
        backupService = new BackupService();
        // Set backup path to a directory in the project
        backupPath = getServletContext().getRealPath("/backups");
        // Create backup directory if it doesn't exist
        File backupDir = new File(backupPath);
        if (!backupDir.exists()) {
            backupDir.mkdirs();
        }
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
            // Show backup dashboard
            showBackupDashboard(request, response);
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
            // Show backup dashboard
            showBackupDashboard(request, response);
        } else if (action.equals("/create")) {
            // Create backup
            createBackup(request, response);
        } else if (action.equals("/restore")) {
            // Restore backup
            restoreBackup(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    private void showBackupDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Get list of backup files
            String[] backupFiles = backupService.getBackupFiles(backupPath);
            
            // Create list of backup info
            List<Map<String, Object>> backups = new ArrayList<>();
            for (String fileName : backupFiles) {
                Map<String, Object> backupInfo = new HashMap<>();
                backupInfo.put("name", fileName);
                backupInfo.put("size", new File(backupPath, fileName).length());
                backupInfo.put("date", fileName.replaceAll("ecolearn_backup_(.*)\\.sql", "$1"));
                backups.add(backupInfo);
            }
            
            request.setAttribute("backups", backups);
            request.setAttribute("backupPath", backupPath);
            
            // Forward to backup dashboard
            request.getRequestDispatcher("/jsp/admin-backup-dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error retrieving backup data: " + e.getMessage());
            request.getRequestDispatcher("/jsp/error/500.jsp").forward(request, response);
        }
    }
    
    private void createBackup(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Create backup
            boolean success = backupService.createBackup(backupPath);
            
            if (success) {
                request.setAttribute("successMessage", "Backup created successfully!");
            } else {
                request.setAttribute("errorMessage", "Failed to create backup.");
            }
            
            // Refresh the backup list
            showBackupDashboard(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error creating backup: " + e.getMessage());
            showBackupDashboard(request, response);
        }
    }
    
    private void restoreBackup(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String backupFileName = request.getParameter("backupFile");
            
            if (backupFileName == null || backupFileName.isEmpty()) {
                request.setAttribute("errorMessage", "No backup file selected.");
                showBackupDashboard(request, response);
                return;
            }
            
            String backupFilePath = backupPath + File.separator + backupFileName;
            
            // Restore backup
            boolean success = backupService.restoreBackup(backupFilePath);
            
            if (success) {
                request.setAttribute("successMessage", "Backup restored successfully!");
            } else {
                request.setAttribute("errorMessage", "Failed to restore backup.");
            }
            
            showBackupDashboard(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error restoring backup: " + e.getMessage());
            showBackupDashboard(request, response);
        }
    }
}