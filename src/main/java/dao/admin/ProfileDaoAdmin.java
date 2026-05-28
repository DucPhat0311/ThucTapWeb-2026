package dao.admin;

import dao.core.BaseDao;
import model.User;

public class ProfileDaoAdmin extends BaseDao {
    public User getAdminById(int id) {
        return getJdbi().withHandle(handle ->
                handle.createQuery("SELECT * FROM users WHERE id = :id AND role = 'ADMIN'")
                        .bind("id", id)
                        .mapToBean(User.class)
                        .findFirst()
                        .orElse(null)
        );
    }

    public void updateAdmin(User admin) {
             getJdbi().withHandle(handle ->
                handle.createUpdate("""
                UPDATE users
                SET username = :username,
                    email = :email,
                    role = :role,
                    status = :status,
                    full_name = :fullName,
                    phone = :phone,
                    birthday = :birthday,
                    gender = :gender,
                    address = :address,
                    avatar_url = :avatarUrl
                WHERE id = :id
            """)
                        .bindBean(admin)
                        .execute()
        );
    }

    public void updateAvatarOnly(int adminId, String avatarUrl) {
        getJdbi().withHandle(handle ->
                handle.createUpdate("UPDATE users SET avatar_url = :avatarUrl WHERE id = :id")
                        .bind("avatarUrl", avatarUrl)
                        .bind("id", adminId)
                        .execute()
        );
    }

    public void changePassword(int adminId, String newPassword) {
        getJdbi().withHandle(handle ->
                handle.createUpdate("UPDATE users SET password = :password WHERE id = :id")
                        .bind("password", newPassword)
                        .bind("id", adminId)
                        .execute()
        );
    }
}
