package model.dao;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.DatabaseConnector;
import model.entity.User;

/**
 *
 * @author Littl
 */
public class UserDAO {
    /**
     *<p>
     * Thực hiện login vào tài khoản thông qua ID và mật khẩu.
     * Kết quả trả về là User.loginAlert.
     *</p>
     *<p>
     * Hàm chỉ trả về kết quả thành công hay không.
     * Việc getInfo cho currentUser do view thực hiện lại.
     * </p>
     * 
     * @param userID = ID người dùng.
     * @param password = mật khẩu xác nhận.
     * 
     * @return  FIRST_TIMES_LOGIN, WRONG_PASSWORD, CORRECT_PASSWORD
     * 
     * @throws SQLException 
     */
    public static User.loginAlert login(String userID, String password) throws SQLException {
        
        CallableStatement finder = (CallableStatement) DatabaseConnector.getConnection().prepareCall("{ call login(?, ?) }");
        
        finder.setString(1, userID);
        finder.setString(2, password);
        
        ResultSet rs;
        rs = finder.executeQuery();
        
        /**
         * There are some case may happen.
         * if (role == null) thì người dùng không tồn tại hoặc sai mật khẩu.
         * else if (firstTry == true) thì là lần đăng nhập đầu tiên.
         * else không phải lần đầu thôi chứ vấn đúng.
         */
        
        while(rs.next()) {
            String role = rs.getString(1);
            if (role == null) {
                return User.loginAlert.WRONG_PASSWORD;
            } else if (rs.getBoolean(2) == true) {
                if (role.equals("Staff")) {
                    return User.loginAlert.FIRST_TIMES_LOGIN;
                } else {
                    return User.loginAlert.FIRST_TIMES_LOGIN;
                }
            } else {
                if (role.equals("Staff")) {
                    return User.loginAlert.CORRECT_PASSWORD;
                } else {
                    return User.loginAlert.CORRECT_PASSWORD;
                }
            }
        }
        return User.loginAlert.WRONG_PASSWORD;
    }
    
    
    /**
     * Cho phép tự cài lại mật khẩu cho một user.
     * 
     * @param userID = ID user cần đổi mật khẩu.
     * @param oldPassword = mật khẩu cũ
     * @param newPassword = mật khẩu mới
     * 
     * @return true/false
     */
    public static boolean changePassword(String userID, String oldPassword, String newPassword) throws SQLException {
        CallableStatement finder = (CallableStatement) DatabaseConnector.getConnection().prepareCall("{ call changePassword(?, ?, ?) }");
        
        finder.setString(1, userID);
        finder.setString(2, oldPassword);
        finder.setString(3, newPassword);
        
        ResultSet rs;
        rs = finder.executeQuery();
        
        while(rs.next()) {
            if (rs.getInt(1) == 1) return true;
            else return false;
        }
        
        return false;
    }
    
    public static void deleteUser(String ID, String whoDidID) throws SQLException {
        CallableStatement finder = (CallableStatement) DatabaseConnector.getConnection().prepareCall("{ call deleteUser(?, ?) }");
        
        finder.setString(1, ID);
        finder.setString(2, whoDidID);
                
        finder.executeQuery();
    }
}
