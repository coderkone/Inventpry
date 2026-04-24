<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Lịch sử kho</title>
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
                        <h3 class="fw-bold mb-1">Lịch sử kho</h3>
                        <p class="text-muted mb-0">Theo dõi toàn bộ nghiệp vụ nhập, xuất.</p>
                    </div>
                    <form action="history" method="get" class="d-flex gap-2">
                        <select class="form-select" name="type">
                            <option value="">Tất cả</option>
                            <option value="NHAP" ${param.type == 'NHAP' ? 'selected' : ''}>NHẬP</option>
                            <option value="XUAT" ${param.type == 'XUAT' ? 'selected' : ''}>XUẤT</option>
                        </select>
                        <button class="btn btn-primary">Lọc</button>
                    </form>
                </div>
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead>
                            <tr>
                                <th>Thời gian</th>
                                <th>Mã hàng</th>
                                <th>Sản phẩm</th>
                                <th>Biến động</th>
                                <th>Tham chiếu</th>
                                <th>Số lượng</th>
                                <th>Tồn cũ</th>
                                <th>Tồn mới</th>
                                <th>Người tạo</th>
                                <th>Ghi chú</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="h" items="${historyList}">
                                <tr>
                                    <td><fmt:formatDate value="${h.ngayTao}" pattern="dd/MM/yyyy HH:mm"/></td>
                                    <td>${h.maHang}</td>
                                    <td>${h.tenSanPham}</td>
                                    <td><span class="badge ${h.loaiBienDong == 'NHAP' ? 'bg-success' : 'bg-danger'}">${h.loaiBienDong}</span></td>
                                    <td>${h.loaiThamChieu} #${h.maThamChieu}</td>
                                    <td>${h.soLuong}</td>
                                    <td>${h.tonCu}</td>
                                    <td>${h.tonMoi}</td>
                                    <td>${h.nguoiTao}</td>
                                    <td>${h.ghiChu}</td>
                                   
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
