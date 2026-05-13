package dao.user;

import dao.core.BaseDao;
import model.Order;

import java.util.List;

public class OrderDao extends BaseDao {
    public int createOrder(int userId,
                           String name,
                           String phone,
                           String address,
                           String note,
                           String paymentMethod,
                           String paymentStatus,
                           String orderStatus,
                           double totalPrice,
                           double shippingFee,
                           double finalAmount) { 

        return getJdbi().withHandle(h ->
                h.createUpdate("""
        INSERT INTO orders(
            user_id, name, phone, shipping_address, note,
            total_price, discount, shipping_fee, final_amount,
            payment_methods, payment_statuses, order_status, created_at
        )
        VALUES(
            :uid, :name, :phone, :address, :note,
            :total, 0, :ship, :final,
            :payment, :paymentStatus, :orderStatus, NOW()
        )
    """)
                        .bind("uid", userId)
                        .bind("name", name)
                        .bind("phone", phone)
                        .bind("address", address)
                        .bind("note", note)
                        .bind("total", totalPrice)
                        .bind("ship", shippingFee)
                        .bind("final", finalAmount)
                        .bind("payment", paymentMethod)
                        .bind("paymentStatus", paymentStatus)
                        .bind("orderStatus", orderStatus)
                        .executeAndReturnGeneratedKeys("id")
                        .mapTo(int.class)
                        .one()
        );
    }

    public Order getById(int orderId) {

        String sql = """
        SELECT
            id,
            user_id,
            name,
            phone,
            shipping_address,
            total_price,
            discount,
            shipping_fee,
            note,
            final_amount,
            payment_methods,
            payment_statuses,
            order_status,
            ghn_order_code,
            ghn_status,
            ghn_status_name,
            ghn_expected_delivery_time,
            ghn_last_updated_at,
            created_at
        FROM orders
        WHERE id = :oid
    """;

        return getJdbi().withHandle(h ->
                h.createQuery(sql)
                        .bind("oid", orderId)
                        .map((rs, ctx) -> {
                            Order o = new Order();
                            o.setId(rs.getInt("id"));
                            o.setUserId(rs.getInt("user_id"));
                            o.setName(rs.getString("name"));
                            o.setPhone(rs.getString("phone"));
                            o.setShippingAddress(rs.getString("shipping_address"));
                            o.setNote(rs.getString("note"));
                            o.setTotalPrice(rs.getDouble("total_price"));
                            o.setDiscount(rs.getDouble("discount"));
                            o.setShippingFee(rs.getDouble("shipping_fee"));
                            o.setFinalAmount(rs.getDouble("final_amount"));
                            o.setPaymentMethods(rs.getString("payment_methods"));
                            o.setPaymentStatuses(rs.getString("payment_statuses"));
                            o.setOrderStatus(rs.getString("order_status"));
                            o.setGhnOrderCode(rs.getString("ghn_order_code"));
                            o.setGhnStatus(rs.getString("ghn_status"));
                            o.setGhnStatusName(rs.getString("ghn_status_name"));
                            var expectedDeliveryTime = rs.getTimestamp("ghn_expected_delivery_time");
                            var lastUpdatedAt = rs.getTimestamp("ghn_last_updated_at");
                            o.setGhnExpectedDeliveryTime(expectedDeliveryTime == null ? null : expectedDeliveryTime.toLocalDateTime());
                            o.setGhnLastUpdatedAt(lastUpdatedAt == null ? null : lastUpdatedAt.toLocalDateTime());
                            o.setCreatedAt(
                                    rs.getTimestamp("created_at").toLocalDateTime()
                            );
                            return o;
                        })
                        .findOne()
                        .orElse(null)
        );
    }

    public void updatePaymentAndOrderStatus(int orderId, String paymentStatus, String orderStatus) {
        getJdbi().useHandle(h ->
                h.createUpdate("""
            UPDATE orders
            SET payment_statuses = :paymentStatus,
                order_status = :orderStatus
            WHERE id = :orderId
        """)
                        .bind("paymentStatus", paymentStatus)
                        .bind("orderStatus", orderStatus)
                        .bind("orderId", orderId)
                        .execute()
        );
    }

    public void updateOrderStatus(int orderId, String orderStatus) {
        getJdbi().useHandle(h ->
                h.createUpdate("""
            UPDATE orders
            SET order_status = :orderStatus
            WHERE id = :orderId
        """)
                        .bind("orderStatus", orderStatus)
                        .bind("orderId", orderId)
                        .execute()
        );
    }

    public void updateGhnTrackingInfo(int orderId,
                                      String ghnOrderCode,
                                      String ghnStatus,
                                      String ghnStatusName,
                                      java.time.LocalDateTime expectedDeliveryTime) {
        getJdbi().useHandle(h ->
                h.createUpdate("""
            UPDATE orders
            SET ghn_order_code = :ghnOrderCode,
                ghn_status = :ghnStatus,
                ghn_status_name = :ghnStatusName,
                ghn_expected_delivery_time = :expectedDeliveryTime,
                ghn_last_updated_at = NOW()
            WHERE id = :orderId
        """)
                        .bind("ghnOrderCode", ghnOrderCode)
                        .bind("ghnStatus", ghnStatus)
                        .bind("ghnStatusName", ghnStatusName)
                        .bind("expectedDeliveryTime", expectedDeliveryTime)
                        .bind("orderId", orderId)
                        .execute()
        );
    }

    public List<Order> getByUserId(int userId) {
        return getJdbi().withHandle(h ->
                h.createQuery("""
            SELECT *
            FROM orders
            WHERE user_id = :uid
            ORDER BY created_at DESC
        """)
                        .bind("uid", userId)
                        .mapToBean(Order.class)
                        .list()
        );
    }

    public List<Order> getByUserIdAndStatus(int userId, String status) {
        return getJdbi().withHandle(h ->
                h.createQuery("""
            SELECT *
            FROM orders
            WHERE user_id = :uid AND order_status = :status
            ORDER BY created_at DESC
        """)
                        .bind("uid", userId)
                        .bind("status", status)
                        .mapToBean(Order.class)
                        .list()
        );
    }
}
