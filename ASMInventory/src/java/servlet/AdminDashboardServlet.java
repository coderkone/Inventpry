package com.inventory.servlet;

import com.inventory.dao.UserDAO;
import com.inventory.model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class AdminDashboardServlet extends HttpServlet {

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

        req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp")
           .forward(req, resp);
    }
}