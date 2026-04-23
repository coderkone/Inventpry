/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.ImportReceiptDAO;
import dao.ProductDAO;
import dao.SupplierDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;
import model.ReceiptItem;
import model.UserAccount;

/**
 *
 * @author doand
 */
public class ImportServlet extends HttpServlet {

    private final SupplierDAO supplierDAO = new SupplierDAO();
    private final ProductDAO productDAO = new ProductDAO();
    private final ImportReceiptDAO importReceiptDAO = new ImportReceiptDAO();

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
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
            out.println("<title>Servlet ImportServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ImportServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        loadFormData(request);
        request.getRequestDispatcher("import-form.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
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

        try {
            long supplierId = Long.parseLong(request.getParameter("supplierId"));
            String note = request.getParameter("note");
            List<ReceiptItem> items = buildItemsFromRequest(request);

            if (items.isEmpty()) {
                throw new Exception("Phieu nhap phai co it nhat 1 dong san pham.");
            }

            String receiptCode = importReceiptDAO.createImportReceipt(supplierId, user.getMaNguoiDung(), note, items);
            response.sendRedirect("imports?msg=created&code=" + receiptCode);
        } catch (Exception e) {
            loadFormData(request);
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("import-form.jsp").forward(request, response);
        }
    }

    private List<ReceiptItem> buildItemsFromRequest(HttpServletRequest request) throws Exception {
        java.util.Map<Long, ReceiptItem> itemMap = new java.util.LinkedHashMap<>();
        String[] productIds = request.getParameterValues("productId");
        String[] quantities = request.getParameterValues("quantity");
        String[] prices = request.getParameterValues("unitPrice");

        if (productIds == null) {
            return new ArrayList<>();
        }

        for (int i = 0; i < productIds.length; i++) {
            if (productIds[i] == null || productIds[i].trim().isEmpty()) {
                continue;
            }
            long productId = Long.parseLong(productIds[i]);
            int qty = Integer.parseInt(quantities[i]);
            double price = Double.parseDouble(prices[i]);
            if (qty <= 0 || price < 0) {
                continue;
            }

            ReceiptItem existing = itemMap.get(productId);
            if (existing == null) {
                ReceiptItem item = new ReceiptItem();
                item.setProductId(productId);
                item.setQuantity(qty);
                item.setUnitPrice(price);
                item.setTotalPrice(qty * price);
                itemMap.put(productId, item);
            } else {
                existing.setQuantity(existing.getQuantity() + qty);
                existing.setUnitPrice(price);
                existing.setTotalPrice(existing.getQuantity() * existing.getUnitPrice());
            }
        }
        return new ArrayList<>(itemMap.values());
    }

    private void loadFormData(HttpServletRequest request) {
        request.setAttribute("suppliers", supplierDAO.getAllActive());
        request.setAttribute("products", productDAO.getActiveForTransaction());
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
