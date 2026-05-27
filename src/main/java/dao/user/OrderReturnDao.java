package dao.user;

import dao.core.BaseDao;
import model.constant.OrderReturnStatus;

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

    public void createCustomerRequest(int orderId, int userId, String reasonCode, String description) {
        getJdbi().useHandle(h ->
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
                        .execute()
        );
    }
}
