package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Supplier;
import utils.DBConnection;

public class SupplierDAO {

    public List<Supplier> getAllActive() {
        List<Supplier> list = new ArrayList<>();
        String sql = "SELECT ma_nha_cung_cap, ten_nha_cung_cap FROM nha_cung_cap WHERE trang_thai = 1 ORDER BY ten_nha_cung_cap";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Supplier s = new Supplier();
                s.setMaNhaCungCap(rs.getLong("ma_nha_cung_cap"));
                s.setTenNhaCungCap(rs.getString("ten_nha_cung_cap"));
                list.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
