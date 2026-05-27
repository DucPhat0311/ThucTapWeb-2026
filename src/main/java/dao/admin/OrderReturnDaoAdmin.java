package dao.admin;

import dao.core.BaseDao;
import model.OrderReturn;
import model.constant.OrderReturnStatus;

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
}
