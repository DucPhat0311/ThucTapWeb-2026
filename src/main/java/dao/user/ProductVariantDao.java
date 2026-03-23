package dao.user;

import dao.core.BaseDao;
import model.ProductVariant;

import java.util.List;

public class ProductVariantDao extends BaseDao {

    public List<ProductVariant> getVariantByProduct(int id) {
        return getJdbi().withHandle(handle -> handle.createQuery("""
                SELECT *
                FROM product_variants
                WHERE product_id = :id
                """).bind("id", id)
                .mapToBean(ProductVariant.class)
                .list());
    }
}
