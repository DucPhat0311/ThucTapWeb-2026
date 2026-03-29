package model;

import org.jdbi.v3.core.mapper.reflect.ColumnName;

public class ProductVariant {
    private int id;

    @ColumnName("product_id")
    private int productId;

    @ColumnName("size_id")
    private int sizeId;

    @ColumnName("color_id")
    private int colorId;
    private int stock;

    private String sizeName;
    private String colorName;

    public String getSizeName() {
        return sizeName;
    }

    public void setSizeName(String sizeName) {
        this.sizeName = sizeName;
    }

    public String getColorName() {
        return colorName;
    }

    public void setColorName(String colorName) {
        this.colorName = colorName;
    }

    public ProductVariant(int id, int productId, int sizeId, int colorId, int stock) {
        this.id = id;
        this.productId = productId;
        this.sizeId = sizeId;
        this.colorId = colorId;
        this.stock = stock;
    }

    public ProductVariant() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getSizeId() {
        return sizeId;
    }

    public void setSizeId(int sizeId) {
        this.sizeId = sizeId;
    }

    public int getColorId() {
        return colorId;
    }

    public void setColorId(int colorId) {
        this.colorId = colorId;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

}
