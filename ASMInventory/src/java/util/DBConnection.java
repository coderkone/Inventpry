package com.inventory.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL      = "jdbc:mysql://localhost:1433/inventory_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String USERNAME = "root";      // ← đổi thành user MySQL của bạn
    private static final String PASSWORD = "yourpassword"; // ← đổi thành password MySQL của bạn

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL JDBC Driver not found!", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }

    public static void close(Connection conn) {
        if (conn != null) {
            try { conn.close(); } catch (SQLException ignored) {}
        }
    }
}
