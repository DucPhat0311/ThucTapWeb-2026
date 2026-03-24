package dao.user;

import dao.core.BaseDao;
import model.Order;

public class OrderDao extends BaseDao {
    public int createOrder(int userId,
                           String name,
                           String phone,
                           String address,
                           String note,
                           String paymentMethod,
                           double totalPrice) {

        return getJdbi().withHandle(h ->
                h.createUpdate("""
            INSERT INTO orders(
                user_id, name, phone, shipping_address, note,
                total_price, discount, shipping_fee, final_amount,
                payment_methods, payment_statuses, order_status, created_at
            )
            VALUES(
                :uid, :name, :phone, :address, :note,
                :total, 0, 0, :total,
                :payment, 'UNPAID', 'PENDING', NOW()
            )
        """)
                        .bind("uid", userId)
                        .bind("name", name)
                        .bind("phone", phone)
                        .bind("address", address)
                        .bind("note", note)
                        .bind("total", totalPrice)
                        .bind("payment", paymentMethod)
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
                            o.setCreatedAt(
                                    rs.getTimestamp("created_at").toLocalDateTime()
                            );
                            return o;
                        })
                        .findOne()
                        .orElse(null)
        );
    }
}
