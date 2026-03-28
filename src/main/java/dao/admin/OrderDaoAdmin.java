package dao.admin;

import model.Order;
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
}