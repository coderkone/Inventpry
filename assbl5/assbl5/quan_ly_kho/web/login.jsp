<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Login | Warehouse Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #1d4ed8, #0f172a);
            font-family: Segoe UI, Arial, sans-serif;
        }
        .login-card {
            width: 920px;
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
            padding: 48px;
        }
    </style>
</head>
<body>
    <div class="login-card row g-0">
        <div class="col-md-6 left-pane d-flex flex-column justify-content-center">
            <h1 class="fw-bold">Quản lý kho hàng</h1>
            <p class="mt-3 mb-4">Đăng nhập để quản lý sản phẩm, tạo phiếu nhập, phiếu xuất và theo dõi lịch sử kho.</p>
            <div class="small opacity-75">
                <div>Admin demo: admin / 123456</div>
                <div>User demo: user01 / 123456</div>
            </div>
        </div>
        <div class="col-md-6 right-pane">
            <h3 class="fw-bold mb-4 text-center">Đăng nhập hệ thống</h3>
            <% String error = (String) request.getAttribute("error"); if (error != null) { %>
                <div class="alert alert-danger"><%= error %></div>
            <% } %>
            <% if ("registered".equals(request.getParameter("msg"))) { %>
                <div class="alert alert-success">Đăng ký tài khoản thành công. Bạn có thể đăng nhập ngay.</div>
            <% } %>
            <form action="login" method="post">
                <div class="mb-3">
                    <label class="form-label">Tên đăng nhập</label>
                    <input type="text" name="username" class="form-control form-control-lg" required>
                </div>
                <div class="mb-4">
                    <label class="form-label">Mật khẩu</label>
                    <input type="password" name="password" class="form-control form-control-lg" required>
                </div>
                <button class="btn btn-primary btn-lg w-100">Login</button>
            </form>
            <div class="text-center mt-4">
                <span class="text-muted">Chưa có tài khoản?</span>
                <a href="register" class="fw-semibold text-decoration-none">Đăng ký ngay</a>
            </div>
        </div>
    </div>
</body>
</html>
