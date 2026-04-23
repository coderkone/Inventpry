package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.DashboardStats;
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

    private int singleInt(Connection con, String sql) throws Exception {
        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            rs.next();
            return rs.getInt(1);
        }
    }
}
