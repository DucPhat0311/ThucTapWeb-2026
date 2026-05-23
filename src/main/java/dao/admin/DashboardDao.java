package dao.admin;

import dao.core.BaseDao;
import model.Order;
import model.constant.OrderStatus;

import java.util.List;

public class DashboardDao extends BaseDao {
    public int countOrders() {
        return getJdbi().withHandle(h ->
                h.createQuery("SELECT COUNT(*) FROM orders")
                        .mapTo(int.class)
                        .one()
        );
    }

    public double totalRevenue() {
        return getJdbi().withHandle(h ->
                h.createQuery("""
            SELECT COALESCE(SUM(total_price),0)
            FROM orders
            WHERE order_status = :completedStatus
        """)
                        .bind("completedStatus", OrderStatus.COMPLETED)
                        .mapTo(double.class)
                        .one()
        );
    }

    public List<Order> latestOrders(int limit) {
        return getJdbi().withHandle(h ->
                h.createQuery("""
            SELECT o.id, o.name AS name, o.total_price AS totalPrice, o.order_status AS orderStatus, o.created_at AS createdAt
            FROM orders o
            ORDER BY o.created_at DESC
            LIMIT :limit
        """)
                        .bind("limit", limit)
                        .mapToBean(Order.class)
                        .list()
        );
    }

    public int countProducts() {
        return getJdbi().withHandle(h ->
                h.createQuery("SELECT COUNT(*) FROM products")
                        .mapTo(int.class)
                        .one()
        );
    }

    public int countUsers() {
        return getJdbi().withHandle(h ->
                h.createQuery("SELECT COUNT(*) FROM users")
                        .mapTo(int.class)
                        .one()
        );
    }
}
