package service;

import dao.user.UserDao;
import dao.admin.UserDaoAdmin;
import model.GoogleUserInfo;
import model.User;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Random;
import java.util.UUID;
import util.PassUtil;

public class UserService {

    private final UserDao userDao = new UserDao();
    private final UserDaoAdmin userDaoAdmin = new UserDaoAdmin();

    public int cleanupExpiredPendingRegistrations() {
        return userDao.deleteExpiredPendingUsers();
    }

    private String checkPasswordStrength(String password) {
        if (password == null || password.length() < 8)
            return "Mật khẩu phải có ít nhất 8 ký tự";

        boolean hasUpper = false;
        boolean hasLower = false;
        boolean hasDigit = false;
        boolean hasSpecial = false;

        for (char c : password.toCharArray()) {
            if (Character.isUpperCase(c)) hasUpper = true;
            else if (Character.isLowerCase(c)) hasLower = true;
            else if (Character.isDigit(c)) hasDigit = true;
            else hasSpecial = true;
        }

        if (!hasUpper) return "Mật khẩu phải có ít nhất 1 chữ hoa";
        if (!hasLower) return "Mật khẩu phải có ít nhất 1 chữ thường";
        if (!hasDigit) return "Mật khẩu phải có ít nhất 1 chữ số";
        if (!hasSpecial) return "Mật khẩu phải có ít nhất 1 ký tự đặc biệt";

        return null; 
    }

     public void registerSendOtp(String username, String email, String password, String fullName, String birthdayStr, String gender) {

        if (userDao.existsByUsername(username)) {
            throw new RuntimeException("Tên đăng nhập đã tồn tại");
        }
        String passwordError = checkPasswordStrength(password);
        if (passwordError != null) {
            throw new RuntimeException(passwordError);
        }

        String hashedPassword = PassUtil.hash(password);
        String otp = String.format("%06d", new Random().nextInt(1_000_000));
        LocalDateTime expiredAt = LocalDateTime.now().plusMinutes(5);

        User existing = userDao.finduser(email);
        if (existing == null) {
            userDao.insertPendingUser(username, email, hashedPassword, fullName, birthdayStr, gender, otp, expiredAt);
        } else if (existing.getIsActive() == 0) {
            userDao.updatePendingUser(email, username, hashedPassword, fullName, birthdayStr, gender, otp, expiredAt);
        } else {
            throw new RuntimeException("Email đã được đăng ký");
        }

        try {
            EmailService.sendEmail(
                    email,
                    "OTP xác nhận đăng ký ",
                    "<h3>Mã OTP của bạn: <b>" + otp + "</b></h3>"
            );
        } catch (EmailService.EmailDeliveryException e) {
            userDao.deletePendingUserByEmail(email);
            throw new RuntimeException("Không thể gửi OTP đến email này. Vui lòng kiểm tra email hoặc thử lại sau.", e);
        }
    }

    public User login(String username, String password) {
        User user = userDao.finduser(username);

        if (user == null) return null;

        if (!PassUtil.verify(password, user.getPassword())) return null;

        return user;
    }

    public User loginWithGoogle(GoogleUserInfo googleInfo) {
        if (googleInfo == null) {
            throw new RuntimeException("Không nhận được dữ liệu tài khoản Google");
        }
        if (googleInfo.getSub() == null || googleInfo.getSub().isBlank()) {
            throw new RuntimeException("Thiếu định danh Google (sub)");
        }
        if (googleInfo.getEmail() == null || googleInfo.getEmail().isBlank()) {
            throw new RuntimeException("Thiếu email từ Google");
        }
        if (!googleInfo.isEmailVerified()) {
            throw new RuntimeException("Email Google chưa được xác minh");
        }

        String email = googleInfo.getEmail().trim().toLowerCase();
        String fullName = googleInfo.getName();
        String avatarUrl = googleInfo.getPicture();
        String googleSub = googleInfo.getSub().trim();

        User bySub = userDao.findByGoogleSub(googleSub);
        if (bySub != null) {
            return bySub;
        }

        User byEmail = userDao.findByEmail(email);
        if (byEmail != null) {
            userDao.linkGoogleAccount(byEmail.getId(), googleSub, avatarUrl, fullName);
            return userDao.findUserById(byEmail.getId());
        }

        String username = buildUniqueUsername(email, fullName);
        String passwordHash = PassUtil.hash(UUID.randomUUID().toString());
        userDao.insertGoogleUser(username, email, passwordHash, fullName, googleSub, avatarUrl);
        return userDao.findByGoogleSub(googleSub);
    }

    private String buildUniqueUsername(String email, String fullName) {
        String base = "";
        if (email != null && !email.isBlank() && email.contains("@")) {
            base = email.substring(0, email.indexOf('@'));
        } else if (fullName != null && !fullName.isBlank()) {
            base = fullName.replaceAll("\\s+", "_");
        }

        base = base.replaceAll("[^a-zA-Z0-9._]", "").toLowerCase();
        if (base.isBlank()) {
            base = "google_user";
        }
        if (base.length() > 20) {
            base = base.substring(0, 20);
        }

        String candidate = base;
        int suffix = 1;
        while (userDao.existsByUsername(candidate)) {
            candidate = base + "_" + suffix++;
        }
        return candidate;
    }
    public User findById(int id) {
        return userDao.findUserById(id);
    }

    public void update(User user) {
        userDao.update(user);
    }

    public void updateAvatar(int userId, String avatarUrl) {
        userDao.updateAvatar(userId, avatarUrl);
    }

    public boolean checkOldPass(int id, String oldPass) {
        String hashPass = userDao.getPasswordById(id);

        return PassUtil.checkOldPass(oldPass, hashPass);
    }

    public boolean updatePass(int id, String newPass) {
        String hash = PassUtil.hash(newPass);

        return userDao.updatePasss(id, hash);
    }

    public void sendOtpResetPassword(String email) {

        User user = userDao.finduser(email);
        if (user == null) {throw new RuntimeException("Email không tồn tại");
        }

        String otp = String.format("%06d", new Random().nextInt(1_000_000));
        LocalDateTime expiredAt = LocalDateTime.now().plusMinutes(5);

        userDao.updateOtpForReset(email, otp, expiredAt);

        EmailService.sendEmail(
                email, "OTP đặt lại mật khẩu", "<h3>Mã OTP của bạn: <b>" + otp + "</b></h3>"
        );
    }

    public void resendRegistrationOtp(String email) {
        User user = userDao.findByEmail(email);
        if (user == null || user.getIsActive() != 0) {
            throw new RuntimeException("Email không có yêu cầu đăng ký cần xác minh");
        }

        String otp = String.format("%06d", new Random().nextInt(1_000_000));
        LocalDateTime expiredAt = LocalDateTime.now().plusMinutes(5);

        EmailService.sendEmail(
                email,
                "OTP xác nhận đăng ký",
                "<h3>Mã OTP của bạn: <b>" + otp + "</b></h3>"
        );

        boolean updated = userDao.updateOtpForPendingRegistration(email, otp, expiredAt);
        if (!updated) {
            throw new RuntimeException("Không thể cập nhật OTP đăng ký");
        }
    }

    public EmailChangeOldEmailVerification createProfileEmailChangeOldEmailVerification(int userId,
                                                                                        String currentEmail,
                                                                                        String newEmail) {
        String normalizedNewEmail = normalizeEmail(newEmail);
        if (normalizedNewEmail.isBlank()) {
            throw new RuntimeException("Email mới không hợp lệ");
        }

        User existingUser = userDao.findByEmail(normalizedNewEmail);
        if (existingUser != null && existingUser.getId() != userId) {
            throw new RuntimeException("Email mới đã được sử dụng bởi tài khoản khác");
        }

        String otp = String.format("%06d", new Random().nextInt(1_000_000));
        LocalDateTime expiredAt = LocalDateTime.now().plusMinutes(5);

        EmailService.sendEmail(
                currentEmail,
                "OTP xác nhận thay đổi email",
                "<h3>Mã OTP xác nhận email hiện tại của bạn: <b>" + otp + "</b></h3>"
                        + "<p>Mã này sẽ hết hạn sau 5 phút.</p>"
        );

        return new EmailChangeOldEmailVerification(normalizedNewEmail, otp, expiredAt);
    }

    public EmailChangeNewEmailVerification createProfileEmailChangeNewEmailVerification(String newEmail) {
        String normalizedNewEmail = normalizeEmail(newEmail);
        if (normalizedNewEmail.isBlank()) {
            throw new RuntimeException("Email mới không hợp lệ");
        }

        String otp = String.format("%06d", new Random().nextInt(1_000_000));
        LocalDateTime expiredAt = LocalDateTime.now().plusMinutes(5);

        EmailService.sendEmail(
                normalizedNewEmail,
                "OTP xác nhận email mới",
                "<h3>Mã OTP xác nhận email mới của bạn: <b>" + otp + "</b></h3>"
                        + "<p>Mã này sẽ hết hạn sau 5 phút.</p>"
        );

        return new EmailChangeNewEmailVerification(otp, expiredAt);
    }

    private String normalizeEmail(String email) {
        return email == null ? "" : email.trim().toLowerCase();
    }

    public User completeProfileEmailChange(int userId,
                                           String fullName,
                                           String phone,
                                           String newEmail,
                                           LocalDate birthday,
                                           String gender) {
        String normalizedNewEmail = normalizeEmail(newEmail);
        User existingUser = userDao.findByEmail(normalizedNewEmail);
        if (existingUser != null && existingUser.getId() != userId) {
            throw new RuntimeException("Email mới đã được sử dụng bởi tài khoản khác");
        }

        User user = userDao.findUserById(userId);
        if (user == null) {
            throw new RuntimeException("Không tìm thấy tài khoản cần cập nhật");
        }

        user.setFullName(fullName);
        user.setPhone(phone);
        user.setEmail(normalizedNewEmail);
        user.setBirthday(birthday);
        user.setGender(gender);
        userDao.update(user);
        return userDao.findUserById(userId);
    }

    public boolean verifyOtp(String email, String otp) {
        return userDao.verifyOtp(email, otp);
    }

    public boolean lastCheckOtp(String email, String otp) {
        return userDao.lastCheckOtp(email, otp);
    }

    public boolean verifyOtpForReset(String email, String otp) {
        return userDao.verifyOtpForReset(email, otp);
    }

    public void resetPass(String email, String otp, String newPassword) {

        String error = checkPasswordStrength(newPassword);
        if (error != null) {
            throw new RuntimeException(error);
        }

        boolean Done = userDao.verifyOtpForReset(email, otp);
        if (!Done) {
            throw new RuntimeException("OTP sai hoặc đã hết hạn");
        }
        String hashed = PassUtil.hash(newPassword);
        userDao.updatePassword(email, hashed);
    }

    public List<User> getAllUser() {
        return userDaoAdmin.getListUser();
    }

    public int getCountActive() {
        return userDaoAdmin.getCountActive();
    }

    public int getCountBlock() {
        return userDaoAdmin.getCountBlock();
    }

    public List<User> searchByUsernameOrEmail(String keyword) {
        return userDaoAdmin.searchByUsernameOrEmail(keyword);
    }

    public void createUser(User user) {
        if (userDao.existsByUsername(user.getUsername())) {
            throw new RuntimeException("Tên đăng nhập đã tồn tại trên hệ thống!");
        }
        if (userDao.findByEmail(user.getEmail()) != null) {
            throw new RuntimeException("Email đã được sử dụng bởi một tài khoản khác!");
        }
        String pass = "Newpass123*";
        String hashed = PassUtil.hash(pass);
        user.setPassword(hashed);

        userDaoAdmin.createUser(user);
    }

    public void updateUser(User user) {
        User existingEmail = userDao.findByEmail(user.getEmail());
        if (existingEmail != null && existingEmail.getId() != user.getId()) {
            throw new RuntimeException("Email đã được sử dụng bởi một tài khoản khác!");
        }
        userDaoAdmin.updateUser(user);
    }

    public void blockUser(int id) {
        userDaoAdmin.blockUser(id , "BLOCKED");
    }

    public void unblockUser(int id) {
        userDaoAdmin.blockUser(id, "ACTIVE");
    }

    public record EmailChangeOldEmailVerification(
            String newEmail,
            String oldEmailOtp,
            LocalDateTime oldEmailOtpExpiredAt
    ) {
    }

    public record EmailChangeNewEmailVerification(
            String newEmailOtp,
            LocalDateTime newEmailOtpExpiredAt
    ) {
    }
}
