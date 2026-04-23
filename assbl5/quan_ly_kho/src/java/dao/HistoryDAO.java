package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.HistoryEntry;
import utils.DBConnection;

public class HistoryDAO {

    public List<HistoryEntry> getAll(String type) {
        List<HistoryEntry> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT ls.ma_lich_su, sp.ma_hang, sp.ten_san_pham, ls.loai_bien_dong, ls.loai_tham_chieu, ");
        sql.append("ls.ma_tham_chieu, ls.so_luong, ls.ton_cu, ls.ton_moi, nd.ho_ten, ls.ngay_tao, ls.ghi_chu ");
        sql.append("FROM lich_su_kho ls ");
        sql.append("JOIN san_pham sp ON ls.ma_san_pham = sp.ma_san_pham ");
        sql.append("LEFT JOIN nguoi_dung nd ON ls.ma_nguoi_tao = nd.ma_nguoi_dung ");
        sql.append("WHERE 1 = 1 ");
        if (type != null && !type.trim().isEmpty()) {
            sql.append("AND ls.loai_bien_dong = ? ");
        }
        sql.append("ORDER BY ls.ngay_tao DESC, ls.ma_lich_su DESC");

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            if (type != null && !type.trim().isEmpty()) {
                ps.setString(1, type);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    HistoryEntry h = new HistoryEntry();
                    h.setMaLichSu(rs.getLong("ma_lich_su"));
                    h.setMaHang(rs.getString("ma_hang"));
                    h.setTenSanPham(rs.getString("ten_san_pham"));
                    h.setLoaiBienDong(rs.getString("loai_bien_dong"));
                    h.setLoaiThamChieu(rs.getString("loai_tham_chieu"));
                    h.setMaThamChieu(rs.getLong("ma_tham_chieu"));
                    h.setSoLuong(rs.getInt("so_luong"));
                    h.setTonCu(rs.getInt("ton_cu"));
                    h.setTonMoi(rs.getInt("ton_moi"));
                    h.setNguoiTao(rs.getString("ho_ten"));
                    h.setNgayTao(rs.getTimestamp("ngay_tao"));
                    h.setGhiChu(rs.getString("ghi_chu"));
                    list.add(h);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<HistoryEntry> getRecent(int limit) {
        List<HistoryEntry> list = new ArrayList<>();
        String sql = "SELECT TOP " + limit + " ls.ma_lich_su, sp.ma_hang, sp.ten_san_pham, ls.loai_bien_dong, ls.loai_tham_chieu, ls.ma_tham_chieu, "
                + "ls.so_luong, ls.ton_cu, ls.ton_moi, nd.ho_ten, ls.ngay_tao, ls.ghi_chu "
                + "FROM lich_su_kho ls "
                + "JOIN san_pham sp ON ls.ma_san_pham = sp.ma_san_pham "
                + "LEFT JOIN nguoi_dung nd ON ls.ma_nguoi_tao = nd.ma_nguoi_dung "
                + "ORDER BY ls.ngay_tao DESC, ls.ma_lich_su DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    HistoryEntry h = new HistoryEntry();
                    h.setMaLichSu(rs.getLong("ma_lich_su"));
                    h.setMaHang(rs.getString("ma_hang"));
                    h.setTenSanPham(rs.getString("ten_san_pham"));
                    h.setLoaiBienDong(rs.getString("loai_bien_dong"));
                    h.setLoaiThamChieu(rs.getString("loai_tham_chieu"));
                    h.setMaThamChieu(rs.getLong("ma_tham_chieu"));
                    h.setSoLuong(rs.getInt("so_luong"));
                    h.setTonCu(rs.getInt("ton_cu"));
                    h.setTonMoi(rs.getInt("ton_moi"));
                    h.setNguoiTao(rs.getString("ho_ten"));
                    h.setNgayTao(rs.getTimestamp("ngay_tao"));
                    h.setGhiChu(rs.getString("ghi_chu"));
                    list.add(h);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
