package com.mycompany.sih3.util;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

public class DBConfigListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext ctx = sce.getServletContext();
        String url = ctx.getInitParameter("dbURL");
        String user = ctx.getInitParameter("dbUser");
        String pwd = ctx.getInitParameter("dbPassword");
        DBUtil.setConfig(url, user, pwd);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Nothing to clean up
    }
}
