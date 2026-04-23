package model;

import java.util.Date;

public class HistoryEntry {
    private long maLichSu;
    private String maHang;
    private String tenSanPham;
    private String loaiBienDong;
    private String loaiThamChieu;
    private long maThamChieu;
    private int soLuong;
    private int tonCu;
    private int tonMoi;
    private String nguoiTao;
    private Date ngayTao;
    private String ghiChu;

    public long getMaLichSu() {
        return maLichSu;
    }

    public void setMaLichSu(long maLichSu) {
        this.maLichSu = maLichSu;
    }

    public String getMaHang() {
        return maHang;
    }

    public void setMaHang(String maHang) {
        this.maHang = maHang;
    }

    public String getTenSanPham() {
        return tenSanPham;
    }

    public void setTenSanPham(String tenSanPham) {
        this.tenSanPham = tenSanPham;
    }

    public String getLoaiBienDong() {
        return loaiBienDong;
    }

    public void setLoaiBienDong(String loaiBienDong) {
        this.loaiBienDong = loaiBienDong;
    }

    public String getLoaiThamChieu() {
        return loaiThamChieu;
    }

    public void setLoaiThamChieu(String loaiThamChieu) {
        this.loaiThamChieu = loaiThamChieu;
    }

    public long getMaThamChieu() {
        return maThamChieu;
    }

    public void setMaThamChieu(long maThamChieu) {
        this.maThamChieu = maThamChieu;
    }

    public int getSoLuong() {
        return soLuong;
    }

    public void setSoLuong(int soLuong) {
        this.soLuong = soLuong;
    }

    public int getTonCu() {
        return tonCu;
    }

    public void setTonCu(int tonCu) {
        this.tonCu = tonCu;
    }

    public int getTonMoi() {
        return tonMoi;
    }

    public void setTonMoi(int tonMoi) {
        this.tonMoi = tonMoi;
    }

    public String getNguoiTao() {
        return nguoiTao;
    }

    public void setNguoiTao(String nguoiTao) {
        this.nguoiTao = nguoiTao;
    }

    public Date getNgayTao() {
        return ngayTao;
    }

    public void setNgayTao(Date ngayTao) {
        this.ngayTao = ngayTao;
    }

    public String getGhiChu() {
        return ghiChu;
    }

    public void setGhiChu(String ghiChu) {
        this.ghiChu = ghiChu;
    }
}
