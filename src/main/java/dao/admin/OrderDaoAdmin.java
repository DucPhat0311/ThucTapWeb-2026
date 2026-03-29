package dao.admin;

import model.Order;
import model.OrderItem;
import dao.core.BaseDao;
import java.util.List;

public class OrderDaoAdmin extends BaseDao {

    public List<Order> getAll() {
        return getJdbi().withHandle(h ->
        h.createQuery("""
            SELECT *
            FROM orders
            ORDER BY created_at DESC """)
        .mapToBean(Order.class)
        .list()
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

    public Order findById(int id) {
        return getById(id);
    }

    public List<OrderItem> getItems(int orderId) {
        return getJdbi().withHandle(h ->
                h.createQuery("""
            SELECT oi.id, oi.order_id, oi.variant_id, oi.quantity, oi.price, oi.total, oi.product_name, oi.size, oi.color, p.thumbnail
                                    FROM order_items oi JOIN products p ON p.id = (SELECT pv.product_id FROM product_variants pv WHERE pv.id = oi.variant_id)
                                    WHERE oi.order_id = :oid
        """)
                        .bind("oid", orderId)
                        .map((rs, ctx) -> {
                            OrderItem i = new OrderItem();
                            i.setId(rs.getInt("id"));
                            i.setOrderId(rs.getInt("order_id"));
                            i.setVariantId(rs.getInt("variant_id"));
                            i.setProductName(rs.getString("product_name"));
                            i.setSize(rs.getString("size"));
                            i.setColor(rs.getString("color"));
                            i.setQuantity(rs.getInt("quantity"));
                            i.setPrice(rs.getDouble("price"));
                            i.setTotal(rs.getDouble("total"));
                            i.setThumbnail(rs.getString("thumbnail"));
                            return i;
                        })
                        .list()
        );
    }

    public void updateStatus(int id, String status) {
        getJdbi().useHandle(h ->
                h.createUpdate("""
            UPDATE orders
            SET order_status = :st
            WHERE id = :id
        """)
                        .bind("st", status)
                        .bind("id", id)
                        .execute()
        );
    }
    public String getUserEmailByOrderId(int orderId) {
        return getJdbi().withHandle(h ->
                h.createQuery("""
            SELECT u.email
            FROM orders o
            JOIN users u ON o.user_id = u.id
            WHERE o.id = :oid
        """)
                        .bind("oid", orderId)
                        .mapTo(String.class)
                        .one()
        );
    }


}