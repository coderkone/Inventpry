package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.List;
import model.Product;
import utils.DBConnection;

public class ProductDAO {

    public List<Product> getAllActive() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT sp.*, lh.ten_loai_hang FROM san_pham sp "
                + "JOIN loai_hang lh ON sp.ma_loai_hang = lh.ma_loai_hang "
                + "WHERE sp.trang_thai = 1 ORDER BY sp.ma_san_pham DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapProduct(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Product> getActiveForTransaction() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT sp.*, lh.ten_loai_hang FROM san_pham sp "
                + "JOIN loai_hang lh ON sp.ma_loai_hang = lh.ma_loai_hang "
                + "WHERE sp.trang_thai = 1 ORDER BY sp.ten_san_pham";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapProduct(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Product getById(long id) {
        String sql = "SELECT sp.*, lh.ten_loai_hang FROM san_pham sp "
                + "JOIN loai_hang lh ON sp.ma_loai_hang = lh.ma_loai_hang WHERE sp.ma_san_pham = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapProduct(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Map<Long, Product> getByIds(List<Long> ids) {
        Map<Long, Product> map = new HashMap<>();
        if (ids == null || ids.isEmpty()) {
            return map;
        }

        StringBuilder in = new StringBuilder();
        for (int i = 0; i < ids.size(); i++) {
            if (i > 0) in.append(",");
            in.append("?");
        }

        String sql = "SELECT sp.*, lh.ten_loai_hang FROM san_pham sp "
                + "JOIN loai_hang lh ON sp.ma_loai_hang = lh.ma_loai_hang "
                + "WHERE sp.ma_san_pham IN (" + in + ")";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            for (int i = 0; i < ids.size(); i++) {
                ps.setLong(i + 1, ids.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = mapProduct(rs);
                    map.put(p.getMaSanPham(), p);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }

    public boolean existsProductCode(String code, Long excludeId) {
        String sql = "SELECT COUNT(*) FROM san_pham WHERE ma_hang = ?" + (excludeId != null ? " AND ma_san_pham <> ?" : "");

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, code);
            if (excludeId != null) {
                ps.setLong(2, excludeId);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean addProduct(Product p) {
        String sql = "INSERT INTO san_pham (ma_san_pham, ma_hang, ten_san_pham, ma_loai_hang, don_vi_tinh, so_luong_ton, gia_nhap, gia_xuat, mo_ta, hinh_anh, trang_thai, ngay_tao, ngay_cap_nhat) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, NULL, 1, GETDATE(), GETDATE())";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            long nextId = getNextId(con, "san_pham", "ma_san_pham");
            ps.setLong(1, nextId);
            ps.setString(2, p.getMaHang());
            ps.setString(3, p.getTenSanPham());
            ps.setInt(4, p.getMaLoaiHang());
            ps.setString(5, p.getDonViTinh());
            ps.setInt(6, p.getSoLuongTon());
            ps.setDouble(7, p.getGiaNhap());
            ps.setDouble(8, p.getGiaXuat());
            ps.setString(9, p.getMoTa());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateProduct(Product p) {
        String sql = "UPDATE san_pham SET ma_hang = ?, ten_san_pham = ?, ma_loai_hang = ?, don_vi_tinh = ?, gia_nhap = ?, gia_xuat = ?, mo_ta = ?, ngay_cap_nhat = GETDATE() WHERE ma_san_pham = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, p.getMaHang());
            ps.setString(2, p.getTenSanPham());
            ps.setInt(3, p.getMaLoaiHang());
            ps.setString(4, p.getDonViTinh());
            ps.setDouble(5, p.getGiaNhap());
            ps.setDouble(6, p.getGiaXuat());
            ps.setString(7, p.getMoTa());
            ps.setLong(8, p.getMaSanPham());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean softDelete(long id) {
        String sql = "UPDATE san_pham SET trang_thai = 0, ngay_cap_nhat = GETDATE() WHERE ma_san_pham = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private Product mapProduct(ResultSet rs) throws Exception {
        Product p = new Product();
        p.setMaSanPham(rs.getLong("ma_san_pham"));
        p.setMaHang(rs.getString("ma_hang"));
        p.setTenSanPham(rs.getString("ten_san_pham"));
        p.setMaLoaiHang(rs.getInt("ma_loai_hang"));
        p.setTenLoaiHang(rs.getString("ten_loai_hang"));
        p.setDonViTinh(rs.getString("don_vi_tinh"));
        p.setSoLuongTon(rs.getInt("so_luong_ton"));
        p.setGiaNhap(rs.getDouble("gia_nhap"));
        p.setGiaXuat(rs.getDouble("gia_xuat"));
        p.setMoTa(rs.getString("mo_ta"));
        p.setActive(rs.getInt("trang_thai") == 1);
        p.setNgayTao(rs.getTimestamp("ngay_tao"));
        p.setNgayCapNhat(rs.getTimestamp("ngay_cap_nhat"));
        return p;
    }

    private long getNextId(Connection con, String table, String idColumn) throws Exception {
        String sql = "SELECT ISNULL(MAX(" + idColumn + "), 0) + 1 FROM " + table;
        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            rs.next();
            return rs.getLong(1);
        }
    }
}
