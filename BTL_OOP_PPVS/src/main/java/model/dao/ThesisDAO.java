package model.dao;

import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import model.DatabaseConnector;
import model.entity.Thesis;

/**
 *
 * @author Littl
 */
public class ThesisDAO {
    
    /**
     * Search Thesis with given keyword types below.
     * 
     * @param titleKeyword = searching by %title%.
     * @param fieldOfStudyKeyword = searching by %fieldOfStudy%.
     * @param writerID = search Thesis write by a Member.
     * @param advisor = search Thesis be supervise by someone.
     * 
     * @return List of thesis found.
     * 
     * @throws SQLException 
     * @throws IOException
     */
    public static ArrayList<Thesis> searchThesis(String titleKeyword, String fieldOfStudyKeyword, String writerID, String advisor) throws SQLException, IOException {
        CallableStatement finder = (CallableStatement) DatabaseConnector.getConnection().prepareCall("{ call searchThesis(?, ?, ?, ?) }");
        
        finder.setString(1, titleKeyword);
        finder.setString(2, fieldOfStudyKeyword);
        finder.setString(3, writerID);
        finder.setString(4, advisor);
        
        ResultSet rs;
        rs = finder.executeQuery();
        
        ArrayList<Thesis> found = new ArrayList<>();
        while (rs.next()) {
            found.add(new Thesis(rs.getString(1), 
                               rs.getString(2), 
                        rs.getInt(3),
                             rs.getString(4), 
                              rs.getString(5), 
                          rs.getString(6), 
                           rs.getString(7),
                             rs.getInt(8)
                        ));
        }
        
        return found;
    }
    
    /**
     * Add a new Thesis to database. 
     * 
     * @param newThesis = only Thesis object have been full construct accept.
     * 
     * @return false if duplicate documentID.
     * 
     * @throws SQLException 
     * @throws IOException
     */
    public static boolean addThesis(Thesis newThesis) throws SQLException, IOException {
        CallableStatement finder = (CallableStatement) DatabaseConnector.getConnection().prepareCall("{ call addThesis(?, ?, ?, ?, ?, ?, ?) }");
        
        finder.setString(1, newThesis.getID());
        finder.setString(2, newThesis.getTitle());
        finder.setString(3, newThesis.getWriterID());
        finder.setString(4, newThesis.getAdvisor());
        finder.setString(5, newThesis.getFieldOfStudy());
        finder.setString(6, newThesis.getDescription());
        finder.setInt(7, newThesis.getAvailableCopies());
        finder.setInt(8, newThesis.getCategoryEncrypt());
        
        ResultSet rs;
        rs = finder.executeQuery();
        
        while(rs.next()) {
            return rs.getBoolean(1);
        }
        
        return false;
    } 
}
