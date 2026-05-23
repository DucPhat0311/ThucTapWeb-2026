package dao.user;

import dao.core.BaseDao;
import model.OrderItem;

import java.util.List;

public class OrderItemDao extends BaseDao {
    public void insert(int orderId,
                       int productId,
                       int variantId,
                       String size,
                       String color,
                       int quantity,
                       double price,
                       double total) {

        getJdbi().useHandle(h ->
                h.createUpdate("""
        INSERT INTO order_items
        (order_id, product_id, variant_id, size, color, quantity, price, total)
        VALUES (:oid, :pid, :vid, :size, :color, :qty, :price, :total)
    """)
                        .bind("oid", orderId)
                        .bind("pid", productId)
                        .bind("vid", variantId)
                        .bind("size", size)
                        .bind("color", color)
                        .bind("qty", quantity)
                        .bind("price", price)
                        .bind("total", total)
                        .execute()
        );
    }


    public List<OrderItem> getByOrderId(int orderId) {
        return getJdbi().withHandle(h ->
                h.createQuery("""
            SELECT oi.id,
                   oi.order_id,
                   oi.variant_id,
                   oi.product_id,
                   oi.size,
                   oi.color,
                   oi.quantity,
                   oi.price,
                   oi.total,
                   oi.reviewed,
                   p.thumbnail,
                   p.name AS productName
            FROM order_items oi
            LEFT JOIN product_variants pv ON oi.variant_id = pv.id
            LEFT JOIN products p ON pv.product_id = p.id
            WHERE oi.order_id = :oid
        """)
                        .bind("oid", orderId)
                        .mapToBean(OrderItem.class)
                        .list()
        );
    }

    public void markReviewed(int id) {
        getJdbi().useHandle(h ->
                h.createUpdate("UPDATE order_items SET reviewed = 1 WHERE id = :id")
                        .bind("id", id)
                        .execute()
        );
    }
}
