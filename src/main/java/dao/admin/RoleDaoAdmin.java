package dao.admin;

import java.util.List;
import dao.core.BaseDao;
import model.Role;
import model.RolePermission;

public class RoleDaoAdmin extends BaseDao {

    public List<Role> getAllRoles() {
        return getJdbi().withHandle(handle -> handle.createQuery("SELECT * FROM roles ORDER BY is_system DESC, id ASC")
                .mapToBean(Role.class)
                .list());
    }

    public Role getRoleById(int id) {
        return getJdbi().withHandle(handle -> handle.createQuery("SELECT * FROM roles WHERE id = :id")
                .bind("id", id)
                .mapToBean(Role.class)
                .findOne()
                .orElse(null));
    }

    public Role getRoleByName(String name) {
        return getJdbi().withHandle(handle -> handle.createQuery("SELECT * FROM roles WHERE name = :name")
                .bind("name", name)
                .mapToBean(Role.class)
                .findOne()
                .orElse(null));
    }

    public int createRole(Role role) {
        return getJdbi().withHandle(handle -> handle.createUpdate("""
                    INSERT INTO roles (name, description, is_system)
                    VALUES (:name, :description, :isSystem)
                """)
                .bindBean(role)
                .executeAndReturnGeneratedKeys("id")
                .mapTo(int.class)
                .one());
    }

    public void updateRole(Role role) {
        getJdbi().withHandle(handle -> handle.createUpdate("""
                    UPDATE roles
                    SET name = :name, description = :description
                    WHERE id = :id AND is_system = 0
                """)
                .bindBean(role)
                .execute());
    }

    public void deleteRole(int id) {
        getJdbi().withHandle(handle -> handle.createUpdate("DELETE FROM roles WHERE id = :id AND is_system = 0")
                .bind("id", id)
                .execute());
    }

    public List<RolePermission> getPermissionsByRoleId(int roleId) {
        return getJdbi().withHandle(handle -> handle.createQuery("""
                    SELECT * FROM role_permissions
                    WHERE role_id = :roleId
                    ORDER BY module, action
                """)
                .bind("roleId", roleId)
                .mapToBean(RolePermission.class)
                .list());
    }

    public void deletePermissionsByRoleId(int roleId) {
        getJdbi().withHandle(handle -> handle.createUpdate("DELETE FROM role_permissions WHERE role_id = :roleId")
                .bind("roleId", roleId)
                .execute());
    }

    public void insertPermission(RolePermission perm) {
        getJdbi().withHandle(handle -> handle.createUpdate("""
                    INSERT INTO role_permissions (role_id, module, action, allowed)
                    VALUES (:roleId, :module, :action, :allowed)
                """)
                .bindBean(perm)
                .execute());
    }

    public void savePermissions(int roleId, List<RolePermission> permissions) {
        getJdbi().useHandle(handle -> {
            handle.createUpdate("DELETE FROM role_permissions WHERE role_id = :roleId")
                    .bind("roleId", roleId)
                    .execute();

            for (RolePermission perm : permissions) {
                handle.createUpdate("""
                            INSERT INTO role_permissions (role_id, module, action, allowed)
                            VALUES (:roleId, :module, :action, :allowed)
                        """)
                        .bind("roleId", roleId)
                        .bind("module", perm.getModule())
                        .bind("action", perm.getAction())
                        .bind("allowed", perm.getAllowed())
                        .execute();
            }
        });
    }

    public boolean hasPermission(int roleId, String module, String action) {
        return getJdbi().withHandle(handle -> handle.createQuery("""
                    SELECT allowed FROM role_permissions
                    WHERE role_id = :roleId AND module = :module AND action = :action
                """)
                .bind("roleId", roleId)
                .bind("module", module)
                .bind("action", action)
                .mapTo(int.class)
                .findOne()
                .orElse(0) == 1);
    }
}
