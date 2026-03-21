package dao.user;

import dao.core.BaseDao;
import model.Product;

import java.util.List;

public class ProductDao extends BaseDao {
    public List<Product> findAll() {
        String sql = """
        SELECT p.*, c.name AS categoryName
        FROM products p
        JOIN categories c ON p.category_id = c.id
        WHERE p.status <> 'Đã xoá'
        ORDER BY p.id DESC
    """;

        return getJdbi().withHandle(h ->
                h.createQuery(sql)
                        .mapToBean(Product.class)
                        .list()
        );
    }
}
