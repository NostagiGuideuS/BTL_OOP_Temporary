package model.dao;

import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import model.DatabaseConnector;
import model.entity.Book;

/**
 *
 * @author Littl
 */
public class BookDAO {
    /**
     * Search Book with given keyword types below.
     * 
     * @param titleKeyword = searching by %title%.
     * @param authorKeyword = searching by %author%.
     * @param releaseYear = search by releaseYear. Sorry, not search on range of Years.
     * @param category = on format of ENUM Book.BookCategory.
     * 
     * @return List of books found.
     * @throws SQLException 
     */
    public static ArrayList<Book> searchBook(String titleKeyword, String authorKeyword, int releaseYear, int category) throws SQLException, IOException {
        CallableStatement finder = (CallableStatement) DatabaseConnector.getConnection().prepareCall("{ call searchBook(?, ?, ?, ?) }");
        
        finder.setString(1, titleKeyword);
        finder.setString(2, authorKeyword);
        finder.setInt(3, releaseYear);
        finder.setInt(4, category);
        
        ResultSet rs;
        rs = finder.executeQuery();
        
        ArrayList<Book> found = new ArrayList<>();
        while (rs.next()) {
            String[] cate = {rs.getString(7)};
            found.add(new Book(rs.getString(1),
                              rs.getString(2),
                       rs.getInt(3),
                             rs.getString(4),
                           rs.getString(5),
                          rs.getInt(6),
                          rs.getString(7),
                            rs.getInt(8)));
        }
        
        return found;
    }
    
    /**
     * Add a new Book to database. 
     * 
     * @param newBook = only Book object have been full construct accept.
     * 
     * @return false if duplicate documentID.
     * 
     * @throws SQLException 
     * @throws IOException
     */
    public static boolean addBook(Book newBook) throws SQLException, IOException  {
        CallableStatement finder = (CallableStatement) DatabaseConnector.getConnection().prepareCall("{ call addBook(?, ?, ?, ?, ?, ?, ?) }");
        
        finder.setString(1, newBook.getID());
        finder.setString(2, newBook.getTitle());
        finder.setString(3, newBook.getAuthor());
        finder.setInt(4, newBook.getAvailableCopies());
        finder.setInt(5, newBook.getCategoryEncrypt());
        finder.setString(6, newBook.getDescription());
        finder.setString(7, newBook.getPublisher());
        finder.setInt(8, newBook.getReleaseYear());
        
        ResultSet rs;
        rs = finder.executeQuery();
        
        while(rs.next()) {
            return rs.getBoolean(1);
        }
        
        return false;
    }
}
