<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thống kê hàng hóa</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body{background:#f5f7fb}
        .card-main,.stat-card{border:0;border-radius:18px;box-shadow:0 8px 24px rgba(15,23,42,.06)}
        .stat-number{font-size:1.5rem;font-weight:700}
        .badge-soft{padding:.45rem .7rem;border-radius:999px;font-weight:600;font-size:.8rem}
        .badge-out{background:#fee2e2;color:#b91c1c}
        .badge-low{background:#fef3c7;color:#b45309}
        .badge-ok{background:#dcfce7;color:#166534}
    </style>
</head>
<body>
    <%@ include file="includes/navbar.jspf" %>
    <div class="container py-4">
        <div class="card card-main mb-4">
            <div class="card-body p-4">
                <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
                    <div>
                        <h3 class="fw-bold mb-1">Thống kê hàng hóa</h3>
                        <p class="text-muted mb-0">Xem số lượng tồn, tổng nhập, tổng xuất và giá trị tồn kho theo từng sản phẩm.</p>
                    </div>
                    <span class="badge bg-dark fs-6">Theo sản phẩm</span>
                </div>

                <form action="statistics" method="get" class="row g-3 align-items-end">
                    <div class="col-md-3">
                        <label class="form-label">Từ khóa</label>
                        <input type="text" class="form-control" name="keyword" value="${keyword}" placeholder="Mã hàng hoặc tên sản phẩm">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Loại hàng</label>
                        <select class="form-select" name="categoryId">
                            <option value="0">Tất cả</option>
                            <c:forEach var="c" items="${categories}">
                                <option value="${c.maLoaiHang}" ${categoryId == c.maLoaiHang ? 'selected' : ''}>${c.tenLoaiHang}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">Trạng thái tồn</label>
                        <select class="form-select" name="stockFilter">
                            <option value="all" ${stockFilter == 'all' ? 'selected' : ''}>Tất cả</option>
                            <option value="available" ${stockFilter == 'available' ? 'selected' : ''}>Còn hàng</option>
                            <option value="low" ${stockFilter == 'low' ? 'selected' : ''}>Sắp hết</option>
                            <option value="out" ${stockFilter == 'out' ? 'selected' : ''}>Hết hàng</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">Sắp xếp</label>
                        <select class="form-select" name="sortBy">
                            <option value="nameAsc" ${sortBy == 'nameAsc' ? 'selected' : ''}>Tên A-Z</option>
                            <option value="stockAsc" ${sortBy == 'stockAsc' ? 'selected' : ''}>Tồn kho tăng dần</option>
                            <option value="importDesc" ${sortBy == 'importDesc' ? 'selected' : ''}>Nhập nhiều nhất</option>
                            <option value="exportDesc" ${sortBy == 'exportDesc' ? 'selected' : ''}>Xuất nhiều nhất</option>
                            <option value="valueDesc" ${sortBy == 'valueDesc' ? 'selected' : ''}>Giá trị tồn cao nhất</option>
                        </select>
                    </div>
                    <div class="col-md-2 d-grid">
                        <button class="btn btn-primary">Xem thống kê</button>
                    </div>
                </form>
            </div>
        </div>

        <div class="row g-4 mb-4">
            <div class="col-md-6 col-xl-3">
                <div class="card stat-card h-100"><div class="card-body p-4">
                    <div class="text-muted mb-2">Tổng sản phẩm</div>
                    <div class="stat-number text-primary">${summary.totalProducts}</div>
                    <div>Tổng tồn kho: <strong>${summary.totalStockQuantity}</strong></div>
                </div></div>
            </div>
            <div class="col-md-6 col-xl-3">
                <div class="card stat-card h-100"><div class="card-body p-4">
                    <div class="text-muted mb-2">Giá trị tồn kho</div>
                    <div class="stat-number text-success"><fmt:formatNumber value="${summary.totalInventoryValue}" type="number" maxFractionDigits="0"/></div>
                    <div>Theo giá nhập hiện tại</div>
                </div></div>
            </div>
            <div class="col-md-6 col-xl-3">
                <div class="card stat-card h-100"><div class="card-body p-4">
                    <div class="text-muted mb-2">Tổng nhập / xuất</div>
                    <div>Nhập: <strong class="text-success">${summary.totalImportQuantity}</strong></div>
                    <div>Xuất: <strong class="text-danger">${summary.totalExportQuantity}</strong></div>
                    <div class="small text-muted mt-2">Theo lịch sử phiếu nhập và phiếu xuất</div>
                </div></div>
            </div>
            <div class="col-md-6 col-xl-3">
                <div class="card stat-card h-100"><div class="card-body p-4">
                    <div class="text-muted mb-2">Cảnh báo hàng hóa</div>
                    <div>Sắp hết: <strong class="text-warning">${summary.lowStockCount}</strong></div>
                    <div>Hết hàng: <strong class="text-danger">${summary.outOfStockCount}</strong></div>
                </div></div>
            </div>
        </div>

        <div class="card card-main">
            <div class="card-body p-4">
                <div class="d-flex justify-content-between align-items-center mb-3 gap-3 flex-wrap">
                    <h5 class="fw-bold mb-0">Chi tiết thống kê hàng hóa</h5>
                    <div class="text-muted">${statisticsRows.size()} sản phẩm</div>
                </div>
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead>
                            <tr>
                                <th>Mã hàng</th>
                                <th>Tên sản phẩm</th>
                                <th>Loại hàng</th>
                                <th>ĐVT</th>
                                <th>Tồn kho</th>
                                <th>Tổng nhập</th>
                                <th>Tổng xuất</th>
                                <th>Giá trị tồn</th>
                                <th>Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty statisticsRows}">
                                    <tr>
                                        <td colspan="9" class="text-center text-muted py-4">Không có dữ liệu hàng hóa phù hợp bộ lọc đã chọn.</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="row" items="${statisticsRows}">
                                        <tr>
                                            <td><strong>${row.maHang}</strong></td>
                                            <td>
                                                <div class="fw-semibold">${row.tenSanPham}</div>
                                                <div class="small text-muted">Nhập: <fmt:formatNumber value="${row.giaTriNhap}" type="number" maxFractionDigits="0"/> | Xuất: <fmt:formatNumber value="${row.giaTriXuat}" type="number" maxFractionDigits="0"/></div>
                                            </td>
                                            <td>${row.tenLoaiHang}</td>
                                            <td>${row.donViTinh}</td>
                                            <td class="fw-semibold">${row.soLuongTon}</td>
                                            <td class="text-success">${row.tongNhap}</td>
                                            <td class="text-danger">${row.tongXuat}</td>
                                            <td><fmt:formatNumber value="${row.giaTriTon}" type="number" maxFractionDigits="0"/></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${row.soLuongTon <= 0}">
                                                        <span class="badge-soft badge-out">Hết hàng</span>
                                                    </c:when>
                                                    <c:when test="${row.soLuongTon <= 10}">
                                                        <span class="badge-soft badge-low">Sắp hết</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge-soft badge-ok">Còn hàng</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
