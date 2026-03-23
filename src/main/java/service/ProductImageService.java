package service;

import dao.user.ProductImageDao;
import model.ProductImage;

import java.util.List;

public class ProductImageService {
    private ProductImageDao productImageDao = new ProductImageDao();

    public List<ProductImage> getImageByProduct(int id) {
        return productImageDao.getImageByProduct(id);
    }
}
