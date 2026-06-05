package dao.admin;

import dao.core.BaseDao;
import model.InventoryReceipt;
import model.InventoryReceiptDetail;

import java.time.LocalDateTime;
import java.util.List;

public class InventoryReceiptDaoAdmin extends BaseDao {

    public InventoryReceiptDaoAdmin() {
        super();
        try {
            getJdbi().useHandle(handle -> {
                try {
                    handle.execute("ALTER TABLE inventory_receipt_details ADD COLUMN remaining_quantity INT NOT NULL DEFAULT 0");
                    handle.execute("UPDATE inventory_receipt_details SET remaining_quantity = quantity WHERE remaining_quantity = 0");
                } catch (Exception e) {
                }
                try {
                    handle.execute("ALTER TABLE inventory_receipt_details ADD COLUMN cost_price DECIMAL(15,2) NULL DEFAULT NULL");
                } catch (Exception e) {
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private double deductFifo(org.jdbi.v3.core.Handle handle, int variantId, int quantity) {
        List<java.util.Map<String, Object>> batches = handle.createQuery(
                "SELECT d.id, d.remaining_quantity, d.price " +
                "FROM inventory_receipt_details d " +
                "JOIN inventory_receipts r ON d.receipt_id = r.id " +
                "WHERE d.product_variant_id = :vid " +
                "  AND r.type = 'IMPORT' " +
                "  AND d.remaining_quantity > 0 " +
                "ORDER BY r.created_at ASC, r.id ASC")
                .bind("vid", variantId)
                .mapToMap()
                .list();

        int remaining = quantity;
        double totalCost = 0.0;
        int totalDeducted = 0;

        for (java.util.Map<String, Object> batch : batches) {
            if (remaining <= 0) break;

            int batchRemaining = ((Number) batch.get("remaining_quantity")).intValue();
            double batchPrice  = ((Number) batch.get("price")).doubleValue();
            Object batchId     = batch.get("id");
            int deduct         = Math.min(remaining, batchRemaining);

            handle.createUpdate(
                    "UPDATE inventory_receipt_details " +
                    "SET remaining_quantity = remaining_quantity - :d " +
                    "WHERE id = :id")
                    .bind("d", deduct)
                    .bind("id", batchId)
                    .execute();

            totalCost     += deduct * batchPrice;
            totalDeducted += deduct;
            remaining     -= deduct;
        }

        return totalDeducted > 0 ? totalCost / totalDeducted : 0.0;
    }

    public boolean addReceiptAndUpdateStock(InventoryReceipt receipt, List<InventoryReceiptDetail> details) {
        return getJdbi().inTransaction(handle -> {
            try {
                int receiptId = handle.createUpdate(
                        "INSERT INTO inventory_receipts (user_id, type, note, total_amount, created_at, status, supplier, order_id) " +
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
                        Integer variantId = handle.createQuery(
                                "SELECT id FROM product_variants WHERE product_id = :pId AND color_id = :cId AND size_id = :sId LIMIT 1")
                                .bind("pId", detail.getProductId())
                                .bind("cId", detail.getColorId())
                                .bind("sId", detail.getSizeId())
                                .mapTo(Integer.class)
                                .findOne().orElse(null);

                        if (variantId == null) {
                            variantId = handle.createUpdate(
                                    "INSERT INTO product_variants (product_id, color_id, size_id, stock) VALUES (:pId, :cId, :sId, 0)")
                                    .bind("pId", detail.getProductId())
                                    .bind("cId", detail.getColorId())
                                    .bind("sId", detail.getSizeId())
                                    .executeAndReturnGeneratedKeys()
                                    .mapTo(Integer.class)
                                    .one();
                        }
                        detail.setProductVariantId(variantId);
                    }

                    if ("EXPORT".equalsIgnoreCase(receipt.getType())) {
                        double costPrice = deductFifo(handle, detail.getProductVariantId(), detail.getQuantity());

                        handle.createUpdate(
                                "INSERT INTO inventory_receipt_details " +
                                "(receipt_id, product_variant_id, quantity, price, remaining_quantity, cost_price) " +
                                "VALUES (:receiptId, :productVariantId, :quantity, :price, 0, :costPrice)")
                                .bind("receiptId", receiptId)
                                .bind("productVariantId", detail.getProductVariantId())
                                .bind("quantity", detail.getQuantity())
                                .bind("price", detail.getPrice())
                                .bind("costPrice", costPrice)
                                .execute();

                        int affectedRows = handle.createUpdate(
                                "UPDATE product_variants SET stock = stock - :quantity " +
                                "WHERE id = :productVariantId AND stock >= :quantity")
                                .bind("quantity", detail.getQuantity())
                                .bind("productVariantId", detail.getProductVariantId())
                                .execute();
                        if (affectedRows == 0) {
                            throw new RuntimeException("Không đủ tồn kho để xuất cho mã biến thể: " + detail.getProductVariantId());
                        }

                    } else {
                        handle.createUpdate(
                                "INSERT INTO inventory_receipt_details " +
                                "(receipt_id, product_variant_id, quantity, price, remaining_quantity) " +
                                "VALUES (:receiptId, :productVariantId, :quantity, :price, :remainingQuantity)")
                                .bind("receiptId", receiptId)
                                .bind("productVariantId", detail.getProductVariantId())
                                .bind("quantity", detail.getQuantity())
                                .bind("price", detail.getPrice())
                                .bind("remainingQuantity", detail.getQuantity())
                                .execute();

                        handle.createUpdate(
                                "UPDATE product_variants SET stock = stock + :quantity WHERE id = :productVariantId")
                                .bind("quantity", detail.getQuantity())
                                .bind("productVariantId", detail.getProductVariantId())
                                .execute();
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

    public List<model.WarehouseStockDto> getWarehouseStockReport() {
        return getJdbi().withHandle(handle ->
                handle.createQuery("SELECT pv.id AS id, pv.stock AS stock, " +
                                "p.name AS productName, s.code AS sizeName, c.name AS colorName, " +
                                "(SELECT d.price FROM inventory_receipt_details d " +
                                " JOIN inventory_receipts r ON d.receipt_id = r.id " +
                                " WHERE d.product_variant_id = pv.id AND r.type = 'IMPORT' " +
                                " ORDER BY r.created_at DESC, r.id DESC LIMIT 1) AS lastImportPrice, " +
                                "(SELECT r.created_at FROM inventory_receipt_details d " +
                                " JOIN inventory_receipts r ON d.receipt_id = r.id " +
                                " WHERE d.product_variant_id = pv.id AND r.type = 'IMPORT' " +
                                " ORDER BY r.created_at DESC, r.id DESC LIMIT 1) AS lastImportDate " +
                                "FROM product_variants pv " +
                                "JOIN products p ON pv.product_id = p.id " +
                                "LEFT JOIN sizes s ON pv.size_id = s.id " +
                                "LEFT JOIN colors c ON pv.color_id = c.id " +
                                "ORDER BY p.name, c.name, s.sort_order")
                        .mapToBean(model.WarehouseStockDto.class)
                        .list()
        );
    }

    public List<model.WarehouseStockBatchDto> getVariantImportBatches(int variantId) {
        return getJdbi().withHandle(handle ->
                handle.createQuery("SELECT r.id AS id, " +
                                "DATE_FORMAT(r.created_at, '%d/%m/%Y %H:%i') AS createdAtFormatted, " +
                                "d.quantity AS quantity, d.price AS price, d.remaining_quantity AS remainingQuantity " +
                                "FROM inventory_receipt_details d " +
                                "JOIN inventory_receipts r ON d.receipt_id = r.id " +
                                "WHERE d.product_variant_id = :variantId AND r.type = 'IMPORT' " +
                                "ORDER BY r.created_at DESC, r.id DESC")
                        .bind("variantId", variantId)
                        .mapToBean(model.WarehouseStockBatchDto.class)
                        .list()
        );
    }

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
            double costPrice = deductFifo(handle, item.getVariantId(), item.getQuantity());

            handle.createUpdate(
                    "INSERT INTO inventory_receipt_details " +
                    "(receipt_id, product_variant_id, quantity, price, remaining_quantity, cost_price) " +
                    "VALUES (:receiptId, :variantId, :quantity, :price, 0, :costPrice)")
                    .bind("receiptId", receiptId)
                    .bind("variantId", item.getVariantId())
                    .bind("quantity", item.getQuantity())
                    .bind("price", item.getPrice())
                    .bind("costPrice", costPrice)
                    .execute();
        }
    }
}
