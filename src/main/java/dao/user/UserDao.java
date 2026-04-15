package dao.user;

import java.time.LocalDateTime;
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

    public User findByEmail(String email) {
        return getJdbi().withHandle(handle ->
                handle.createQuery("SELECT * FROM users WHERE email = :email")
                        .bind("email", email)
                        .mapToBean(User.class)
                        .findFirst()
                        .orElse(null)
        );
    }

    public User findByGoogleSub(String googleSub) {
        return getJdbi().withHandle(handle ->
                handle.createQuery("SELECT * FROM users WHERE google_sub = :googleSub")
                        .bind("googleSub", googleSub)
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

    public void linkGoogleAccount(int userId, String googleSub, String avatarUrl, String fullName) {
        getJdbi().withHandle(h ->
                h.createUpdate("""
                                UPDATE users
                                SET google_sub = :googleSub,
                                    auth_provider = 'GOOGLE',
                                    avatar_url = COALESCE(:avatarUrl, avatar_url),
                                    full_name = CASE
                                        WHEN full_name IS NULL OR full_name = '' THEN :fullName
                                        ELSE full_name
                                    END
                                WHERE id = :id
                                """)
                        .bind("googleSub", googleSub)
                        .bind("avatarUrl", avatarUrl)
                        .bind("fullName", fullName)
                        .bind("id", userId)
                        .execute()
        );
    }

    public void insertGoogleUser(String username, String email, String passwordHash, String fullName, String googleSub, String avatarUrl) {
        getJdbi().withHandle(h ->
                h.createUpdate("""
                                INSERT INTO users
                                (username, email, password, role, full_name, avatar_url, google_sub, auth_provider, is_active, status, created_at)
                                VALUES
                                (:username, :email, :password, 'USER', :fullName, :avatarUrl, :googleSub, 'GOOGLE', 1, 'ACTIVE', NOW())
                                """)
                        .bind("username", username)
                        .bind("email", email)
                        .bind("password", passwordHash)
                        .bind("fullName", fullName)
                        .bind("avatarUrl", avatarUrl)
                        .bind("googleSub", googleSub)
                        .execute()
        );
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
    public User findUserById(int id) {
        return getJdbi().withHandle(handle ->
                handle.createQuery("""
                SELECT id,
                       username,
                       email,
                       google_sub,
                       role,
                       auth_provider,
                       is_active,
                       created_at,
                       full_name,
                       avatar_url,
                       birthday,
                       gender,
                       phone,
                       address,
                       status
                FROM users
                WHERE id = :id
            """)
                        .bind("id", id)
                        .mapToBean(User.class)
                        .findOne()
                        .orElse(null)
        );
    }

    public void update(User user) {
        getJdbi().withHandle(handle -> handle.createUpdate("""
                        UPDATE users
                                    SET full_name = :fullName,
                                        phone = :phone,
                                        email = :email,
                                        birthday = :birthday,
                                        gender = :gender,
                                        address = :address
                                    WHERE id = :id
                        """)
                .bind("fullName", user.getFullName())
                .bind("phone", user.getPhone())
                .bind("email", user.getEmail())
                .bind("birthday", user.getBirthday())
                .bind("gender", user.getGender())
                .bind("address", user.getAddress())
                .bind("id", user.getId())
                .execute()
        );


    }

    public void updateAvatar(int userId, String avatarUrl) {
        getJdbi().withHandle(handle -> handle.createUpdate("""
                        UPDATE users
                        SET avatar_url = :avatarUrl
                        WHERE id = :id
                        """)
                .bind("avatarUrl", avatarUrl)
                .bind("id", userId)
                .execute()
        );
    }

    public String getPasswordById(int id) {
        return getJdbi().withHandle(handle -> handle.createQuery("""
                SELECT password
                FROM users
                WHERE id = :id""")
                .bind("id", id)
                .mapTo(String.class)
                .findOne()
                .orElse(null));
    }

    public boolean updatePasss(int id, String hash) {
        return  getJdbi().withHandle(handle -> handle.createUpdate("""
                UPDATE users
                SET password = :hash
                WHERE id = :id""")
                .bind("hash",hash)
                .bind("id", id)
                .execute()) > 0;        //Nếu update thành công thì trả về 1 không thì trả về 0
    }



    public void updateOtpForReset(String email, String otp, LocalDateTime expiredAt) {
        getJdbi().withHandle(h ->
                h.createUpdate("UPDATE users SET otp_code=:otp, otp_expired_at=:exp WHERE email=:e")
                .bind("otp", otp)
                .bind("exp", expiredAt)
                .bind("e", email)
                .execute());
    }

    public boolean verifyOtp(String email, String otp) {
        return getJdbi().withHandle(h ->
                h.createUpdate(
                                "UPDATE users SET is_active=1, status = 'ACTIVE',otp_code=NULL, otp_expired_at=NULL " +
                                        "WHERE email=:e AND otp_code=:otp AND otp_expired_at > NOW()"
                        )
                        .bind("e", email)
                        .bind("otp", otp)
                        .execute()
        ) > 0;
    }

       public boolean lastCheckOtp(String email, String otp) {
        return getJdbi().withHandle(h ->
                h.createQuery("SELECT COUNT(*) FROM users " +
                                        "WHERE email=:e AND otp_code=:otp AND otp_expired_at > NOW()")
                                        .bind("e", email)
                                        .bind("otp", otp)
                                        .mapTo(int.class)
                                        .one()) > 0;
    }

    public boolean verifyOtpForReset(String email, String otp) {
        int count = getJdbi().withHandle(h ->
                h.createQuery(
                                "SELECT COUNT(*) FROM users " +
                                        "WHERE email=:e AND otp_code=:otp AND otp_expired_at > NOW()")
                                        .bind("e", email)
                                        .bind("otp", otp)
                                        .mapTo(int.class)
                                        .one());
        return count > 0;
    }

    public void updatePassword(String email, String password) {
        getJdbi().withHandle(h ->
                h.createUpdate("UPDATE users SET password=:p, otp_code=NULL, otp_expired_at=NULL " +
                                        "WHERE email=:e")
                                        .bind("p", password)
                                        .bind("e", email)
                                        .execute()
        );
    }
}
