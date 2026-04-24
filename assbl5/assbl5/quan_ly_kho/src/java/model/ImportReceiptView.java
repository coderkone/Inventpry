package model;

import java.util.Date;

public class ImportReceiptView {
    private long maPhieuNhap;
    private String maPhieu;
    private String nhaCungCap;
    private String nguoiTao;
    private Date ngayNhap;
    private double tongTien;
    private String ghiChu;

    public long getMaPhieuNhap() {
        return maPhieuNhap;
    }

    public void setMaPhieuNhap(long maPhieuNhap) {
        this.maPhieuNhap = maPhieuNhap;
    }

    public String getMaPhieu() {
        return maPhieu;
    }

    public void setMaPhieu(String maPhieu) {
        this.maPhieu = maPhieu;
    }

    public String getNhaCungCap() {
        return nhaCungCap;
    }

    public void setNhaCungCap(String nhaCungCap) {
        this.nhaCungCap = nhaCungCap;
    }

    public String getNguoiTao() {
        return nguoiTao;
    }

    public void setNguoiTao(String nguoiTao) {
        this.nguoiTao = nguoiTao;
    }

    public Date getNgayNhap() {
        return ngayNhap;
    }

    public void setNgayNhap(Date ngayNhap) {
        this.ngayNhap = ngayNhap;
    }

    public double getTongTien() {
        return tongTien;
    }

    public void setTongTien(double tongTien) {
        this.tongTien = tongTien;
    }

    public String getGhiChu() {
        return ghiChu;
    }

    public void setGhiChu(String ghiChu) {
        this.ghiChu = ghiChu;
    }
}
