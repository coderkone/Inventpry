<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.inventory.model.User, java.util.List" %>
<%
    User me    = (User) session.getAttribute("user");
    List<User> users = (List<User>) request.getAttribute("users");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý User – InventoryPro</title>
    <%@ include file="/WEB-INF/views/common/styles.jsp" %>
    <style>
        .section {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 12px; overflow: hidden;
        }
        .section-header {
            padding: 18px 20px; border-bottom: 1px solid var(--border);
            display: flex; align-items: center; gap: 12px;
        }
        .section-title { font-size: 15px; font-weight: 600; }

        /* Add user form */
        .add-form {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 24px;
            margin-bottom: 24px;
        }
        .add-form h3 { font-size: 15px; font-weight: 600; margin-bottom: 18px; }
        .form-row { display: grid; grid-template-columns: 1fr 1fr 1fr auto; gap: 12px; align-items: end; }
        .form-group { display: flex; flex-direction: column; gap: 6px; }
        .form-label { font-size: 11px; font-weight: 600; color: var(--muted); letter-spacing: .5px; text-transform: uppercase; }
        .form-control {
            padding: 10px 12px;
            background: var(--bg); border: 1px solid var(--border);
            border-radius: 8px; color: var(--text);
            font-family: 'DM Sans', sans-serif; font-size: 14px; outline: none;
            transition: border-color .2s;
        }
        .form-control:focus { border-color: var(--accent); }
        select.form-control { cursor: pointer; }
        option { background: var(--bg); }

        .btn-add {
            padding: 10px 20px;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            color: #0d1117; border: none; border-radius: 8px;
            font-family: 'DM Sans', sans-serif; font-size: 14px; font-weight: 600; cursor: pointer;
            white-space: nowrap; height: 40px;
        }
        .btn-add:hover { opacity: .9; }

        /* Table */
        table { width: 100%; border-collapse: collapse; }
        th {
            padding: 12px 18px; text-align: left;
            font-size: 11px; font-weight: 600; color: var(--muted);
            letter-spacing: .8px; text-transform: uppercase;
            background: rgba(255,255,255,.02); border-bottom: 1px solid var(--border);
        }
        td { padding: 12px 18px; font-size: 14px; border-bottom: 1px solid rgba(48,54,61,.5); }
        tr:last-child td { border-bottom: none; }
        tr:hover td { background: rgba(240,165,0,.03); }

        .badge { display: inline-flex; align-items: center; padding: 3px 10px; border-radius: 20px; font-size: 11px; font-weight: 600; }
        .badge-admin { background: rgba(240,165,0,.18); color: var(--accent); }
        .badge-staff { background: rgba(63,185,80,.18);  color: var(--success); }
        .mono { font-family: 'DM Mono', monospace; font-size: 13px; color: var(--muted); }

        .action-form { display: inline; }
        .btn-action {
            padding: 5px 10px; border-radius: 6px; font-size: 12px; font-weight: 500;
            cursor: pointer; border: none; font-family: 'DM Sans', sans-serif;
            transition: opacity .15s; margin-right: 4px;
        }
        .btn-action:hover { opacity: .8; }
        .btn-role-admin { background: rgba(240,165,0,.15); color: var(--accent); }
        .btn-role-staff { background: rgba(63,185,80,.15);  color: var(--success); }
        .btn-del        { background: rgba(248,81,73,.15);  color: var(--danger); }

        .me-tag { font-size: 10px; color: var(--accent); margin-left: 6px; font-family: 'DM Mono', monospace; }
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
        <div class="nav-label">Admin</div>
        <a href="<%= request.getContextPath() %>/admin/dashboard" class="nav-item">
            <span class="nav-icon">🏠</span> Dashboard
        </a>
        <a href="<%= request.getContextPath() %>/admin/users" class="nav-item active">
            <span class="nav-icon">👥</span> Quản lý User
        </a>
    </div>
    <div class="nav-section">
        <div class="nav-label">Kho hàng</div>
        <a href="#" class="nav-item"><span class="nav-icon">📦</span> Sản phẩm</a>
        <a href="#" class="nav-item"><span class="nav-icon">📥</span> Nhập kho</a>
        <a href="#" class="nav-item"><span class="nav-icon">📤</span> Xuất kho</a>
        <a href="#" class="nav-item"><span class="nav-icon">📊</span> Báo cáo</a>
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
        <span class="topbar-title">Quản lý User</span>
        <span class="topbar-sep">/</span>
        <span class="topbar-sub">Thêm, sửa quyền, xoá tài khoản</span>
        <div class="topbar-right">
            <span class="role-badge badge-admin">ADMIN</span>
        </div>
    </div>

    <div class="content">

        <!-- ADD USER FORM -->
        <div class="add-form">
            <h3>➕ Thêm người dùng mới</h3>
            <form action="<%= request.getContextPath() %>/admin/users" method="post">
                <input type="hidden" name="action" value="add">
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">Tài khoản</label>
                        <input type="text" name="username" class="form-control" placeholder="username" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Mật khẩu</label>
                        <input type="password" name="password" class="form-control" placeholder="password" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Quyền</label>
                        <select name="role" class="form-control">
                            <option value="STAFF">STAFF</option>
                            <option value="ADMIN">ADMIN</option>
                        </select>
                    </div>
                    <button type="submit" class="btn-add">Thêm</button>
                </div>
            </form>
        </div>

        <!-- USER TABLE -->
        <div class="section">
            <div class="section-header">
                <span>👥</span>
                <span class="section-title">Danh sách tài khoản (<%= users != null ? users.size() : 0 %>)</span>
            </div>
            <table>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Tài khoản</th>
                        <th>Quyền hiện tại</th>
                        <th>Ngày tạo</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                <% if (users != null) { for (User u : users) {
                    boolean isSelf = (me.getId() == u.getId());
                %>
                    <tr>
                        <td class="mono"><%= u.getId() %></td>
                        <td>
                            <strong><%= u.getUsername() %></strong>
                            <% if (isSelf) { %><span class="me-tag">(bạn)</span><% } %>
                        </td>
                        <td>
                            <span class="badge <%= u.isAdmin() ? "badge-admin" : "badge-staff" %>">
                                <%= u.getRole() %>
                            </span>
                        </td>
                        <td class="mono"><%= u.getCreatedAt() != null ? u.getCreatedAt().toLocalDate() : "—" %></td>
                        <td>
                            <%-- Đổi thành STAFF --%>
                            <% if (!isSelf && u.isAdmin()) { %>
                            <form class="action-form" method="post" action="<%= request.getContextPath() %>/admin/users">
                                <input type="hidden" name="action" value="updateRole">
                                <input type="hidden" name="id"     value="<%= u.getId() %>">
                                <input type="hidden" name="role"   value="STAFF">
                                <button type="submit" class="btn-action btn-role-staff" onclick="return confirm('Đổi thành STAFF?')">→ STAFF</button>
                            </form>
                            <% } %>

                            <%-- Đổi thành ADMIN --%>
                            <% if (!isSelf && u.isStaff()) { %>
                            <form class="action-form" method="post" action="<%= request.getContextPath() %>/admin/users">
                                <input type="hidden" name="action" value="updateRole">
                                <input type="hidden" name="id"     value="<%= u.getId() %>">
                                <input type="hidden" name="role"   value="ADMIN">
                                <button type="submit" class="btn-action btn-role-admin" onclick="return confirm('Nâng quyền ADMIN?')">→ ADMIN</button>
                            </form>
                            <% } %>

                            <%-- Xoá --%>
                            <% if (!isSelf) { %>
                            <form class="action-form" method="post" action="<%= request.getContextPath() %>/admin/users">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id"     value="<%= u.getId() %>">
                                <button type="submit" class="btn-action btn-del" onclick="return confirm('Xoá tài khoản <%= u.getUsername() %>?')">🗑 Xoá</button>
                            </form>
                            <% } %>

                            <% if (isSelf) { %>
                                <span style="font-size:12px;color:var(--muted)">—</span>
                            <% } %>
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
