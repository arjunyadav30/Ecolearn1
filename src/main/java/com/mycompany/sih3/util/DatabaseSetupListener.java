package com.mycompany.sih3.util;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.Statement;

public class DatabaseSetupListener implements ServletContextListener {

    private final String[] sqlFiles = new String[] {
        "/sql/create_schools_table.sql",
        "/sql/create_users_table.sql"
    };

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // Run SQL scripts to ensure required tables exist
        try (Connection con = DBUtil.getConnection()) {
            for (String path : sqlFiles) {
                try (InputStream is = getClass().getResourceAsStream(path)) {
                    if (is == null) continue;
                    StringBuilder sb = new StringBuilder();
                    try (BufferedReader br = new BufferedReader(new InputStreamReader(is))) {
                        String line;
                        while ((line = br.readLine()) != null) {
                            sb.append(line).append('\n');
                        }
                    }
                    String sql = sb.toString();
                    // Split statements by semicolon and execute
                    String[] statements = sql.split(";\\s*\n");
                    try (Statement stmt = con.createStatement()) {
                        for (String st : statements) {
                            String s = st.trim();
                            if (s.isEmpty()) continue;
                            try {
                                stmt.execute(s);
                            } catch (Exception ex) {
                                System.out.println("Warning executing statement: " + ex.getMessage());
                            }
                        }
                    }
                } catch (Exception e) {
                    System.out.println("Error reading SQL resource " + path + ": " + e.getMessage());
                }
            }
            System.out.println("DatabaseSetupListener: ensured tables exist.");
        } catch (Exception e) {
            System.out.println("DatabaseSetupListener failed: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // nothing
    }
}
