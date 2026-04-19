<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.inventory.model.User, java.util.List" %>
<%
    User me = (User) session.getAttribute("user");
    List<User> users = (List<User>) request.getAttribute("users");
    int adminCount = 0, staffCount = 0;
    if (users != null) {
        for (User u : users) {
            if (u.isAdmin()) adminCount++; else staffCount++;
        }
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard – InventoryPro</title>
    <%@ include file="/WEB-INF/views/common/styles.jsp" %>
    <style>
        /* Stats cards */
        .stats { display: grid; grid-template-columns: repeat(auto-fit, minmax(180px,1fr)); gap: 16px; margin-bottom: 28px; }
        .stat-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 20px;
            position: relative; overflow: hidden;
        }
        .stat-card::before {
            content: '';
            position: absolute; top: 0; left: 0; right: 0; height: 3px;
            background: linear-gradient(90deg, var(--accent), var(--accent2));
        }
        .stat-icon  { font-size: 28px; margin-bottom: 10px; }
        .stat-num   { font-size: 32px; font-weight: 700; font-family: 'DM Mono', monospace; }
        .stat-label { font-size: 12px; color: var(--muted); margin-top: 4px; text-transform: uppercase; letter-spacing: .5px; }

        /* Table */
        .section {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 12px;
            overflow: hidden;
        }
        .section-header {
            padding: 18px 20px;
            border-bottom: 1px solid var(--border);
            display: flex; align-items: center; gap: 12px;
        }
        .section-title { font-size: 15px; font-weight: 600; }
        .section-header .btn-sm {
            margin-left: auto;
            padding: 7px 14px;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            color: #0d1117; border: none; border-radius: 7px;
            font-family: 'DM Sans', sans-serif; font-size: 13px; font-weight: 600; cursor: pointer;
            text-decoration: none;
        }

        table { width: 100%; border-collapse: collapse; }
        th {
            padding: 12px 18px;
            text-align: left; font-size: 11px; font-weight: 600;
            color: var(--muted); letter-spacing: .8px; text-transform: uppercase;
            background: rgba(255,255,255,.02);
            border-bottom: 1px solid var(--border);
        }
        td {
            padding: 13px 18px;
            font-size: 14px;
            border-bottom: 1px solid rgba(48,54,61,.5);
        }
        tr:last-child td { border-bottom: none; }
        tr:hover td { background: rgba(240,165,0,.03); }

        .badge {
            display: inline-flex; align-items: center;
            padding: 3px 10px; border-radius: 20px;
            font-size: 11px; font-weight: 600; letter-spacing: .3px;
        }
        .badge-admin { background: rgba(240,165,0,.18); color: var(--accent); }
        .badge-staff { background: rgba(63,185,80,.18);  color: var(--success); }

        .mono { font-family: 'DM Mono', monospace; font-size: 13px; color: var(--muted); }

        .action-btn {
            padding: 5px 11px; border-radius: 6px; font-size: 12px; font-weight: 500;
            cursor: pointer; border: none; font-family: 'DM Sans', sans-serif;
            text-decoration: none; display: inline-block;
            transition: opacity .15s;
        }
        .action-btn:hover { opacity: .8; }
        .btn-manage { background: rgba(240,165,0,.15); color: var(--accent); }

        .welcome-banner {
            background: linear-gradient(135deg, rgba(240,165,0,.12), rgba(224,92,0,.06));
            border: 1px solid rgba(240,165,0,.2);
            border-radius: 12px;
            padding: 20px 24px;
            display: flex; align-items: center; gap: 16px;
            margin-bottom: 24px;
        }
        .welcome-icon { font-size: 36px; }
        .welcome-title { font-size: 18px; font-weight: 600; }
        .welcome-sub   { font-size: 13px; color: var(--muted); margin-top: 3px; }
    </style>
</head>
<body>

<!-- SIDEBAR -->
<nav class="sidebar">
    <div class="sidebar-logo">
        <div class="icon">📦</div>
        <div>
            <div class="name">InventoryPro</div>
            <div class="ver">v1.0.0</div>
        </div>
    </div>

    <div class="nav-section">
        <div class="nav-label">Admin</div>
        <a href="<%= request.getContextPath() %>/admin/dashboard" class="nav-item active">
            <span class="nav-icon">🏠</span> Dashboard
        </a>
        <a href="<%= request.getContextPath() %>/admin/users" class="nav-item">
            <span class="nav-icon">👥</span> Quản lý User
        </a>
    </div>

    <div class="nav-section">
        <div class="nav-label">Kho hàng</div>
        <a href="#" class="nav-item">
            <span class="nav-icon">📦</span> Sản phẩm
        </a>
        <a href="#" class="nav-item">
            <span class="nav-icon">📥</span> Nhập kho
        </a>
        <a href="#" class="nav-item">
            <span class="nav-icon">📤</span> Xuất kho
        </a>
        <a href="#" class="nav-item">
            <span class="nav-icon">📊</span> Báo cáo
        </a>
    </div>

    <div class="sidebar-footer">
        <div class="user-info">
            <div class="avatar"><%= me.getUsername().substring(0,1).toUpperCase() %></div>
            <div>
                <div class="user-name"><%= me.getUsername() %></div>
                <div class="user-role">Administrator</div>
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
        <span class="topbar-sub">Tổng quan hệ thống</span>
        <div class="topbar-right">
            <span class="role-badge badge-admin">ADMIN</span>
        </div>
    </div>

    <div class="content">
        <div class="welcome-banner">
            <div class="welcome-icon">👋</div>
            <div>
                <div class="welcome-title">Xin chào, <%= me.getUsername() %>!</div>
                <div class="welcome-sub">Bạn đang đăng nhập với quyền ADMIN. Toàn quyền quản lý hệ thống.</div>
            </div>
        </div>

        <!-- Stats -->
        <div class="stats">
            <div class="stat-card">
                <div class="stat-icon">👥</div>
                <div class="stat-num"><%= users != null ? users.size() : 0 %></div>
                <div class="stat-label">Tổng người dùng</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">🛡</div>
                <div class="stat-num"><%= adminCount %></div>
                <div class="stat-label">Admins</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">👤</div>
                <div class="stat-num"><%= staffCount %></div>
                <div class="stat-label">Nhân viên</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">📦</div>
                <div class="stat-num">—</div>
                <div class="stat-label">Sản phẩm</div>
            </div>
        </div>

        <!-- User table preview -->
        <div class="section">
            <div class="section-header">
                <span>👥</span>
                <span class="section-title">Danh sách người dùng</span>
                <a href="<%= request.getContextPath() %>/admin/users" class="btn-sm">Quản lý đầy đủ →</a>
            </div>
            <table>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Tài khoản</th>
                        <th>Quyền</th>
                        <th>Ngày tạo</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                <% if (users != null) { for (User u : users) { %>
                    <tr>
                        <td class="mono"><%= u.getId() %></td>
                        <td><strong><%= u.getUsername() %></strong></td>
                        <td>
                            <span class="badge <%= u.isAdmin() ? "badge-admin" : "badge-staff" %>">
                                <%= u.getRole() %>
                            </span>
                        </td>
                        <td class="mono"><%= u.getCreatedAt() != null ? u.getCreatedAt().toLocalDate() : "—" %></td>
                        <td>
                            <a href="<%= request.getContextPath() %>/admin/users" class="action-btn btn-manage">Quản lý</a>
                        </td>
                    </tr>
                <% }} %>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>
