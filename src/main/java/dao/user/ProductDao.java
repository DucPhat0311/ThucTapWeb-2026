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

    public List<Product> searchByName(String keyword) {
        String sql = """
    SELECT p.*, c.name AS categoryName
    FROM products p
    JOIN categories c ON p.category_id = c.id
    WHERE p.status <> 'Đã xoá'
    AND (
        p.name LIKE :fullKey
        OR p.name LIKE :startKey
        OR p.name LIKE :endKey
        OR p.name LIKE :middleKey
    )
    """;

        String kw = keyword.trim();

        return getJdbi().withHandle(h ->
                h.createQuery(sql)
                        .bind("fullKey", kw)
                        .bind("startKey", kw + " %")
                        .bind("endKey", "% " + kw)
                        .bind("middleKey", "% " + kw + " %")
                        .mapToBean(Product.class)
                        .list()
        );
    }

    public List<Product> findBoyProducts(int limit) {
        return getJdbi().withHandle(handle ->
                handle.createQuery("""
            SELECT * FROM products
            WHERE category_id IN (1,2,3)
              AND status = 'Đang bán'
            ORDER BY created_at DESC
            LIMIT :limit
        """)
                        .bind("limit", limit)
                        .mapToBean(Product.class)
                        .list()
        );
    }
    public List<Product> findGirlProducts(int limit) {
        return getJdbi().withHandle(handle ->
                handle.createQuery("""
            SELECT * FROM products
            WHERE category_id IN (4,5,6,7)
              AND status = 'Đang bán'
            ORDER BY created_at DESC
            LIMIT :limit
        """)
                        .bind("limit", limit)
                        .mapToBean(Product.class)
                        .list()
        );
    }

    public List<Product> findAccessoryProducts(int limit) {
        return getJdbi().withHandle(handle ->
                handle.createQuery("""
            SELECT * FROM products
            WHERE category_id IN (8,9,10)
              AND status = 'Đang bán'
            ORDER BY created_at DESC
            LIMIT :limit
        """)
                        .bind("limit", limit)
                        .mapToBean(Product.class)
                        .list()
        );
    }

    public List<Product> findByCategories(List<Integer> categoryIds) {

        if (categoryIds == null || categoryIds.isEmpty()) {
            return List.of();
        }

        String sql = "SELECT * FROM products " +
                "WHERE category_id IN (<ids>) AND status = 'Đang bán'";

        return getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                        .bindList("ids", categoryIds)
                        .mapToBean(Product.class)
                        .list()
        );
    }

    public List<Product> findDiscountProducts() {
        return getJdbi().withHandle(handle ->
                handle.createQuery("""
                                SELECT *
                                FROM products
                                WHERE sale_price IS NOT NULL
                                    AND sale_price < price
                                    AND sale_price > 0
                                    AND status = 'Đang bán'
                                ORDER BY created_at DESC
                        """)
                        .mapToBean(Product.class)
                        .list()
        );
    }

    public List<Product> filterProducts(String groupId, String categoryId, String sortType, String minPrice, String maxPrice) {
        StringBuilder sql = new StringBuilder("SELECT * FROM products WHERE status = 'Đang bán'");

        if (categoryId != null && !categoryId.isEmpty()) {
            sql.append(" AND (category_id = :cid OR category_id IN (SELECT id FROM categories WHERE parent_id = :cid))");
        }
        else if (groupId != null && !groupId.isEmpty()) {
            int parentId = switch (groupId) {
                case "phukien" -> 11;
                case "thoiTrangNam" -> 12;
                case "thoiTrangNu" -> 13;
                default -> 0;
            };
            if (parentId != 0) {
                sql.append(" AND (category_id = ").append(parentId)
                        .append(" OR category_id IN (SELECT id FROM categories WHERE parent_id = ").append(parentId).append("))");
            }
        }

        String truePrice = "COALESCE(NULLIF(sale_price, 0), price)";

        if (minPrice != null && !minPrice.isEmpty()) {
            sql.append(" AND ").append(truePrice).append(" >= :minP");
        }
        if (maxPrice != null && !maxPrice.isEmpty()) {
            sql.append(" AND ").append(truePrice).append(" <= :maxP");
        }

        String orderBy = switch (sortType != null ? sortType : "") {
            case "new"         -> "created_at DESC";
            case "oldest"      -> "created_at ASC";
            case "name_az"     -> "name ASC";
            case "name_za"     -> "name DESC";
            case "price_up"    -> "COALESCE(NULLIF(sale_price, 0), price) ASC";
            case "price_down"  -> "COALESCE(NULLIF(sale_price, 0), price) DESC";
            case "best_seller" -> "views DESC"; // best seller là dựa vào view??? để tạm
            default            -> "id ASC";
        };
        sql.append(" ORDER BY ").append(orderBy);

        return getJdbi().withHandle(handle -> {
            var query = handle.createQuery(sql.toString());
            if (categoryId != null && !categoryId.isEmpty()) query.bind("cid", Integer.parseInt(categoryId));
            if (minPrice != null && !minPrice.isEmpty()) query.bind("minP", Double.parseDouble(minPrice));
            if (maxPrice != null && !maxPrice.isEmpty()) query.bind("maxP", Double.parseDouble(maxPrice));
            return query.mapToBean(Product.class).list();
        });
    }


}
