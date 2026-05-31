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
                h.createQuery("SELECT COUNT(*) FROM products WHERE status <> 'Đã xoá'")
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

    /**
     * Doanh thu từng tháng trong năm chỉ định (chỉ tính đơn COMPLETED).
     * @return double[12] – index 0 = Tháng 1, ..., index 11 = Tháng 12
     */
    public double[] revenueByMonth(int year) {
        double[] result = new double[12];
        getJdbi().withHandle(h -> {
            h.createQuery("""
                SELECT MONTH(created_at) AS month,
                       COALESCE(SUM(total_price), 0) AS revenue
                FROM orders
                WHERE order_status = :status
                  AND YEAR(created_at) = :year
                GROUP BY MONTH(created_at)
                ORDER BY month
            """)
                    .bind("status", OrderStatus.COMPLETED)
                    .bind("year", year)
                    .mapToMap()
                    .forEach(row -> {
                        int month = ((Number) row.get("month")).intValue();
                        double rev   = ((Number) row.get("revenue")).doubleValue();
                        result[month - 1] = rev;
                    });
            return null;
        });
        return result;
    }
}
