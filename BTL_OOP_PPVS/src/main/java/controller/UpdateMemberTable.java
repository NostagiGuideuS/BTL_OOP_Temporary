package controller;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import javax.swing.JButton;
import javax.swing.JTable;
import javax.swing.JTextField;
import javax.swing.RowFilter;
import javax.swing.event.DocumentEvent;
import javax.swing.event.DocumentListener;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.TableModel;
import javax.swing.table.TableRowSorter;

import model.entity.Member;
import model.dao.MemberDAO;

/**
 *
 * @author ADMIN
 */
public class UpdateMemberTable extends UpdateTable<Member> {
    
    private static UpdateMemberTable singleTon = new UpdateMemberTable();
    
    private UpdateMemberTable() {}
    
    /**
     * Duy trì một UpdateMemberTable duy nhất.
     * Đông thời khi thêm thành viên, ThemThanhVienJFrame gọi thẳng được cái này.
     * Nên sẽ add thêm dòng vào bảng được luôn.
     * 
     * @return singleTon duy nhất tồn tại
     */
    public static UpdateMemberTable getUpdateMemberTable() {
        return singleTon;
    }
    
    @Override
    protected void getListElement() throws SQLException {
        allElement = MemberDAO.getAllMember();
    }
    
    @Override
    public boolean addElement(Member newMember) throws SQLException {
        if (MemberDAO.addNewMember(newMember)) {
            allElement.add(newMember);
            addRow(newMember);
            return true;
        }
        
        return false;
    }
    
    @Override
    protected void addRow(Member member) {
        String[] newLine = new String[5]; // Số lượng cột trong listColumn
        newLine[0] = member.getID();
        newLine[1] = member.getFirstName();
        newLine[2] = member.getLastName();
        newLine[3] = member.getContact();
        newLine[4] = member.getDateOfBirth(); // Hiển thị ngày sinh
            
        tableModel.addRow(newLine);
    }
    
    @Override
    public void setTableUpToDate(JTable table, JButton jbtAdd, JTextField jtfSearch) throws SQLException {
       
        singleTon.tableModel = (DefaultTableModel) table.getModel();
        singleTon.jbtAdd = jbtAdd;
        singleTon.jtfSearch = jtfSearch;
        
        // Lấy toàn bộ thông tin từ DB. 
        // addAll dòng mới vào trong tableModel
        getListElement();
        for (Member member : allElement) {
            addRow(member);
        }
        
        
        // Setting để có chức năng sort ngay trên table
        TableRowSorter<TableModel> rowSorter = new TableRowSorter<>(table.getModel());
        table.setRowSorter(rowSorter);
        
        
        // ActionListener cho thanh search (J Text Field)
        jtfSearch.getDocument().addDocumentListener(new DocumentListener() {
            @Override
            public void insertUpdate(DocumentEvent e) {
                String text = jtfSearch.getText();
                if(text.trim().length() == 0) {
                    rowSorter.setRowFilter(null);
                } else {
                    rowSorter.setRowFilter(RowFilter.regexFilter("(?i)" + text));
                }
            }

            @Override
            public void removeUpdate(DocumentEvent e) {
                String text = jtfSearch.getText();
                if(text.trim().length() == 0) {
                    rowSorter.setRowFilter(null);
                } else {
                    rowSorter.setRowFilter(RowFilter.regexFilter("(?i)" + text));
                }
            }

            @Override
            public void changedUpdate(DocumentEvent e) {
                System.out.println("Track changed Update");
            }
        }); 
    }
}
