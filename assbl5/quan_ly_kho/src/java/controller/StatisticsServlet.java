/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.CategoryDAO;
import dao.StatisticsDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.ProductStatisticRow;
import model.ProductStatisticSummary;

/**
 *
 * @author doand
 */
public class StatisticsServlet extends HttpServlet {
   
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
            out.println("<title>Servlet StatisticsServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet StatisticsServlet at " + request.getContextPath () + "</h1>");
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
        StatisticsDAO statisticsDAO = new StatisticsDAO();
        CategoryDAO categoryDAO = new CategoryDAO();

        String keyword = trimToEmpty(request.getParameter("keyword"));
        Integer categoryId = parseCategoryId(request.getParameter("categoryId"));
        String stockFilter = normalizeStockFilter(request.getParameter("stockFilter"));
        String sortBy = normalizeSortBy(request.getParameter("sortBy"));

        List<ProductStatisticRow> rows = statisticsDAO.getProductStatistics(keyword, categoryId, stockFilter, sortBy);

        request.setAttribute("keyword", keyword);
        request.setAttribute("categoryId", categoryId == null ? 0 : categoryId);
        request.setAttribute("stockFilter", stockFilter);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("categories", categoryDAO.getAll());
        request.setAttribute("statisticsRows", rows);
        request.setAttribute("summary", buildSummary(rows));
        request.getRequestDispatcher("statistics.jsp").forward(request, response);
    }

    private String trimToEmpty(String value) {
        return value == null ? "" : value.trim();
    }

    private Integer parseCategoryId(String value) {
        try {
            if (value == null || value.trim().isEmpty()) {
                return null;
            }
            int id = Integer.parseInt(value.trim());
            return id > 0 ? id : null;
        } catch (Exception e) {
            return null;
        }
    }

    private String normalizeStockFilter(String value) {
        if ("low".equals(value) || "out".equals(value) || "available".equals(value)) {
            return value;
        }
        return "all";
    }

    private String normalizeSortBy(String value) {
        if ("stockAsc".equals(value) || "importDesc".equals(value)
                || "exportDesc".equals(value) || "valueDesc".equals(value)) {
            return value;
        }
        return "nameAsc";
    }

    private ProductStatisticSummary buildSummary(List<ProductStatisticRow> rows) {
        ProductStatisticSummary summary = new ProductStatisticSummary();
        summary.setTotalProducts(rows.size());

        for (ProductStatisticRow row : rows) {
            summary.setTotalStockQuantity(summary.getTotalStockQuantity() + row.getSoLuongTon());
            summary.setTotalInventoryValue(summary.getTotalInventoryValue() + row.getGiaTriTon());
            summary.setTotalImportQuantity(summary.getTotalImportQuantity() + row.getTongNhap());
            summary.setTotalImportValue(summary.getTotalImportValue() + row.getGiaTriNhap());
            summary.setTotalExportQuantity(summary.getTotalExportQuantity() + row.getTongXuat());
            summary.setTotalExportValue(summary.getTotalExportValue() + row.getGiaTriXuat());

            if (row.getSoLuongTon() <= 0) {
                summary.setOutOfStockCount(summary.getOutOfStockCount() + 1);
            } else if (row.getSoLuongTon() <= 10) {
                summary.setLowStockCount(summary.getLowStockCount() + 1);
            }
        }
        return summary;
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
        processRequest(request, response);
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
