package service.admin;

import dao.admin.ProfileDaoAdmin;
import model.User;
import util.PassUtil;

public class ProfileAdminService {
    private final ProfileDaoAdmin profileAdminDAO;
    private static ProfileAdminService instance;

    private ProfileAdminService() {
        this.profileAdminDAO = new ProfileDaoAdmin();
    }

    public static ProfileAdminService getInstance() {
        if (instance == null) {
            instance = new ProfileAdminService();
        }
        return instance;
    }

    public User getAdminById(int id) {
        return profileAdminDAO.getAdminById(id);
    }

    public void updateAdmin(User admin) {
        profileAdminDAO.updateAdmin(admin);
    }

    public void updateAvatarOnly(int adminId, String avatarUrl) {
        profileAdminDAO.updateAvatarOnly(adminId, avatarUrl);
    }

    public boolean changePassword(int adminId, String currentPassword, String newPassword, String confirmPassword) {
        User admin = profileAdminDAO.getAdminById(adminId);
        if (admin == null) {
            throw new IllegalArgumentException("Tài khoản không tồn tại!");
        }
        if (newPassword == null || newPassword.trim().isEmpty()) {
            throw new IllegalArgumentException("Mật khẩu mới không được để trống!");
        }
        if (!PassUtil.checkOldPass(currentPassword, admin.getPassword())) {
            throw new IllegalArgumentException("Mật khẩu hiện tại không chính xác!");
        }
        if (PassUtil.checkOldPass(newPassword, admin.getPassword())) {
            throw new IllegalArgumentException("Mật khẩu mới không được trùng với mật khẩu hiện tại!");
        }
        if (!newPassword.equals(confirmPassword)) {
            throw new IllegalArgumentException("Mật khẩu xác nhận không khớp!");
        }

        String hashedPassword = PassUtil.hash(newPassword);
        profileAdminDAO.changePassword(adminId, hashedPassword);
        return true;
    }
}
