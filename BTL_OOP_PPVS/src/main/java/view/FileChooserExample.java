package view;

import javax.swing.*;
import java.io.File;

public class FileChooserExample {
    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            try {
                // Đặt Look and Feel thành giao diện của hệ điều hành (Windows)
                UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
                
            } catch (Exception e) {
                e.printStackTrace();
            }
            // Tạo cửa sổ JFileChooser
            JFileChooser fileChooser = new JFileChooser();
            fileChooser.setFileSelectionMode(JFileChooser.FILES_AND_DIRECTORIES); // Cho phép chọn file và thư mục
            
            // Hiển thị popup
            int result = fileChooser.showOpenDialog(null);

            // Xử lý kết quả
            if (result == JFileChooser.APPROVE_OPTION) {
                File selectedFile = fileChooser.getSelectedFile();
                System.out.println("Đã chọn: " + selectedFile.getAbsolutePath());
            } else {
                System.out.println("Người dùng đã hủy chọn file.");
            }
        });
    }
}