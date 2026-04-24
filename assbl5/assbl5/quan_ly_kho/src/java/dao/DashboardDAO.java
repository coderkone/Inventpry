package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import model.DashboardStats;
import model.HistoryEntry;
import model.ProductStatisticRow;
import model.StockStatisticRow;
import utils.DBConnection;

public class DashboardDAO {

    public DashboardStats getStats() {
        DashboardStats stats = new DashboardStats();
        try (Connection con = DBConnection.getConnection()) {
            stats.setTotalProducts(singleInt(con, "SELECT COUNT(*) FROM san_pham WHERE trang_thai = 1"));
            stats.setTotalQuantity(singleInt(con, "SELECT ISNULL(SUM(so_luong_ton), 0) FROM san_pham WHERE trang_thai = 1"));
            stats.setTotalImports(singleInt(con, "SELECT COUNT(*) FROM phieu_nhap"));
            stats.setTotalExports(singleInt(con, "SELECT COUNT(*) FROM phieu_xuat"));
            stats.setTotalHistory(singleInt(con, "SELECT COUNT(*) FROM lich_su_kho"));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return stats;
    }

    /**
     * KPI nhập/xuất theo khoảng thời gian (bao gồm cả số phiếu, số lượng, giá
     * trị).
     */
    public StockStatisticRow getKpi(Date from, Date to) {
        StockStatisticRow kpi = new StockStatisticRow();
        String sql
                = "SELECT "
                + "  ISNULL(n.import_receipt_count, 0) AS import_receipt_count, "
                + "  ISNULL(n.import_quantity, 0) AS import_quantity, "
                + "  ISNULL(n.import_amount, 0) AS import_amount, "
                + "  ISNULL(x.export_receipt_count, 0) AS export_receipt_count, "
                + "  ISNULL(x.export_quantity, 0) AS export_quantity, "
                + "  ISNULL(x.export_amount, 0) AS export_amount "
                + "FROM "
                + "  (SELECT "
                + "     COUNT(DISTINCT pn.ma_phieu_nhap) AS import_receipt_count, "
                + "     ISNULL(SUM(ct.so_luong), 0) AS import_quantity, "
                + "     ISNULL(SUM(ct.thanh_tien), 0) AS import_amount "
                + "   FROM phieu_nhap pn "
                + "   LEFT JOIN chi_tiet_phieu_nhap ct ON pn.ma_phieu_nhap = ct.ma_phieu_nhap "
                + "   WHERE pn.ngay_nhap >= ? AND pn.ngay_nhap < ? "
                + "  ) n "
                + "CROSS JOIN "
                + "  (SELECT "
                + "     COUNT(DISTINCT px.ma_phieu_xuat) AS export_receipt_count, "
                + "     ISNULL(SUM(ct.so_luong), 0) AS export_quantity, "
                + "     ISNULL(SUM(ct.thanh_tien), 0) AS export_amount "
                + "   FROM phieu_xuat px "
                + "   LEFT JOIN chi_tiet_phieu_xuat ct ON px.ma_phieu_xuat = ct.ma_phieu_xuat "
                + "   WHERE px.ngay_xuat >= ? AND px.ngay_xuat < ? "
                + "  ) x";

        if (from == null || to == null) {
            return kpi;
        }

        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            Timestamp fromTs = new Timestamp(from.getTime());
            Timestamp toTs = new Timestamp(to.getTime());
            ps.setTimestamp(1, fromTs);
            ps.setTimestamp(2, toTs);
            ps.setTimestamp(3, fromTs);
            ps.setTimestamp(4, toTs);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    kpi.setImportReceiptCount(rs.getInt("import_receipt_count"));
                    kpi.setImportQuantity(rs.getInt("import_quantity"));
                    kpi.setImportAmount(rs.getDouble("import_amount"));
                    kpi.setExportReceiptCount(rs.getInt("export_receipt_count"));
                    kpi.setExportQuantity(rs.getInt("export_quantity"));
                    kpi.setExportAmount(rs.getDouble("export_amount"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return kpi;
    }

    /**
     * Chuỗi thời gian nhập/xuất theo ngày trong khoảng [from, to). periodLabel
     * định dạng yyyy-MM-dd (theo SQL CONVERT(varchar(10), date, 120)).
     */
    public List<StockStatisticRow> getDailyStockSeries(Date from, Date to) {
        List<StockStatisticRow> list = new ArrayList<>();
        if (from == null || to == null) {
            return list;
        }

        String sql
                = "SELECT "
                + "  d.period_label, "
                + "  ISNULL(n.import_receipt_count, 0) AS import_receipt_count, "
                + "  ISNULL(n.import_quantity, 0) AS import_quantity, "
                + "  ISNULL(n.import_amount, 0) AS import_amount, "
                + "  ISNULL(x.export_receipt_count, 0) AS export_receipt_count, "
                + "  ISNULL(x.export_quantity, 0) AS export_quantity, "
                + "  ISNULL(x.export_amount, 0) AS export_amount "
                + "FROM ( "
                + "  SELECT CONVERT(varchar(10), pn.ngay_nhap, 120) AS period_label "
                + "  FROM phieu_nhap pn "
                + "  WHERE pn.ngay_nhap >= ? AND pn.ngay_nhap < ? "
                + "  GROUP BY CONVERT(varchar(10), pn.ngay_nhap, 120) "
                + "  UNION "
                + "  SELECT CONVERT(varchar(10), px.ngay_xuat, 120) AS period_label "
                + "  FROM phieu_xuat px "
                + "  WHERE px.ngay_xuat >= ? AND px.ngay_xuat < ? "
                + "  GROUP BY CONVERT(varchar(10), px.ngay_xuat, 120) "
                + ") d "
                + "LEFT JOIN ( "
                + "  SELECT "
                + "    CONVERT(varchar(10), pn.ngay_nhap, 120) AS period_label, "
                + "    COUNT(DISTINCT pn.ma_phieu_nhap) AS import_receipt_count, "
                + "    ISNULL(SUM(ct.so_luong), 0) AS import_quantity, "
                + "    ISNULL(SUM(ct.thanh_tien), 0) AS import_amount "
                + "  FROM phieu_nhap pn "
                + "  LEFT JOIN chi_tiet_phieu_nhap ct ON pn.ma_phieu_nhap = ct.ma_phieu_nhap "
                + "  WHERE pn.ngay_nhap >= ? AND pn.ngay_nhap < ? "
                + "  GROUP BY CONVERT(varchar(10), pn.ngay_nhap, 120) "
                + ") n ON d.period_label = n.period_label "
                + "LEFT JOIN ( "
                + "  SELECT "
                + "    CONVERT(varchar(10), px.ngay_xuat, 120) AS period_label, "
                + "    COUNT(DISTINCT px.ma_phieu_xuat) AS export_receipt_count, "
                + "    ISNULL(SUM(ct.so_luong), 0) AS export_quantity, "
                + "    ISNULL(SUM(ct.thanh_tien), 0) AS export_amount "
                + "  FROM phieu_xuat px "
                + "  LEFT JOIN chi_tiet_phieu_xuat ct ON px.ma_phieu_xuat = ct.ma_phieu_xuat "
                + "  WHERE px.ngay_xuat >= ? AND px.ngay_xuat < ? "
                + "  GROUP BY CONVERT(varchar(10), px.ngay_xuat, 120) "
                + ") x ON d.period_label = x.period_label "
                + "ORDER BY d.period_label ASC";

        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            Timestamp fromTs = new Timestamp(from.getTime());
            Timestamp toTs = new Timestamp(to.getTime());

            // d (imports) + d (exports)
            ps.setTimestamp(1, fromTs);
            ps.setTimestamp(2, toTs);
            ps.setTimestamp(3, fromTs);
            ps.setTimestamp(4, toTs);
            // n
            ps.setTimestamp(5, fromTs);
            ps.setTimestamp(6, toTs);
            // x
            ps.setTimestamp(7, fromTs);
            ps.setTimestamp(8, toTs);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    StockStatisticRow row = new StockStatisticRow();
                    row.setPeriodLabel(rs.getString("period_label"));
                    row.setImportReceiptCount(rs.getInt("import_receipt_count"));
                    row.setImportQuantity(rs.getInt("import_quantity"));
                    row.setImportAmount(rs.getDouble("import_amount"));
                    row.setExportReceiptCount(rs.getInt("export_receipt_count"));
                    row.setExportQuantity(rs.getInt("export_quantity"));
                    row.setExportAmount(rs.getDouble("export_amount"));
                    list.add(row);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Top sản phẩm xuất nhiều nhất trong khoảng [from, to). Trả về
     * ProductStatisticRow với tongXuat + giaTriXuat (và thông tin sản phẩm cơ
     * bản).
     */
    public List<ProductStatisticRow> getTopExportProducts(Date from, Date to, int limit) {
        List<ProductStatisticRow> list = new ArrayList<>();
        if (from == null || to == null) {
            return list;
        }
        if (limit <= 0) {
            limit = 10;
        }

        String sql
                = "SELECT TOP (" + limit + ") "
                + "  sp.ma_san_pham, sp.ma_hang, sp.ten_san_pham, lh.ten_loai_hang, "
                + "  sp.don_vi_tinh, sp.so_luong_ton, sp.gia_nhap, sp.gia_xuat, "
                + "  ISNULL(SUM(ct.so_luong), 0) AS tong_xuat, "
                + "  ISNULL(SUM(ct.thanh_tien), 0) AS gia_tri_xuat "
                + "FROM chi_tiet_phieu_xuat ct "
                + "JOIN phieu_xuat px ON ct.ma_phieu_xuat = px.ma_phieu_xuat "
                + "JOIN san_pham sp ON ct.ma_san_pham = sp.ma_san_pham "
                + "JOIN loai_hang lh ON sp.ma_loai_hang = lh.ma_loai_hang "
                + "WHERE px.ngay_xuat >= ? AND px.ngay_xuat < ? "
                + "GROUP BY sp.ma_san_pham, sp.ma_hang, sp.ten_san_pham, lh.ten_loai_hang, "
                + "         sp.don_vi_tinh, sp.so_luong_ton, sp.gia_nhap, sp.gia_xuat "
                + "ORDER BY ISNULL(SUM(ct.so_luong), 0) DESC, sp.ten_san_pham ASC";

        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setTimestamp(1, new Timestamp(from.getTime()));
            ps.setTimestamp(2, new Timestamp(to.getTime()));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProductStatisticRow row = new ProductStatisticRow();
                    row.setMaSanPham(rs.getLong("ma_san_pham"));
                    row.setMaHang(rs.getString("ma_hang"));
                    row.setTenSanPham(rs.getString("ten_san_pham"));
                    row.setTenLoaiHang(rs.getString("ten_loai_hang"));
                    row.setDonViTinh(rs.getString("don_vi_tinh"));
                    row.setSoLuongTon(rs.getInt("so_luong_ton"));
                    row.setGiaNhap(rs.getDouble("gia_nhap"));
                    row.setGiaXuat(rs.getDouble("gia_xuat"));
                    row.setTongXuat(rs.getInt("tong_xuat"));
                    row.setGiaTriXuat(rs.getDouble("gia_tri_xuat"));
                    list.add(row);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Danh sách sản phẩm tồn dưới ngưỡng (bao gồm cả hết hàng). Dùng cho widget
     * cảnh báo tồn kho.
     */
    public List<ProductStatisticRow> getLowStockProducts(int threshold, String keyword, Integer categoryId) {
        List<ProductStatisticRow> list = new ArrayList<>();
        if (threshold < 0) {
            threshold = 0;
        }

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT sp.ma_san_pham, sp.ma_hang, sp.ten_san_pham, lh.ten_loai_hang, ")
                .append("sp.don_vi_tinh, sp.so_luong_ton, sp.gia_nhap, sp.gia_xuat ")
                .append("FROM san_pham sp ")
                .append("JOIN loai_hang lh ON sp.ma_loai_hang = lh.ma_loai_hang ")
                .append("WHERE sp.trang_thai = 1 AND sp.so_luong_ton <= ? ");

        List<Object> params = new ArrayList<>();
        params.add(threshold);

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

        sql.append("ORDER BY sp.so_luong_ton ASC, sp.ten_san_pham ASC");

        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProductStatisticRow row = new ProductStatisticRow();
                    row.setMaSanPham(rs.getLong("ma_san_pham"));
                    row.setMaHang(rs.getString("ma_hang"));
                    row.setTenSanPham(rs.getString("ten_san_pham"));
                    row.setTenLoaiHang(rs.getString("ten_loai_hang"));
                    row.setDonViTinh(rs.getString("don_vi_tinh"));
                    row.setSoLuongTon(rs.getInt("so_luong_ton"));
                    row.setGiaNhap(rs.getDouble("gia_nhap"));
                    row.setGiaXuat(rs.getDouble("gia_xuat"));
                    list.add(row);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private int singleInt(Connection con, String sql) throws Exception {
        try (PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            rs.next();
            return rs.getInt(1);
        }
    }

    public List<HistoryEntry> getRecent(int limit, String keyword) {
        List<HistoryEntry> list = new ArrayList<>();
        if (limit <= 0) {
            limit = 8;
        }

        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();

        String sql = "SELECT TOP " + limit + " ls.ma_lich_su, sp.ma_hang, sp.ten_san_pham, ls.loai_bien_dong, ls.loai_tham_chieu, ls.ma_tham_chieu, "
                + "ls.so_luong, ls.ton_cu, ls.ton_moi, nd.ho_ten, ls.ngay_tao, ls.ghi_chu "
                + "FROM lich_su_kho ls "
                + "JOIN san_pham sp ON ls.ma_san_pham = sp.ma_san_pham "
                + "LEFT JOIN nguoi_dung nd ON ls.ma_nguoi_tao = nd.ma_nguoi_dung "
                + (hasKeyword ? "WHERE (sp.ma_hang LIKE ? OR sp.ten_san_pham LIKE ?) " : "")
                + "ORDER BY ls.ngay_tao DESC, ls.ma_lich_su DESC";

        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            if (hasKeyword) {
                String value = "%" + keyword.trim() + "%";
                ps.setString(1, value);
                ps.setString(2, value);
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
}
