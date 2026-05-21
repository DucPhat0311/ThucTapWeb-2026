package dao.user;

import dao.core.BaseDao;
import model.Review;

import java.util.List;

public class ReviewDao extends BaseDao {

    public Review findByProductAndUser(int productId, int userId) {
        return getJdbi().withHandle(handle ->
                handle.createQuery("""
            SELECT * 
            FROM reviews
            WHERE product_id = :pid AND user_id = :uid
        """)
                        .bind("pid", productId)
                        .bind("uid", userId)
                        .mapToBean(Review.class)
                        .findOne()
                        .orElse(null)
        );
    }



    public void update(Review review) {
        getJdbi().useHandle(handle ->
                handle.createUpdate("""
            UPDATE reviews
            SET rating = :rating,
                comment = :comment,
                created_at = NOW()
            WHERE product_id = :pid AND user_id = :uid
        """)
                        .bind("pid", review.getProductId())
                        .bind("uid", review.getUserId())
                        .bind("rating", review.getRating())
                        .bind("comment", review.getComment())
                        .execute()
        );
    }



    public List<Review> findByProductID(int productId) {
        return getJdbi().withHandle(handle -> handle.createQuery(
                        """
                                SELECT * 
                                FROM reviews
                                WHERE product_id = :productId
                                ORDER BY created_at DESC
                                """
                ).bind("productId", productId)
                .mapToBean(Review.class)
                .list());
    }


    public double getAvgRating(int id) {
        return getJdbi().withHandle(handle -> handle.createQuery("""
                SELECT AVG(rating)
                FROM reviews
                WHERE product_id = :id
                """).bind("id", id)
                .mapTo(double.class)
                .one());

    }

    public int getTotalReviews(int id) {
        return getJdbi().withHandle(handle -> handle.createQuery("""
                SELECT COUNT(*)
                FROM reviews
                WHERE product_id = :id
                """).bind("id", id)
                .mapTo(int.class)
                .one());
    }

    public List<String> getImagesByReviewId(int reviewId) {
        return getJdbi().withHandle(handle -> handle.createQuery(
                        "SELECT image_url FROM review_images WHERE review_id = :rid")
                .bind("rid", reviewId)
                .mapTo(String.class)
                .list()
        );
    }

    // void -> int
    public int insert(Review review) {
        return getJdbi().withHandle(handle ->
                handle.createUpdate("""
               INSERT INTO reviews(product_id, user_id, rating, comment, created_at)
               VALUES (:pid, :uid, :rating, :comment, NOW())
           """)
                        .bind("pid", review.getProductId())
                        .bind("uid", review.getUserId())
                        .bind("rating", review.getRating())
                        .bind("comment", review.getComment())
                        .executeAndReturnGeneratedKeys("id")
                        .mapTo(Integer.class)
                        .one()
        );
    }

    public void insertReviewImage(int reviewId, String imageUrl) {
        getJdbi().useHandle(handle -> handle.createUpdate(
                        "INSERT INTO review_images(review_id, image_url) VALUES (:rid, :img)")
                .bind("rid", reviewId)
                .bind("img", imageUrl)
                .execute()
        );
    }
}
