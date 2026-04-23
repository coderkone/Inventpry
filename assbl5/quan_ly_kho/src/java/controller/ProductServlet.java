/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.CategoryDAO;
import dao.ProductDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Product;
import model.UserAccount;

/**
 *
 * @author doand
 */
public class ProductServlet extends HttpServlet {
   
    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

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
            out.println("<title>Servlet ProductServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ProductServlet at " + request.getContextPath () + "</h1>");
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
        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            request.setAttribute("products", productDAO.getAllActive());
            request.getRequestDispatcher("product-list.jsp").forward(request, response);
            return;
        }

        if ("add".equals(action)) {
            request.setAttribute("formMode", "add");
            request.setAttribute("categories", categoryDAO.getAll());
            request.getRequestDispatcher("product-form.jsp").forward(request, response);
            return;
        }

        if ("edit".equals(action)) {
            long id = Long.parseLong(request.getParameter("id"));
            request.setAttribute("formMode", "edit");
            request.setAttribute("product", productDAO.getById(id));
            request.setAttribute("categories", categoryDAO.getAll());
            request.getRequestDispatcher("product-form.jsp").forward(request, response);
            return;
        }

        if ("delete".equals(action)) {
            long id = Long.parseLong(request.getParameter("id"));
            productDAO.softDelete(id);
            response.sendRedirect("products?msg=deleted");
            return;
        }

        response.sendRedirect("products");
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
        HttpSession session = request.getSession(false);
        UserAccount user = (UserAccount) session.getAttribute("user");
        if (user == null || !user.isAdmin()) {
            response.sendRedirect("products?msg=permissionDenied");
            return;
        }

        String action = request.getParameter("action");
        Product p = new Product();
        p.setMaHang(request.getParameter("maHang"));
        p.setTenSanPham(request.getParameter("tenSanPham"));
        p.setMaLoaiHang(Integer.parseInt(request.getParameter("maLoaiHang")));
        p.setDonViTinh(request.getParameter("donViTinh"));
        p.setGiaNhap(Double.parseDouble(request.getParameter("giaNhap")));
        p.setGiaXuat(Double.parseDouble(request.getParameter("giaXuat")));
        p.setMoTa(request.getParameter("moTa"));

        if ("save".equals(action)) {
            p.setSoLuongTon(Integer.parseInt(request.getParameter("soLuongTon")));
            if (productDAO.existsProductCode(p.getMaHang(), null)) {
                request.setAttribute("error", "Ma hang da ton tai.");
                request.setAttribute("formMode", "add");
                request.setAttribute("categories", categoryDAO.getAll());
                request.setAttribute("product", p);
                request.getRequestDispatcher("product-form.jsp").forward(request, response);
                return;
            }
            productDAO.addProduct(p);
            response.sendRedirect("products?msg=created");
            return;
        }

        if ("update".equals(action)) {
            p.setMaSanPham(Long.parseLong(request.getParameter("id")));
            if (productDAO.existsProductCode(p.getMaHang(), p.getMaSanPham())) {
                Product productInDb = productDAO.getById(p.getMaSanPham());
                p.setSoLuongTon(productInDb != null ? productInDb.getSoLuongTon() : 0);
                request.setAttribute("error", "Ma hang da ton tai.");
                request.setAttribute("formMode", "edit");
                request.setAttribute("categories", categoryDAO.getAll());
                request.setAttribute("product", p);
                request.getRequestDispatcher("product-form.jsp").forward(request, response);
                return;
            }
            productDAO.updateProduct(p);
            response.sendRedirect("products?msg=updated");
            return;
        }

        response.sendRedirect("products");
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
