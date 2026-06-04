package com.mycompany.sih3.service;

import java.io.*;
import java.sql.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.zip.GZIPOutputStream;

public class BackupService {
    
    private static final String DB_URL = "jdbc:mysql://localhost:3306/ecolearn?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "1234";
    
    public BackupService() {
        // Default constructor
    }
    
    /**
     * Create a database backup
     * @param backupPath The path where the backup file will be saved
     * @return true if backup was successful, false otherwise
     */
    public boolean createBackup(String backupPath) {
        try {
            // Create backup directory if it doesn't exist
            File backupDir = new File(backupPath).getParentFile();
            if (backupDir != null && !backupDir.exists()) {
                backupDir.mkdirs();
            }
            
            // Create backup file with timestamp
            String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss"));
            String backupFile = backupPath + File.separator + "ecolearn_backup_" + timestamp + ".sql";
            
            // Create the backup
            return exportDatabase(backupFile);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Restore database from backup file
     * @param backupFile The path to the backup file
     * @return true if restore was successful, false otherwise
     */
    public boolean restoreBackup(String backupFile) {
        try {
            return importDatabase(backupFile);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Export database to SQL file
     * @param filePath The path where the SQL file will be saved
     * @return true if export was successful, false otherwise
     */
    private boolean exportDatabase(String filePath) {
        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PrintWriter writer = new PrintWriter(new FileWriter(filePath))) {
            
            // Write header information
            writer.println("-- EcoLearn Database Backup");
            writer.println("-- Generated on: " + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
            writer.println("-- Database: ecolearn");
            writer.println();
            writer.println("SET FOREIGN_KEY_CHECKS = 0;");
            writer.println();
            
            // Get all table names
            DatabaseMetaData metaData = connection.getMetaData();
            ResultSet tables = metaData.getTables(null, null, "%", new String[]{"TABLE"});
            
            while (tables.next()) {
                String tableName = tables.getString("TABLE_NAME");
                
                // Skip system tables if any
                if (tableName.startsWith("sys_") || tableName.startsWith("information_schema")) {
                    continue;
                }
                
                // Drop table statement
                writer.println("DROP TABLE IF EXISTS `" + tableName + "`;");
                
                // Create table statement
                exportTableSchema(connection, writer, tableName);
                
                // Insert data statements
                exportTableData(connection, writer, tableName);
                
                writer.println();
            }
            
            writer.println("SET FOREIGN_KEY_CHECKS = 1;");
            
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Export table schema
     */
    private void exportTableSchema(Connection connection, PrintWriter writer, String tableName) throws SQLException {
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery("SHOW CREATE TABLE `" + tableName + "`")) {
            
            if (rs.next()) {
                String createTable = rs.getString(2);
                writer.println(createTable + ";");
            }
        }
    }
    
    /**
     * Export table data
     */
    private void exportTableData(Connection connection, PrintWriter writer, String tableName) throws SQLException {
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT * FROM `" + tableName + "`")) {
            
            ResultSetMetaData metaData = rs.getMetaData();
            int columnCount = metaData.getColumnCount();
            
            // Write insert statements for each row
            while (rs.next()) {
                StringBuilder insert = new StringBuilder("INSERT INTO `" + tableName + "` VALUES (");
                
                for (int i = 1; i <= columnCount; i++) {
                    Object value = rs.getObject(i);
                    
                    if (value == null) {
                        insert.append("NULL");
                    } else if (value instanceof String || value instanceof java.util.Date) {
                        // Escape single quotes in string values
                        String escapedValue = value.toString().replace("'", "\\'");
                        insert.append("'").append(escapedValue).append("'");
                    } else {
                        insert.append(value.toString());
                    }
                    
                    if (i < columnCount) {
                        insert.append(", ");
                    }
                }
                
                insert.append(");");
                writer.println(insert.toString());
            }
        }
    }
    
    /**
     * Import database from SQL file
     * @param filePath The path to the SQL file
     * @return true if import was successful, false otherwise
     */
    private boolean importDatabase(String filePath) {
        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
            
            StringBuilder statement = new StringBuilder();
            String line;
            
            while ((line = reader.readLine()) != null) {
                // Skip comments and empty lines
                if (line.trim().isEmpty() || line.startsWith("--")) {
                    continue;
                }
                
                statement.append(line).append("\n");
                
                // Execute statement when we find a semicolon
                if (line.trim().endsWith(";")) {
                    try (Statement stmt = connection.createStatement()) {
                        stmt.execute(statement.toString());
                    } catch (SQLException e) {
                        System.err.println("Error executing statement: " + statement.toString());
                        e.printStackTrace();
                        return false;
                    }
                    
                    statement.setLength(0); // Clear the statement
                }
            }
            
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Get list of available backup files
     * @param backupPath The path where backups are stored
     * @return Array of backup file names
     */
    public String[] getBackupFiles(String backupPath) {
        File backupDir = new File(backupPath);
        if (backupDir.exists() && backupDir.isDirectory()) {
            return backupDir.list((dir, name) -> name.startsWith("ecolearn_backup_") && name.endsWith(".sql"));
        }
        return new String[0];
    }
    
    /**
     * Compress backup file using GZIP
     * @param sourceFile The source file to compress
     * @param compressedFile The compressed file name
     * @return true if compression was successful, false otherwise
     */
    public boolean compressBackup(String sourceFile, String compressedFile) {
        try (FileInputStream fis = new FileInputStream(sourceFile);
             FileOutputStream fos = new FileOutputStream(compressedFile);
             GZIPOutputStream gzos = new GZIPOutputStream(fos)) {
            
            byte[] buffer = new byte[1024];
            int len;
            while ((len = fis.read(buffer)) > 0) {
                gzos.write(buffer, 0, len);
            }
            
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }
}