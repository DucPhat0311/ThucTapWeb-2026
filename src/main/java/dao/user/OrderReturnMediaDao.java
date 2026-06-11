package dao.user;

import dao.core.BaseDao;
import model.OrderReturnMedia;

import java.util.List;

public class OrderReturnMediaDao extends BaseDao {

    public void insert(int orderReturnId, String mediaType, String mediaUrl, String originalName) {
        getJdbi().useHandle(h ->
                h.createUpdate("""
                    INSERT INTO order_return_media (
                        order_return_id,
                        media_type,
                        media_url,
                        original_name,
                        created_at
                    )
                    VALUES (
                        :orderReturnId,
                        :mediaType,
                        :mediaUrl,
                        :originalName,
                        NOW()
                    )
                """)
                        .bind("orderReturnId", orderReturnId)
                        .bind("mediaType", mediaType)
                        .bind("mediaUrl", mediaUrl)
                        .bind("originalName", originalName)
                        .execute()
        );
    }

    public List<OrderReturnMedia> findByReturnId(int orderReturnId) {
        return getJdbi().withHandle(h ->
                h.createQuery("""
                    SELECT
                        id,
                        order_return_id AS orderReturnId,
                        media_type AS mediaType,
                        media_url AS mediaUrl,
                        original_name AS originalName,
                        created_at AS createdAt
                    FROM order_return_media
                    WHERE order_return_id = :orderReturnId
                    ORDER BY id ASC
                """)
                        .bind("orderReturnId", orderReturnId)
                        .mapToBean(OrderReturnMedia.class)
                        .list()
        );
    }
}
