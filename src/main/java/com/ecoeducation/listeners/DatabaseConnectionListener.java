package com.ecoeducation.listeners;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class DatabaseConnectionListener implements ServletContextListener {
    
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // Initialization code if needed
        System.out.println("DatabaseConnectionListener initialized");
    }
    
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Cleanup code if needed
        System.out.println("DatabaseConnectionListener destroyed");
    }
}