<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập – Hệ Thống Kho Hàng</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --bg:        #0d1117;
            --surface:   #161b22;
            --border:    #30363d;
            --accent:    #f0a500;
            --accent2:   #e05c00;
            --text:      #e6edf3;
            --muted:     #7d8590;
            --danger:    #f85149;
            --success:   #3fb950;
            --radius:    12px;
        }

        body {
            font-family: 'DM Sans', sans-serif;
            background: var(--bg);
            color: var(--text);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            position: relative;
        }

        /* Animated background grid */
        body::before {
            content: '';
            position: fixed;
            inset: 0;
            background-image:
                linear-gradient(rgba(240,165,0,.04) 1px, transparent 1px),
                linear-gradient(90deg, rgba(240,165,0,.04) 1px, transparent 1px);
            background-size: 40px 40px;
            animation: gridMove 20s linear infinite;
            pointer-events: none;
        }
        @keyframes gridMove { to { background-position: 40px 40px; } }

        /* Glow blobs */
        .blob {
            position: fixed;
            border-radius: 50%;
            filter: blur(80px);
            opacity: .18;
            pointer-events: none;
        }
        .blob-1 { width: 400px; height: 400px; background: var(--accent); top: -100px; right: -100px; animation: float 8s ease-in-out infinite; }
        .blob-2 { width: 300px; height: 300px; background: var(--accent2); bottom: -80px; left: -80px; animation: float 10s ease-in-out infinite reverse; }
        @keyframes float {
            0%,100% { transform: translate(0,0) scale(1); }
            50%      { transform: translate(30px,20px) scale(1.1); }
        }

        /* Card */
        .card {
            position: relative;
            z-index: 10;
            width: 420px;
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 20px;
            padding: 44px 40px;
            box-shadow: 0 24px 80px rgba(0,0,0,.5), 0 0 0 1px rgba(240,165,0,.08);
            animation: slideUp .5s cubic-bezier(.16,1,.3,1) forwards;
            opacity: 0;
            transform: translateY(24px);
        }
        @keyframes slideUp { to { opacity: 1; transform: translateY(0); } }

        .logo {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 32px;
        }
        .logo-icon {
            width: 44px; height: 44px;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            font-size: 20px;
        }
        .logo-text { font-size: 18px; font-weight: 600; letter-spacing: -.3px; }
        .logo-sub  { font-size: 12px; color: var(--muted); font-family: 'DM Mono', monospace; margin-top: 2px; }

        h2 { font-size: 22px; font-weight: 600; margin-bottom: 6px; }
        .subtitle { color: var(--muted); font-size: 14px; margin-bottom: 28px; }

        /* Alert */
        .alert {
            display: flex; align-items: center; gap: 10px;
            padding: 12px 14px;
            border-radius: 8px;
            font-size: 13.5px;
            margin-bottom: 20px;
            animation: shake .35s cubic-bezier(.36,.07,.19,.97);
        }
        .alert-error   { background: rgba(248,81,73,.12); border: 1px solid rgba(248,81,73,.3); color: var(--danger); }
        .alert-success { background: rgba(63,185,80,.12); border: 1px solid rgba(63,185,80,.3); color: var(--success); }
        @keyframes shake {
            0%,100% { transform: translateX(0); }
            20%,60%  { transform: translateX(-6px); }
            40%,80%  { transform: translateX(6px); }
        }

        /* Form */
        .form-group  { margin-bottom: 18px; }
        .form-label  { display: block; font-size: 13px; font-weight: 500; color: var(--muted); margin-bottom: 7px; letter-spacing: .3px; text-transform: uppercase; }
        .input-wrap  { position: relative; }
        .input-icon  { position: absolute; left: 14px; top: 50%; transform: translateY(-50%); font-size: 16px; pointer-events: none; opacity: .5; }
        .form-control {
            width: 100%;
            padding: 12px 14px 12px 40px;
            background: var(--bg);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            color: var(--text);
            font-family: 'DM Sans', sans-serif;
            font-size: 15px;
            outline: none;
            transition: border-color .2s, box-shadow .2s;
        }
        .form-control:focus {
            border-color: var(--accent);
            box-shadow: 0 0 0 3px rgba(240,165,0,.15);
        }
        .form-control::placeholder { color: var(--muted); font-size: 14px; }

        /* Toggle password */
        .pwd-toggle {
            position: absolute; right: 12px; top: 50%; transform: translateY(-50%);
            background: none; border: none; cursor: pointer; padding: 4px;
            color: var(--muted); font-size: 16px;
            transition: color .2s;
        }
        .pwd-toggle:hover { color: var(--text); }

        /* Submit button */
        .btn-login {
            width: 100%; padding: 13px;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            border: none; border-radius: var(--radius);
            color: #0d1117; font-family: 'DM Sans', sans-serif;
            font-size: 15px; font-weight: 600; cursor: pointer;
            transition: opacity .2s, transform .15s;
            margin-top: 8px;
            position: relative; overflow: hidden;
        }
        .btn-login::after {
            content: '';
            position: absolute; inset: 0;
            background: linear-gradient(rgba(255,255,255,.15), transparent);
            border-radius: inherit;
        }
        .btn-login:hover   { opacity: .9; transform: translateY(-1px); }
        .btn-login:active  { transform: translateY(0); }

        /* Footer hint */
        .hint {
            margin-top: 24px; text-align: center;
            font-size: 12px; color: var(--muted);
            font-family: 'DM Mono', monospace;
        }
        .hint span { color: var(--accent); }
    </style>
</head>
<body>

<div class="blob blob-1"></div>
<div class="blob blob-2"></div>

<div class="card">
    <div class="logo">
        <div class="logo-icon">📦</div>
        <div>
            <div class="logo-text">InventoryPro</div>
            <div class="logo-sub">WAREHOUSE MANAGEMENT</div>
        </div>
    </div>

    <h2>Đăng nhập</h2>
    <p class="subtitle">Chào mừng! Vui lòng nhập thông tin tài khoản.</p>

    <%-- Thông báo lỗi / logout --%>
    <% String error = (String) request.getAttribute("error"); %>
    <% if (error != null && !error.isEmpty()) { %>
        <div class="alert alert-error">⚠ <%= error %></div>
    <% } %>
    <% if ("true".equals(request.getParameter("logout"))) { %>
        <div class="alert alert-success">✓ Đã đăng xuất thành công.</div>
    <% } %>

    <form action="<%= request.getContextPath() %>/login" method="post" autocomplete="off">
        <div class="form-group">
            <label class="form-label" for="username">Tài khoản</label>
            <div class="input-wrap">
                <span class="input-icon">👤</span>
                <input type="text" id="username" name="username" class="form-control"
                       placeholder="Nhập tên đăng nhập"
                       value="<%= request.getAttribute("username") != null ? request.getAttribute("username") : "" %>"
                       required autofocus>
            </div>
        </div>

        <div class="form-group">
            <label class="form-label" for="password">Mật khẩu</label>
            <div class="input-wrap">
                <span class="input-icon">🔒</span>
                <input type="password" id="password" name="password" class="form-control"
                       placeholder="Nhập mật khẩu" required>
                <button type="button" class="pwd-toggle" onclick="togglePwd()" title="Hiện/ẩn mật khẩu">👁</button>
            </div>
        </div>

        <button type="submit" class="btn-login">Đăng nhập →</button>
    </form>

    <p class="hint">Hệ thống dành cho <span>ADMIN</span> &amp; <span>STAFF</span></p>
</div>

<script>
    function togglePwd() {
        const pwd = document.getElementById('password');
        pwd.type = pwd.type === 'password' ? 'text' : 'password';
    }
</script>
</body>
</html>
