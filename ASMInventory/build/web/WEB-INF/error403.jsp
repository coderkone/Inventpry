<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>403 – Không có quyền</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;600&family=DM+Mono:wght@500&display=swap" rel="stylesheet">
    <style>
        body { font-family:'DM Sans',sans-serif; background:#0d1117; color:#e6edf3; display:flex; align-items:center; justify-content:center; min-height:100vh; margin:0; }
        .box { text-align:center; max-width:420px; }
        .code { font-size:96px; font-family:'DM Mono',monospace; color:#f0a500; line-height:1; }
        h1   { font-size:22px; margin:16px 0 8px; }
        p    { color:#7d8590; font-size:14px; line-height:1.6; }
        .btn { display:inline-block; margin-top:24px; padding:10px 22px; background:#f0a500; color:#0d1117; border-radius:8px; text-decoration:none; font-weight:600; }
        .btn:hover { opacity:.9; }
    </style>
</head>
<body>
<div class="box">
    <div class="code">403</div>
    <h1>Không có quyền truy cập</h1>
    <p><%= request.getAttribute("errorMessage") != null ? request.getAttribute("errorMessage") : "Bạn không có quyền xem trang này." %></p>
    <a href="<%= request.getContextPath() %>/" class="btn">← Quay lại</a>
</div>
</body>
</html>
