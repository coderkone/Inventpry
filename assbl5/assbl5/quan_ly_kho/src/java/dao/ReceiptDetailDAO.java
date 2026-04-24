package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.ExportReceiptView;
import model.ImportReceiptView;
import model.ReceiptLine;
import utils.DBConnection;

public class ReceiptDetailDAO {

    public ImportReceiptView getImportReceipt(long receiptId) {
        String sql = "SELECT pn.ma_phieu_nhap, pn.ma_phieu, ncc.ten_nha_cung_cap, nd.ho_ten, pn.ngay_nhap, pn.tong_tien, pn.ghi_chu "
                + "FROM phieu_nhap pn "
                + "LEFT JOIN nha_cung_cap ncc ON pn.ma_nha_cung_cap = ncc.ma_nha_cung_cap "
                + "LEFT JOIN nguoi_dung nd ON pn.ma_nguoi_tao = nd.ma_nguoi_dung "
                + "WHERE pn.ma_phieu_nhap = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, receiptId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ImportReceiptView r = new ImportReceiptView();
                    r.setMaPhieuNhap(rs.getLong("ma_phieu_nhap"));
                    r.setMaPhieu(rs.getString("ma_phieu"));
                    r.setNhaCungCap(rs.getString("ten_nha_cung_cap"));
                    r.setNguoiTao(rs.getString("ho_ten"));
                    r.setNgayNhap(rs.getTimestamp("ngay_nhap"));
                    r.setTongTien(rs.getDouble("tong_tien"));
                    r.setGhiChu(rs.getString("ghi_chu"));
                    return r;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<ReceiptLine> getImportLines(long receiptId) {
        List<ReceiptLine> list = new ArrayList<>();
        String sql = "SELECT sp.ma_hang, sp.ten_san_pham, ct.so_luong, ct.don_gia, ct.thanh_tien "
                + "FROM chi_tiet_phieu_nhap ct "
                + "JOIN san_pham sp ON ct.ma_san_pham = sp.ma_san_pham "
                + "WHERE ct.ma_phieu_nhap = ? "
                + "ORDER BY ct.ma_chi_tiet_phieu_nhap";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, receiptId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ReceiptLine line = new ReceiptLine();
                    line.setMaHang(rs.getString("ma_hang"));
                    line.setTenSanPham(rs.getString("ten_san_pham"));
                    line.setSoLuong(rs.getInt("so_luong"));
                    line.setDonGia(rs.getDouble("don_gia"));
                    line.setThanhTien(rs.getDouble("thanh_tien"));
                    list.add(line);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public ExportReceiptView getExportReceipt(long receiptId) {
        String sql = "SELECT px.ma_phieu_xuat, px.ma_phieu, px.ten_khach_hang, nd.ho_ten, px.ngay_xuat, px.tong_tien, px.ghi_chu "
                + "FROM phieu_xuat px "
                + "LEFT JOIN nguoi_dung nd ON px.ma_nguoi_tao = nd.ma_nguoi_dung "
                + "WHERE px.ma_phieu_xuat = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, receiptId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ExportReceiptView r = new ExportReceiptView();
                    r.setMaPhieuXuat(rs.getLong("ma_phieu_xuat"));
                    r.setMaPhieu(rs.getString("ma_phieu"));
                    r.setTenKhachHang(rs.getString("ten_khach_hang"));
                    r.setNguoiTao(rs.getString("ho_ten"));
                    r.setNgayXuat(rs.getTimestamp("ngay_xuat"));
                    r.setTongTien(rs.getDouble("tong_tien"));
                    r.setGhiChu(rs.getString("ghi_chu"));
                    return r;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<ReceiptLine> getExportLines(long receiptId) {
        List<ReceiptLine> list = new ArrayList<>();
        String sql = "SELECT sp.ma_hang, sp.ten_san_pham, ct.so_luong, ct.don_gia, ct.thanh_tien "
                + "FROM chi_tiet_phieu_xuat ct "
                + "JOIN san_pham sp ON ct.ma_san_pham = sp.ma_san_pham "
                + "WHERE ct.ma_phieu_xuat = ? "
                + "ORDER BY ct.ma_chi_tiet_phieu_xuat";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, receiptId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ReceiptLine line = new ReceiptLine();
                    line.setMaHang(rs.getString("ma_hang"));
                    line.setTenSanPham(rs.getString("ten_san_pham"));
                    line.setSoLuong(rs.getInt("so_luong"));
                    line.setDonGia(rs.getDouble("don_gia"));
                    line.setThanhTien(rs.getDouble("thanh_tien"));
                    list.add(line);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}

