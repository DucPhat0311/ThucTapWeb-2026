package dao.user;

import dao.core.BaseDao;
import model.OrderTrackingLog;

import java.time.LocalDateTime;
import java.util.List;

public class OrderTrackingLogDao extends BaseDao {
    public void insert(int orderId,
                       String provider,
                       String trackingCode,
                       String statusCode,
                       String statusName,
                       String description,
                       LocalDateTime eventTime) {
        getJdbi().useHandle(h ->
                h.createUpdate("""
            INSERT INTO order_tracking_logs (
                order_id,
                provider,
                tracking_code,
                status_code,
                status_name,
                description,
                event_time
            )
            VALUES (
                :orderId,
                :provider,
                :trackingCode,
                :statusCode,
                :statusName,
                :description,
                :eventTime
            )
        """)
                        .bind("orderId", orderId)
                        .bind("provider", provider)
                        .bind("trackingCode", trackingCode)
                        .bind("statusCode", statusCode)
                        .bind("statusName", statusName)
                        .bind("description", description)
                        .bind("eventTime", eventTime)
                        .execute()
        );
    }

    public List<OrderTrackingLog> getByOrderId(int orderId) {
        return getJdbi().withHandle(h ->
                h.createQuery("""
            SELECT
                id,
                order_id AS orderId,
                provider,
                tracking_code AS trackingCode,
                status_code AS statusCode,
                status_name AS statusName,
                description,
                event_time AS eventTime,
                created_at AS createdAt
            FROM order_tracking_logs
            WHERE order_id = :orderId
            ORDER BY COALESCE(event_time, created_at) DESC, id DESC
        """)
                        .bind("orderId", orderId)
                        .mapToBean(OrderTrackingLog.class)
                        .list()
        );
    }
}
