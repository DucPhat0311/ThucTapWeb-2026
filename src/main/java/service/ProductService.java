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

}
