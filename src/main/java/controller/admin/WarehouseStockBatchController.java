package controller.admin;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.WarehouseStockBatchDto;
import service.admin.InventoryServiceAdmin;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/warehouseStockBatch")
public class WarehouseStockBatchController extends HttpServlet {
    private final InventoryServiceAdmin inventoryService = new InventoryServiceAdmin();
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json;charset=UTF-8");
        
        try {
            String variantIdStr = request.getParameter("variantId");
            if (variantIdStr == null || variantIdStr.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Mã biến thể không hợp lệ!\"}");
                return;
            }

            int variantId = Integer.parseInt(variantIdStr);
            List<WarehouseStockBatchDto> batches = inventoryService.getVariantImportBatches(variantId);
            
            String json = objectMapper.writeValueAsString(batches);
            response.getWriter().write(json);
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Lỗi máy chủ nội bộ!\"}");
        }
    }
}
