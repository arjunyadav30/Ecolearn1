package com.mycompany.sih3.util;

import java.sql.*;

public class LeaderboardRankingUpdater {
    
    private static final String DB_URL = "jdbc:mysql://localhost/ecolearn";
    private static final String DB_USERNAME = "root";
    private static final String DB_PASSWORD = "1234";
    
    /**
     * Updates both global and school rankings for all users in the database
     * @return int[] where index 0 is global rankings updated count and index 1 is school rankings updated count
     */
    public static int[] updateAllRankings() {
        Connection con = null;
        int[] results = new int[2]; // [globalUpdated, schoolUpdated]
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(DB_URL, DB_USERNAME, DB_PASSWORD);
            
            // Update global rankings
            results[0] = updateGlobalRankings(con);
            
            // Update school rankings
            results[1] = updateSchoolRankings(con);
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return results;
    }
    
    /**
     * Updates global rankings based on total points
     * @param con Database connection
     * @return Number of rows updated
     * @throws SQLException
     */
    private static int updateGlobalRankings(Connection con) throws SQLException {
        String sql = "UPDATE user_statistics us " +
                     "JOIN ( " +
                     "    SELECT user_id, ROW_NUMBER() OVER (ORDER BY total_points DESC) as new_rank " +
                     "    FROM user_statistics " +
                     ") ranked ON us.user_id = ranked.user_id " +
                     "SET us.global_rank = ranked.new_rank";
        
        PreparedStatement stmt = con.prepareStatement(sql);
        int rowsUpdated = stmt.executeUpdate();
        stmt.close();
        
        return rowsUpdated;
    }
    
    /**
     * Updates school rankings based on total points within each school
     * @param con Database connection
     * @return Number of rows updated
     * @throws SQLException
     */
    private static int updateSchoolRankings(Connection con) throws SQLException {
        String sql = "UPDATE user_statistics us " +
                     "JOIN users u ON us.user_id = u.id " +
                     "JOIN ( " +
                     "    SELECT us2.user_id, " +
                     "           ROW_NUMBER() OVER (PARTITION BY u2.school_id ORDER BY us2.total_points DESC) as new_rank " +
                     "    FROM user_statistics us2 " +
                     "    JOIN users u2 ON us2.user_id = u2.id " +
                     "    WHERE u2.school_id IS NOT NULL " +
                     ") ranked ON us.user_id = ranked.user_id " +
                     "SET us.school_rank = ranked.new_rank " +
                     "WHERE u.school_id IS NOT NULL";
        
        PreparedStatement stmt = con.prepareStatement(sql);
        int rowsUpdated = stmt.executeUpdate();
        stmt.close();
        
        return rowsUpdated;
    }
    
    /**
     * Updates rankings for a specific user
     * @param userId The user ID to update rankings for
     */
    public static void updateUserRankings(int userId) {
        // For a specific user, we still need to update all rankings
        // because changing one user's rank affects others
        updateAllRankings();
    }
    
    // Test method
    public static void main(String[] args) {
        int[] results = updateAllRankings();
        System.out.println("Global rankings updated: " + results[0]);
        System.out.println("School rankings updated: " + results[1]);
    }
}