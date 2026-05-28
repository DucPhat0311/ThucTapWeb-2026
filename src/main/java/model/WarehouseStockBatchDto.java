package model;

import org.jdbi.v3.core.mapper.reflect.ColumnName;
import java.io.Serializable;

public class WarehouseStockBatchDto implements Serializable {
    private int id;
    
    @ColumnName("createdAtFormatted")
    private String createdAtFormatted;
    
    private int quantity;
    private double price;
    
    @ColumnName("remainingQuantity")
    private int remainingQuantity;

    public WarehouseStockBatchDto() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCreatedAtFormatted() {
        return createdAtFormatted;
    }

    public void setCreatedAtFormatted(String createdAtFormatted) {
        this.createdAtFormatted = createdAtFormatted;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getRemainingQuantity() {
        return remainingQuantity;
    }

    public void setRemainingQuantity(int remainingQuantity) {
        this.remainingQuantity = remainingQuantity;
    }
}
