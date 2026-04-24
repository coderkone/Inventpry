<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chi tiết phiếu nhập</title>
</head>
<body>
<h2>Chi tiết phiếu nhập</h2>

<c:set var="r" value="${requestScope.receipt}"/>
<div>
    <div>Mã phiếu: <b>${r.maPhieu}</b> (ID: ${r.maPhieuNhap})</div>
    <div>Nhà cung cấp: ${r.nhaCungCap}</div>
    <div>Người tạo: ${r.nguoiTao}</div>
    <div>Ngày nhập: <fmt:formatDate value="${r.ngayNhap}" pattern="dd/MM/yyyy HH:mm"/></div>
    <div>Tổng tiền: ${r.tongTien}</div>
    <div>Ghi chú: ${r.ghiChu}</div>
</div>

<hr/>

<table border="1" cellpadding="6" cellspacing="0">
    <thead>
    <tr>
        <th>Mã hàng</th>
        <th>Sản phẩm</th>
        <th>Số lượng</th>
        <th>Đơn giá</th>
        <th>Thành tiền</th>
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

