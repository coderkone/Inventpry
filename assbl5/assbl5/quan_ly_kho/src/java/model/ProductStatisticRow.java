package model;

public class ProductStatisticRow {
    private long maSanPham;
    private String maHang;
    private String tenSanPham;
    private String tenLoaiHang;
    private String donViTinh;
    private int soLuongTon;
    private double giaNhap;
    private double giaXuat;
    private int tongNhap;
    private int tongXuat;
    private double giaTriNhap;
    private double giaTriXuat;

    public long getMaSanPham() {
        return maSanPham;
    }

    public void setMaSanPham(long maSanPham) {
        this.maSanPham = maSanPham;
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

    public String getTenLoaiHang() {
        return tenLoaiHang;
    }

    public void setTenLoaiHang(String tenLoaiHang) {
        this.tenLoaiHang = tenLoaiHang;
    }

    public String getDonViTinh() {
        return donViTinh;
    }

    public void setDonViTinh(String donViTinh) {
        this.donViTinh = donViTinh;
    }

    public int getSoLuongTon() {
        return soLuongTon;
    }

    public void setSoLuongTon(int soLuongTon) {
        this.soLuongTon = soLuongTon;
    }

    public double getGiaNhap() {
        return giaNhap;
    }

    public void setGiaNhap(double giaNhap) {
        this.giaNhap = giaNhap;
    }

    public double getGiaXuat() {
        return giaXuat;
    }

    public void setGiaXuat(double giaXuat) {
        this.giaXuat = giaXuat;
    }

    public int getTongNhap() {
        return tongNhap;
    }

    public void setTongNhap(int tongNhap) {
        this.tongNhap = tongNhap;
    }

    public int getTongXuat() {
        return tongXuat;
    }

    public void setTongXuat(int tongXuat) {
        this.tongXuat = tongXuat;
    }

    public double getGiaTriNhap() {
        return giaTriNhap;
    }

    public void setGiaTriNhap(double giaTriNhap) {
        this.giaTriNhap = giaTriNhap;
    }

    public double getGiaTriXuat() {
        return giaTriXuat;
    }

    public void setGiaTriXuat(double giaTriXuat) {
        this.giaTriXuat = giaTriXuat;
    }

    public double getGiaTriTon() {
        return soLuongTon * giaNhap;
    }

    public String getTrangThaiTon() {
        if (soLuongTon <= 0) {
            return "Hết hàng";
        }
        if (soLuongTon <= 10) {
            return "Sắp hết";
        }
        return "Còn hàng";
    }
}
