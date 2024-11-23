package model.entity;



import java.sql.SQLException;

import java.util.List;
import java.util.ArrayList;
import java.util.HashMap;

import java.io.File;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import model.dao.DocumentDAO;

/**
 *
 * @author Littl
 */
public abstract class Document {
    protected String ID;
    protected String title;
    protected int availableCopies;
    protected ArrayList<String> category = new ArrayList<>();
    protected String description;
    
    protected File cover = null;
    protected String PDFpath = null;
    
    /**
     * Get document search by title. 
     * Book title, or Thesis title and Field of Study.
     * 
     * @param titleKeyword = search keyword
     * 
     * @return list of Document (both Thesis and Book)
     * 
     * @throws SQLException 
     * @throws IOException
     */
    public static ArrayList<Document> searchDocument(String titleKeyword) throws SQLException, IOException {
        ArrayList<Document> result = new ArrayList<>();
        
        result.addAll(Book.searchBook(titleKeyword, "", 0, null));
        result.addAll(Thesis.searchThesis(titleKeyword, titleKeyword, null, ""));
        
        return result;
    }
    
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
        return DocumentDAO.getDocumentInfo(documentID);
    }
    
//    public File loadCover() throws IOException {
//        
//    }

    public String getID() {
        return ID;
    }

    public void setID(String ID) {
        this.ID = ID;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public int getAvailableCopies() {
        return availableCopies;
    }

    public void setAvailableCopies(int availableCopies) {
        this.availableCopies = availableCopies;
    }
    
    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public ArrayList<String> getCategory() {
        return category;
    }

    public void setCategory(ArrayList<String> category) {
        this.category = category;
    }
    
    public int getCategoryEncrypt() throws IOException {
        return CategoryType.encrypt(this.category);
    }
    
    
    public static class CategoryType {
        static private HashMap<Integer, String> decoder;
        static private HashMap<String, Integer> encrypter;
        static private String path = "src\\image\\Document Category.txt";
        
        private static void loadDecoder() throws IOException {
            decoder = new HashMap<>();
            encrypter = new HashMap<>();
            decoder.entrySet();
            
            FileReader input = new FileReader(path);
            BufferedReader reader = new BufferedReader(input);
            
            int index = 0;
            int power = 1;
            String line = reader.readLine();
            while (line != null) {
                decoder.put(index++, line);
                encrypter.put(line, power);
                power *= 2;
                
                line = reader.readLine();
            }
            
            reader.close();
        }
        
        static ArrayList<String> decode(int k) throws IOException {
            if (decoder == null) {
                loadDecoder();
            }
            
            ArrayList<String> result = new ArrayList<>();
            int i = 0;
            while (k != 0) {
                if (k % 2 == 1) {
                    result.add(decoder.get(i++));
                }
                k /= 2;
            }
            return result;
        }
        
        static void addNewCategory (List<String> newCategory) throws IOException {
            FileWriter output = new FileWriter(path, true);
            BufferedWriter writer = new BufferedWriter(output);
            
            int power = (int) Math.pow(2, decoder.size());
            for (String x : newCategory) {
                writer.newLine();
                writer.write(x);
                
                decoder.put(power, x);
                encrypter.put(x, power);
                power *= 2;
            }
            
            writer.close();
            
            
        } 
        
        static int encrypt(List<String> category) throws IOException {
            if (encrypter == null) {
                loadDecoder();
            }
            
            int result = 0;
            for (String x : category) {
                result += encrypter.getOrDefault(x, 0);
            }
            
            return result;
        }
    }
}
