<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${formMode == 'edit' ? 'Sửa account' : 'Tạo account'}</title>
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
                        <c:choose>
                            <c:when test="${formMode == 'edit'}">
                                <h3 class="fw-bold mb-1">Cập nhật account</h3>
                                <div class="text-muted">Admin có thể sửa thông tin, đổi quyền, khóa hoặc mở khóa tài khoản.</div>
                            </c:when>
                            <c:otherwise>
                                <h3 class="fw-bold mb-1">Tạo account mới</h3>
                                <div class="text-muted">Chỉ admin mới được tạo tài khoản đăng nhập cho hệ thống.</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <span class="badge bg-dark">ADMIN</span>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>

                <form action="accounts" method="post" class="row g-3">
                    <input type="hidden" name="action" value="${formMode == 'edit' ? 'update' : 'save'}">
                    <c:if test="${formMode == 'edit'}">
                        <input type="hidden" name="id" value="${account.maNguoiDung}">
                    </c:if>

                    <div class="col-md-6">
                        <label class="form-label">Tên đăng nhập</label>
                        <input class="form-control" name="username" value="${account.tenDangNhap}" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Họ tên</label>
                        <input class="form-control" name="fullName" value="${account.hoTen}" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Email</label>
                        <input type="email" class="form-control" name="email" value="${account.email}" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Số điện thoại</label>
                        <input class="form-control" name="phone" value="${account.soDienThoai}">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Mật khẩu ${formMode == 'edit' ? '(để trống nếu không đổi)' : ''}</label>
                        <input type="password" class="form-control" name="password" ${formMode == 'edit' ? '' : 'required'}>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Nhập lại mật khẩu</label>
                        <input type="password" class="form-control" name="confirmPassword" ${formMode == 'edit' ? '' : 'required'}>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Vai trò</label>
                        <select class="form-select" name="role" required ${formMode == 'edit' && account.maNguoiDung == sessionScope.user.maNguoiDung ? 'disabled' : ''}>
                            <option value="USER" ${empty account.vaiTro || account.vaiTro == 'USER' ? 'selected' : ''}>USER</option>
                            <option value="ADMIN" ${account.vaiTro == 'ADMIN' ? 'selected' : ''}>ADMIN</option>
                        </select>
                        <c:if test="${formMode == 'edit' && account.maNguoiDung == sessionScope.user.maNguoiDung}">
                            <input type="hidden" name="role" value="${account.vaiTro}">
                            <div class="form-text">Bạn không thể tự đổi quyền của chính mình.</div>
                        </c:if>
                    </div>
                    <div class="col-md-6 d-flex align-items-end">
                        <div class="form-check mb-2">
                            <input class="form-check-input" type="checkbox" name="active" id="active"
                                   ${account.active || empty account.tenDangNhap ? 'checked' : ''}
                                   ${formMode == 'edit' && account.maNguoiDung == sessionScope.user.maNguoiDung ? 'disabled' : ''}>
                            <label class="form-check-label" for="active">Kích hoạt tài khoản</label>
                        </div>
                        <c:if test="${formMode == 'edit' && account.maNguoiDung == sessionScope.user.maNguoiDung}">
                            <input type="hidden" name="active" value="on">
                        </c:if>
                    </div>
                    <div class="col-12 d-flex gap-2">
                        <button class="btn btn-primary">${formMode == 'edit' ? 'Lưu thay đổi' : 'Tạo account'}</button>
                        <a href="accounts" class="btn btn-outline-secondary">Quay lại</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
