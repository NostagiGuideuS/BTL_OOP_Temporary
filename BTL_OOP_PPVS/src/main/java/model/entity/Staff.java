package model.entity;


import java.io.IOException;
import java.sql.SQLException;

import java.util.ArrayList;

import java.util.Date;
import model.dao.MemberDAO;
import model.dao.StaffDAO;
import model.dao.UserDAO;
import model.dao.ThesisDAO;
import model.dao.BookDAO;
import model.dao.DocumentDAO;
import model.dao.RequestDAO;


/**
 *
 * @author Littl
 */
public class Staff extends User {
    protected String contact = "example@staff.ppvs";
    protected String jobTitle = "Librarian";
    protected String reportTo = "U001";

    /*
    Contructor and get Own Information.
    */
    
    public Staff(String ID, String firstName, String lastName) {
        this.ID = ID;
        this.firstName = firstName;
        this.lastName = lastName;
    }
    
    public Staff(String ID, String firstName, String lastName, String contact, String jobTitle, String reportTo) {
        this.ID = ID;
        this.firstName = firstName;
        this.lastName = lastName;
        this.contact = contact;
        this.jobTitle = jobTitle;
        this.reportTo = reportTo;
    }
    
    /**
     * Load FULL INFORMATION to this Staff through ID.
     * 
     * @param ID = ID người dùng
     * 
     * @throws SQLException 
     */
    public Staff(String ID) throws SQLException {
        Staff getter = StaffDAO.getStaffInfo(ID);
        
        if (getter != null) {
            ID = getter.ID;
            firstName = getter.firstName;
            lastName = getter.lastName;
            contact = getter.contact;
            jobTitle = getter.jobTitle;
            this.reportTo = getter.reportTo;
        }
    }
    
    
    /*
    Function
    */
    
    
    /**
     * take full information for a reading member.
     * 
     * @param ID = that member ID.
     * 
     * @return an model.Member object contain information.
     * return null if there's no such userID
     * 
     * @throws SQLException 
     */
    public Member getMemberInfo(String ID) throws SQLException {
        return MemberDAO.getMemberInfo(ID);
    }
    
    /**
     * take full information for a library Staff.
     * 
     * @param ID = that staff ID.
     * 
     * @return an model.Staff object contain information.
     * return null if there's no such userID
     * 
     * @throws SQLException 
     */
    public Staff getStaffInfo(String ID)throws SQLException {
        return StaffDAO.getStaffInfo(ID);
    }
    
    
    /**
     * Take full information for a library User.
     * Might be Staff or Member. All be call as User
     * 
     * @param ID = that staff ID.
     * 
     * @return an model.Staff object contain information.
     * return null if there's no such userID
     * 
     * @throws SQLException 
     */
    public User getUserInfo(String ID) throws SQLException {
        User target = getMemberInfo(ID);
        if (target == null) {
            target = getStaffInfo(ID);
        }
        return target;
    }
    
    /**
     * Add a new Member to database.
     * 
     * @param ID = new User ID
     * @param firstName = their first Name
     * @param lastName = their last Name
     * @param contact = their contact
     * @param dateOfBirth = their date of birth
     * 
     * @return false only if being duplicate userID
     * 
     * @throws SQLException 
     */
    public boolean addNewMember (String ID, String firstName, String lastName, String contact, String dateOfBirth) throws SQLException  {
        Member newOne = new Member(ID, firstName, lastName, contact, dateOfBirth);
        return addNewMember(newOne);
    }
    
    /**
     * Add a new Member to database.
     * 
     * @param newMember = that new Member.
     * 
     * @return false if duplicate userID.
     * 
     * @throws SQLException 
     */
    public boolean addNewMember (Member newMember) throws SQLException {
        return MemberDAO.addNewMember(newMember);
    }
    
    /**
     * Add a new Staff to database.
     * 
     * @param ID = their ID
     * @param firstName = their first Name
     * @param lastName = their last Name
     * @param contact = their contact
     * @param jobTitle = new staff job title (job position)
     * 
     * @return false only if being duplicate user ID.
     * 
     * @throws SQLException 
     */
    public boolean addNewStaff(String ID, String firstName, String lastName, String contact, String jobTitle) throws SQLException {
        Staff newOne = new Staff(ID, firstName, lastName, contact, jobTitle, null);
        return addNewStaff(newOne);
    }
    
    /**
     * Add a new Staff to database.
     * 
     * @param newStaff = that new comer.
     * 
     * @return false if duplicate userID.
     * 
     * @throws SQLException 
     */
    public boolean addNewStaff (Staff newStaff) throws SQLException {
        return StaffDAO.addNewStaff(newStaff, this.ID);
    }
    
    public void deleteUser(String ID) throws SQLException {
        UserDAO.deleteUser(ID, this.ID);
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
    public boolean addBook(Book newBook) throws SQLException, IOException  {
        return BookDAO.addBook(newBook);
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
    public boolean addThesis(Thesis newThesis) throws SQLException, IOException {
        return ThesisDAO.addThesis(newThesis);
    } 
    
    /**
     * Add a new Document to database. 
     * 
     * @param newDocument = only Book or Thesis object have been full construct accept.
     * 
     * @return false if duplicate documentID.
     * 
     * @throws SQLException 
     * @throws IOException
     */
    public boolean addDocument(Document newDocument) throws SQLException, IOException {
        if (newDocument instanceof Book) {
           return addBook((Book) newDocument);
        } else if (newDocument instanceof Thesis) {
           return addThesis((Thesis) newDocument);
        }
        return false;
    }
    
    /**
     * Load more or less copies of a document already store in library.
     * 
     * @param documentID
     * @param quantityChange
     * @throws SQLException 
     */
    public void loadMoreCopies(String documentID, int quantityChange) throws SQLException {
        DocumentDAO.loadMoreCopies(documentID, quantityChange);
    }
    
    /**
     * Delete a document determine by its ID.
     * 
     * @param documentID = ID of the document want to be deleted.
     * 
     * @throws SQLException 
     */
    public void deleteDocument(String documentID) throws SQLException  {
        DocumentDAO.deleteDocument(documentID);
    }
    
    /**
     * Get a List<Request> being made by an user which not yet returned.
     * 
     * @param userID = ID of the user who borrow.
     * 
     * @return list of request found.
     * 
     * @throws SQLException 
     */
    public ArrayList<Request> getUnreturnDocument(String userID) throws SQLException {
        return RequestDAO.getUnreturnDocument(userID);
    }
    
    /**
     * Get all borrow history of an user. 
     * 
     * @param userID = that user ID.
     * 
     * @return list of request found.
     * 
     * @throws SQLException 
     */
    public ArrayList<Request> getBorrowHistory(String userID) throws SQLException {
        return RequestDAO.getBorrowHistory(userID);
    }
    
    /**
     * Get List<Request> of all who borrow a Document
     * 
     * @param documentID = the document being borrowed ID.
     * 
     * @return list of request borrow that document.
     * 
     * @throws SQLException 
     */
    public ArrayList<Request> getUserBorrowThisDocument(String documentID) throws SQLException {
        return RequestDAO.getUserBorrowThisDocument(documentID);
    }
    
    
    /*
    Getter/Setter.
    */
    
    
    public String getContact() {
        return contact;
    }

    public void setContact(String contact) {
        this.contact = contact;
    }

    public String getJobTitle() {
        return jobTitle;
    }

    public void setJobTitle(String jobTitle) {
        this.jobTitle = jobTitle;
    }

    public String getReportTo() {
        return reportTo;
    }

    public void setReportTo(String reportTo) {
        this.reportTo = reportTo;
    }
    
    
}
