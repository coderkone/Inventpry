<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${formMode == 'edit' ? 'Sửa sản phẩm' : 'Thêm sản phẩm'}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>body{background:#f5f7fb}.card-main{border:0;border-radius:18px;box-shadow:0 8px 24px rgba(15,23,42,.06)}</style>
</head>
<body>
    <%@ include file="includes/navbar.jspf" %>
    <div class="container py-4">
        <div class="card card-main">
            <div class="card-body p-4">
                <h3 class="fw-bold mb-4">${formMode == 'edit' ? 'Sửa sản phẩm' : 'Thêm sản phẩm mới'}</h3>
                <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>
                <form action="products" method="post" class="row g-3">
                    <input type="hidden" name="action" value="${formMode == 'edit' ? 'update' : 'save'}">
                    <c:if test="${formMode == 'edit'}"><input type="hidden" name="id" value="${product.maSanPham}"></c:if>

                    <div class="col-md-4">
                        <label class="form-label">Mã hàng</label>
                        <input class="form-control" name="maHang" value="${product.maHang}" required>
                    </div>
                    <div class="col-md-8">
                        <label class="form-label">Tên sản phẩm</label>
                        <input class="form-control" name="tenSanPham" value="${product.tenSanPham}" required>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Loại hàng</label>
                        <select class="form-select" name="maLoaiHang" required>
                            <option value="">-- Chọn loại --</option>
                            <c:forEach var="c" items="${categories}">
                                <option value="${c.maLoaiHang}" ${product.maLoaiHang == c.maLoaiHang ? 'selected' : ''}>${c.tenLoaiHang}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Đơn vị tính</label>
                        <input class="form-control" name="donViTinh" value="${product.donViTinh}" required>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Tồn kho</label>
                        <input type="number" class="form-control" name="soLuongTon" value="${empty product.soLuongTon ? 0 : product.soLuongTon}" min="0" ${formMode == 'edit' ? 'readonly' : ''} required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Giá nhập</label>
                        <input type="number" step="0.01" class="form-control" name="giaNhap" value="${product.giaNhap}" min="0" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Giá xuất</label>
                        <input type="number" step="0.01" class="form-control" name="giaXuat" value="${product.giaXuat}" min="0" required>
                    </div>
                    <div class="col-12">
                        <label class="form-label">Mô tả</label>
                        <textarea class="form-control" name="moTa" rows="3">${product.moTa}</textarea>
                    </div>
                    <div class="col-12 d-flex gap-2">
                        <button class="btn btn-primary">${formMode == 'edit' ? 'Cập nhật' : 'Lưu sản phẩm'}</button>
                        <a href="products" class="btn btn-outline-secondary">Quay lại</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
