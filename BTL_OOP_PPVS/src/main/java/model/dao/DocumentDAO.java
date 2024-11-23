package model.dao;

import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import model.DatabaseConnector;
import model.entity.Book;
import model.entity.Document;
import model.entity.Thesis;

/**
 *
 * @author Littl
 */
public class DocumentDAO {
    
    /**
     * Get Document only if you know exactly its Thesis ID / Book ISBN.
     * 
     * @param documentID = Thesis ID / Book ISBN.
     * 
     * @return Document object.
     * 
     * @throws SQLException 
     * @throws IOException
     */
    public static Document getDocumentInfo(String documentID) throws SQLException, IOException {
        CallableStatement finder = (CallableStatement) DatabaseConnector.getConnection().prepareCall("{ call searchDocument(?) }");
        
        finder.setString(1, documentID);
        
        ResultSet rs;
        rs = finder.executeQuery();
        
        while (rs.next()) {
            switch(rs.getString("genre")) {
                case "Book" -> {
                    return new Book(rs.getString(1),
                                    rs.getString(2),
                            rs.getInt(3),
                                  rs.getString(4),
                                rs.getString(5),
                               rs.getInt(6),
                               rs.getString(7),
                                 rs.getInt(8));
                } 
                case "Thesis" -> {
                    while (rs.next()) {
                    return new Thesis(rs.getString(1), 
                                    rs.getString(2), 
                             rs.getInt(3),
                                  rs.getString(4), 
                                   rs.getString(5), 
                               rs.getString(6), 
                                rs.getString(7),
                                  rs.getInt(8));
        }
                }
                default -> {
                    return null;
                }
            }
        }
        
        return null;
    }
    
    /**
     * Load more or less copies of a document already store in library.
     * 
     * @param documentID
     * @param quantityChange
     * @throws SQLException 
     */
    public static void loadMoreCopies(String documentID, int quantityChange) throws SQLException {
        CallableStatement finder = (CallableStatement) DatabaseConnector.getConnection().prepareCall("{ call deleteDocument(?) }");
        
        finder.setString(1, documentID);
        
        finder.executeQuery();
    }
    
    /**
     * Delete a document determine by its ID.
     * 
     * @param documentID = ID of the document want to be deleted.
     * 
     * @throws SQLException 
     */
    public static void deleteDocument(String documentID) throws SQLException  {
        CallableStatement finder = (CallableStatement) DatabaseConnector.getConnection().prepareCall("{ call deleteDocument(?) }");
        
        finder.setString(1, documentID);
        
        finder.executeQuery();
    }
}
