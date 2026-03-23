package dao.user;

import dao.core.BaseDao;
import model.Product;
import org.jdbi.v3.core.Jdbi;

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

    public List<Product> findLatest(int limit) {
        Jdbi jdbi = getJdbi();
        return jdbi.withHandle(handle ->
                handle.createQuery(
                                "SELECT * FROM products WHERE status = 'Đang bán' ORDER BY created_at DESC LIMIT :limit"
                        )
                        .bind("limit", limit)
                        .mapToBean(Product.class)
                        .list()
        );
    }

    //  các sản phẩm tương ứng với category đó
    public List<Product> findLatestByCategories(List<Integer> categoryIds, int limit) {
        if (categoryIds == null || categoryIds.isEmpty()) {
            return List.of();
        }

        String sql = "SELECT * FROM products " +
                "WHERE category_id IN (<ids>) AND status = 'Đang bán' " +
                "ORDER BY created_at DESC LIMIT :limit";

        return getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                        .bindList("ids", categoryIds)
                        .bind("limit", limit)
                        .mapToBean(Product.class)
                        .list()
        );
    }

    // lấy chi tiết sản phẩm theo id
    public Product findById(int id) {
        return getJdbi().withHandle(h ->
                h.createQuery("""
                SELECT p.*, c.name AS categoryName
                FROM products p
                JOIN categories c ON p.category_id = c.id
                WHERE p.id = :id
            """)
                        .bind("id", id)
                        .mapToBean(Product.class)
                        .findOne()
                        .orElse(null)
        );
    }

    // lấy các sp liên quan dựa theo category id
    public List<Product> getRelatedProductByCategory(int categoryId, int currentProductId, int limit){
        return getJdbi().withHandle(handle ->
                handle.createQuery("""
                                SELECT *
                                FROM products
                                WHERE category_id = :categoryId
                                AND id <> :currentProductId
                                AND status = 'Đang bán'
                                ORDER BY created_at DESC
                                LIMIT :limit
                                """
                        ).bind("categoryId", categoryId)
                        .bind("currentProductId",currentProductId)
                        .bind("limit", limit).
                        mapToBean(Product.class)
                        .list());
    }
}
