<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Dashboard</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body {
                background:#f5f7fb;
            }
            .stat-card {
                border:0;
                border-radius:18px;
                box-shadow:0 8px 24px rgba(15,23,42,.06);
            }
            .quick-link {
                text-decoration:none;
                color:inherit;
            }
        </style>
    </head>
    <body>
        <%@ include file="includes/navbar.jspf" %>
        <div class="container py-4">
            <div class="mb-4">
                <h2 class="fw-bold mb-1">Xin chào, ${sessionScope.user.hoTen}</h2>
                <p class="text-muted mb-0">Menu hiển thị theo quyền ${sessionScope.user.vaiTro}. Admin được thêm, sửa, xóa sản phẩm.</p>
            </div>

            <div class="row g-4 mb-4">
                <div class="col-md-6 col-xl-3">
                    <div class="card stat-card p-3"><div class="card-body"><div class="text-muted">Sản phẩm đang hoạt động</div><h3 class="fw-bold">${stats.totalProducts}</h3></div></div>
                </div>
                <div class="col-md-6 col-xl-3">
                    <div class="card stat-card p-3"><div class="card-body"><div class="text-muted">Tổng tồn kho</div><h3 class="fw-bold">${stats.totalQuantity}</h3></div></div>
                </div>
                <div class="col-md-6 col-xl-3">
                    <div class="card stat-card p-3"><div class="card-body"><div class="text-muted">Phiếu nhập</div><h3 class="fw-bold">${stats.totalImports}</h3></div></div>
                </div>
                <div class="col-md-6 col-xl-3">
                    <div class="card stat-card p-3"><div class="card-body"><div class="text-muted">Phiếu xuất</div><h3 class="fw-bold">${stats.totalExports}</h3></div></div>
                </div>
            </div>

            <div class="row g-4 mb-4">
                <div class="col-md-6 col-xl-3">
                    <a class="quick-link" href="products">
                        <div class="card stat-card h-100 p-3"><div class="card-body"><h5>Danh sách sản phẩm</h5><p class="text-muted mb-0">Xem toàn bộ hàng hóa trong kho.</p></div></div>
                    </a>
                </div>
                <div class="col-md-6 col-xl-3">
                    <a class="quick-link" href="imports">
                        <div class="card stat-card h-100 p-3"><div class="card-body"><h5>Tạo phiếu nhập</h5><p class="text-muted mb-0">Nhập hàng từ nhà cung cấp.</p></div></div>
                    </a>
                </div>
                <div class="col-md-6 col-xl-3">
                    <a class="quick-link" href="exports">
                        <div class="card stat-card h-100 p-3"><div class="card-body"><h5>Tạo phiếu xuất</h5><p class="text-muted mb-0">Xuất hàng và tự trừ tồn kho.</p></div></div>
                    </a>
                </div>
                <div class="col-md-6 col-xl-3">
                    <a class="quick-link" href="history">
                        <div class="card stat-card h-100 p-3"><div class="card-body"><h5>Lịch sử kho</h5><p class="text-muted mb-0">Theo dõi toàn bộ biến động kho.</p></div></div>
                    </a>
                </div>
            </div>

            <c:if test="${sessionScope.user.vaiTro == 'ADMIN'}">
                <div class="alert alert-info">Admin có thêm quyền: thêm, sửa, xóa sản phẩm.</div>
            </c:if>

            <div class="card stat-card">
                <div class="card-header bg-white border-0 pt-4 px-4">
                    <h5 class="mb-0 fw-bold">Biến động kho gần đây</h5>
                </div>
                <div class="card-body px-4 pb-4">
                    <div class="table-responsive">
                        <table class="table align-middle">
                            <thead>
                                <tr>
                                    <th>Thời gian</th>
                                    <th>Mã hàng</th>
                                    <th>Sản phẩm</th>
                                    <th>Biến động</th>
                                    <th>Số lượng</th>
                                    <th>Tồn cũ</th>
                                    <th>Tồn mới</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="h" items="${recentHistory}">
                                    <tr>
                                        <td><fmt:formatDate value="${h.ngayTao}" pattern="dd/MM/yyyy HH:mm"/></td>
                                        <td>${h.maHang}</td>
                                        <td>${h.tenSanPham}</td>
                                        <td>
                                            <span class="badge ${h.loaiBienDong == 'NHAP' ? 'bg-success' : 'bg-danger'}">${h.loaiBienDong}</span>
                                        </td>
                                        <td>${h.soLuong}</td>
                                        <td>${h.tonCu}</td>
                                        <td>${h.tonMoi}</td>
                                        <%-- <td>
                                            <c:choose>
                                                <c:when test="${h.loaiThamChieu == 'PHIEU_NHAP'}">
                                                    <a href="import-detail?id=${h.maThamChieu}">Xem</a>
                                                </c:when>
                                                <c:when test="${h.loaiThamChieu == 'PHIEU_XUAT'}">
                                                    <a href="export-detail?id=${h.maThamChieu}">Xem</a>
                                                </c:when>
                                                <c:otherwise>
                                                    -
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr> --%>
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
