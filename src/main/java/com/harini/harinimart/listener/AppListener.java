package com.harini.harinimart.listener;

import com.harini.harinimart.util.DatabaseUtil;
import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class AppListener implements ServletContextListener {
    private HikariDataSource dataSource;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        HikariConfig config = new HikariConfig();
        config.setDriverClassName("org.h2.Driver");
        config.setJdbcUrl("jdbc:h2:mem:harinimart;DB_CLOSE_DELAY=-1;INIT=RUNSCRIPT FROM 'classpath:schema.sql'");
        config.setUsername("sa");
        config.setPassword("");
        
        dataSource = new HikariDataSource(config);
        DatabaseUtil.setDataSource(dataSource);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (dataSource != null) {
            dataSource.close();
        }
    }
}