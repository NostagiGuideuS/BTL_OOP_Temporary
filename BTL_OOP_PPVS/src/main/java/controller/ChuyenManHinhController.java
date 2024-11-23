package controller;
import bean.DanhMucBean;
import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import javax.swing.JLabel;
import javax.swing.JPanel;
import view.GDMain;
import view.TrangChuJPanel;
import java.util.List;
import view.BanDocJPanel;
import view.MuonTraTaiLieuJPanel;
import view.SachJPanel;
import view.TaiLieuPanel;
import view.ThongTinThanhVienJPanel;

public class ChuyenManHinhController {
    private JPanel root;
    private String kindSelected = "";
    private List<DanhMucBean> listItem = null;
    
    public ChuyenManHinhController(JPanel jpnRoot) {
        this.root= jpnRoot;
    }
    
    //Doi mau
    public void setView(JPanel jpnItem, JLabel jlbItem) {
        kindSelected = "TrangChu";
        jpnItem.setBackground(new Color(26, 83, 25));
        jlbItem.setBackground(new Color(26, 83, 25));
        
        root.removeAll();
        root.setLayout(new BorderLayout());
        root.add(new TrangChuJPanel());
        root.validate();
        root.repaint();
    }
    
    public void setEvent(List<DanhMucBean> listItem) {
        this.listItem = listItem;
        for (DanhMucBean item : listItem) {
            item.getJlb().addMouseListener(new LabelEvent(item.getKind(), item.getJpn(), item.getJlb()));
        }
    }
    
    class LabelEvent implements MouseListener {
        private JPanel node;
        private String kind;
        private JPanel jpnItem;
        private JLabel jlbItem;

        public LabelEvent(String kind,JPanel jpnItem, JLabel jlbItem) {
            this.kind = kind;
            this.jpnItem = jpnItem;
            this.jlbItem = jlbItem;
        }

        @Override
        public void mouseClicked(MouseEvent e) {
            switch(kind) {
                case "TrangChu":
                    node = new TrangChuJPanel();
                    break;
                case "BanDoc":
                    node = new BanDocJPanel();
                    break;
                case "TaiLieu":
                    node = new TaiLieuPanel();
                    break;
                case "MuonTraTaiLieu":
                    node = new MuonTraTaiLieuJPanel();
                    break;
                case "ThongTinThanhVien":
                    node = new ThongTinThanhVienJPanel();
                    break;
                default:
                    node = new TrangChuJPanel();
                    break;
            }
            root.removeAll();
            root.setLayout(new BorderLayout());
            root.add(node);
            root.validate();
            root.repaint();
            setChangeBackgroud(kind);
        }

        @Override
        public void mousePressed(MouseEvent e) {
            kindSelected = kind;
            jpnItem.setBackground(new Color(26, 83, 25));
            jlbItem.setBackground(new Color(26, 83, 25));
            
        }

        @Override
        public void mouseReleased(MouseEvent e) {
         if (!kindSelected.equalsIgnoreCase(kind)) {
            jpnItem.setBackground(new Color(80, 141, 78)); // Màu cũ (mặc định)
            jlbItem.setBackground(new Color(80, 141, 78));
          }
        }

        @Override
        public void mouseEntered(MouseEvent e) {
            jpnItem.setBackground(new Color(26, 83, 25));
            jlbItem.setBackground(new Color(26, 83, 25));
        }

        @Override
        public void mouseExited(MouseEvent e) {
            if (!kindSelected.equalsIgnoreCase(kind)) {
               jpnItem.setBackground(new Color(80, 141, 78)); // Màu cũ (mặc định)
               jlbItem.setBackground(new Color(80, 141, 78));
            } else {
               jpnItem.setBackground(new Color(26, 83, 25)); // Màu khi được chọn
               jlbItem.setBackground(new Color(26, 83, 25));
            }
        }
        
    }
    
    private void setChangeBackgroud(String kind) {
        for(DanhMucBean item : listItem){
            if(item.getKind().equalsIgnoreCase(kind)) {
                item.getJpn().setBackground(new Color(26, 83, 25));
                item.getJlb().setBackground(new Color(26, 83, 25));
            } else {
                item.getJpn().setBackground(new Color(80,141,78));
                item.getJlb().setBackground(new Color(80,141,78));
            }
        }
    }
}
