package model;

import org.jdbi.v3.core.mapper.reflect.ColumnName;
import java.io.Serializable;
import java.time.LocalDateTime;

public class WarehouseStockDto implements Serializable {
    private int id;
    private int stock;
    
    @ColumnName("productName")
    private String productName;
    
    @ColumnName("sizeName")
    private String sizeName;
    
    @ColumnName("colorName")
    private String colorName;
    
    @ColumnName("lastImportPrice")
    private Double lastImportPrice;
    
    @ColumnName("lastImportDate")
    private LocalDateTime lastImportDate;

    public WarehouseStockDto() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

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

    public Double getLastImportPrice() {
        return lastImportPrice;
    }

    public void setLastImportPrice(Double lastImportPrice) {
        this.lastImportPrice = lastImportPrice;
    }

    public LocalDateTime getLastImportDate() {
        return lastImportDate;
    }

    public void setLastImportDate(LocalDateTime lastImportDate) {
        this.lastImportDate = lastImportDate;
    }
}
