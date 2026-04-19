<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.inventory.model.User" %>
<%
    User me = (User) session.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nhân viên – InventoryPro</title>
    <%@ include file="/WEB-INF/views/common/styles.jsp" %>
    <style>
        .welcome-banner {
            background: linear-gradient(135deg, rgba(63,185,80,.1), rgba(63,185,80,.04));
            border: 1px solid rgba(63,185,80,.2);
            border-radius: 12px;
            padding: 24px;
            display: flex; align-items: center; gap: 16px;
            margin-bottom: 28px;
        }
        .welcome-icon  { font-size: 40px; }
        .welcome-title { font-size: 18px; font-weight: 600; }
        .welcome-sub   { font-size: 13px; color: var(--muted); margin-top: 4px; }

        .cards { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px,1fr)); gap: 16px; margin-bottom: 28px; }
        .card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 12px; padding: 22px;
            text-decoration: none; color: var(--text);
            transition: border-color .2s, transform .15s;
            display: flex; flex-direction: column; gap: 10px;
        }
        .card:hover { border-color: var(--accent); transform: translateY(-2px); }
        .card-icon  { font-size: 30px; }
        .card-title { font-size: 15px; font-weight: 600; }
        .card-desc  { font-size: 13px; color: var(--muted); }

        .notice {
            background: rgba(248,81,73,.08);
            border: 1px solid rgba(248,81,73,.2);
            border-radius: 10px;
            padding: 14px 18px;
            font-size: 13.5px;
            color: var(--danger);
            display: flex; align-items: center; gap: 10px;
        }
    </style>
</head>
<body>

<!-- SIDEBAR -->
<nav class="sidebar">
    <div class="sidebar-logo">
        <div class="icon">📦</div>
        <div><div class="name">InventoryPro</div><div class="ver">v1.0.0</div></div>
    </div>

    <div class="nav-section">
        <div class="nav-label">Kho hàng</div>
        <a href="<%= request.getContextPath() %>/staff/dashboard" class="nav-item active">
            <span class="nav-icon">🏠</span> Trang chủ
        </a>
        <a href="#" class="nav-item">
            <span class="nav-icon">📦</span> Sản phẩm
        </a>
        <a href="#" class="nav-item">
            <span class="nav-icon">📥</span> Nhập kho
        </a>
        <a href="#" class="nav-item">
            <span class="nav-icon">📤</span> Xuất kho
        </a>
    </div>

    <div class="sidebar-footer">
        <div class="user-info">
            <div class="avatar"><%= me.getUsername().substring(0,1).toUpperCase() %></div>
            <div>
                <div class="user-name"><%= me.getUsername() %></div>
                <div class="user-role">Nhân viên kho</div>
            </div>
        </div>
        <a href="<%= request.getContextPath() %>/logout" class="btn-logout">🚪 Đăng xuất</a>
    </div>
</nav>

<!-- MAIN -->
<div class="main">
    <div class="topbar">
        <span class="topbar-title">Dashboard</span>
        <span class="topbar-sep">/</span>
        <span class="topbar-sub">Trang làm việc của nhân viên</span>
        <div class="topbar-right">
            <span class="role-badge badge-staff">STAFF</span>
        </div>
    </div>

    <div class="content">

        <div class="welcome-banner">
            <div class="welcome-icon">📦</div>
            <div>
                <div class="welcome-title">Chào, <%= me.getUsername() %>!</div>
                <div class="welcome-sub">Bạn đang đăng nhập với quyền STAFF. Có thể thực hiện nhập/xuất kho và xem sản phẩm.</div>
            </div>
        </div>

        <!-- Feature cards -->
        <div class="cards">
            <a href="#" class="card">
                <div class="card-icon">📦</div>
                <div class="card-title">Danh sách sản phẩm</div>
                <div class="card-desc">Xem tồn kho và thông tin sản phẩm</div>
            </a>
            <a href="#" class="card">
                <div class="card-icon">📥</div>
                <div class="card-title">Tạo phiếu nhập</div>
                <div class="card-desc">Ghi nhận hàng hóa nhập vào kho</div>
            </a>
            <a href="#" class="card">
                <div class="card-icon">📤</div>
                <div class="card-title">Tạo phiếu xuất</div>
                <div class="card-desc">Ghi nhận hàng hóa xuất ra khỏi kho</div>
            </a>
        </div>

        <!-- Locked section notice -->
        <div class="notice">
            🔒 Khu vực quản lý tài khoản và báo cáo toàn hệ thống chỉ dành cho ADMIN.
        </div>

    </div>
</div>

</body>
</html>
