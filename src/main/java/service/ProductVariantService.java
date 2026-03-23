package service;

import dao.user.ProductVariantDao;
import model.ProductVariant;

import java.util.List;

public class ProductVariantService {
    private final ProductVariantDao productVariantDao = new ProductVariantDao();

    public List<ProductVariant> getVariantByProductId(int id) {
        return productVariantDao.getVariantByProduct(id);
    }
}
