package model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class OrderReturnMedia {
    public static final String TYPE_IMAGE = "IMAGE";
    public static final String TYPE_VIDEO = "VIDEO";

    private int id;
    private int orderReturnId;
    private String mediaType;
    private String mediaUrl;
    private String originalName;
    private LocalDateTime createdAt;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getOrderReturnId() {
        return orderReturnId;
    }

    public void setOrderReturnId(int orderReturnId) {
        this.orderReturnId = orderReturnId;
    }

    public String getMediaType() {
        return mediaType;
    }

    public void setMediaType(String mediaType) {
        this.mediaType = mediaType;
    }

    public String getMediaUrl() {
        return mediaUrl;
    }

    public void setMediaUrl(String mediaUrl) {
        this.mediaUrl = mediaUrl;
    }

    public String getOriginalName() {
        return originalName;
    }

    public void setOriginalName(String originalName) {
        this.originalName = originalName;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public boolean isImage() {
        return TYPE_IMAGE.equals(mediaType);
    }

    public boolean isVideo() {
        return TYPE_VIDEO.equals(mediaType);
    }

    public String getCreatedAtFormatted() {
        if (createdAt == null) {
            return "";
        }
        return createdAt.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
    }
}
