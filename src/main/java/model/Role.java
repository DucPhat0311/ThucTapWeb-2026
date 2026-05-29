package model;

import java.time.LocalDateTime;

public class Role {
    private int id;
    private String name;
    private String description;
    private int isSystem;
    private LocalDateTime createdAt;

    public Role() {}

    public Role(int id, String name, String description, int isSystem, LocalDateTime createdAt) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.isSystem = isSystem;
        this.createdAt = createdAt;
    }

    // ===== getter / setter =====
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getIsSystem() {
        return isSystem;
    }

    public void setIsSystem(int isSystem) {
        this.isSystem = isSystem;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Role{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", isSystem=" + isSystem +
                '}';
    }
}
