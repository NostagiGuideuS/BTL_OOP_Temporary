package model.dao;

import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.Date;

import model.DatabaseConnector;
import model.entity.Member;

/**
 *
 * @author Littl
 */
public class MemberDAO {
    
    public static ArrayList<Member> getAllMember() throws SQLException {
        String sql = "SELECT * FROM library_2nd_edition.member";
        PreparedStatement ps = DatabaseConnector.getConnection().prepareStatement(sql);
        ResultSet rs = ps.executeQuery();
        
        String[] date;
        ArrayList<Member> list = new ArrayList<>();
        while(rs.next()) {
            
            Member member = new Member(rs.getString(1),
                                  rs.getString(2),
                                   rs.getString(3),
                                    rs.getString(4),
                                 rs.getString(5));
            
            list.add(member);
        }
        
        ps.close();
        rs.close();
        return list;
    }
    
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
    public static Member getMemberInfo(String ID) throws SQLException {
        CallableStatement finder = (CallableStatement) DatabaseConnector.getConnection().prepareCall("{ call getMemberInfo(?) }");
        
        finder.setString(1, ID);
        
        ResultSet rs;
        rs = finder.executeQuery();
        
        String[] date;
        while (rs.next()) {
            return new Member(rs.getString(1),
                         rs.getString(2),
                          rs.getString(3),
                           rs.getString(4),
                        rs.getString(5));
        }
        return null;
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
    public static boolean addNewMember (Member newMember) throws SQLException {
        CallableStatement finder = (CallableStatement) DatabaseConnector.getConnection().prepareCall("{ call addMember(?, ?, ?, ?, ?) }");
        
        finder.setString(1, newMember.getID());
        finder.setString(2, newMember.getFirstName());
        finder.setString(3, newMember.getLastName());
        finder.setString(4, newMember.getContact());
        finder.setString(5, newMember.getDateOfBirth());
                
        ResultSet rs;
        rs = finder.executeQuery();
        
        while (rs.next()) {
            return rs.getBoolean(1);
        }
        return false;
    }
}
