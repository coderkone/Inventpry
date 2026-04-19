package com.inventory.filter;

import com.inventory.model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * AuthFilter – chặn các URL yêu cầu đăng nhập và phân quyền theo role.
 * Mapping được khai báo trong web.xml.
 *
 * Luồng kiểm tra:
 *  1. URL công khai (/login, /css, /js) → cho qua
 *  2. Chưa đăng nhập → redirect /login
 *  3. Truy cập /admin/* mà không phải ADMIN → 403
 *  4. Còn lại → cho qua
 */
public class AuthFilter implements Filter {

    // Các đường dẫn không cần xác thực
    private static final String[] PUBLIC_PATHS = {
        "/login", "/css/", "/js/", "/images/", "/favicon.ico"
    };

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  req  = (HttpServletRequest)  request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String contextPath = req.getContextPath();                 // e.g. "/inventory"
        String requestURI  = req.getRequestURI();                  // e.g. "/inventory/admin/dashboard"
        String path        = requestURI.substring(contextPath.length()); // e.g. "/admin/dashboard"

        // --- 1. Cho qua URL công khai ---
        if (isPublicPath(path)) {
            chain.doFilter(request, response);
            return;
        }

        // --- 2. Kiểm tra đăng nhập ---
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            resp.sendRedirect(contextPath + "/login");
            return;
        }

        // --- 3. Phân quyền: chỉ ADMIN mới vào /admin/* ---
        if (path.startsWith("/admin/") || path.equals("/admin")) {
            if (!user.isAdmin()) {
                resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
                req.setAttribute("errorMessage", "Bạn không có quyền truy cập trang này.");
                req.getRequestDispatcher("/WEB-INF/views/error403.jsp").forward(req, resp);
                return;
            }
        }

        // --- 4. Phân quyền: STAFF không vào trang quản lý user ---
        if (path.startsWith("/admin/users") && !user.isAdmin()) {
            resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
            req.setAttribute("errorMessage", "Chỉ ADMIN mới có thể quản lý người dùng.");
            req.getRequestDispatcher("/WEB-INF/views/error403.jsp").forward(req, resp);
            return;
        }

        chain.doFilter(request, response);
    }

    private boolean isPublicPath(String path) {
        for (String pub : PUBLIC_PATHS) {
            if (path.equals(pub) || path.startsWith(pub)) {
                return true;
            }
        }
        return false;
    }

    @Override public void init(FilterConfig config) {}
    @Override public void destroy() {}
}
