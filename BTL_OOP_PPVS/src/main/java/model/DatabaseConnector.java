package model;


import java.sql.DriverManager;
import java.sql.Connection;

import java.util.logging.Level;
import java.util.logging.Logger;
import java.sql.SQLException;


public class DatabaseConnector {
    
    private static Connection connection = null;
    private final static String url = "jdbc:mysql://127.0.0.1:3306/Library_2nd_Edition";
    private final static String username = "root";
    private final static String password = "";
    
    public static void getInstance() throws SQLException {
        new DatabaseConnector();
    }
    
    public static Connection getConnection() throws SQLException {
        if (connection == null) {
            getInstance();
        }
        return connection;
    }
    
    public static void closeConnection() {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException ex) {
                Logger.getLogger(DatabaseConnector.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }
    
    private static Connection createJDBCConnection() throws SQLException {
        
        try {
            // Class.forName("com.mysql.jdbc.Driver");
            return DriverManager.getConnection(url, username, password);
            
        } catch (SQLException ex) {
            Logger.getLogger(DatabaseConnector.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return null;
    }
    
    private DatabaseConnector() throws SQLException {
        firstTODO();
    }
    
    /**
     * There are some task we must do. 
     * Make a JDBCconnection to the database as example.
     * 
     * @throws SQLException 
     */
    private static void firstTODO() throws SQLException{
        connection = DatabaseConnector.createJDBCConnection();
        if (connection != null ) {
            String[] lib = DatabaseConnector.url.split("/");
            System.out.print("\n\n\n\n\n\n\n\nConnecting Database Success\n");
            System.out.println(lib[3] + "\n\n");
        } else {
            System.out.print("\n\n\n\n\n\n\n\nConnecting Database FAILED\n");
        }
    }
    
    
    /** Test if the connection can be make */
    public static void main(String[] args) {
        try {
            firstTODO();
        } catch (SQLException sqlex) {
            sqlex.printStackTrace();
        }
    }
}

