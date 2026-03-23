package service;

import dao.user.ProductDao;
import model.Product;

import java.util.List;

public class ProductService {
    private final ProductDao productDao = new ProductDao();

    public List<Product> getAllProducts() {
        return productDao.findAll();
    }

    // lấy các sản phẩm MỚI NHẤT cho trang home
    public List<Product> getLatestProducts(int limit) {
        return productDao.findLatest(limit);
    }

    // lấy sản phẩm liên quan
    public List<Product> ralatedProduct(int currentProductId, int limit) {
        Product currentProduct = productDao.findById(currentProductId);

        int categoryId = currentProduct.getCategory_id();

        return productDao.getRelatedProductByCategory(categoryId, currentProductId, limit);
    }

    // lấy chi tiết sản phẩm theo id
    public Product getProductById(int id) {
        return productDao.findById(id);
    }

}
