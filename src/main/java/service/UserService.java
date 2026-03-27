package service;

import dao.user.UserDao;
import model.User;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Random;
import util.PassUtil;

public class UserService {

    private final UserDao userDao = new UserDao();

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

        EmailService.sendEmail(
                email,
                "OTP xác nhận đăng ký ",
                "<h3>Mã OTP của bạn: <b>" + otp + "</b></h3>"
        );
    }

    public User login(String username, String password) {
        User user = userDao.finduser(username);

        if (user == null) return null;

        if (!PassUtil.verify(password, user.getPassword())) return null;

        return user;
    }
    public User findById(int id) {
        return userDao.findUserById(id);
    }

    public void update(User user) {
        userDao.update(user);
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
}
