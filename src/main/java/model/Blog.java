package model;

import java.sql.Timestamp;

public class Blog {
    private int id, author_id, status;
    private String title, img, description, content;
    private Timestamp created_at, updated_at;

    // No-args constructor for JDBI
    public Blog() {
    }

    public Blog(int id, int author_id, int status, String title, String img, String description, String content, Timestamp created_at, Timestamp updated_at) {
        this.id = id;
        this.author_id = author_id;
        this.status = status;
        this.title = title;
        this.img = img;
        this.description = description;
        this.content = content;
        this.created_at = created_at;
        this.updated_at = updated_at;
    }
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }
    public void setTitle(String title) {
        this.title = title;
    }
public String getImg() {
        return img;
    }
    public void setImg(String img) {
        this.img = img;
    }

    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }

    public String getContent() {
        return content;
    }
    public void setContent(String content) {
        this.content = content;
    }

    public int getAuthorId() {
        return author_id;
    }
    public void setAuthorId(int authorId) {
        this.author_id = authorId;
    }

    public int getStatus() {
        return status;
    }
    public void setStatus(int status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return created_at;
    }
    public void setCreatedAt(Timestamp createdAt) {
        this.created_at = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updated_at;
    }
    public void setUpdatedAt(Timestamp updatedAt) {
        this.updated_at = updatedAt;
    }
}