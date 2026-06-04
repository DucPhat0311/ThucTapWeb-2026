package dao.user;

import dao.core.BaseDao;
import model.Product;

import java.util.List;

public class WishlistDao extends BaseDao {
    public boolean isExist(int userId, int productId) {
        return getJdbi().withHandle(handle ->
                handle.createQuery("SELECT COUNT(*) FROM wishlists WHERE user_id = :userId AND product_id = :productId")
                        .bind("userId", userId)
                        .bind("productId", productId)
                        .mapTo(int.class)
                        .one()
        ) > 0;
    }

    public boolean addWishlist(int userId, int productId) {
        return getJdbi().withHandle(handle ->
                handle.createUpdate("INSERT INTO wishlists (user_id, product_id) VALUES (:userId, :productId)")
                        .bind("userId", userId)
                        .bind("productId", productId)
                        .execute()
        ) > 0;
    }

    public boolean removeWishlist(int userId, int productId) {
        return getJdbi().withHandle(handle ->
                handle.createUpdate("DELETE FROM wishlists WHERE user_id = :userId AND product_id = :productId")
                        .bind("userId", userId)
                        .bind("productId", productId)
                        .execute()
        ) > 0;
    }


    public List<Product> getWishlistProductsByUserId(int userId) {
        String sql = "SELECT p.*, " +
                "(SELECT image_url FROM product_images WHERE product_id = p.id AND is_main = 0 ORDER BY id ASC LIMIT 1) AS hoverImage, " +
                "(SELECT COUNT(DISTINCT color_id) FROM product_variants WHERE product_id = p.id) AS colorCount, " +
                "(SELECT COUNT(DISTINCT size_id) FROM product_variants WHERE product_id = p.id) AS sizeCount, " +
                "(SELECT COALESCE(ROUND(AVG(rating), 1), 5.0) FROM reviews WHERE product_id = p.id) AS avgRating, " +
                "(SELECT COUNT(*) FROM reviews WHERE product_id = p.id) AS totalReviews, " +
                "(SELECT COALESCE(SUM(stock), 0) FROM product_variants WHERE product_id = p.id) AS totalStock " +
                "FROM products p " +
                "JOIN wishlists w ON p.id = w.product_id " +
                "WHERE w.user_id = :userId " +
                "ORDER BY w.id DESC";

        return getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("userId", userId)
                        .mapToBean(Product.class)
                        .list()
        );
    }

}