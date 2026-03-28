package service;

import dao.user.ProductVariantDao;
import dao.admin.ProductVariantDaoAdmin;
import model.Color;
import model.ProductVariant;
import model.Size;

import java.util.List;

public class ProductVariantService {
    private final ProductVariantDao productVariantDao = new ProductVariantDao();
    private final ProductVariantDaoAdmin productVariantDaoAdmin = new ProductVariantDaoAdmin();

    public List<ProductVariant> getVariantByProductId(int id) {
        return productVariantDao.getVariantByProduct(id);
    }

        public int countVariant(int productId) {
        return productVariantDaoAdmin.countVariant(productId);
    }

    public int countStock(int productId) {
        return productVariantDaoAdmin.countStock(productId);
    }

    public int countSize(int productId) {
        return productVariantDaoAdmin.countSize(productId);
    }

    public int countColor(int productId) {
        return productVariantDaoAdmin.countColor(productId);
    }

    public List<Size> getAllSizes() {
        return productVariantDaoAdmin.getAllSizes();
    }

    public List<Color> getAllColors() {
        return productVariantDaoAdmin.getAllColors();
    }


    public ProductVariant getVariantById(int id) {
        return productVariantDaoAdmin.getVariantById(id);
    }

    public void createVariant(ProductVariant variant) {
        productVariantDaoAdmin.createVariant(variant);
    }

    public void updateVariant(ProductVariant variant) {
        productVariantDaoAdmin.updateVariant(variant);
    }

    public void deleteVariant(int id) {
        productVariantDaoAdmin.deleteVariant(id);
    }

    public List<ProductVariant> getProductVariantByProductId(int productId) {
        return productVariantDaoAdmin.getProductVariantByProductId(productId);
    }
}
