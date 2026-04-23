package filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.UserAccount;

public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        String uri = req.getRequestURI();
        String context = req.getContextPath();

        if (uri.endsWith("/login") || uri.contains("login.jsp")
                || uri.endsWith("/register") || uri.contains("register.jsp")
                || uri.endsWith(".css") || uri.endsWith(".js")
                || uri.endsWith(".png") || uri.endsWith(".jpg")
                || uri.endsWith(".jpeg") || uri.endsWith(".gif")) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            res.sendRedirect(context + "/login");
            return;
        }

        UserAccount user = (UserAccount) session.getAttribute("user");
        String action = req.getParameter("action");

        if (!user.isAdmin() && uri.contains("/accounts")) {
            res.sendRedirect(context + "/dashboard?msg=permissionDenied");
            return;
        }

        if (!user.isAdmin() && uri.contains("/products") && action != null
                && ("add".equals(action) || "edit".equals(action) || "delete".equals(action)
                || "save".equals(action) || "update".equals(action))) {
            res.sendRedirect(context + "/products?msg=permissionDenied");
            return;
        }

        chain.doFilter(request, response);
    }
}
