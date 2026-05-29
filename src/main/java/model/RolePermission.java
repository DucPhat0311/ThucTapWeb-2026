package model;

public class RolePermission {
    private int id;
    private int roleId;
    private String module;
    private String action;
    private int allowed;

    public RolePermission() {}

    public RolePermission(int id, int roleId, String module, String action, int allowed) {
        this.id = id;
        this.roleId = roleId;
        this.module = module;
        this.action = action;
        this.allowed = allowed;
    }

    // ===== getter / setter =====
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public String getModule() {
        return module;
    }

    public void setModule(String module) {
        this.module = module;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public int getAllowed() {
        return allowed;
    }

    public void setAllowed(int allowed) {
        this.allowed = allowed;
    }

    @Override
    public String toString() {
        return "RolePermission{" +
                "roleId=" + roleId +
                ", module='" + module + '\'' +
                ", action='" + action + '\'' +
                ", allowed=" + allowed +
                '}';
    }
}
