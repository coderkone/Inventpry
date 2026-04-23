<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh sách sản phẩm</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>body{background:#f5f7fb}.card-main{border:0;border-radius:18px;box-shadow:0 8px 24px rgba(15,23,42,.06)}</style>
</head>
<body>
    <%@ include file="includes/navbar.jspf" %>
    <div class="container py-4">
        <div class="card card-main">
            <div class="card-body p-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h3 class="fw-bold mb-1">Danh sách sản phẩm</h3>
                        <p class="text-muted mb-0">User chỉ được xem. Admin được thêm, sửa, xóa.</p>
                    </div>
                    <c:if test="${sessionScope.user.vaiTro == 'ADMIN'}">
                        <a href="products?action=add" class="btn btn-primary">+ Thêm sản phẩm</a>
                    </c:if>
                </div>

                <c:if test="${param.msg == 'permissionDenied'}"><div class="alert alert-danger">Bạn không có quyền thực hiện chức năng này.</div></c:if>
                <c:if test="${param.msg == 'created'}"><div class="alert alert-success">Thêm sản phẩm thành công.</div></c:if>
                <c:if test="${param.msg == 'updated'}"><div class="alert alert-success">Cập nhật sản phẩm thành công.</div></c:if>
                <c:if test="${param.msg == 'deleted'}"><div class="alert alert-success">Đã xóa mềm sản phẩm khỏi danh sách hoạt động.</div></c:if>

                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead>
                            <tr>
                                <th>Mã hàng</th>
                                <th>Tên sản phẩm</th>
                                <th>Loại</th>
                                <th>ĐVT</th>
                                <th>Tồn kho</th>
                                <th>Giá nhập</th>
                                <th>Giá xuất</th>
                                <th>Mô tả</th>
                                <c:if test="${sessionScope.user.vaiTro == 'ADMIN'}"><th>Thao tác</th></c:if>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="p" items="${products}">
                                <tr>
                                    <td><span class="badge bg-primary-subtle text-primary">${p.maHang}</span></td>
                                    <td class="fw-semibold">${p.tenSanPham}</td>
                                    <td>${p.tenLoaiHang}</td>
                                    <td>${p.donViTinh}</td>
                                    <td>${p.soLuongTon}</td>
                                    <td><fmt:formatNumber value="${p.giaNhap}" type="number" groupingUsed="true"/></td>
                                    <td><fmt:formatNumber value="${p.giaXuat}" type="number" groupingUsed="true"/></td>
                                    <td>${p.moTa}</td>
                                    <c:if test="${sessionScope.user.vaiTro == 'ADMIN'}">
                                        <td>
                                            <a class="btn btn-sm btn-outline-primary" href="products?action=edit&id=${p.maSanPham}">Sửa</a>
                                            <a class="btn btn-sm btn-outline-danger" href="products?action=delete&id=${p.maSanPham}" onclick="return confirm('Xóa sản phẩm này?')">Xóa</a>
                                        </td>
                                    </c:if>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
