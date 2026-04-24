/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.UserAccount;
import dao.UserDAO;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author doand
 */
public class AccountServlet extends HttpServlet {
   
    private final UserDAO userDAO = new UserDAO();
    
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AccountServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AccountServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        UserAccount currentUser = getCurrentUser(request);
        if (currentUser == null || !currentUser.isAdmin()) {
            response.sendRedirect("dashboard?msg=permissionDenied");
            return;
        }

        String action = trim(request.getParameter("action"));
        if (action.isEmpty()) {
            request.setAttribute("users", userDAO.getAllUsers());
            request.getRequestDispatcher("account-list.jsp").forward(request, response);
            return;
        }

        if ("add".equals(action)) {
            request.setAttribute("formMode", "add");
            request.getRequestDispatcher("account-form.jsp").forward(request, response);
            return;
        }

        if ("edit".equals(action)) {
            long id = parseLong(request.getParameter("id"));
            UserAccount editUser = userDAO.getById(id);
            if (editUser == null) {
                response.sendRedirect("accounts?msg=notFound");
                return;
            }
            request.setAttribute("formMode", "edit");
            request.setAttribute("account", editUser);
            request.getRequestDispatcher("account-form.jsp").forward(request, response);
            return;
        }

        if ("delete".equals(action)) {
            long id = parseLong(request.getParameter("id"));
            if (id == currentUser.getMaNguoiDung()) {
                response.sendRedirect("accounts?msg=cannotDeleteSelf");
                return;
            }
            if (userDAO.hasReferences(id)) {
                response.sendRedirect("accounts?msg=hasReferences");
                return;
            }
            boolean deleted = userDAO.deleteUser(id);
            response.sendRedirect(deleted ? "accounts?msg=deleted" : "accounts?msg=error");
            return;
        }

        if ("toggle".equals(action)) {
            long id = parseLong(request.getParameter("id"));
            if (id == currentUser.getMaNguoiDung()) {
                response.sendRedirect("accounts?msg=cannotLockSelf");
                return;
            }
            UserAccount editUser = userDAO.getById(id);
            if (editUser == null) {
                response.sendRedirect("accounts?msg=notFound");
                return;
            }
            boolean updated = userDAO.updateStatus(id, !editUser.isActive());
            if (!updated) {
                response.sendRedirect("accounts?msg=error");
                return;
            }
            response.sendRedirect(editUser.isActive() ? "accounts?msg=locked" : "accounts?msg=unlocked");
            return;
        }

        response.sendRedirect("accounts");
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        UserAccount currentUser = getCurrentUser(request);
        if (currentUser == null || !currentUser.isAdmin()) {
            response.sendRedirect("dashboard?msg=permissionDenied");
            return;
        }

        String action = trim(request.getParameter("action"));
        if ("update".equals(action)) {
            handleUpdate(request, response, currentUser);
            return;
        }
        handleCreate(request, response);
    }

    private void handleCreate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = trim(request.getParameter("username"));
        String fullName = trim(request.getParameter("fullName"));
        String email = trim(request.getParameter("email"));
        String phone = trim(request.getParameter("phone"));
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String role = normalizeRole(request.getParameter("role"));
        boolean active = request.getParameter("active") != null;

        UserAccount form = buildFormUser(0, username, fullName, email, phone, role, active);
        request.setAttribute("formMode", "add");
        request.setAttribute("account", form);

        if (username.isEmpty() || fullName.isEmpty() || email.isEmpty() || password == null || password.isEmpty()) {
            request.setAttribute("error", "Vui long nhap day du thong tin bat buoc.");
            request.getRequestDispatcher("account-form.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Mat khau nhap lai khong khop.");
            request.getRequestDispatcher("account-form.jsp").forward(request, response);
            return;
        }

        if (userDAO.existsUsername(username)) {
            request.setAttribute("error", "Ten dang nhap da ton tai.");
            request.getRequestDispatcher("account-form.jsp").forward(request, response);
            return;
        }

        if (userDAO.existsEmail(email)) {
            request.setAttribute("error", "Email da ton tai.");
            request.getRequestDispatcher("account-form.jsp").forward(request, response);
            return;
        }

        boolean created = userDAO.createUser(username, password, fullName, email, phone, role, active);
        if (!created) {
            request.setAttribute("error", "Khong tao duoc tai khoan. Vui long thu lai.");
            request.getRequestDispatcher("account-form.jsp").forward(request, response);
            return;
        }

        response.sendRedirect("accounts?msg=created");
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response, UserAccount currentUser)
            throws ServletException, IOException {
        long id = parseLong(request.getParameter("id"));
        UserAccount dbUser = userDAO.getById(id);
        if (dbUser == null) {
            response.sendRedirect("accounts?msg=notFound");
            return;
        }

        String username = trim(request.getParameter("username"));
        String fullName = trim(request.getParameter("fullName"));
        String email = trim(request.getParameter("email"));
        String phone = trim(request.getParameter("phone"));
        String password = trim(request.getParameter("password"));
        String confirmPassword = trim(request.getParameter("confirmPassword"));
        String role = normalizeRole(request.getParameter("role"));
        boolean active = request.getParameter("active") != null;

        if (id == currentUser.getMaNguoiDung()) {
            role = dbUser.getVaiTro();
            active = dbUser.isActive();
        }

        UserAccount form = buildFormUser(id, username, fullName, email, phone, role, active);
        request.setAttribute("formMode", "edit");
        request.setAttribute("account", form);

        if (username.isEmpty() || fullName.isEmpty() || email.isEmpty()) {
            request.setAttribute("error", "Vui long nhap day du thong tin bat buoc.");
            request.getRequestDispatcher("account-form.jsp").forward(request, response);
            return;
        }

        if (!password.isEmpty() && !password.equals(confirmPassword)) {
            request.setAttribute("error", "Mat khau nhap lai khong khop.");
            request.getRequestDispatcher("account-form.jsp").forward(request, response);
            return;
        }

        if (userDAO.existsUsername(username, id)) {
            request.setAttribute("error", "Ten dang nhap da ton tai.");
            request.getRequestDispatcher("account-form.jsp").forward(request, response);
            return;
        }

        if (userDAO.existsEmail(email, id)) {
            request.setAttribute("error", "Email da ton tai.");
            request.getRequestDispatcher("account-form.jsp").forward(request, response);
            return;
        }

        boolean updated = userDAO.updateUser(id, username, password, fullName, email, phone, role, active);
        if (!updated) {
            request.setAttribute("error", "Khong cap nhat duoc tai khoan. Vui long thu lai.");
            request.getRequestDispatcher("account-form.jsp").forward(request, response);
            return;
        }

        if (id == currentUser.getMaNguoiDung()) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.setAttribute("user", userDAO.getById(id));
            }
        }

        response.sendRedirect("accounts?msg=updated");
    }

    private UserAccount buildFormUser(long id, String username, String fullName, String email,
            String phone, String role, boolean active) {
        UserAccount user = new UserAccount();
        user.setMaNguoiDung(id);
        user.setTenDangNhap(username);
        user.setHoTen(fullName);
        user.setEmail(email);
        user.setSoDienThoai(phone);
        user.setVaiTro(role);
        user.setActive(active);
        return user;
    }

    private UserAccount getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session == null ? null : (UserAccount) session.getAttribute("user");
    }

    private String normalizeRole(String role) {
        return "ADMIN".equalsIgnoreCase(trim(role)) ? "ADMIN" : "USER";
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }

    private long parseLong(String value) {
        try {
            return Long.parseLong(value);
        } catch (Exception e) {
            return 0;
        }
    }


    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
