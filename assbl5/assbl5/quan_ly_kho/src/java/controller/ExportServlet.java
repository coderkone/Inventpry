/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.ExportReceiptDAO;
import dao.ProductDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import model.ExportFormRow;
import model.Product;
import model.ReceiptItem;
import model.UserAccount;

/**
 *
 * @author doand
 */
public class ExportServlet extends HttpServlet {
   
    private final ProductDAO productDAO = new ProductDAO();
    private final ExportReceiptDAO exportReceiptDAO = new ExportReceiptDAO();
    private static final String SESSION_ITEMS_KEY = "exportFormItems";

   
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
       
    } 

   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession(true);
        ensureFormItems(session);
        loadFormData(request, session);
        request.getRequestDispatcher("export-form.jsp").forward(request, response);
    } 

  
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(true);
        UserAccount user = (UserAccount) session.getAttribute("user");
        ensureFormItems(session);

        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            action = "create";
        }

        try {
            if ("addRow".equals(action)) {
                List<ReceiptItem> items = readFormItemsFromRequest(request);
                items.add(buildEmptyRow());
                session.setAttribute(SESSION_ITEMS_KEY, items);

                loadFormData(request, session);
                request.getRequestDispatcher("export-form.jsp").forward(request, response);
                return;
            }

            if ("remove".equals(action)) {
                List<ReceiptItem> items = readFormItemsFromRequest(request);
                int index = parseIntSafe(request.getParameter("index"), -1);
                if (index >= 0 && index < items.size()) {
                    items.remove(index);
                }
                if (items.isEmpty()) {
                    items.add(buildEmptyRow());
                }
                session.setAttribute(SESSION_ITEMS_KEY, items);

                loadFormData(request, session);
                request.getRequestDispatcher("export-form.jsp").forward(request, response);
                return;
            }

            if ("refresh".equals(action)) {
                List<ReceiptItem> items = readFormItemsFromRequest(request);
                session.setAttribute(SESSION_ITEMS_KEY, items);

                loadFormData(request, session);
                request.getRequestDispatcher("export-form.jsp").forward(request, response);
                return;
            }

            // create
            String customerName = request.getParameter("customerName");
            String note = request.getParameter("note");
            List<ReceiptItem> items = buildItemsFromRequest(request);

            if (user == null) {
                throw new Exception("Vui long dang nhap de tao phieu xuat.");
            }
            if (items.isEmpty()) {
                throw new Exception("Phieu xuat phai co it nhat 1 dong san pham.");
            }

            // Direction 1: Always use export price from DB when saving
            Set<Long> ids = new HashSet<>();
            for (ReceiptItem it : items) {
                if (it.getProductId() > 0) {
                    ids.add(it.getProductId());
                }
            }
            Map<Long, Product> productMap = productDAO.getByIds(new ArrayList<>(ids));
            for (ReceiptItem it : items) {
                Product p = productMap.get(it.getProductId());
                if (p == null) {
                    throw new Exception("Khong tim thay san pham ID " + it.getProductId() + " de lay gia xuat.");
                }
                double dbPrice = p.getGiaXuat();
                it.setUnitPrice(dbPrice);
                it.setTotalPrice(it.getQuantity() * dbPrice);
            }

            String receiptCode = exportReceiptDAO.createExportReceipt(user.getMaNguoiDung(), customerName, note, items);
            session.removeAttribute(SESSION_ITEMS_KEY);
            response.sendRedirect("exports?msg=created&code=" + receiptCode);
        } catch (Exception e) {
            loadFormData(request, session);
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("export-form.jsp").forward(request, response);
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

    private void ensureFormItems(HttpSession session) {
        Object obj = session.getAttribute(SESSION_ITEMS_KEY);
        if (!(obj instanceof List)) {
            List<ReceiptItem> items = new ArrayList<>();
            items.add(buildEmptyRow());
            session.setAttribute(SESSION_ITEMS_KEY, items);
        } else {
            @SuppressWarnings("unchecked")
            List<ReceiptItem> items = (List<ReceiptItem>) obj;
            if (items.isEmpty()) {
                items.add(buildEmptyRow());
                session.setAttribute(SESSION_ITEMS_KEY, items);
            }
        }
    }

    private ReceiptItem buildEmptyRow() {
        ReceiptItem it = new ReceiptItem();
        it.setProductId(0);
        it.setQuantity(1);
        it.setUnitPrice(0);
        it.setTotalPrice(0);
        return it;
    }

    private List<ReceiptItem> readFormItemsFromRequest(HttpServletRequest request) {
        String[] productIds = request.getParameterValues("productId");
        String[] quantities = request.getParameterValues("quantity");
        String[] prices = request.getParameterValues("unitPrice");

        List<ReceiptItem> items = new ArrayList<>();
        if (productIds == null) {
            items.add(buildEmptyRow());
            return items;
        }

        for (int i = 0; i < productIds.length; i++) {
            ReceiptItem it = new ReceiptItem();
            long pid = parseLongSafe(productIds[i], 0);
            int qty = parseIntSafe(quantities != null && i < quantities.length ? quantities[i] : null, 1);
            double price = parseDoubleSafe(prices != null && i < prices.length ? prices[i] : null, 0);

            if (qty <= 0) qty = 1;
            if (price < 0) price = 0;

            it.setProductId(pid);
            it.setQuantity(qty);
            it.setUnitPrice(price);
            it.setTotalPrice(qty * price);
            items.add(it);
        }

        if (items.isEmpty()) {
            items.add(buildEmptyRow());
        }
        return items;
    }

    private void loadFormData(HttpServletRequest request, HttpSession session) {
        request.setAttribute("products", productDAO.getActiveForTransaction());

        @SuppressWarnings("unchecked")
        List<ReceiptItem> items = (List<ReceiptItem>) session.getAttribute(SESSION_ITEMS_KEY);
        if (items == null) {
            items = new ArrayList<>();
            items.add(buildEmptyRow());
            session.setAttribute(SESSION_ITEMS_KEY, items);
        }

        Set<Long> ids = new HashSet<>();
        for (ReceiptItem it : items) {
            if (it.getProductId() > 0) {
                ids.add(it.getProductId());
            }
        }
        Map<Long, Product> productMap = productDAO.getByIds(new ArrayList<>(ids));

        List<ExportFormRow> rows = new ArrayList<>();
        double grandTotal = 0;
        for (int i = 0; i < items.size(); i++) {
            ReceiptItem it = items.get(i);
            Product p = it.getProductId() > 0 ? productMap.get(it.getProductId()) : null;

            double unitPrice = it.getUnitPrice();
            int stock = 0;
            String label = "";
            if (p != null) {
                stock = p.getSoLuongTon();
                label = p.getMaHang() + " - " + p.getTenSanPham();
                if (unitPrice <= 0) {
                    unitPrice = p.getGiaXuat();
                }
            }

            int qty = it.getQuantity() <= 0 ? 1 : it.getQuantity();
            double lineTotal = qty * unitPrice;
            grandTotal += lineTotal;

            ExportFormRow row = new ExportFormRow();
            row.setIndex(i);
            row.setProductId(it.getProductId());
            row.setProductLabel(label);
            row.setStock(stock);
            row.setQuantity(qty);
            row.setUnitPrice(unitPrice);
            row.setLineTotal(lineTotal);
            rows.add(row);
        }

        request.setAttribute("rows", rows);
        request.setAttribute("grandTotal", grandTotal);
    }

    private int parseIntSafe(String s, int def) {
        try {
            if (s == null) return def;
            return Integer.parseInt(s.trim());
        } catch (Exception e) {
            return def;
        }
    }

    private long parseLongSafe(String s, long def) {
        try {
            if (s == null) return def;
            return Long.parseLong(s.trim());
        } catch (Exception e) {
            return def;
        }
    }

    private double parseDoubleSafe(String s, double def) {
        try {
            if (s == null) return def;
            return Double.parseDouble(s.trim());
        } catch (Exception e) {
            return def;
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
