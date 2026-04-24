package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.ProductStatisticRow;
import utils.DBConnection;

public class StatisticsDAO {

    public List<ProductStatisticRow> getProductStatistics(String keyword, Integer categoryId, String stockFilter, String sortBy) {
        List<ProductStatisticRow> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT sp.ma_san_pham, sp.ma_hang, sp.ten_san_pham, lh.ten_loai_hang, ")
           .append("sp.don_vi_tinh, sp.so_luong_ton, sp.gia_nhap, sp.gia_xuat, ")
           .append("ISNULL(nhap.tong_nhap, 0) AS tong_nhap, ISNULL(nhap.gia_tri_nhap, 0) AS gia_tri_nhap, ")
           .append("ISNULL(xuat.tong_xuat, 0) AS tong_xuat, ISNULL(xuat.gia_tri_xuat, 0) AS gia_tri_xuat ")
           .append("FROM san_pham sp ")
           .append("JOIN loai_hang lh ON sp.ma_loai_hang = lh.ma_loai_hang ")
           .append("LEFT JOIN ( ")
           .append("    SELECT ma_san_pham, SUM(so_luong) AS tong_nhap, SUM(thanh_tien) AS gia_tri_nhap ")
           .append("    FROM chi_tiet_phieu_nhap GROUP BY ma_san_pham ")
           .append(") nhap ON sp.ma_san_pham = nhap.ma_san_pham ")
           .append("LEFT JOIN ( ")
           .append("    SELECT ma_san_pham, SUM(so_luong) AS tong_xuat, SUM(thanh_tien) AS gia_tri_xuat ")
           .append("    FROM chi_tiet_phieu_xuat GROUP BY ma_san_pham ")
           .append(") xuat ON sp.ma_san_pham = xuat.ma_san_pham ")
           .append("WHERE sp.trang_thai = 1 ");

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (sp.ma_hang LIKE ? OR sp.ten_san_pham LIKE ?) ");
            String value = "%" + keyword.trim() + "%";
            params.add(value);
            params.add(value);
        }

        if (categoryId != null && categoryId > 0) {
            sql.append("AND sp.ma_loai_hang = ? ");
            params.add(categoryId);
        }

        if ("out".equals(stockFilter)) {
            sql.append("AND sp.so_luong_ton <= 0 ");
        } else if ("low".equals(stockFilter)) {
            sql.append("AND sp.so_luong_ton BETWEEN 1 AND 10 ");
        } else if ("available".equals(stockFilter)) {
            sql.append("AND sp.so_luong_ton > 10 ");
        }

        sql.append(buildOrderBy(sortBy));

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private String buildOrderBy(String sortBy) {
        if ("stockAsc".equals(sortBy)) {
            return "ORDER BY sp.so_luong_ton ASC, sp.ten_san_pham ASC";
        }
        if ("importDesc".equals(sortBy)) {
            return "ORDER BY ISNULL(nhap.tong_nhap, 0) DESC, sp.ten_san_pham ASC";
        }
        if ("exportDesc".equals(sortBy)) {
            return "ORDER BY ISNULL(xuat.tong_xuat, 0) DESC, sp.ten_san_pham ASC";
        }
        if ("valueDesc".equals(sortBy)) {
            return "ORDER BY (sp.so_luong_ton * sp.gia_nhap) DESC, sp.ten_san_pham ASC";
        }
        return "ORDER BY sp.ten_san_pham ASC";
    }

    private ProductStatisticRow mapRow(ResultSet rs) throws Exception {
        ProductStatisticRow row = new ProductStatisticRow();
        row.setMaSanPham(rs.getLong("ma_san_pham"));
        row.setMaHang(rs.getString("ma_hang"));
        row.setTenSanPham(rs.getString("ten_san_pham"));
        row.setTenLoaiHang(rs.getString("ten_loai_hang"));
        row.setDonViTinh(rs.getString("don_vi_tinh"));
        row.setSoLuongTon(rs.getInt("so_luong_ton"));
        row.setGiaNhap(rs.getDouble("gia_nhap"));
        row.setGiaXuat(rs.getDouble("gia_xuat"));
        row.setTongNhap(rs.getInt("tong_nhap"));
        row.setGiaTriNhap(rs.getDouble("gia_tri_nhap"));
        row.setTongXuat(rs.getInt("tong_xuat"));
        row.setGiaTriXuat(rs.getDouble("gia_tri_xuat"));
        return row;
    }
}
