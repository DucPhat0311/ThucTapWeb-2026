package service.admin;

import dao.admin.InventoryReceiptDaoAdmin;
import model.InventoryReceipt;
import model.InventoryReceiptDetail;

import java.util.List;

public class InventoryServiceAdmin {
    private InventoryReceiptDaoAdmin inventoryDao;

    public InventoryServiceAdmin() {
        this.inventoryDao = new InventoryReceiptDaoAdmin();
    }

    public boolean processInventoryReceipt(InventoryReceipt receipt, List<InventoryReceiptDetail> details) {
        if (receipt == null || details == null || details.isEmpty()) {
            return false;
        }

        double totalAmount = 0;
        for (InventoryReceiptDetail detail : details) {
            totalAmount += (detail.getPrice() * detail.getQuantity());
        }
        receipt.setTotalAmount(totalAmount);

        return inventoryDao.addReceiptAndUpdateStock(receipt, details);
    }

    public List<InventoryReceipt> getAllReceipts() {
        return inventoryDao.getAllReceipts();
    }

    public List<InventoryReceiptDetail> getReceiptDetails(int receiptId) {
        if (receiptId <= 0) {
            return null;
        }
        return inventoryDao.getReceiptDetails(receiptId);
    }

    public List<model.WarehouseStockDto> getWarehouseStockReport() {
        return inventoryDao.getWarehouseStockReport();
    }
}
