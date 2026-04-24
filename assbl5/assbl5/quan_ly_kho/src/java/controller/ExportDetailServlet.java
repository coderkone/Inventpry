package controller;

import dao.ReceiptDetailDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.ExportReceiptView;

public class ExportDetailServlet extends HttpServlet {

    ReceiptDetailDAO dao = new ReceiptDetailDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idRaw = request.getParameter("id");
        if (idRaw == null || idRaw.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing id");
            return;
        }

        long id;
        try {
            id = Long.parseLong(idRaw);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid id");
            return;
        }

        ExportReceiptView receipt = dao.getExportReceipt(id);
        if (receipt == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Receipt not found");
            return;
        }

        request.setAttribute("receipt", receipt);
        request.setAttribute("lines", dao.getExportLines(id));
        request.getRequestDispatcher("export-detail.jsp").forward(request, response);
    }
}

