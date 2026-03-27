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


    public int getProductIdByVariantId(int variantId) {
        return getJdbi().withHandle(h ->
                h.createQuery("""
            SELECT product_id
            FROM product_variants
            WHERE id = :vid
        """)
                        .bind("vid", variantId)
                        .mapTo(int.class)
                        .one()
        );
    }

    public double getPriceByVariantId(int variantId) {
        return getJdbi().withHandle(h ->
                h.createQuery("""
            SELECT COALESCE(sale_price, price)
            FROM product_variants
            WHERE id = :vid
        """)
                        .bind("vid", variantId)
                        .mapTo(double.class)
                        .one()
        );
    }


    public int getStockByVariantId(int variantId) {
        String sql = "SELECT stock FROM product_variants WHERE id = ?";
        return getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, variantId)
                        .mapTo(int.class)
                        .one()
        );
    }
    public void decreaseStock(int variantId, int qty) {
        getJdbi().useHandle(h ->
                h.createUpdate("""
            UPDATE product_variants
            SET stock = stock - :q
            WHERE id = :vid
        """)
                        .bind("q", qty)
                        .bind("vid", variantId)
                        .execute()
        );
    }
    public ProductVariant getFirstVariantByProductId(int productId) {
        return getJdbi().withHandle(h ->
                h.createQuery("""
            SELECT *
            FROM product_variants
            WHERE product_id = :pid
            ORDER BY id ASC
            LIMIT 1
        """)
                        .bind("pid", productId)
                        .mapToBean(ProductVariant.class)
                        .findOne()
                        .orElse(null)
        );
    }

}
