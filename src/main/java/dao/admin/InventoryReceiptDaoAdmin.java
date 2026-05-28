package dao.admin;

import dao.core.BaseDao;
import model.InventoryReceipt;
import model.InventoryReceiptDetail;

import java.time.LocalDateTime;
import java.util.List;

public class InventoryReceiptDaoAdmin extends BaseDao {

    public boolean addReceiptAndUpdateStock(InventoryReceipt receipt, List<InventoryReceiptDetail> details) {
        return getJdbi().inTransaction(handle -> {
            try {

                int receiptId = handle.createUpdate("INSERT INTO inventory_receipts (user_id, type, note, total_amount, created_at, status, supplier, order_id) " +
                                "VALUES (:userId, :type, :note, :totalAmount, :createdAt, :status, :supplier, :orderId)")
                        .bind("userId", receipt.getUserId())
                        .bind("type", receipt.getType())
                        .bind("note", receipt.getNote())
                        .bind("totalAmount", receipt.getTotalAmount())
                        .bind("createdAt", LocalDateTime.now())
                        .bind("status", "COMPLETED")
                        .bind("supplier", receipt.getSupplier())
                        .bind("orderId", receipt.getOrderId())
                        .executeAndReturnGeneratedKeys()
                        .mapTo(Integer.class)
                        .one();

                for (InventoryReceiptDetail detail : details) {
                    if ("IMPORT".equalsIgnoreCase(receipt.getType()) && detail.getProductVariantId() == 0) {
                        Integer variantId = handle.createQuery("SELECT id FROM product_variants WHERE product_id = :pId AND color_id = :cId AND size_id = :sId LIMIT 1")
                                .bind("pId", detail.getProductId())
                                .bind("cId", detail.getColorId())
                                .bind("sId", detail.getSizeId())
                                .mapTo(Integer.class)
                                .findOne().orElse(null);
                        
                        if (variantId == null) {
                            variantId = handle.createUpdate("INSERT INTO product_variants (product_id, color_id, size_id, stock) VALUES (:pId, :cId, :sId, 0)")
                                    .bind("pId", detail.getProductId())
                                    .bind("cId", detail.getColorId())
                                    .bind("sId", detail.getSizeId())
                                    .executeAndReturnGeneratedKeys()
                                    .mapTo(Integer.class)
                                    .one();
                        }
                        detail.setProductVariantId(variantId);
                    }
                    handle.createUpdate("INSERT INTO inventory_receipt_details (receipt_id, product_variant_id, quantity, price) " +
                                    "VALUES (:receiptId, :productVariantId, :quantity, :price)")
                            .bind("receiptId", receiptId)
                            .bind("productVariantId", detail.getProductVariantId())
                            .bind("quantity", detail.getQuantity())
                            .bind("price", detail.getPrice())
                            .execute();


                    if ("IMPORT".equalsIgnoreCase(receipt.getType()) || "RETURN".equalsIgnoreCase(receipt.getType())) {
                        handle.createUpdate("UPDATE product_variants SET stock = stock + :quantity WHERE id = :productVariantId")
                                .bind("quantity", detail.getQuantity())
                                .bind("productVariantId", detail.getProductVariantId())
                                .execute();
                    } else if ("EXPORT".equalsIgnoreCase(receipt.getType())) {
                        int affectedRows = handle.createUpdate("UPDATE product_variants SET stock = stock - :quantity WHERE id = :productVariantId AND stock >= :quantity")
                                .bind("quantity", detail.getQuantity())
                                .bind("productVariantId", detail.getProductVariantId())
                                .execute();
                        if (affectedRows == 0) {
                            throw new RuntimeException("Không đủ tồn kho để xuất cho mã biến thể: " + detail.getProductVariantId());
                        }
                    }
                }
                return true;
            } catch (Exception e) {
                handle.rollback(); 
                e.printStackTrace();
                return false;
            }
        });
    }

    public List<InventoryReceipt> getAllReceipts() {
        return getJdbi().withHandle(handle ->
                handle.createQuery("SELECT r.*, u.full_name as user_name FROM inventory_receipts r " +
                                "LEFT JOIN users u ON r.user_id = u.id ORDER BY r.created_at DESC")
                        .mapToBean(InventoryReceipt.class)
                        .list()
        );
    }

    public List<InventoryReceiptDetail> getReceiptDetails(int receiptId) {
        return getJdbi().withHandle(handle ->
                handle.createQuery("SELECT d.*, p.name as product_name, c.name as color_name, s.code as size_name " +
                                "FROM inventory_receipt_details d " +
                                "JOIN product_variants pv ON d.product_variant_id = pv.id " +
                                "JOIN products p ON pv.product_id = p.id " +
                                "JOIN colors c ON pv.color_id = c.id " +
                                "JOIN sizes s ON pv.size_id = s.id " +
                                "WHERE d.receipt_id = :receiptId")
                        .bind("receiptId", receiptId)
                        .mapToBean(InventoryReceiptDetail.class)
                        .list()
        );
    }

//Tạo phiếu xuất kho tự động trong một Handle (transaction) bên ngoài.
//Được gọi từ OrderPlacementService trong cùng transaction đặt hàng.

    public void createExportReceiptInHandle(
            org.jdbi.v3.core.Handle handle,
            int orderId,
            java.util.List<model.OrderItem> items,
            int userId) {

        double totalAmount = items.stream()
                .mapToDouble(i -> i.getPrice() * i.getQuantity())
                .sum();

        int receiptId = handle.createUpdate(
                "INSERT INTO inventory_receipts (user_id, type, note, total_amount, created_at, status, order_id) " +
                "VALUES (:userId, 'EXPORT', :note, :totalAmount, NOW(), 'COMPLETED', :orderId)")
                .bind("userId", userId)
                .bind("note", "Xuất kho tự động theo đơn hàng #" + orderId)
                .bind("totalAmount", totalAmount)
                .bind("orderId", orderId)
                .executeAndReturnGeneratedKeys()
                .mapTo(Integer.class)
                .one();

        for (model.OrderItem item : items) {
            handle.createUpdate(
                    "INSERT INTO inventory_receipt_details (receipt_id, product_variant_id, quantity, price) " +
                    "VALUES (:receiptId, :variantId, :quantity, :price)")
                    .bind("receiptId", receiptId)
                    .bind("variantId", item.getVariantId())
                    .bind("quantity", item.getQuantity())
                    .bind("price", item.getPrice())
                    .execute();
        }
    }
}
