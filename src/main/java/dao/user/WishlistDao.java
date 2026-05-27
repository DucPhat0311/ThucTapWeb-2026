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

}