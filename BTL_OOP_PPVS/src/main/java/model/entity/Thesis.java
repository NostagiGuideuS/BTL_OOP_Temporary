package model.entity;

import java.io.IOException;
import java.sql.SQLException;

import java.util.ArrayList;
import model.dao.ThesisDAO;


/**
 *
 * @author Littl
 */
public class Thesis extends Document {
    protected String writerID;
    protected String advisor;
    protected String fieldOfStudy;

    /**
     * Constructor for model.DAO using only.
     * 
     * @param ID = new Thesis ID.
     * @param title = this thesis title.
     * @param availableCopies = load copies for this document.
     * @param writerID = ID of member who write this.
     * @param advisor = lecturer supervisor.
     * @param fieldOfStudy = a short describe.
     * @param description = thesis introduction.
     * @param category = category ENCRYPT FORM.
     * 
     * @throws IOException 
     */
    public Thesis(String ID, String title, int availableCopies, String writerID, String advisor, String fieldOfStudy, String description, int category) throws IOException {
        this.ID = ID;
        this.title = title;
        this.availableCopies = availableCopies;
        this.writerID = writerID;
        this.advisor = advisor;
        this.fieldOfStudy = fieldOfStudy;
        this.description = description;
        this.category = CategoryType.decode(category);
    }

    public Thesis(String documentID) throws SQLException, IOException {
        Document docu = getDocumentInfo(documentID);
        
        if (docu != null && docu instanceof Thesis) {
            Thesis getter = (Thesis) docu;
            
            this.ID = getter.ID;
            this.title = getter.title;
            this.availableCopies = getter.availableCopies;
            this.writerID = getter.writerID;
            this.advisor = getter.advisor;
            this.fieldOfStudy = getter.fieldOfStudy;
            this.description = getter.description;
        }
    }
    
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
        return ThesisDAO.searchThesis(titleKeyword, fieldOfStudyKeyword, writerID, advisor);
    }
    
    
    public String getWriterID() {
        return writerID;
    }

    public void setWriterID(String writerID) {
        this.writerID = writerID;
    }

    public String getAdvisor() {
        return advisor;
    }

    public void setAdvisor(String advisor) {
        this.advisor = advisor;
    }

    public String getFieldOfStudy() {
        return fieldOfStudy;
    }

    public void setFieldOfStudy(String fieldOfStudy) {
        this.fieldOfStudy = fieldOfStudy;
    }
    
    
}
