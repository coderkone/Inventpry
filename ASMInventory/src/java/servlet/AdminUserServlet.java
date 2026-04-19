package com.inventory.servlet;

import com.inventory.dao.UserDAO;
import com.inventory.model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class AdminUserServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<User> users = userDAO.findAll();
        req.setAttribute("users", users);

        req.getRequestDispatcher("/WEB-INF/views/admin/users.jsp")
           .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        switch (action == null ? "" : action) {
            case "add":
                addUser(req);
                break;
            case "updateRole":
                updateRole(req);
                break;
            case "delete":
                deleteUser(req);
                break;
        }

        resp.sendRedirect(req.getContextPath() + "/admin/users");
    }

    private void addUser(HttpServletRequest req) {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String role     = req.getParameter("role");

        if (username != null && password != null && role != null) {
            User user = new User();
            user.setUsername(username.trim());
            user.setPassword(password.trim());
            user.setRole(role.trim().toUpperCase());
            userDAO.insert(user);
        }
    }

    private void updateRole(HttpServletRequest req) {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            String role = req.getParameter("role");
            userDAO.updateRole(id, role.toUpperCase());
        } catch (NumberFormatException ignored) {}
    }

    private void deleteUser(HttpServletRequest req) {
        try {
            int id = Integer.parseInt(req.getParameter("id"));

            User current = (User) req.getSession().getAttribute("user");
            if (current != null && current.getId() != id) {
                userDAO.delete(id);
            }
        } catch (NumberFormatException ignored) {}
    }
}