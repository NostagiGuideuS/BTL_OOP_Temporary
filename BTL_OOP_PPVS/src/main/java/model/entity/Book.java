package model.entity;

import java.sql.SQLException;
import java.io.IOException;
        
import java.util.ArrayList;
import java.util.List;
import model.dao.BookDAO;

/**
 *
 * @author Littl
 */
public class Book extends Document {
    
    protected String author;
    protected String publisher;
    protected int releaseYear;
    
    /**
     * Constructor for model.DAO using only.
     * 
     * @param ISBN = new Book ID/ ISBN code.
     * @param title = its title.
     * @param availableCopies = load copies amount.
     * @param author = author name.
     * @param publisher = publisher name.
     * @param releaseYear = release in what year (after 1900)
     * @param description = the book introduction.
     * @param category = category ENCRYPT FORM.
     * 
     * @throws IOException 
     */
    public Book(String ISBN, String title, int availableCopies, String author, String publisher, int releaseYear, String description, int category) throws IOException {
        this.ID = ISBN;
        this.title = title;
        this.availableCopies = availableCopies;
        this.author = author;
        this.publisher = publisher;
        this.releaseYear = releaseYear;
        this.description = description;
        this.category = CategoryType.decode(category);
    }
    
    /**
     * Constructor 
     * 
     * @param ISBN
     * @param title
     * @param availableCopies
     * @param author
     * @param publisher
     * @param releaseYear
     * @param description
     * @param category 
     */
    public Book(String ISBN, String title, int availableCopies, String author, String publisher, int releaseYear, String description, ArrayList<String> category) {
        this.ID = ISBN;
        this.title = title;
        this.availableCopies = availableCopies;
        this.author = author;
        this.publisher = publisher;
        this.releaseYear = releaseYear;
        this.description = description;
        this.category = category;
    }
    
    public Book(String documentID) throws SQLException, IOException {
        Document docu = getDocumentInfo(documentID);
        
        if (docu != null && docu instanceof Book) {
            Book getter = (Book) docu;
            
            this.ID = getter.ID;
            this.title = getter.title;
            this.author = getter.author;
            this.publisher = getter.publisher;
            this.releaseYear = getter.releaseYear;
            this.availableCopies = getter.availableCopies;
            this.category = getter.category;
        }
    }
    
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
    public static ArrayList<Book> searchBook(String titleKeyword, String authorKeyword, int releaseYear, List<String> category) throws SQLException, IOException {
        return BookDAO.searchBook(titleKeyword, authorKeyword, releaseYear, CategoryType.encrypt(category));
    }
    
    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public String getPublisher() {
        return publisher;
    }

    public void setPublisher(String publisher) {
        this.publisher = publisher;
    }

    public int getReleaseYear() {
        return releaseYear;
    }

    public void setReleaseYear(int releaseYear) {
        this.releaseYear = releaseYear;
    }
}
