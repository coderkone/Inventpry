package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;
import model.ReceiptItem;
import utils.DBConnection;

public class ImportReceiptDAO {

    public String createImportReceipt(long supplierId, long userId, String note, List<ReceiptItem> items) throws Exception {
        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            long receiptId = getNextId(con, "phieu_nhap", "ma_phieu_nhap");
            long detailId = getNextId(con, "chi_tiet_phieu_nhap", "ma_chi_tiet_phieu_nhap");
            long historyId = getNextId(con, "lich_su_kho", "ma_lich_su");
            String receiptCode = buildCode("PN", receiptId);
            double total = 0;
            for (ReceiptItem item : items) {
                total += item.getTotalPrice();
            }

            String insertReceipt = "INSERT INTO phieu_nhap (ma_phieu_nhap, ma_phieu, ma_nha_cung_cap, ma_nguoi_tao, ngay_nhap, tong_tien, ghi_chu, trang_thai) VALUES (?, ?, ?, ?, GETDATE(), ?, ?, 'HOAN_THANH')";
            try (PreparedStatement ps = con.prepareStatement(insertReceipt)) {
                ps.setLong(1, receiptId);
                ps.setString(2, receiptCode);
                ps.setLong(3, supplierId);
                ps.setLong(4, userId);
                ps.setDouble(5, total);
                ps.setString(6, note);
                ps.executeUpdate();
            }

            String insertDetail = "INSERT INTO chi_tiet_phieu_nhap (ma_chi_tiet_phieu_nhap, ma_phieu_nhap, ma_san_pham, so_luong, don_gia, thanh_tien) VALUES (?, ?, ?, ?, ?, ?)";
            String updateStock = "UPDATE san_pham SET so_luong_ton = ?, ngay_cap_nhat = GETDATE() WHERE ma_san_pham = ?";
            String insertHistory = "INSERT INTO lich_su_kho (ma_lich_su, ma_san_pham, loai_bien_dong, loai_tham_chieu, ma_tham_chieu, so_luong, ton_cu, ton_moi, ma_nguoi_tao, ngay_tao, ghi_chu) VALUES (?, ?, 'NHAP', 'PHIEU_NHAP', ?, ?, ?, ?, ?, GETDATE(), ?)";

            for (ReceiptItem item : items) {
                try (PreparedStatement ps = con.prepareStatement(insertDetail)) {
                    ps.setLong(1, detailId++);
                    ps.setLong(2, receiptId);
                    ps.setLong(3, item.getProductId());
                    ps.setInt(4, item.getQuantity());
                    ps.setDouble(5, item.getUnitPrice());
                    ps.setDouble(6, item.getTotalPrice());
                    ps.executeUpdate();
                }

                int oldStock = getCurrentStock(con, item.getProductId());
                int newStock = oldStock + item.getQuantity();

                try (PreparedStatement ps = con.prepareStatement(updateStock)) {
                    ps.setInt(1, newStock);
                    ps.setLong(2, item.getProductId());
                    ps.executeUpdate();
                }

                try (PreparedStatement ps = con.prepareStatement(insertHistory)) {
                    ps.setLong(1, historyId++);
                    ps.setLong(2, item.getProductId());
                    ps.setLong(3, receiptId);
                    ps.setInt(4, item.getQuantity());
                    ps.setInt(5, oldStock);
                    ps.setInt(6, newStock);
                    ps.setLong(7, userId);
                    ps.setString(8, note != null && !note.trim().isEmpty() ? note : "Nhap kho tu phieu " + receiptCode);
                    ps.executeUpdate();
                }
            }

            con.commit();
            return receiptCode;
        } catch (Exception e) {
            if (con != null) {
                con.rollback();
            }
            throw e;
        } finally {
            if (con != null) {
                con.setAutoCommit(true);
                con.close();
            }
        }
    }

    private int getCurrentStock(Connection con, long productId) throws Exception {
        String sql = "SELECT so_luong_ton FROM san_pham WHERE ma_san_pham = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                return rs.getInt(1);
            }
        }
    }

    private long getNextId(Connection con, String table, String idColumn) throws Exception {
        String sql = "SELECT ISNULL(MAX(" + idColumn + "), 0) + 1 FROM " + table;
        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            rs.next();
            return rs.getLong(1);
        }
    }

    private String buildCode(String prefix, long id) {
        return String.format("%s%05d", prefix, id);
    }
}
