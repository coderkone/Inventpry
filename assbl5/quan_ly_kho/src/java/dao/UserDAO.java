package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import model.UserAccount;
import utils.DBConnection;

public class UserDAO {

    public UserAccount login(String username, String password) {
        String sql = "SELECT ma_nguoi_dung, ten_dang_nhap, ho_ten, email, so_dien_thoai, vai_tro, trang_thai "
                + "FROM nguoi_dung WHERE ten_dang_nhap = ? AND mat_khau = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapUser(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<UserAccount> getAllUsers() {
        List<UserAccount> users = new ArrayList<>();
        String sql = "SELECT ma_nguoi_dung, ten_dang_nhap, ho_ten, email, so_dien_thoai, vai_tro, trang_thai "
                + "FROM nguoi_dung ORDER BY ma_nguoi_dung DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                users.add(mapUser(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return users;
    }

    public UserAccount getById(long userId) {
        String sql = "SELECT ma_nguoi_dung, ten_dang_nhap, ho_ten, email, so_dien_thoai, vai_tro, trang_thai "
                + "FROM nguoi_dung WHERE ma_nguoi_dung = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapUser(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean existsUsername(String username) {
        return existsUsername(username, null);
    }

    public boolean existsUsername(String username, Long excludeUserId) {
        String sql = "SELECT 1 FROM nguoi_dung WHERE ten_dang_nhap = ?"
                + (excludeUserId != null ? " AND ma_nguoi_dung <> ?" : "");
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            if (excludeUserId != null) {
                ps.setLong(2, excludeUserId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean existsEmail(String email) {
        return existsEmail(email, null);
    }

    public boolean existsEmail(String email, Long excludeUserId) {
        String sql = "SELECT 1 FROM nguoi_dung WHERE email = ?"
                + (excludeUserId != null ? " AND ma_nguoi_dung <> ?" : "");
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            if (excludeUserId != null) {
                ps.setLong(2, excludeUserId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean createUser(String username, String password, String fullName, String email,
            String phone, String role, boolean active) {
        String sql = "INSERT INTO nguoi_dung (ma_nguoi_dung, ten_dang_nhap, mat_khau, ho_ten, email, so_dien_thoai, vai_tro, trang_thai) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setLong(1, getNextUserId(con));
            ps.setString(2, username);
            ps.setString(3, password);
            ps.setString(4, fullName);
            ps.setString(5, email);
            if (phone == null || phone.trim().isEmpty()) {
                ps.setNull(6, Types.VARCHAR);
            } else {
                ps.setString(6, phone);
            }
            ps.setString(7, role);
            ps.setInt(8, active ? 1 : 0);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateUser(long userId, String username, String password, String fullName,
            String email, String phone, String role, boolean active) {
        StringBuilder sql = new StringBuilder();
        sql.append("UPDATE nguoi_dung SET ten_dang_nhap = ?, ho_ten = ?, email = ?, so_dien_thoai = ?, vai_tro = ?, trang_thai = ?");
        if (password != null && !password.trim().isEmpty()) {
            sql.append(", mat_khau = ?");
        }
        sql.append(" WHERE ma_nguoi_dung = ?");

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            int index = 1;
            ps.setString(index++, username);
            ps.setString(index++, fullName);
            ps.setString(index++, email);
            if (phone == null || phone.trim().isEmpty()) {
                ps.setNull(index++, Types.VARCHAR);
            } else {
                ps.setString(index++, phone);
            }
            ps.setString(index++, role);
            ps.setInt(index++, active ? 1 : 0);
            if (password != null && !password.trim().isEmpty()) {
                ps.setString(index++, password);
            }
            ps.setLong(index, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateStatus(long userId, boolean active) {
        String sql = "UPDATE nguoi_dung SET trang_thai = ? WHERE ma_nguoi_dung = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, active ? 1 : 0);
            ps.setLong(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean hasReferences(long userId) {
        return existsReference("SELECT 1 FROM phieu_nhap WHERE ma_nguoi_tao = ?", userId)
                || existsReference("SELECT 1 FROM phieu_xuat WHERE ma_nguoi_tao = ?", userId)
                || existsReference("SELECT 1 FROM lich_su_kho WHERE ma_nguoi_tao = ?", userId);
    }

    public boolean deleteUser(long userId) {
        String sql = "DELETE FROM nguoi_dung WHERE ma_nguoi_dung = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private boolean existsReference(String sql, long userId) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private long getNextUserId(Connection con) throws Exception {
        String sql = "SELECT ISNULL(MAX(ma_nguoi_dung), 0) + 1 AS next_id FROM nguoi_dung";
        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getLong("next_id");
            }
        }
        return 1;
    }

    private UserAccount mapUser(ResultSet rs) throws Exception {
        UserAccount user = new UserAccount();
        user.setMaNguoiDung(rs.getLong("ma_nguoi_dung"));
        user.setTenDangNhap(rs.getString("ten_dang_nhap"));
        user.setHoTen(rs.getString("ho_ten"));
        user.setEmail(rs.getString("email"));
        user.setSoDienThoai(rs.getString("so_dien_thoai"));
        user.setVaiTro(rs.getString("vai_tro"));
        user.setActive(rs.getInt("trang_thai") == 1);
        return user;
    }
}
