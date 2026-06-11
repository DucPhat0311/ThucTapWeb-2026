package dao.user;

import dao.core.BaseDao;
import model.Notification;

import java.util.List;

public class NotificationDao extends BaseDao {

    public int createNotification(Integer userId, String title, String message, String url) {
        return getJdbi().withHandle(h ->
                h.createUpdate("""
                    INSERT INTO notifications(
                        user_id, title, message, url, is_read, created_at
                    ) VALUES(
                        :userId, :title, :message, :url, 0, NOW()
                    )
                """)
                        .bind("userId", userId)
                        .bind("title", title)
                        .bind("message", message)
                        .bind("url", url)
                        .executeAndReturnGeneratedKeys("id")
                        .mapTo(int.class)
                        .one()
        );
    }

    public List<Notification> findAllByUserId(int userId) {
        return getJdbi().withHandle(h ->
                h.createQuery("""
                SELECT id, user_id, title, message, url, is_read, created_at
                FROM notifications
                WHERE user_id = :userId
                ORDER BY created_at DESC
            """)
                        .bind("userId", userId)
                        .map((rs, ctx) -> {
                            Notification n = new Notification();
                            n.setId(rs.getInt("id"));
                            n.setUserId(rs.getInt("user_id"));
                            n.setTitle(rs.getString("title"));
                            n.setMessage(rs.getString("message"));
                            n.setUrl(rs.getString("url"));
                            n.setRead(rs.getInt("is_read") != 0);
                            var ts = rs.getTimestamp("created_at");
                            n.setCreatedAt(ts == null ? null : ts.toLocalDateTime());
                            return n;
                        })
                        .list()
        );
    }

    public List<Notification> findLatestByUserId(int userId, int limit) {
        return getJdbi().withHandle(h ->
                h.createQuery("""
                    SELECT id, user_id, title, message, url, is_read, created_at
                    FROM notifications
                    WHERE user_id = :userId
                    ORDER BY created_at DESC
                    LIMIT :limit
                """)
                        .bind("userId", userId)
                        .bind("limit", limit)
                        .map((rs, ctx) -> {
                            Notification n = new Notification();
                            n.setId(rs.getInt("id"));
                            n.setUserId(rs.getInt("user_id"));
                            n.setTitle(rs.getString("title"));
                            n.setMessage(rs.getString("message"));
                            n.setUrl(rs.getString("url"));
                            n.setRead(rs.getInt("is_read") != 0);
                            var ts = rs.getTimestamp("created_at");
                            n.setCreatedAt(ts == null ? null : ts.toLocalDateTime());
                            return n;
                        })
                        .list()
        );
    }

    public void markAllReadForUser(int userId) {
        getJdbi().useHandle(h ->
                h.createUpdate("UPDATE notifications SET is_read = 1 WHERE user_id = :userId AND is_read = 0")
                        .bind("userId", userId)
                        .execute()
        );
    }

    public int countUnreadForUser(int userId) {
        return getJdbi().withHandle(h ->
                h.createQuery("SELECT COUNT(*) FROM notifications WHERE user_id = :userId AND is_read = 0")
                        .bind("userId", userId)
                        .mapTo(int.class)
                        .one()
        );
    }

    public List<Notification> findLatestForUser(int userId) {
        return findLatestByUserId(userId, 5);
    }

}

