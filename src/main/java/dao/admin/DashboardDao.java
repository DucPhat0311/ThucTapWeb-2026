package dao.admin;

import dao.core.BaseDao;
import model.Order;
import model.constant.OrderStatus;

import java.util.List;
import java.util.Map;

public class DashboardDao extends BaseDao {
    public int countOrders() {
        return getJdbi().withHandle(h -> h.createQuery("SELECT COUNT(*) FROM orders")
                .mapTo(int.class)
                .one());
    }

    public double totalRevenue() {
        return getJdbi().withHandle(h -> h.createQuery("""
                    SELECT COALESCE(SUM(total_price),0)
                    FROM orders
                    WHERE order_status = :completedStatus
                      AND id NOT IN (SELECT order_id FROM order_returns WHERE return_status = 'RETURNED')
                """)
                .bind("completedStatus", OrderStatus.COMPLETED)
                .mapTo(double.class)
                .one());
    }

    public List<Order> latestOrders(int limit) {
        return getJdbi().withHandle(h -> h
                .createQuery(
                        """
                                    SELECT o.id, o.name AS name, o.total_price AS totalPrice, o.order_status AS orderStatus, o.created_at AS createdAt
                                    FROM orders o
                                    ORDER BY o.created_at DESC
                                    LIMIT :limit
                                """)
                .bind("limit", limit)
                .mapToBean(Order.class)
                .list());
    }

    public int countProducts() {
        return getJdbi().withHandle(h -> h.createQuery("SELECT COUNT(*) FROM products WHERE status <> 'Đã xoá'")
                .mapTo(int.class)
                .one());
    }

    public int countUsers() {
        return getJdbi().withHandle(h -> h.createQuery("SELECT COUNT(*) FROM users")
                .mapTo(int.class)
                .one());
    }

    /**
     * Tổng lợi nhuận gộp theo FIFO thực tế.
     * - Nếu đơn mới: dùng cost_price lưu trong EXPORT receipt detail.
     * - Nếu đơn cũ (chưa có cost_price): fallback về weighted average từ tất cả
     * batch IMPORT.
     * Chỉ tính đơn hàng COMPLETED.
     */
    public double totalProfit() {
        return getJdbi().withHandle(h -> h.createQuery("""
                    SELECT COALESCE(SUM(
                        oi.quantity * oi.price
                        - oi.quantity * COALESCE(
                            (
                                SELECT exp_d.cost_price
                                FROM inventory_receipt_details exp_d
                                JOIN inventory_receipts exp_r ON exp_d.receipt_id = exp_r.id
                                WHERE exp_r.order_id = o.id
                                  AND exp_r.type = 'EXPORT'
                                  AND exp_d.product_variant_id = oi.variant_id
                                  AND exp_d.cost_price IS NOT NULL
                                  AND exp_d.cost_price > 0
                                LIMIT 1
                            ),
                            (
                                SELECT SUM(imp.price * imp.quantity) / NULLIF(SUM(imp.quantity), 0)
                                FROM inventory_receipt_details imp
                                JOIN inventory_receipts imp_r ON imp.receipt_id = imp_r.id
                                WHERE imp.product_variant_id = oi.variant_id
                                  AND imp_r.type = 'IMPORT'
                            ),
                            0
                        )
                    ), 0)
                    FROM order_items oi
                    JOIN orders o ON oi.order_id = o.id
                    WHERE o.order_status = :completedStatus
                      AND o.id NOT IN (SELECT order_id FROM order_returns WHERE return_status = 'RETURNED')
                """)
                .bind("completedStatus", OrderStatus.COMPLETED)
                .mapTo(double.class)
                .one());
    }

    public double[] profitByMonth(int year) {
        double[] result = new double[12];
        getJdbi().withHandle(h -> {
            h.createQuery("""
                        SELECT MONTH(o.created_at) AS month,
                               COALESCE(SUM(
                                   oi.quantity * oi.price
                                   - oi.quantity * COALESCE(
                                       (
                                           SELECT exp_d.cost_price
                                           FROM inventory_receipt_details exp_d
                                           JOIN inventory_receipts exp_r ON exp_d.receipt_id = exp_r.id
                                           WHERE exp_r.order_id = o.id
                                             AND exp_r.type = 'EXPORT'
                                             AND exp_d.product_variant_id = oi.variant_id
                                             AND exp_d.cost_price IS NOT NULL
                                             AND exp_d.cost_price > 0
                                           LIMIT 1
                                       ),
                                       (
                                           SELECT SUM(imp.price * imp.quantity) / NULLIF(SUM(imp.quantity), 0)
                                           FROM inventory_receipt_details imp
                                           JOIN inventory_receipts imp_r ON imp.receipt_id = imp_r.id
                                           WHERE imp.product_variant_id = oi.variant_id
                                             AND imp_r.type = 'IMPORT'
                                       ),
                                       0
                                   )
                               ), 0) AS profit
                        FROM order_items oi
                        JOIN orders o ON oi.order_id = o.id
                        WHERE o.order_status = :status
                          AND YEAR(o.created_at) = :year
                          AND o.id NOT IN (SELECT order_id FROM order_returns WHERE return_status = 'RETURNED')
                        GROUP BY MONTH(o.created_at)
                        ORDER BY month
                    """)
                    .bind("status", OrderStatus.COMPLETED)
                    .bind("year", year)
                    .mapToMap()
                    .forEach(row -> {
                        int month = ((Number) row.get("month")).intValue();
                        double profit = ((Number) row.get("profit")).doubleValue();
                        result[month - 1] = profit;
                    });
            return null;
        });
        return result;
    }

    public double[] profitByDaysInMonth(int year, int month) {
        int daysInMonth = java.time.YearMonth.of(year, month).lengthOfMonth();
        double[] result = new double[daysInMonth];
        getJdbi().withHandle(h -> {
            h.createQuery("""
                        SELECT DAY(o.created_at) AS day,
                               COALESCE(SUM(
                                   oi.quantity * oi.price
                                   - oi.quantity * COALESCE(
                                       (
                                           SELECT exp_d.cost_price
                                           FROM inventory_receipt_details exp_d
                                           JOIN inventory_receipts exp_r ON exp_d.receipt_id = exp_r.id
                                           WHERE exp_r.order_id = o.id
                                             AND exp_r.type = 'EXPORT'
                                             AND exp_d.product_variant_id = oi.variant_id
                                             AND exp_d.cost_price IS NOT NULL
                                             AND exp_d.cost_price > 0
                                           LIMIT 1
                                       ),
                                       (
                                           SELECT SUM(imp.price * imp.quantity) / NULLIF(SUM(imp.quantity), 0)
                                           FROM inventory_receipt_details imp
                                           JOIN inventory_receipts imp_r ON imp.receipt_id = imp_r.id
                                           WHERE imp.product_variant_id = oi.variant_id
                                             AND imp_r.type = 'IMPORT'
                                       ),
                                       0
                                   )
                               ), 0) AS profit
                        FROM order_items oi
                        JOIN orders o ON oi.order_id = o.id
                        WHERE o.order_status = :status
                          AND YEAR(o.created_at) = :year
                          AND MONTH(o.created_at) = :month
                          AND o.id NOT IN (SELECT order_id FROM order_returns WHERE return_status = 'RETURNED')
                        GROUP BY DAY(o.created_at)
                        ORDER BY day
                    """)
                    .bind("status", OrderStatus.COMPLETED)
                    .bind("year", year)
                    .bind("month", month)
                    .mapToMap()
                    .forEach(row -> {
                        int day = ((Number) row.get("day")).intValue();
                        double profit = ((Number) row.get("profit")).doubleValue();
                        result[day - 1] = profit;
                    });
            return null;
        });
        return result;
    }

    public java.util.Map<String, Double> profitByDateRange(String startDateStr, String endDateStr) {
        java.time.LocalDate start = java.time.LocalDate.parse(startDateStr);
        java.time.LocalDate end = java.time.LocalDate.parse(endDateStr);

        java.util.Map<String, Double> result = new java.util.LinkedHashMap<>();
        java.time.LocalDate current = start;
        java.time.format.DateTimeFormatter formatter = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy");
        while (!current.isAfter(end)) {
            result.put(current.format(formatter), 0.0);
            current = current.plusDays(1);
        }

        getJdbi().withHandle(h -> {
            h.createQuery("""
                        SELECT DATE(o.created_at) AS order_date,
                               COALESCE(SUM(
                                   oi.quantity * oi.price
                                   - oi.quantity * COALESCE(
                                       (
                                           SELECT exp_d.cost_price
                                           FROM inventory_receipt_details exp_d
                                           JOIN inventory_receipts exp_r ON exp_d.receipt_id = exp_r.id
                                           WHERE exp_r.order_id = o.id
                                             AND exp_r.type = 'EXPORT'
                                             AND exp_d.product_variant_id = oi.variant_id
                                             AND exp_d.cost_price IS NOT NULL
                                             AND exp_d.cost_price > 0
                                           LIMIT 1
                                       ),
                                       (
                                           SELECT SUM(imp.price * imp.quantity) / NULLIF(SUM(imp.quantity), 0)
                                           FROM inventory_receipt_details imp
                                           JOIN inventory_receipts imp_r ON imp.receipt_id = imp_r.id
                                           WHERE imp.product_variant_id = oi.variant_id
                                             AND imp_r.type = 'IMPORT'
                                       ),
                                       0
                                   )
                               ), 0) AS profit
                        FROM order_items oi
                        JOIN orders o ON oi.order_id = o.id
                        WHERE o.order_status = :status
                          AND DATE(o.created_at) >= :startDate
                          AND DATE(o.created_at) <= :endDate
                          AND o.id NOT IN (SELECT order_id FROM order_returns WHERE return_status = 'RETURNED')
                        GROUP BY DATE(o.created_at)
                        ORDER BY order_date
                    """)
                    .bind("status", OrderStatus.COMPLETED)
                    .bind("startDate", startDateStr)
                    .bind("endDate", endDateStr)
                    .mapToMap()
                    .forEach(row -> {
                        Object dateObj = row.get("order_date");
                        java.time.LocalDate date;
                        if (dateObj instanceof java.sql.Date) {
                            date = ((java.sql.Date) dateObj).toLocalDate();
                        } else if (dateObj instanceof java.time.LocalDate) {
                            date = (java.time.LocalDate) dateObj;
                        } else {
                            date = java.time.LocalDate.parse(dateObj.toString());
                        }
                        double profit = ((Number) row.get("profit")).doubleValue();
                        result.put(date.format(formatter), profit);
                    });
            return null;
        });
        return result;
    }

    /**
     * Doanh thu từng tháng trong năm chỉ định (chỉ tính đơn COMPLETED).
     * 
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
                          AND id NOT IN (SELECT order_id FROM order_returns WHERE return_status = 'RETURNED')
                        GROUP BY MONTH(created_at)
                        ORDER BY month
                    """)
                    .bind("status", OrderStatus.COMPLETED)
                    .bind("year", year)
                    .mapToMap()
                    .forEach(row -> {
                        int month = ((Number) row.get("month")).intValue();
                        double rev = ((Number) row.get("revenue")).doubleValue();
                        result[month - 1] = rev;
                    });
            return null;
        });
        return result;
    }

    public double[] revenueByDaysInMonth(int year, int month) {
        int daysInMonth = java.time.YearMonth.of(year, month).lengthOfMonth();
        double[] result = new double[daysInMonth];
        getJdbi().withHandle(h -> {
            h.createQuery("""
                        SELECT DAY(created_at) AS day,
                               COALESCE(SUM(total_price), 0) AS revenue
                        FROM orders
                        WHERE order_status = :status
                          AND YEAR(created_at) = :year
                          AND MONTH(created_at) = :month
                          AND id NOT IN (SELECT order_id FROM order_returns WHERE return_status = 'RETURNED')
                        GROUP BY DAY(created_at)
                        ORDER BY day
                    """)
                    .bind("status", OrderStatus.COMPLETED)
                    .bind("year", year)
                    .bind("month", month)
                    .mapToMap()
                    .forEach(row -> {
                        int day = ((Number) row.get("day")).intValue();
                        double rev = ((Number) row.get("revenue")).doubleValue();
                        result[day - 1] = rev;
                    });
            return null;
        });
        return result;
    }

    public java.util.Map<String, Double> revenueByDateRange(String startDateStr, String endDateStr) {
        java.time.LocalDate start = java.time.LocalDate.parse(startDateStr);
        java.time.LocalDate end = java.time.LocalDate.parse(endDateStr);

        java.util.Map<String, Double> result = new java.util.LinkedHashMap<>();
        java.time.LocalDate current = start;
        java.time.format.DateTimeFormatter formatter = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy");
        while (!current.isAfter(end)) {
            result.put(current.format(formatter), 0.0);
            current = current.plusDays(1);
        }

        getJdbi().withHandle(h -> {
            h.createQuery("""
                        SELECT DATE(created_at) AS order_date,
                               COALESCE(SUM(total_price), 0) AS revenue
                        FROM orders
                        WHERE order_status = :status
                          AND DATE(created_at) >= :startDate
                          AND DATE(created_at) <= :endDate
                          AND id NOT IN (SELECT order_id FROM order_returns WHERE return_status = 'RETURNED')
                        GROUP BY DATE(created_at)
                        ORDER BY order_date
                    """)
                    .bind("status", OrderStatus.COMPLETED)
                    .bind("startDate", startDateStr)
                    .bind("endDate", endDateStr)
                    .mapToMap()
                    .forEach(row -> {
                        Object dateObj = row.get("order_date");
                        java.time.LocalDate date;
                        if (dateObj instanceof java.sql.Date) {
                            date = ((java.sql.Date) dateObj).toLocalDate();
                        } else if (dateObj instanceof java.time.LocalDate) {
                            date = (java.time.LocalDate) dateObj;
                        } else {
                            date = java.time.LocalDate.parse(dateObj.toString());
                        }
                        double rev = ((Number) row.get("revenue")).doubleValue();
                        result.put(date.format(formatter), rev);
                    });
            return null;
        });
        return result;
    }
}
