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

    public boolean changePassword(int adminId, String currentPassword, String newPassword, String confirmPassword) {
        User admin = profileAdminDAO.getAdminById(adminId);
        if (admin != null && PassUtil.checkOldPass(currentPassword, admin.getPassword()) && newPassword.equals(confirmPassword)) {
            String hashedPassword = PassUtil.hash(newPassword);
            profileAdminDAO.changePassword(adminId, hashedPassword);
            return true;
        }
        return false;
    }
}
