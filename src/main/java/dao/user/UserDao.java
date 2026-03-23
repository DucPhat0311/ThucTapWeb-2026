package dao.user;

import java.time.LocalDateTime;
import java.util.List;
import dao.core.BaseDao;
import model.User;

public class UserDao extends BaseDao {
        public User finduser(String username) {
        return getJdbi().withHandle(handle ->
                handle.createQuery("select * from users where username=:username OR email=:username")
                        .bind("username", username)
                        .mapToBean(User.class)
                        .findFirst()
                        .orElse(null)
        );
    }

        public boolean existsByUsername(String username) {
        return getJdbi().withHandle(h ->
                h.createQuery("SELECT COUNT(*) FROM users WHERE username = :u")
                        .bind("u", username)
                        .mapTo(int.class)
                        .one()
        ) > 0;
    }

    
        public void insertPendingUser(String username, String email, String password, String fullName, String birthdayStr, String gender,
                                  String otp, LocalDateTime expiredAt) {
        getJdbi().withHandle(h ->
                h.createUpdate(
                                "INSERT INTO users(username,email,password,full_name,birthday,gender,otp_code,otp_expired_at,is_active,status) " +
                                        "VALUES (:u,:e,:p,:fn,:b,:g,:otp,:exp,0,'PENDING')"
                        )
                        .bind("u", username)
                        .bind("e", email)
                        .bind("p", password)
                        .bind("fn", fullName)
                        .bind("b", birthdayStr)
                        .bind("g", gender)
                        .bind("otp", otp)
                        .bind("exp", expiredAt)
                        .execute()
        );
    }

    public void updatePendingUser(String email, String username, String password, String fullName, String birthdayStr, String gender,
                                  String otp, LocalDateTime expiredAt) {
        getJdbi().withHandle(h ->
                h.createUpdate(
                                "UPDATE users SET username=:u, password=:p, full_name=:fn, birthday=:b, gender=:g, otp_code=:otp, otp_expired_at=:exp " +
                                        "WHERE email=:e AND is_active=0"
                        )
                        .bind("u", username)
                        .bind("e", email)
                        .bind("p", password)
                        .bind("fn", fullName)
                        .bind("b", birthdayStr)
                        .bind("g", gender)
                        .bind("otp", otp)
                        .bind("exp", expiredAt)
                        .execute()
        );
    }

}