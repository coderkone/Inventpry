CREATE DATABASE KhoHangDB
GO
USE KhoHangDB
GO

CREATE TABLE nguoi_dung (
    ma_nguoi_dung BIGINT PRIMARY KEY,
    ten_dang_nhap VARCHAR(50) NOT NULL UNIQUE,
    mat_khau VARCHAR(255) NOT NULL,
    ho_ten NVARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    so_dien_thoai VARCHAR(20),
    vai_tro VARCHAR(20) NOT NULL DEFAULT 'USER' CHECK (vai_tro IN ('ADMIN', 'USER')),
    trang_thai TINYINT NOT NULL DEFAULT 1
)

CREATE TABLE loai_hang (
    ma_loai_hang INT PRIMARY KEY,
    ten_loai_hang NVARCHAR(100) NOT NULL UNIQUE,
    mo_ta NVARCHAR(255)
)

CREATE TABLE nha_cung_cap (
    ma_nha_cung_cap BIGINT PRIMARY KEY,
    ten_nha_cung_cap NVARCHAR(150) NOT NULL,
    nguoi_lien_he NVARCHAR(100),
    so_dien_thoai VARCHAR(20),
    email VARCHAR(100),
    dia_chi NVARCHAR(255),
    trang_thai TINYINT NOT NULL DEFAULT 1
)

CREATE TABLE san_pham (
    ma_san_pham BIGINT PRIMARY KEY,
    ma_hang VARCHAR(50) NOT NULL UNIQUE,
    ten_san_pham NVARCHAR(150) NOT NULL,
    ma_loai_hang INT NOT NULL,
    don_vi_tinh NVARCHAR(30) NOT NULL,
    so_luong_ton INT NOT NULL DEFAULT 0,
    gia_nhap DECIMAL(15,2) NOT NULL DEFAULT 0,
    gia_xuat DECIMAL(15,2) NOT NULL DEFAULT 0,
    mo_ta NVARCHAR(255),
    hinh_anh VARCHAR(255),
    trang_thai TINYINT NOT NULL DEFAULT 1,
    ngay_tao DATETIME DEFAULT GETDATE(),
    ngay_cap_nhat DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ma_loai_hang) REFERENCES loai_hang(ma_loai_hang)
)

CREATE TABLE phieu_nhap (
    ma_phieu_nhap BIGINT PRIMARY KEY,
    ma_phieu VARCHAR(30) NOT NULL UNIQUE,
    ma_nha_cung_cap BIGINT NOT NULL,
    ma_nguoi_tao BIGINT NOT NULL,
    ngay_nhap DATETIME NOT NULL DEFAULT GETDATE(),
    tong_tien DECIMAL(15,2) NOT NULL DEFAULT 0,
    ghi_chu NVARCHAR(255),
    trang_thai VARCHAR(20) NOT NULL DEFAULT 'HOAN_THANH',
     CHECK (trang_thai IN ('CHO_DUYET', 'HOAN_THANH', 'HUY')),
    FOREIGN KEY (ma_nha_cung_cap) REFERENCES nha_cung_cap(ma_nha_cung_cap),
    FOREIGN KEY (ma_nguoi_tao) REFERENCES nguoi_dung(ma_nguoi_dung)
)

CREATE TABLE chi_tiet_phieu_nhap (
    ma_chi_tiet_phieu_nhap BIGINT PRIMARY KEY,
    ma_phieu_nhap BIGINT NOT NULL,
    ma_san_pham BIGINT NOT NULL,
    so_luong INT NOT NULL,
    don_gia DECIMAL(15,2) NOT NULL,
    thanh_tien DECIMAL(15,2) NOT NULL,
     FOREIGN KEY (ma_phieu_nhap) REFERENCES phieu_nhap(ma_phieu_nhap) ON DELETE CASCADE,
     FOREIGN KEY (ma_san_pham) REFERENCES san_pham(ma_san_pham),
    UNIQUE (ma_phieu_nhap, ma_san_pham)
)

CREATE TABLE phieu_xuat (
    ma_phieu_xuat BIGINT PRIMARY KEY,
    ma_phieu VARCHAR(30) NOT NULL UNIQUE,
    ma_nguoi_tao BIGINT NOT NULL,
    ngay_xuat DATETIME NOT NULL DEFAULT GETDATE(),
    ten_khach_hang NVARCHAR(150),
    tong_tien DECIMAL(15,2) NOT NULL DEFAULT 0,
    ghi_chu NVARCHAR(255),
    trang_thai VARCHAR(20) NOT NULL DEFAULT 'HOAN_THANH',
     CHECK (trang_thai IN ('CHO_DUYET', 'HOAN_THANH', 'HUY')),
    FOREIGN KEY (ma_nguoi_tao) REFERENCES nguoi_dung(ma_nguoi_dung)
)

CREATE TABLE chi_tiet_phieu_xuat (
    ma_chi_tiet_phieu_xuat BIGINT PRIMARY KEY,
    ma_phieu_xuat BIGINT NOT NULL,
    ma_san_pham BIGINT NOT NULL,
    so_luong INT NOT NULL,
    don_gia DECIMAL(15,2) NOT NULL,
    thanh_tien DECIMAL(15,2) NOT NULL,
    FOREIGN KEY (ma_phieu_xuat) REFERENCES phieu_xuat(ma_phieu_xuat) ON DELETE CASCADE,
    FOREIGN KEY (ma_san_pham) REFERENCES san_pham(ma_san_pham),
    UNIQUE (ma_phieu_xuat, ma_san_pham)
)

CREATE TABLE lich_su_kho (
    ma_lich_su BIGINT PRIMARY KEY,
    ma_san_pham BIGINT NOT NULL,
    loai_bien_dong VARCHAR(20) NOT NULL,
    loai_tham_chieu VARCHAR(30),
    ma_tham_chieu BIGINT,
    so_luong INT NOT NULL,
    ton_cu INT NOT NULL,
    ton_moi INT NOT NULL,
    ma_nguoi_tao BIGINT,
    ngay_tao DATETIME DEFAULT GETDATE(),
    ghi_chu NVARCHAR(255),
    CHECK (loai_bien_dong IN ('NHAP', 'XUAT', 'DIEU_CHINH')),
     FOREIGN KEY (ma_san_pham) REFERENCES san_pham(ma_san_pham),
     FOREIGN KEY (ma_nguoi_tao) REFERENCES nguoi_dung(ma_nguoi_dung)
)

INSERT INTO nguoi_dung
(ma_nguoi_dung, ten_dang_nhap, mat_khau, ho_ten, email, so_dien_thoai, vai_tro, trang_thai)
VALUES
(1, 'admin', '123456', N'Quản trị hệ thống', 'admin@gmail.com', '0900000001', 'ADMIN', 1),
(2, 'user01', '123456', N'Đoàn Phương Duy', 'user01@gmail.com', '0900000002', 'USER', 1);

INSERT INTO loai_hang
(ma_loai_hang, ten_loai_hang, mo_ta)
VALUES
(1, N'Điện tử', N'Thiết bị điện tử và phụ kiện'),
(2, N'Gia dụng', N'Đồ dùng gia đình'),
(3, N'Văn phòng phẩm', N'Dụng cụ học tập và văn phòng'),
(4, N'Thực phẩm', N'Hàng tiêu dùng thực phẩm'),
(5, N'Đồ uống', N'Nước giải khát và đồ uống'),
(6, N'Mỹ phẩm', N'Sản phẩm chăm sóc cá nhân');

INSERT INTO nha_cung_cap
(ma_nha_cung_cap, ten_nha_cung_cap, nguoi_lien_he, so_dien_thoai, email, dia_chi, trang_thai)
VALUES
(1, N'Công ty TNHH Minh Phát', N'Trần Văn Minh', '0911000001', 'minhphat@gmail.com', N'Hà Nội', 1),
(2, N'Công ty Hoàng Gia', N'Nguyễn Thị Hoa', '0911000002', 'hoanggia@gmail.com', N'Hải Phòng', 1),
(3, N'Công ty An Khang', N'Lê Quốc Bảo', '0911000003', 'ankhang@gmail.com', N'Đà Nẵng', 1),
(4, N'Công ty Thành Công', N'Phạm Văn Dũng', '0911000004', 'thanhcong@gmail.com', N'TP. Hồ Chí Minh', 1),
(5, N'Công ty Phú Quý', N'Võ Thị Mai', '0911000005', 'phuquy@gmail.com', N'Cần Thơ', 1),
(6, N'Công ty Đại Nam', N'Bùi Thanh Tùng', '0911000006', 'dainam@gmail.com', N'Bình Dương', 1),
(7, N'Công ty Hưng Thịnh', N'Đỗ Minh Tâm', '0911000007', 'hungthinh@gmail.com', N'Đồng Nai', 1),
(8, N'Công ty Thiên Long', N'Ngô Thị Hạnh', '0911000008', 'thienlong@gmail.com', N'Nghệ An', 1),
(9, N'Công ty Việt Nhật', N'Phan Quốc Khánh', '0911000009', 'vietnhat@gmail.com', N'Quảng Ninh', 1),
(10, N'Công ty Sao Mai', N'Hồ Thị Yến', '0911000010', 'saomai@gmail.com', N'Huế', 1);

INSERT INTO san_pham
(ma_san_pham, ma_hang, ten_san_pham, ma_loai_hang, don_vi_tinh, so_luong_ton, gia_nhap, gia_xuat, mo_ta, hinh_anh, trang_thai, ngay_tao, ngay_cap_nhat)
VALUES
(1, 'SP001', N'Chuột không dây Logitech M185', 1, N'Cái', 50, 180000, 250000, N'Chuột không dây dành cho văn phòng', NULL, 1, GETDATE(), GETDATE()),
(2, 'SP002', N'Bàn phím Logitech K120', 1, N'Cái', 40, 150000, 220000, N'Bàn phím có dây chuẩn USB', NULL, 1, GETDATE(), GETDATE()),
(3, 'SP003', N'Tai nghe chụp tai Sony ZX110', 1, N'Cái', 35, 320000, 450000, N'Tai nghe âm thanh rõ', NULL, 1, GETDATE(), GETDATE()),
(4, 'SP004', N'Sạc dự phòng Xiaomi 10000mAh', 1, N'Cái', 25, 280000, 390000, N'Sạc dự phòng dung lượng 10000mAh', NULL, 1, GETDATE(), GETDATE()),
(5, 'SP005', N'Ấm siêu tốc Sunhouse 1.8L', 2, N'Cái', 20, 260000, 350000, N'Ấm đun nước siêu tốc', NULL, 1, GETDATE(), GETDATE()),
(6, 'SP006', N'Nồi cơm điện Sharp 1.8L', 2, N'Cái', 18, 650000, 820000, N'Nồi cơm điện gia đình', NULL, 1, GETDATE(), GETDATE()),
(7, 'SP007', N'Chảo chống dính Lock&Lock 26cm', 2, N'Cái', 22, 210000, 300000, N'Chảo chống dính dùng bếp gas', NULL, 1, GETDATE(), GETDATE()),
(8, 'SP008', N'Hộp cơm giữ nhiệt Inox', 2, N'Cái', 30, 120000, 180000, N'Hộp cơm văn phòng', NULL, 1, GETDATE(), GETDATE()),
(9, 'SP009', N'Bút bi Thiên Long TL027', 3, N'Hộp', 100, 45000, 65000, N'Hộp 20 cây bút bi', NULL, 1, GETDATE(), GETDATE()),
(10, 'SP010', N'Tập học sinh 200 trang', 3, N'Quyển', 120, 12000, 18000, N'Tập giấy kẻ ngang', NULL, 1, GETDATE(), GETDATE()),
(11, 'SP011', N'Giấy in A4 Double A 70gsm', 3, N'Ream', 60, 62000, 78000, N'Giấy in văn phòng khổ A4', NULL, 1, GETDATE(), GETDATE()),
(12, 'SP012', N'Kẹp giấy màu 32mm', 3, N'Hộp', 80, 15000, 25000, N'Hộp kẹp giấy văn phòng', NULL, 1, GETDATE(), GETDATE()),
(13, 'SP013', N'Mì tôm Hảo Hảo tôm chua cay', 4, N'Thùng', 45, 95000, 125000, N'Thùng 30 gói mì', NULL, 1, GETDATE(), GETDATE()),
(14, 'SP014', N'Bánh quy Cosy Marie', 4, N'Hộp', 55, 28000, 38000, N'Bánh quy đóng hộp', NULL, 1, GETDATE(), GETDATE()),
(15, 'SP015', N'Sữa đặc Ông Thọ', 4, N'Lon', 70, 22000, 30000, N'Sữa đặc có đường', NULL, 1, GETDATE(), GETDATE()),
(16, 'SP016', N'Gạo ST25', 4, N'Bao', 25, 240000, 295000, N'Bao gạo 10kg', NULL, 1, GETDATE(), GETDATE()),
(17, 'SP017', N'Nước suối Lavie 500ml', 5, N'Thùng', 90, 70000, 95000, N'Thùng 24 chai nước suối', NULL, 1, GETDATE(), GETDATE()),
(18, 'SP018', N'Coca Cola lon 330ml', 5, N'Thùng', 65, 155000, 190000, N'Thùng 24 lon Coca Cola', NULL, 1, GETDATE(), GETDATE()),
(19, 'SP019', N'Sữa tắm Dove 900g', 6, N'Chai', 28, 135000, 175000, N'Sữa tắm dưỡng ẩm', NULL, 1, GETDATE(), GETDATE()),
(20, 'SP020', N'Dầu gội Head & Shoulders 850ml', 6, N'Chai', 26, 145000, 189000, N'Dầu gội sạch gàu', NULL, 1, GETDATE(), GETDATE());

INSERT INTO phieu_nhap
(ma_phieu_nhap, ma_phieu, ma_nha_cung_cap, ma_nguoi_tao, ngay_nhap, tong_tien, ghi_chu, trang_thai)
VALUES
(1001, 'PN001', 1, 1, '2026-04-01 08:00:00', 20850000, N'Nhập hàng đợt 1', 'HOAN_THANH'),
(1002, 'PN002', 2, 2, '2026-04-02 08:30:00', 27200000, N'Nhập hàng đợt 2', 'HOAN_THANH'),
(1003, 'PN003', 3, 1, '2026-04-03 09:00:00', 28600000, N'Nhập hàng đợt 3', 'HOAN_THANH'),
(1004, 'PN004', 4, 2, '2026-04-04 09:15:00', 13800000, N'Nhập hàng đợt 4', 'HOAN_THANH'),
(1005, 'PN005', 5, 1, '2026-04-05 10:00:00', 7200000, N'Nhập hàng đợt 5', 'HOAN_THANH'),
(1006, 'PN006', 6, 2, '2026-04-06 10:20:00', 6460000, N'Nhập hàng đợt 6', 'HOAN_THANH'),
(1007, 'PN007', 7, 1, '2026-04-07 10:45:00', 7660000, N'Nhập hàng đợt 7', 'HOAN_THANH'),
(1008, 'PN008', 8, 2, '2026-04-08 11:00:00', 11580000, N'Nhập hàng đợt 8', 'HOAN_THANH'),
(1009, 'PN009', 9, 1, '2026-04-09 13:00:00', 21575000, N'Nhập hàng đợt 9', 'HOAN_THANH'),
(1010, 'PN010', 10, 2, '2026-04-10 14:00:00', 10910000, N'Nhập hàng đợt 10', 'HOAN_THANH');

INSERT INTO chi_tiet_phieu_nhap
(ma_chi_tiet_phieu_nhap, ma_phieu_nhap, ma_san_pham, so_luong, don_gia, thanh_tien)
VALUES
(5001, 1001, 1, 70, 180000, 12600000),
(5002, 1001, 2, 55, 150000, 8250000),

(5003, 1002, 3, 50, 320000, 16000000),
(5004, 1002, 4, 40, 280000, 11200000),

(5005, 1003, 5, 35, 260000, 9100000),
(5006, 1003, 6, 30, 650000, 19500000),

(5007, 1004, 7, 40, 210000, 8400000),
(5008, 1004, 8, 45, 120000, 5400000),

(5009, 1005, 9, 120, 45000, 5400000),
(5010, 1005, 10, 150, 12000, 1800000),

(5011, 1006, 11, 80, 62000, 4960000),
(5012, 1006, 12, 100, 15000, 1500000),

(5013, 1007, 13, 60, 95000, 5700000),
(5014, 1007, 14, 70, 28000, 1960000),

(5015, 1008, 15, 90, 22000, 1980000),
(5016, 1008, 16, 40, 240000, 9600000),

(5017, 1009, 17, 120, 70000, 8400000),
(5018, 1009, 18, 85, 155000, 13175000),

(5019, 1010, 19, 40, 135000, 5400000),
(5020, 1010, 20, 38, 145000, 5510000);

INSERT INTO phieu_xuat
(ma_phieu_xuat, ma_phieu, ma_nguoi_tao, ngay_xuat, ten_khach_hang, tong_tien, ghi_chu, trang_thai)
VALUES
(2001, 'PX001', 2, '2026-04-11 09:00:00', N'Cửa hàng An Phúc', 8300000, N'Xuất bán đợt 1', 'HOAN_THANH'),
(2002, 'PX002', 1, '2026-04-11 14:00:00', N'Cửa hàng Minh Tâm', 12600000, N'Xuất bán đợt 2', 'HOAN_THANH'),
(2003, 'PX003', 2, '2026-04-12 09:30:00', N'Siêu thị Hoàng Long', 15090000, N'Xuất bán đợt 3', 'HOAN_THANH'),
(2004, 'PX004', 1, '2026-04-12 15:00:00', N'Cửa hàng Việt Hưng', 8100000, N'Xuất bán đợt 4', 'HOAN_THANH'),
(2005, 'PX005', 2, '2026-04-13 08:30:00', N'Nhà sách Phương Nam', 1840000, N'Xuất bán đợt 5', 'HOAN_THANH'),
(2006, 'PX006', 1, '2026-04-13 13:30:00', N'Văn phòng ABC', 2060000, N'Xuất bán đợt 6', 'HOAN_THANH'),
(2007, 'PX007', 2, '2026-04-14 09:15:00', N'Tạp hóa Mai Lan', 2445000, N'Xuất bán đợt 7', 'HOAN_THANH'),
(2008, 'PX008', 1, '2026-04-14 15:20:00', N'Đại lý Lộc Phát', 5025000, N'Xuất bán đợt 8', 'HOAN_THANH'),
(2009, 'PX009', 2, '2026-04-15 10:00:00', N'Siêu thị Phú Cường', 6650000, N'Xuất bán đợt 9', 'HOAN_THANH'),
(2010, 'PX010', 1, '2026-04-15 16:10:00', N'Cửa hàng Hồng Phúc', 4368000, N'Xuất bán đợt 10', 'HOAN_THANH');

INSERT INTO chi_tiet_phieu_xuat
(ma_chi_tiet_phieu_xuat, ma_phieu_xuat, ma_san_pham, so_luong, don_gia, thanh_tien)
VALUES
(6001, 2001, 1, 20, 250000, 5000000),
(6002, 2001, 2, 15, 220000, 3300000),

(6003, 2002, 3, 15, 450000, 6750000),
(6004, 2002, 4, 15, 390000, 5850000),

(6005, 2003, 5, 15, 350000, 5250000),
(6006, 2003, 6, 12, 820000, 9840000),

(6007, 2004, 7, 18, 300000, 5400000),
(6008, 2004, 8, 15, 180000, 2700000),

(6009, 2005, 9, 20, 65000, 1300000),
(6010, 2005, 10, 30, 18000, 540000),

(6011, 2006, 11, 20, 78000, 1560000),
(6012, 2006, 12, 20, 25000, 500000),

(6013, 2007, 13, 15, 125000, 1875000),
(6014, 2007, 14, 15, 38000, 570000),

(6015, 2008, 15, 20, 30000, 600000),
(6016, 2008, 16, 15, 295000, 4425000),

(6017, 2009, 17, 30, 95000, 2850000),
(6018, 2009, 18, 20, 190000, 3800000),

(6019, 2010, 19, 12, 175000, 2100000),
(6020, 2010, 20, 12, 189000, 2268000);

INSERT INTO lich_su_kho
(ma_lich_su, ma_san_pham, loai_bien_dong, loai_tham_chieu, ma_tham_chieu, so_luong, ton_cu, ton_moi, ma_nguoi_tao, ngay_tao, ghi_chu)
VALUES
(7001, 1, 'NHAP', 'PHIEU_NHAP', 1001, 70, 0, 70, 1, '2026-04-01 08:10:00', N'Nhập kho sản phẩm SP001'),
(7002, 2, 'NHAP', 'PHIEU_NHAP', 1001, 55, 0, 55, 1, '2026-04-01 08:12:00', N'Nhập kho sản phẩm SP002'),

(7003, 3, 'NHAP', 'PHIEU_NHAP', 1002, 50, 0, 50, 2, '2026-04-02 08:40:00', N'Nhập kho sản phẩm SP003'),
(7004, 4, 'NHAP', 'PHIEU_NHAP', 1002, 40, 0, 40, 2, '2026-04-02 08:42:00', N'Nhập kho sản phẩm SP004'),

(7005, 5, 'NHAP', 'PHIEU_NHAP', 1003, 35, 0, 35, 1, '2026-04-03 09:10:00', N'Nhập kho sản phẩm SP005'),
(7006, 6, 'NHAP', 'PHIEU_NHAP', 1003, 30, 0, 30, 1, '2026-04-03 09:12:00', N'Nhập kho sản phẩm SP006'),

(7007, 7, 'NHAP', 'PHIEU_NHAP', 1004, 40, 0, 40, 2, '2026-04-04 09:25:00', N'Nhập kho sản phẩm SP007'),
(7008, 8, 'NHAP', 'PHIEU_NHAP', 1004, 45, 0, 45, 2, '2026-04-04 09:27:00', N'Nhập kho sản phẩm SP008'),

(7009, 9, 'NHAP', 'PHIEU_NHAP', 1005, 120, 0, 120, 1, '2026-04-05 10:10:00', N'Nhập kho sản phẩm SP009'),
(7010, 10, 'NHAP', 'PHIEU_NHAP', 1005, 150, 0, 150, 1, '2026-04-05 10:12:00', N'Nhập kho sản phẩm SP010'),

(7011, 11, 'NHAP', 'PHIEU_NHAP', 1006, 80, 0, 80, 2, '2026-04-06 10:30:00', N'Nhập kho sản phẩm SP011'),
(7012, 12, 'NHAP', 'PHIEU_NHAP', 1006, 100, 0, 100, 2, '2026-04-06 10:32:00', N'Nhập kho sản phẩm SP012'),

(7013, 13, 'NHAP', 'PHIEU_NHAP', 1007, 60, 0, 60, 1, '2026-04-07 10:55:00', N'Nhập kho sản phẩm SP013'),
(7014, 14, 'NHAP', 'PHIEU_NHAP', 1007, 70, 0, 70, 1, '2026-04-07 10:57:00', N'Nhập kho sản phẩm SP014'),

(7015, 15, 'NHAP', 'PHIEU_NHAP', 1008, 90, 0, 90, 2, '2026-04-08 11:10:00', N'Nhập kho sản phẩm SP015'),
(7016, 16, 'NHAP', 'PHIEU_NHAP', 1008, 40, 0, 40, 2, '2026-04-08 11:12:00', N'Nhập kho sản phẩm SP016'),

(7017, 17, 'NHAP', 'PHIEU_NHAP', 1009, 120, 0, 120, 1, '2026-04-09 13:10:00', N'Nhập kho sản phẩm SP017'),
(7018, 18, 'NHAP', 'PHIEU_NHAP', 1009, 85, 0, 85, 1, '2026-04-09 13:12:00', N'Nhập kho sản phẩm SP018'),

(7019, 19, 'NHAP', 'PHIEU_NHAP', 1010, 40, 0, 40, 2, '2026-04-10 14:10:00', N'Nhập kho sản phẩm SP019'),
(7020, 20, 'NHAP', 'PHIEU_NHAP', 1010, 38, 0, 38, 2, '2026-04-10 14:12:00', N'Nhập kho sản phẩm SP020'),

(7021, 1, 'XUAT', 'PHIEU_XUAT', 2001, 20, 70, 50, 2, '2026-04-11 09:10:00', N'Xuất kho sản phẩm SP001'),
(7022, 2, 'XUAT', 'PHIEU_XUAT', 2001, 15, 55, 40, 2, '2026-04-11 09:12:00', N'Xuất kho sản phẩm SP002'),

(7023, 3, 'XUAT', 'PHIEU_XUAT', 2002, 15, 50, 35, 1, '2026-04-11 14:10:00', N'Xuất kho sản phẩm SP003'),
(7024, 4, 'XUAT', 'PHIEU_XUAT', 2002, 15, 40, 25, 1, '2026-04-11 14:12:00', N'Xuất kho sản phẩm SP004'),

(7025, 5, 'XUAT', 'PHIEU_XUAT', 2003, 15, 35, 20, 2, '2026-04-12 09:40:00', N'Xuất kho sản phẩm SP005'),
(7026, 6, 'XUAT', 'PHIEU_XUAT', 2003, 12, 30, 18, 2, '2026-04-12 09:42:00', N'Xuất kho sản phẩm SP006'),

(7027, 7, 'XUAT', 'PHIEU_XUAT', 2004, 18, 40, 22, 1, '2026-04-12 15:10:00', N'Xuất kho sản phẩm SP007'),
(7028, 8, 'XUAT', 'PHIEU_XUAT', 2004, 15, 45, 30, 1, '2026-04-12 15:12:00', N'Xuất kho sản phẩm SP008'),

(7029, 9, 'XUAT', 'PHIEU_XUAT', 2005, 20, 120, 100, 2, '2026-04-13 08:40:00', N'Xuất kho sản phẩm SP009'),
(7030, 10, 'XUAT', 'PHIEU_XUAT', 2005, 30, 150, 120, 2, '2026-04-13 08:42:00', N'Xuất kho sản phẩm SP010'),

(7031, 11, 'XUAT', 'PHIEU_XUAT', 2006, 20, 80, 60, 1, '2026-04-13 13:40:00', N'Xuất kho sản phẩm SP011'),
(7032, 12, 'XUAT', 'PHIEU_XUAT', 2006, 20, 100, 80, 1, '2026-04-13 13:42:00', N'Xuất kho sản phẩm SP012'),

(7033, 13, 'XUAT', 'PHIEU_XUAT', 2007, 15, 60, 45, 2, '2026-04-14 09:25:00', N'Xuất kho sản phẩm SP013'),
(7034, 14, 'XUAT', 'PHIEU_XUAT', 2007, 15, 70, 55, 2, '2026-04-14 09:27:00', N'Xuất kho sản phẩm SP014'),

(7035, 15, 'XUAT', 'PHIEU_XUAT', 2008, 20, 90, 70, 1, '2026-04-14 15:30:00', N'Xuất kho sản phẩm SP015'),
(7036, 16, 'XUAT', 'PHIEU_XUAT', 2008, 15, 40, 25, 1, '2026-04-14 15:32:00', N'Xuất kho sản phẩm SP016'),

(7037, 17, 'XUAT', 'PHIEU_XUAT', 2009, 30, 120, 90, 2, '2026-04-15 10:10:00', N'Xuất kho sản phẩm SP017'),
(7038, 18, 'XUAT', 'PHIEU_XUAT', 2009, 20, 85, 65, 2, '2026-04-15 10:12:00', N'Xuất kho sản phẩm SP018'),

(7039, 19, 'XUAT', 'PHIEU_XUAT', 2010, 12, 40, 28, 1, '2026-04-15 16:20:00', N'Xuất kho sản phẩm SP019'),
(7040, 20, 'XUAT', 'PHIEU_XUAT', 2010, 12, 38, 26, 1, '2026-04-15 16:22:00', N'Xuất kho sản phẩm SP020');
