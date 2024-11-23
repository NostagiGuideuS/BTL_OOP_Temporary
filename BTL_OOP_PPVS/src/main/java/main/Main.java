package main;

import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import view.GDMain;


public class Main {
    public static void main(String[] args) {
        try {
            model.DatabaseConnector.getInstance();
            
            new GDMain().setVisible(true);
            
            // model.DatabaseConnector.closeConnection();
            
        } catch (SQLException ex) {
            Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
        }
        
    }
}
