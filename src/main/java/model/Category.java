package model;

import java.io.Serializable;

public class Category implements Serializable {
    private int id;
    private String name;
    private int status;
    private int parentId; // ID danh mục cha
    private java.util.List<Category> subCategories = new java.util.ArrayList<>(); // Danh sách danh mục con
    private java.util.List<Product> products = new java.util.ArrayList<>(); // Các sản phẩm thuộc danh mục này

    public Category() {
    }

    public Category(int id, String name, int status) {
        this.id = id;
        this.name = name;
        this.status = status;
    }

    public Category(int id, String name, int status, int parentId) {
        this.id = id;
        this.name = name;
        this.status = status;
        this.parentId = parentId;
    }

    public int getParentId() {
        return parentId;
    }

    public void setParentId(int parentId) {
        this.parentId = parentId;
    }

    public java.util.List<Category> getSubCategories() {
        return subCategories;
    }

    public void setSubCategories(java.util.List<Category> subCategories) {
        this.subCategories = subCategories;
    }

    public java.util.List<Product> getProducts() {
        return products;
    }

    public void setProducts(java.util.List<Product> products) {
        this.products = products;
    }

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

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public void setStatus(String status) {
        this.status = "Đang bán".equals(status) ? 1 : 0;
    }

    @Override
    public String toString() {
        return "Category{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", status=" + status +
                '}';
    }
}
