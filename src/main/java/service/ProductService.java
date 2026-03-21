package service;

import dao.user.ProductDao;
import model.Product;

import java.util.List;

public class ProductService {
    private final ProductDao productDao = new ProductDao();

    public List<Product> getAllProducts() {
        return productDao.findAll();
    }


}
