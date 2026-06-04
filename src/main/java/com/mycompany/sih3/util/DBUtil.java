package com.mycompany.sih3.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {

    private static String dbUrl;
    private static String dbUser;
    private static String dbPassword;

    public static void setConfig(String url, String user, String password) {
        dbUrl = url;
        dbUser = user;
        dbPassword = password;
    }

    public static Connection getConnection() throws SQLException {
        if (dbUrl == null) {
            throw new SQLException("Database configuration not initialized");
        }
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("Postgres JDBC driver not found", e);
        }
        return DriverManager.getConnection(dbUrl, dbUser, dbPassword);
    }
}
