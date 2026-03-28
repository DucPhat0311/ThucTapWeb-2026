package dao.admin;

import java.util.List;
import dao.core.BaseDao;
import model.User;

public class UserDaoAdmin extends BaseDao {
    public List<User> getListUser() {
        return getJdbi().withHandle(handle ->
                handle.createQuery("SELECT * FROM users")
                        .mapToBean(User.class)
                        .list()
        );
    }

        public int getCountActive() {
        return getJdbi().withHandle(handle ->
                handle.createQuery("""
                SELECT COUNT(*)
                FROM users
                WHERE status = 'ACTIVE'
            """)
                        .mapTo(int.class)
                        .one()
        );
    }


    public int getCountBlock() {
        return getJdbi().withHandle(handle ->
                handle.createQuery("""
                SELECT COUNT(*)
                FROM users
                WHERE status = 'BLOCKED'
            """)
                        .mapTo(int.class)
                        .one()
        );
    }

    public List<User> searchByUsernameOrEmail(String keyword) {
        return getJdbi().withHandle(handle -> handle.createQuery("""
                SELECT *
                FROM users
                WHERE username LIKE :keyword OR email LIKE :keyword
                """).bind("keyword", "%" + keyword + "%")
                .mapToBean(User.class)
                .list());
    }

    public void createUser(User user) {
        getJdbi().withHandle(handle ->
                handle.createUpdate("""
                INSERT INTO users
                (username, email, password, role, status,
                 full_name, birthday, gender, phone, address, created_at)
                VALUES
                (:username, :email, :password, :role, :status,
                 :fullName, :birthday, :gender, :phone, :address, NOW())
            """)
                        .bindBean(user)
                        .execute()
        );
    }

    public void updateUser(User user) {
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
                    address = :address
                WHERE id = :id
            """)
                        .bindBean(user)
                        .execute()
        );
    }

    public void blockUser(int id, String status) {
        getJdbi().withHandle(handle ->
                handle.createUpdate("""
                UPDATE users
                SET status = :status
                WHERE id = :id
            """)
                        .bind("status", status)
                        .bind("id", id)
                        .execute()
        );
    }

}
