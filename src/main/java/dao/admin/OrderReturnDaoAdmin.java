package dao.admin;

import dao.core.BaseDao;
import model.OrderReturn;
import model.constant.OrderReturnStatus;
import model.constant.PaymentStatus;

import java.util.List;
import java.util.Optional;

public class OrderReturnDaoAdmin extends BaseDao {

    public List<OrderReturn> getAll() {
        return getJdbi().withHandle(h ->
                h.createQuery(baseSelect() + " ORDER BY r.requested_at DESC, r.id DESC")
                        .mapToBean(OrderReturn.class)
                        .list()
        );
    }

    public Optional<OrderReturn> findById(int id) {
        return getJdbi().withHandle(h ->
                h.createQuery(baseSelect() + " WHERE r.id = :id LIMIT 1")
                        .bind("id", id)
                        .mapToBean(OrderReturn.class)
                        .findOne()
        );
    }

    public boolean approve(int id, String adminNote) {
        return updateRequestedStatus(id, OrderReturnStatus.APPROVED, adminNote);
    }

    public boolean reject(int id, String adminNote) {
        return updateRequestedStatus(id, OrderReturnStatus.REJECTED, adminNote);
    }

    public boolean startReturning(int id, String adminNote) {
        return getJdbi().withHandle(h ->
                h.createUpdate("""
                    UPDATE order_returns
                    SET return_status = :newStatus,
                        admin_note = CASE
                            WHEN :adminNote IS NULL OR :adminNote = '' THEN admin_note
                            ELSE :adminNote
                        END,
                        returning_at = NOW()
                    WHERE id = :id
                      AND return_status = :currentStatus
                """)
                        .bind("newStatus", OrderReturnStatus.RETURNING)
                        .bind("adminNote", normalizeNote(adminNote))
                        .bind("id", id)
                        .bind("currentStatus", OrderReturnStatus.APPROVED)
                        .execute() > 0
        );
    }

    public boolean completeReturnAndRestoreStock(int id, String adminNote) {
        return getJdbi().inTransaction(h -> {
            ReturnedOrder returnedOrder = h.createQuery("""
                    SELECT r.order_id, o.payment_statuses
                    FROM order_returns r
                    JOIN orders o ON o.id = r.order_id
                    WHERE r.id = :id
                      AND r.return_status = :currentStatus
                      AND r.stock_restored = 0
                    FOR UPDATE
                """)
                    .bind("id", id)
                    .bind("currentStatus", OrderReturnStatus.RETURNING)
                    .map((rs, ctx) -> new ReturnedOrder(
                            rs.getInt("order_id"),
                            rs.getString("payment_statuses")
                    ))
                    .findOne()
                    .orElse(null);
            if (returnedOrder == null) {
                return false;
            }

            List<ReturnedItem> returnedItems = h.createQuery("""
                    SELECT variant_id, SUM(quantity) AS quantity
                    FROM order_items
                    WHERE order_id = :orderId
                    GROUP BY variant_id
                    ORDER BY variant_id
                """)
                    .bind("orderId", returnedOrder.orderId())
                    .map((rs, ctx) -> new ReturnedItem(
                            rs.getInt("variant_id"),
                            rs.getInt("quantity")
                    ))
                    .list();
            if (returnedItems.isEmpty()) {
                throw new IllegalStateException("Đơn hàng không có sản phẩm để hoàn lại tồn kho.");
            }

            for (ReturnedItem item : returnedItems) {
                int affectedRows = h.createUpdate("""
                        UPDATE product_variants
                        SET stock = stock + :quantity
                        WHERE id = :variantId
                    """)
                        .bind("quantity", item.quantity())
                        .bind("variantId", item.variantId())
                        .execute();
                if (affectedRows == 0) {
                    throw new IllegalStateException("Không tìm thấy biến thể sản phẩm khi hoàn tồn kho.");
                }
            }

            int affectedRows = h.createUpdate("""
                    UPDATE order_returns
                    SET return_status = :newStatus,
                        refund_status = :refundStatus,
                        admin_note = CASE
                            WHEN :adminNote IS NULL OR :adminNote = '' THEN admin_note
                            ELSE :adminNote
                        END,
                        returned_at = NOW(),
                        stock_restored = 1
                    WHERE id = :id
                      AND return_status = :currentStatus
                      AND stock_restored = 0
                """)
                    .bind("newStatus", OrderReturnStatus.RETURNED)
                    .bind("refundStatus", PaymentStatus.PAID.equals(returnedOrder.paymentStatus())
                            ? OrderReturnStatus.REFUND_PENDING
                            : OrderReturnStatus.REFUND_NOT_REQUIRED)
                    .bind("adminNote", normalizeNote(adminNote))
                    .bind("id", id)
                    .bind("currentStatus", OrderReturnStatus.RETURNING)
                    .execute();
            if (affectedRows == 0) {
                throw new IllegalStateException("Không thể hoàn tất yêu cầu trả hàng sau khi cập nhật tồn kho.");
            }

            // Cập nhật trạng thái đơn hàng thành Đã hoàn trả (RETURNED)
            h.createUpdate("UPDATE orders SET order_status = :status WHERE id = :orderId")
                    .bind("status", model.constant.OrderStatus.RETURNED)
                    .bind("orderId", returnedOrder.orderId())
                    .execute();

            return true;
        });
    }

    public boolean confirmRefund(int id, String adminNote) {
        return getJdbi().withHandle(h ->
                h.createUpdate("""
                    UPDATE order_returns
                    SET refund_status = :newStatus,
                        admin_note = CASE
                            WHEN :adminNote IS NULL OR :adminNote = '' THEN admin_note
                            ELSE :adminNote
                        END,
                        refunded_at = NOW()
                    WHERE id = :id
                      AND return_status = :returnStatus
                      AND refund_status = :currentStatus
                """)
                        .bind("newStatus", OrderReturnStatus.REFUNDED)
                        .bind("adminNote", normalizeNote(adminNote))
                        .bind("id", id)
                        .bind("returnStatus", OrderReturnStatus.RETURNED)
                        .bind("currentStatus", OrderReturnStatus.REFUND_PENDING)
                        .execute() > 0
        );
    }

    private boolean updateRequestedStatus(int id, String newStatus, String adminNote) {
        return getJdbi().withHandle(h ->
                h.createUpdate("""
                    UPDATE order_returns
                    SET return_status = :newStatus,
                        admin_note = :adminNote,
                        processed_at = NOW()
                    WHERE id = :id
                      AND return_status = :currentStatus
                """)
                        .bind("newStatus", newStatus)
                        .bind("adminNote", normalizeNote(adminNote))
                        .bind("id", id)
                        .bind("currentStatus", OrderReturnStatus.REQUESTED)
                        .execute() > 0
        );
    }

    private String baseSelect() {
        return """
            SELECT
                r.id,
                r.order_id AS orderId,
                r.user_id AS userId,
                r.request_source AS requestSource,
                r.reason_code AS reasonCode,
                r.description,
                r.return_status AS returnStatus,
                r.refund_status AS refundStatus,
                r.admin_note AS adminNote,
                r.requested_at AS requestedAt,
                r.processed_at AS processedAt,
                r.returning_at AS returningAt,
                r.returned_at AS returnedAt,
                r.refunded_at AS refundedAt,
                r.stock_restored AS stockRestored,
                o.name AS customerName,
                o.phone AS customerPhone,
                o.final_amount AS orderAmount,
                o.payment_methods AS paymentMethod,
                o.payment_statuses AS paymentStatus
            FROM order_returns r
            JOIN orders o ON o.id = r.order_id
            """;
    }

    private String normalizeNote(String note) {
        return note == null ? "" : note.trim();
    }

    private record ReturnedItem(int variantId, int quantity) {
    }

    private record ReturnedOrder(int orderId, String paymentStatus) {
    }
}
