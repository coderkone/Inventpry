<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Register | Warehouse Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #0f172a, #1d4ed8);
            font-family: Segoe UI, Arial, sans-serif;
            padding: 24px 0;
        }
        .register-card {
            width: 980px;
            max-width: calc(100% - 24px);
            border-radius: 24px;
            overflow: hidden;
            background: rgba(255,255,255,.14);
            backdrop-filter: blur(16px);
            box-shadow: 0 24px 60px rgba(0,0,0,.25);
        }
        .left-pane {
            color: white;
            padding: 48px;
            background: linear-gradient(135deg, rgba(255,255,255,.12), rgba(255,255,255,.04));
        }
        .right-pane {
            background: white;
            padding: 40px;
        }
    </style>
</head>
<body>
    <div class="register-card row g-0">
        <div class="col-lg-5 left-pane d-flex flex-column justify-content-center">
            <h1 class="fw-bold">Tạo tài khoản USER</h1>
            <p class="mt-3 mb-4">Chức năng đăng ký ngoài màn login dành cho người dùng thường. Tài khoản tạo mới mặc định là USER.</p>
            <ul class="small opacity-75 mb-0 ps-3">
                <li>Sau khi đăng ký sẽ quay về màn hình login</li>
                <li>Admin vẫn có menu riêng để quản lý account</li>
                <li>Tài khoản đăng ký mới được kích hoạt ngay</li>
            </ul>
        </div>
        <div class="col-lg-7 right-pane">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h3 class="fw-bold mb-0">Đăng ký tài khoản</h3>
                <a href="login" class="btn btn-outline-secondary btn-sm">Quay lại login</a>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <form action="register" method="post" class="row g-3">
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
                    <label class="form-label">Mật khẩu</label>
                    <input type="password" class="form-control" name="password" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Nhập lại mật khẩu</label>
                    <input type="password" class="form-control" name="confirmPassword" required>
                </div>
                <div class="col-12">
                    <button class="btn btn-primary">Đăng ký</button>
                    <a href="login" class="btn btn-outline-secondary ms-2">Đã có tài khoản</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
