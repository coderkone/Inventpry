<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chi tiết phiếu xuất</title>
</head>
<body>
<h2>Chi tiết phiếu xuất</h2>

<c:set var="r" value="${requestScope.receipt}"/>
<div>
    <div>Mã phiếu: ${r.maPhieu} (ID: ${r.maPhieuXuat})</div>
    <div>Khách hàng: ${r.tenKhachHang}</div>
    <div>Người tạo: ${r.nguoiTao}</div>
    <div>Ngày xuất: <fmt:formatDate value="${r.ngayXuat}" pattern="dd/MM/yyyy HH:mm"/></div>
    <div>Tổng tiền: ${r.tongTien}</div>
    <div>Ghi chú: ${r.ghiChu}</div>
</div>


<table border="1">
    <thead>
    <tr>
        <td>Mã hàng</td>
        <td>Sản phẩm</td>
        <td>Số lượng</td>
        <td>Đơn giá</td>
        <td>Thành tiền</td>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="line" items="${lines}">
        <tr>
            <td>${line.maHang}</td>
            <td>${line.tenSanPham}</td>
            <td>${line.soLuong}</td>
            <td>${line.donGia}</td>
            <td>${line.thanhTien}</td>
        </tr>
    </c:forEach>
    </tbody>
</table>

<p><a href="history">Quay lại lịch sử</a></p>
</body>
</html>

