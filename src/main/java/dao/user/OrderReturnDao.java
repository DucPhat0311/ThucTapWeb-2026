package dao.user;

import dao.core.BaseDao;
import model.OrderReturn;
import model.constant.OrderReturnStatus;

import java.util.Optional;

public class OrderReturnDao extends BaseDao {

    public boolean existsByOrderId(int orderId) {
        return getJdbi().withHandle(h ->
                h.createQuery("""
                    SELECT COUNT(*)
                    FROM order_returns
                    WHERE order_id = :orderId
                """)
                        .bind("orderId", orderId)
                        .mapTo(int.class)
                        .one() > 0
        );
    }

    public int createCustomerRequest(int orderId, int userId, String reasonCode, String description) {
        return getJdbi().withHandle(h ->
                h.createUpdate("""
                    INSERT INTO order_returns (
                        order_id,
                        user_id,
                        request_source,
                        reason_code,
                        description,
                        return_status,
                        refund_status,
                        requested_at
                    )
                    VALUES (
                        :orderId,
                        :userId,
                        :requestSource,
                        :reasonCode,
                        :description,
                        :returnStatus,
                        :refundStatus,
                        NOW()
                    )
                """)
                        .bind("orderId", orderId)
                        .bind("userId", userId)
                        .bind("requestSource", OrderReturnStatus.SOURCE_CUSTOMER)
                        .bind("reasonCode", reasonCode)
                        .bind("description", description)
                        .bind("returnStatus", OrderReturnStatus.REQUESTED)
                        .bind("refundStatus", OrderReturnStatus.REFUND_NOT_REQUIRED)
                        .executeAndReturnGeneratedKeys("id")
                        .mapTo(int.class)
                        .one()
        );
    }

    public Optional<OrderReturn> findByOrderId(int orderId) {
        return getJdbi().withHandle(h ->
                h.createQuery("""
                    SELECT
                        id,
                        order_id AS orderId,
                        user_id AS userId,
                        request_source AS requestSource,
                        reason_code AS reasonCode,
                        description,
                        return_status AS returnStatus,
                        refund_status AS refundStatus,
                        admin_note AS adminNote,
                        requested_at AS requestedAt,
                        processed_at AS processedAt,
                        returning_at AS returningAt,
                        returned_at AS returnedAt,
                        refunded_at AS refundedAt,
                        stock_restored AS stockRestored
                    FROM order_returns
                    WHERE order_id = :orderId
                    LIMIT 1
                """)
                        .bind("orderId", orderId)
                        .mapToBean(OrderReturn.class)
                        .findOne()
        );
    }
}
