package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.InventoryReceipt;
import service.admin.InventoryServiceAdmin;

import java.io.IOException;
import java.util.List;

@WebServlet("/warehouseAdmin")
public class WarehouseAdminController extends HttpServlet {
    private final InventoryServiceAdmin inventoryService = new InventoryServiceAdmin();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        
        if ("view".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            req.setAttribute("receiptDetails", inventoryService.getReceiptDetails(id));
            req.setAttribute("page", "warehouse");
            req.getRequestDispatcher("/WEB-INF/admin/warehouseDetail.jsp").forward(req, resp);
            return;
        }

        List<InventoryReceipt> receipts = inventoryService.getAllReceipts();
        req.setAttribute("receipts", receipts);
        req.setAttribute("page", "warehouse");
        req.getRequestDispatcher("/WEB-INF/admin/warehouseAdmin.jsp").forward(req, resp);
    }
}
