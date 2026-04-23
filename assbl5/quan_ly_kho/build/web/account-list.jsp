<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh sách account</title>
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
                        <h3 class="fw-bold mb-1">Danh sách account</h3>
                        <p class="text-muted mb-0">Admin được xem, sửa, xóa, khóa và mở khóa tài khoản.</p>
                    </div>
                    <a href="accounts?action=add" class="btn btn-primary">+ Tạo account</a>
                </div>

                <c:if test="${param.msg == 'created'}"><div class="alert alert-success">Tạo tài khoản thành công.</div></c:if>
                <c:if test="${param.msg == 'updated'}"><div class="alert alert-success">Cập nhật tài khoản thành công.</div></c:if>
                <c:if test="${param.msg == 'deleted'}"><div class="alert alert-success">Xóa tài khoản thành công.</div></c:if>
                <c:if test="${param.msg == 'locked'}"><div class="alert alert-warning">Đã khóa tài khoản.</div></c:if>
                <c:if test="${param.msg == 'unlocked'}"><div class="alert alert-success">Đã mở khóa tài khoản.</div></c:if>
                <c:if test="${param.msg == 'cannotDeleteSelf'}"><div class="alert alert-danger">Bạn không thể tự xóa chính mình.</div></c:if>
                <c:if test="${param.msg == 'cannotLockSelf'}"><div class="alert alert-danger">Bạn không thể tự khóa chính mình.</div></c:if>
                <c:if test="${param.msg == 'hasReferences'}"><div class="alert alert-danger">Không thể xóa tài khoản vì đã phát sinh phiếu nhập, phiếu xuất hoặc lịch sử kho.</div></c:if>
                <c:if test="${param.msg == 'notFound'}"><div class="alert alert-danger">Không tìm thấy tài khoản.</div></c:if>
                <c:if test="${param.msg == 'error'}"><div class="alert alert-danger">Thao tác thất bại. Vui lòng thử lại.</div></c:if>

                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tên đăng nhập</th>
                                <th>Họ tên</th>
                                <th>Email</th>
                                <th>SĐT</th>
                                <th>Vai trò</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="u" items="${users}">
                                <tr>
                                    <td>${u.maNguoiDung}</td>
                                    <td class="fw-semibold">${u.tenDangNhap}</td>
                                    <td>${u.hoTen}</td>
                                    <td>${u.email}</td>
                                    <td>${u.soDienThoai}</td>
                                    <td><span class="badge ${u.vaiTro == 'ADMIN' ? 'bg-dark' : 'bg-primary'}">${u.vaiTro}</span></td>
                                    <td>
                                        <span class="badge ${u.active ? 'bg-success' : 'bg-secondary'}">${u.active ? 'Đang hoạt động' : 'Đã khóa'}</span>
                                        <c:if test="${u.maNguoiDung == sessionScope.user.maNguoiDung}">
                                            <span class="badge bg-info text-dark">Tài khoản hiện tại</span>
                                        </c:if>
                                    </td>
                                    <td>
                                        <a class="btn btn-sm btn-outline-primary" href="accounts?action=edit&id=${u.maNguoiDung}">Sửa</a>
                                        <c:choose>
                                            <c:when test="${u.active}">
                                                <a class="btn btn-sm btn-outline-warning" href="accounts?action=toggle&id=${u.maNguoiDung}" onclick="return confirm('Khóa tài khoản này?')">Khóa</a>
                                            </c:when>
                                            <c:otherwise>
                                                <a class="btn btn-sm btn-outline-success" href="accounts?action=toggle&id=${u.maNguoiDung}" onclick="return confirm('Mở khóa tài khoản này?')">Mở khóa</a>
                                            </c:otherwise>
                                        </c:choose>
                                        <a class="btn btn-sm btn-outline-danger" href="accounts?action=delete&id=${u.maNguoiDung}" onclick="return confirm('Xóa tài khoản này?')">Xóa</a>
                                    </td>
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
