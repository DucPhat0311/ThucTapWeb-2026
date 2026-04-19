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
    private double price;

    @ColumnName("sale_price")
    private double salePrice;

    private String productName;
    private String sizeName;
    private String colorName;

    public ProductVariant() {}

    public double getPriceAfterSale() {
        return (salePrice > 0) ? salePrice : price;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public double getSalePrice() { return salePrice; }
    public void setSalePrice(double salePrice) { this.salePrice = salePrice; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public String getSizeName() { return sizeName; }
    public void setSizeName(String sizeName) { this.sizeName = sizeName; }

    public String getColorName() { return colorName; }
    public void setColorName(String colorName) { this.colorName = colorName; }

    public int getSizeId() { return sizeId; }
    public void setSizeId(int sizeId) { this.sizeId = sizeId; }

    public int getColorId() { return colorId; }
    public void setColorId(int colorId) { this.colorId = colorId; }
}