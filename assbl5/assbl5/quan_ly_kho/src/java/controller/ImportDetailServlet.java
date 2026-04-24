package controller;

import dao.ReceiptDetailDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.ImportReceiptView;

public class ImportDetailServlet extends HttpServlet {

    private final ReceiptDetailDAO dao = new ReceiptDetailDAO();

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

        ImportReceiptView receipt = dao.getImportReceipt(id);
        if (receipt == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Receipt not found");
            return;
        }

        request.setAttribute("receipt", receipt);
        request.setAttribute("lines", dao.getImportLines(id));
        request.getRequestDispatcher("import-detail.jsp").forward(request, response);
    }
}

