package com.inventory.servlet;

import com.inventory.dao.UserDAO;
import com.inventory.model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class LoginServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            redirectByRole(user, req, resp);
            return;
        }

        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {

            req.setAttribute("error", "Vui lòng nhập đầy đủ tài khoản và mật khẩu.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        User user = userDAO.authenticate(username.trim(), password.trim());

        if (user == null) {
            req.setAttribute("error", "Tài khoản hoặc mật khẩu không đúng.");
            req.setAttribute("username", username);
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        HttpSession session = req.getSession();
        session.invalidate();
        session = req.getSession(true);

        session.setAttribute("user", user);
        session.setMaxInactiveInterval(30 * 60);

        redirectByRole(user, req, resp);
    }

    private void redirectByRole(User user, HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        String contextPath = req.getContextPath();

        if (user.isAdmin()) {
            resp.sendRedirect(resp.encodeRedirectURL(contextPath + "/admin/dashboard"));
        } else {
            resp.sendRedirect(resp.encodeRedirectURL(contextPath + "/staff/dashboard"));
        }
    }
}