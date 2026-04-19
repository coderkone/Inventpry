<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.inventory.model.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
    String currentPath = request.getRequestURI();
%>
<!DOCTYPE html>
<!-- This file is included as a partial — do not use as standalone -->
<style>
    :root {
        --bg:      #0d1117;
        --surface: #161b22;
        --border:  #30363d;
        --accent:  #f0a500;
        --accent2: #e05c00;
        --text:    #e6edf3;
        --muted:   #7d8590;
        --danger:  #f85149;
        --success: #3fb950;
        --sidebar-w: 240px;
    }
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    body {
        font-family: 'DM Sans', sans-serif;
        background: var(--bg);
        color: var(--text);
        display: flex;
        min-height: 100vh;
    }

    /* ===== SIDEBAR ===== */
    .sidebar {
        width: var(--sidebar-w);
        background: var(--surface);
        border-right: 1px solid var(--border);
        display: flex;
        flex-direction: column;
        position: fixed;
        top: 0; bottom: 0; left: 0;
        z-index: 100;
    }
    .sidebar-logo {
        padding: 22px 20px 18px;
        display: flex; align-items: center; gap: 10px;
        border-bottom: 1px solid var(--border);
    }
    .sidebar-logo .icon {
        width: 36px; height: 36px;
        background: linear-gradient(135deg, var(--accent), var(--accent2));
        border-radius: 8px;
        display: flex; align-items: center; justify-content: center;
        font-size: 16px; flex-shrink: 0;
    }
    .sidebar-logo .name { font-size: 15px; font-weight: 600; }
    .sidebar-logo .ver  { font-size: 11px; color: var(--muted); }

    .nav-section { padding: 18px 12px 6px; }
    .nav-label   { font-size: 10px; font-weight: 600; color: var(--muted); letter-spacing: 1px; text-transform: uppercase; padding: 0 8px; margin-bottom: 6px; }

    .nav-item {
        display: flex; align-items: center; gap: 10px;
        padding: 9px 10px;
        border-radius: 8px;
        text-decoration: none;
        color: var(--muted);
        font-size: 14px; font-weight: 500;
        transition: background .15s, color .15s;
        margin-bottom: 2px;
    }
    .nav-item:hover  { background: rgba(240,165,0,.08); color: var(--text); }
    .nav-item.active { background: rgba(240,165,0,.14); color: var(--accent); }
    .nav-item .nav-icon { font-size: 16px; width: 20px; text-align: center; }

    /* Role badge */
    .role-badge {
        display: inline-flex; align-items: center;
        padding: 2px 8px; border-radius: 20px;
        font-size: 10px; font-weight: 600; letter-spacing: .5px;
        text-transform: uppercase; margin-left: auto;
    }
    .badge-admin { background: rgba(240,165,0,.18); color: var(--accent); }
    .badge-staff { background: rgba(63,185,80,.18); color: var(--success); }

    /* Sidebar footer */
    .sidebar-footer {
        margin-top: auto;
        padding: 16px 12px;
        border-top: 1px solid var(--border);
    }
    .user-info {
        display: flex; align-items: center; gap: 10px;
        padding: 10px;
        border-radius: 8px;
        background: rgba(255,255,255,.03);
        margin-bottom: 10px;
    }
    .avatar {
        width: 34px; height: 34px;
        background: linear-gradient(135deg, var(--accent), var(--accent2));
        border-radius: 50%;
        display: flex; align-items: center; justify-content: center;
        font-size: 14px; font-weight: 700; color: #0d1117;
        flex-shrink: 0;
    }
    .user-name { font-size: 13.5px; font-weight: 500; }
    .user-role { font-size: 11px; color: var(--muted); }

    .btn-logout {
        display: flex; align-items: center; justify-content: center; gap: 8px;
        width: 100%; padding: 9px;
        background: rgba(248,81,73,.1);
        border: 1px solid rgba(248,81,73,.25);
        border-radius: 8px;
        color: var(--danger); font-family: 'DM Sans', sans-serif;
        font-size: 13.5px; font-weight: 500; cursor: pointer;
        text-decoration: none;
        transition: background .15s;
    }
    .btn-logout:hover { background: rgba(248,81,73,.18); }

    /* ===== MAIN CONTENT ===== */
    .main {
        margin-left: var(--sidebar-w);
        flex: 1;
        display: flex;
        flex-direction: column;
    }
    .topbar {
        height: 58px;
        background: var(--surface);
        border-bottom: 1px solid var(--border);
        display: flex; align-items: center;
        padding: 0 28px;
        gap: 12px;
    }
    .topbar-title { font-size: 16px; font-weight: 600; }
    .topbar-sep   { color: var(--border); }
    .topbar-sub   { font-size: 13px; color: var(--muted); }
    .topbar-right { margin-left: auto; display: flex; align-items: center; gap: 10px; }

    .content { padding: 28px; flex: 1; }
</style>
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
