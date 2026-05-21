package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.InventoryReceipt;
import model.InventoryReceiptDetail;
import service.admin.InventoryServiceAdmin;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import dao.admin.ProductDaoAdmin;
import dao.admin.ProductVariantDaoAdmin;

@WebServlet("/admin/warehouseImportForm")
public class WarehouseImportFormController extends HttpServlet {
    private final InventoryServiceAdmin inventoryService = new InventoryServiceAdmin();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ProductVariantDaoAdmin variantDao = new ProductVariantDaoAdmin();
        request.setAttribute("variants", variantDao.getAllVariantsWithDetails());
        request.setAttribute("page", "warehouse");
        
        request.getRequestDispatcher("/WEB-INF/admin/warehouseImportForm.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String supplier = request.getParameter("supplier");
            String note = request.getParameter("note");
            
            InventoryReceipt receipt = new InventoryReceipt();
            receipt.setType("IMPORT");
            receipt.setNote(note);
            receipt.setSupplier(supplier);

            model.User user = (model.User) request.getSession().getAttribute("adminLogined");
            receipt.setUserId(user != null ? user.getId() : 1);

            String[] variantIds = request.getParameterValues("productVariantId[]");
            String[] quantities = request.getParameterValues("quantity[]");
            String[] prices = request.getParameterValues("price[]");

            List<InventoryReceiptDetail> details = new ArrayList<>();
            
            if (variantIds != null && quantities != null && prices != null) {
                for (int i = 0; i < variantIds.length; i++) {
                    InventoryReceiptDetail detail = new InventoryReceiptDetail();
                    detail.setProductVariantId(Integer.parseInt(variantIds[i]));
                    detail.setQuantity(Integer.parseInt(quantities[i]));
                    detail.setPrice(Double.parseDouble(prices[i]));
                    details.add(detail);
                }
            }

            boolean isSuccess = inventoryService.processInventoryReceipt(receipt, details);
            
            if (isSuccess) {
                request.getSession().setAttribute("message", "Thêm phiếu nhập kho thành công!");
            } else {
                request.getSession().setAttribute("error", "Có lỗi xảy ra khi tạo phiếu!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Dữ liệu form không hợp lệ!");
        }

        response.sendRedirect(request.getContextPath() + "/warehouseAdmin");
    }
}
