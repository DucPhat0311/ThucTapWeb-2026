package service;

import dao.user.ProductImageDao;
import dao.admin.ProductImgDaoAdmin;
import model.ProductImage;

import java.util.List;

public class ProductImageService {
    private ProductImageDao productImageDao = new ProductImageDao();
    private ProductImgDaoAdmin productImgDaoAdmin = new ProductImgDaoAdmin();

    public List<ProductImage> getImageByProduct(int id) {
        return productImageDao.getImageByProduct(id);
    }

        public ProductImage getImageById(int id) {
        return productImgDaoAdmin.getImageById(id);
    }

    public void createImage(ProductImage image) {
        productImgDaoAdmin.insert(image);
    }

    public void updateImage(ProductImage image) {
        productImgDaoAdmin.update(image);
    }

    public void deleteImage(int id) {
        productImgDaoAdmin.delete(id);
    }
    
}
