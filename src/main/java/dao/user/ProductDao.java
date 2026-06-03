package dao.user;
import dao.core.BaseDao;
import model.Product;
import org.jdbi.v3.core.Jdbi;
import java.util.ArrayList;
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
                                "SELECT p.*, " +
                                        "(SELECT image_url FROM product_images WHERE product_id = p.id AND is_main = 0 ORDER BY id ASC LIMIT 1) AS hoverImage, " +
                                        "(SELECT COUNT(DISTINCT color_id) FROM product_variants WHERE product_id = p.id) AS colorCount, " +
                                        "(SELECT COUNT(DISTINCT size_id) FROM product_variants WHERE product_id = p.id) AS sizeCount, " +
                                        "(SELECT COALESCE(ROUND(AVG(rating), 1), 0) FROM reviews WHERE product_id = p.id) AS avgRating, " +
                                        "(SELECT COUNT(*) FROM reviews WHERE product_id = p.id) AS totalReviews, " +
                                        "(SELECT COALESCE(SUM(stock), 0) FROM product_variants WHERE product_id = p.id) AS totalStock " +
                                        "FROM products p " +
                                        "WHERE p.status = 'Đang hoạt động' " +
                                        "ORDER BY p.created_at DESC LIMIT :limit"
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
        String sql = "SELECT p.*, " +
                "(SELECT image_url FROM product_images WHERE product_id = p.id AND is_main = 0 ORDER BY id ASC LIMIT 1) AS hoverImage, " +
                "(SELECT COUNT(DISTINCT color_id) FROM product_variants WHERE product_id = p.id) AS colorCount, " +
                "(SELECT COUNT(DISTINCT size_id) FROM product_variants WHERE product_id = p.id) AS sizeCount, " +
                "(SELECT COALESCE(ROUND(AVG(rating), 1), 5.0) FROM reviews WHERE product_id = p.id) AS avgRating, " +
                "(SELECT COUNT(*) FROM reviews WHERE product_id = p.id) AS totalReviews, " +
                "(SELECT COALESCE(SUM(stock), 0) FROM product_variants WHERE product_id = p.id) AS totalStock "+
                "FROM products p " +
                "WHERE p.category_id IN (<ids>) AND p.status = 'Đang hoạt động' " +
                "ORDER BY p.created_at DESC LIMIT :limit";




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
              SELECT p.*, c.name AS categoryName, "(SELECT COALESCE(SUM(stock), 0) FROM product_variants WHERE product_id = p.id) AS totalStock "
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
    public List<Product> getRelatedProductByCategory(int categoryId, int currentProductId, int limit) {
        String sql = """
            SELECT p.*, 
                   (SELECT image_url FROM product_images WHERE product_id = p.id AND is_main = 0 ORDER BY id ASC LIMIT 1) AS hoverImage, 
                   (SELECT COUNT(DISTINCT color_id) FROM product_variants WHERE product_id = p.id) AS colorCount, 
                   (SELECT COUNT(DISTINCT size_id) FROM product_variants WHERE product_id = p.id) AS sizeCount, 
                   (SELECT COALESCE(ROUND(AVG(rating), 1), 5.0) FROM reviews WHERE product_id = p.id) AS avgRating, 
                   (SELECT COUNT(*) FROM reviews WHERE product_id = p.id) AS totalReviews,
                   (SELECT COALESCE(SUM(stock), 0) FROM product_variants WHERE product_id = p.id) AS totalStock
            FROM products p 
            WHERE p.category_id = :categoryId 
              AND p.id <> :currentProductId 
              AND p.status = 'Đang hoạt động' 
            ORDER BY p.created_at DESC 
            LIMIT :limit
            """;

        return getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("categoryId", categoryId)
                        .bind("currentProductId", currentProductId)
                        .bind("limit", limit)
                        .mapToBean(Product.class)
                        .list()
        );
    }




    public List<Product> searchByName(String keyword) {
        String sql = """
  SELECT p.*, c.name AS categoryName, (SELECT COALESCE(SUM(stock), 0) FROM product_variants WHERE product_id = p.id) AS totalStock
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
            AND status = 'Đang hoạt động'
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
            AND status = 'Đang hoạt động'
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
            AND status = 'Đang hoạt động'
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
        String sql = "SELECT *, (SELECT COALESCE(SUM(stock), 0) FROM product_variants WHERE product_id = p.id) AS totalStock " +
                "FROM products p WHERE category_id IN (<ids>) AND status = 'Đang hoạt động'";
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
                                  AND status = 'Đang hoạt động'
                              ORDER BY created_at DESC
                      """)
                        .mapToBean(Product.class)
                        .list()
        );
    }

    public List<Product> filterProducts(String categoryIds, String sortType, String minPrice, String maxPrice,
                                        String sizes, String colors, int limit, int offset) {
        StringBuilder sql = new StringBuilder("SELECT DISTINCT p.*, ");
        sql.append("(SELECT image_url FROM product_images WHERE product_id = p.id AND is_main = 0 ORDER BY id ASC LIMIT 1) AS hoverImage, ");
        sql.append("(SELECT COUNT(DISTINCT color_id) FROM product_variants WHERE product_id = p.id) AS colorCount, ");
        sql.append("(SELECT COUNT(DISTINCT size_id) FROM product_variants WHERE product_id = p.id) AS sizeCount, ");
        sql.append("(SELECT COALESCE(ROUND(AVG(rating), 1), 0) FROM reviews WHERE product_id = p.id) AS avgRating, ");
        sql.append("(SELECT COUNT(*) FROM reviews WHERE product_id = p.id) AS totalReviews, ");
        sql.append("(SELECT COALESCE(SUM(stock), 0) FROM product_variants WHERE product_id = p.id) AS totalStock ");
        sql.append("FROM products p ");
        if (sizes != null || colors != null) {
            sql.append(" JOIN product_variants pv ON p.id = pv.product_id ");
            sql.append(" JOIN colors c_v ON pv.color_id = c_v.id ");
            sql.append(" JOIN sizes s_v ON pv.size_id = s_v.id ");
        }
        sql.append(" WHERE p.status = 'Đang hoạt động' ");
        List<Integer> catIdList = new ArrayList<>();
        if (categoryIds != null && !categoryIds.isEmpty()) {
            for (String id : categoryIds.split(",")) {
                try { catIdList.add(Integer.parseInt(id.trim())); } catch (Exception e) {}
            }
            if (!catIdList.isEmpty()) sql.append(" AND p.category_id IN (<catIds>) ");
        }
        if (colors != null && !colors.isEmpty()) {
            sql.append(" AND c_v.name IN (<colorList>) ");
        }
        if (sizes != null && !sizes.isEmpty()) {
            sql.append(" AND s_v.code IN (<sizeList>) ");
        }
        String truePrice = "COALESCE(NULLIF(p.sale_price, 0), p.price)";
        if (minPrice != null && !minPrice.isEmpty()) sql.append(" AND ").append(truePrice).append(" >= :minP ");
        if (maxPrice != null && !maxPrice.isEmpty()) sql.append(" AND ").append(truePrice).append(" <= :maxP ");
        // Sắp xếp
        String orderBy = switch (sortType != null ? sortType : "") {
            case "price_up" -> truePrice + " ASC";
            case "price_down" -> truePrice + " DESC";
            case "best_seller" -> "p.views DESC";
            case "oldest" -> "p.created_at ASC";
            default -> "p.created_at DESC";
        };
        sql.append(" ORDER BY ").append(orderBy);
        sql.append(" LIMIT :limit OFFSET :offset");
        return getJdbi().withHandle(handle -> {
            var query = handle.createQuery(sql.toString());
            if (!catIdList.isEmpty()) query.bindList("catIds", catIdList);
            if (colors != null && !colors.isEmpty()) query.bindList("colorList", List.of(colors.split(",")));
            if (sizes != null && !sizes.isEmpty()) query.bindList("sizeList", List.of(sizes.split(",")));
            query.bind("minP", (minPrice == null || minPrice.isEmpty()) ? 0 : Double.parseDouble(minPrice));
            query.bind("maxP", (maxPrice == null || maxPrice.isEmpty()) ? 99999999 : Double.parseDouble(maxPrice));
            query.bind("limit", limit);
            query.bind("offset", offset);
            return query.mapToBean(Product.class).list();
        });
    }

    public int countProducts(String categoryIds, String minPrice, String maxPrice, String sizes, String colors) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(DISTINCT p.id) FROM products p ");
        boolean hasSize = (sizes != null && !sizes.isEmpty());
        boolean hasColor = (colors != null && !colors.isEmpty());
        if (sizes != null || colors != null) {
            sql.append(" JOIN product_variants pv ON p.id = pv.product_id ");
            sql.append(" JOIN colors c_v ON pv.color_id = c_v.id ");
            sql.append(" JOIN sizes s_v ON pv.size_id = s_v.id ");
        }
        sql.append(" WHERE p.status = 'Đang hoạt động' ");
        List<Integer> catIds = new ArrayList<>();
        if (categoryIds != null && !categoryIds.isEmpty()) {
            for (String id : categoryIds.split(",")) {
                try { catIds.add(Integer.parseInt(id.trim())); } catch (Exception e) {}
            }
            if (!catIds.isEmpty()) {
                sql.append(" AND p.category_id IN (<ids>) ");
            }
        }
        String truePrice = "COALESCE(NULLIF(p.sale_price, 0), p.price)";
        boolean bindMin = (minPrice != null && !minPrice.isEmpty());
        boolean bindMax = (maxPrice != null && !maxPrice.isEmpty());
        if (bindMin) sql.append(" AND ").append(truePrice).append(" >= :minP ");
        if (bindMax) sql.append(" AND ").append(truePrice).append(" <= :maxP ");
        if (hasColor) sql.append(" AND c_v.name IN (<colorList>) ");
        if (hasSize) sql.append(" AND s_v.code IN (<sizeList>) ");

        return getJdbi().withHandle(handle -> {
            var query = handle.createQuery(sql.toString());
            if (!catIds.isEmpty()) {
                query.bindList("ids", catIds);
            }

            if (bindMin) {
                query.bind("minP", Double.parseDouble(minPrice));
            }

            if (bindMax) {
                query.bind("maxP", Double.parseDouble(maxPrice));
            }

            if (hasColor) {
                query.bindList("colorList", List.of(colors.split(",")));
            }

            if (hasSize) {
                query.bindList("sizeList", List.of(sizes.split(",")));
            }

            return query.mapTo(Integer.class).one();
        });
    }

    public List<Product> searchAndPaginate(String keyword, int limit, int offset) {
        StringBuilder sql = new StringBuilder("""
           SELECT p.*,
              (SELECT image_url FROM product_images WHERE product_id = p.id AND is_main = 0 ORDER BY id ASC LIMIT 1) AS hoverImage,
              (SELECT COUNT(DISTINCT color_id) FROM product_variants WHERE product_id = p.id) AS colorCount,
              (SELECT COUNT(DISTINCT size_id) FROM product_variants WHERE product_id = p.id) AS sizeCount,
              (SELECT COALESCE(ROUND(AVG(rating), 1), 0) FROM reviews WHERE product_id = p.id) AS avgRating,
              (SELECT COUNT(*) FROM reviews WHERE product_id = p.id) AS totalReviews,
              (SELECT COALESCE(SUM(stock), 0) FROM product_variants WHERE product_id = p.id) AS totalStock
           FROM products p
           WHERE p.status = 'Đang hoạt động'
       """);

        String[] words = keyword.trim().replaceAll("\\s+", " ").split(" ");
        for (int i = 0; i < words.length; i++) {
            sql.append(" AND CONCAT(' ', LOWER(p.name), ' ') LIKE :word").append(i);
        }

        sql.append(" ORDER BY p.id DESC LIMIT :limit OFFSET :offset");
        return getJdbi().withHandle(handle -> {
            var query = handle.createQuery(sql.toString());

            for (int i = 0; i < words.length; i++) {
                query.bind("word" + i, "% " + words[i].toLowerCase() + " %");
            }
            query.bind("limit", limit);
            query.bind("offset", offset);


            return query.mapToBean(Product.class).list();
        });
    }

    public int countAndSearch(String keyword) {
        StringBuilder sql = new StringBuilder("""
           SELECT COUNT(*)
           FROM products p
           WHERE p.status = 'Đang hoạt động'
       """);

        String[] words = keyword.trim().replaceAll("\\s+", " ").split(" ");
        for (int i = 0; i < words.length; i++) {
            sql.append(" AND CONCAT(' ', LOWER(p.name), ' ') LIKE :word").append(i);
        }

        return getJdbi().withHandle(handle -> {
            var query = handle.createQuery(sql.toString());
            for (int i = 0; i < words.length; i++) {
                query.bind("word" + i, "% " + words[i].toLowerCase() + " %");
            }
            return query.mapTo(Integer.class).one();
        });
    }


}
