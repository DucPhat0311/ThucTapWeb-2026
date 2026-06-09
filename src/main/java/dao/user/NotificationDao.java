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


}

