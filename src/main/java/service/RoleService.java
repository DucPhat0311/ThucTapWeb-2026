package service;

import dao.admin.RoleDaoAdmin;
import model.Role;
import model.RolePermission;

import java.util.ArrayList;
import java.util.List;

public class RoleService {

    private final RoleDaoAdmin roleDao = new RoleDaoAdmin();

    private static final String[] MODULES = {
            "user", "category", "product", "order",
            "return", "banner", "blog", "contact",
            "warehouse", "role"
    };

    private static final String[] ACTIONS = {
            "view_list", "view_detail", "add", "edit", "delete", "lock"
    };

    public String[] getAllModules() {
        return MODULES;
    }

    public String[] getAllActions() {
        return ACTIONS;
    }

    public List<Role> getAllRoles() {
        return roleDao.getAllRoles();
    }

    public Role getRoleById(int id) {
        return roleDao.getRoleById(id);
    }

    public Role getRoleByName(String name) {
        return roleDao.getRoleByName(name);
    }

    public List<RolePermission> getPermissionsByRoleId(int roleId) {
        return roleDao.getPermissionsByRoleId(roleId);
    }

    public int createRole(Role role) {
        role.setIsSystem(0);
        int roleId = roleDao.createRole(role);

        List<RolePermission> defaultPerms = new ArrayList<>();
        for (String module : MODULES) {
            for (String action : ACTIONS) {
                RolePermission perm = new RolePermission();
                perm.setRoleId(roleId);
                perm.setModule(module);
                perm.setAction(action);
                perm.setAllowed(0);
                defaultPerms.add(perm);
            }
        }
        roleDao.savePermissions(roleId, defaultPerms);
        return roleId;
    }

    public boolean updateRole(Role role) {
        Role existing = roleDao.getRoleById(role.getId());
        if (existing == null || existing.getIsSystem() == 1) {
            return false;
        }
        roleDao.updateRole(role);
        return true;
    }

    public boolean deleteRole(int id) {
        Role existing = roleDao.getRoleById(id);
        if (existing == null || existing.getIsSystem() == 1) {
            return false;
        }
        roleDao.resetUsersRole(id);
        roleDao.deleteRole(id);
        return true;
    }

    public boolean savePermissions(int roleId, List<RolePermission> permissions) {
        Role existing = roleDao.getRoleById(roleId);
        if (existing == null || existing.getIsSystem() == 1) {
            return false;
        }
        roleDao.savePermissions(roleId, permissions);
        return true;
    }

    public boolean hasPermission(int roleId, String module, String action) {
        return roleDao.hasPermission(roleId, module, action);
    }

    public static String getModuleDisplayName(String module) {
        return switch (module) {
            case "user" -> "Người dùng";
            case "category" -> "Danh mục";
            case "product" -> "Sản phẩm";
            case "order" -> "Đơn hàng";
            case "return" -> "Trả hàng";
            case "banner" -> "Banner";
            case "blog" -> "Bài viết";
            case "contact" -> "Liên hệ";
            case "warehouse" -> "Kho";
            case "role" -> "Phân quyền";
            default -> module;
        };
    }

    public static String getActionDisplayName(String action) {
        return switch (action) {
            case "view_list" -> "Xem DS";
            case "view_detail" -> "Chi tiết";
            case "add" -> "Thêm";
            case "edit" -> "Sửa";
            case "delete" -> "Xoá";
            case "lock" -> "Khoá";
            default -> action;
        };
    }
}
