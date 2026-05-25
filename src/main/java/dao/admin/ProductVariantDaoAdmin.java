package dao.admin;

import java.util.List;

import model.Color;
import model.ProductVariant;
import model.Size;
import dao.core.BaseDao;

public class ProductVariantDaoAdmin extends BaseDao {

        public int countVariant(int productId) {
        return getJdbi().withHandle(handle -> handle.createQuery("""
            SELECT COUNT(*) 
            FROM product_variants
            WHERE product_id = :productId
                """)
                .bind("productId", productId)
                .mapTo(int.class)
                .one()
        );
    }

    public int countStock(int productId) {
        return getJdbi().withHandle(handle -> handle.createQuery("""
                SELECT COALESCE(SUM(stock), 0)
                FROM product_variants
                WHERE product_id = :productId""")
                .bind("productId", productId)
                .mapTo(int.class)
                .one());
    }

    public int countSize(int productId) {
        return getJdbi().withHandle(handle -> handle.createQuery("""
                SELECT COUNT(DISTINCT size_id)
                FROM product_variants
                WHERE product_id = :productId""")
                .bind("productId", productId)
                .mapTo(int.class)
                .one());
    }

    public int countColor(int productId) {
        return getJdbi().withHandle(handle -> handle.createQuery("""
                SELECT COUNT(DISTINCT color_id)
                FROM product_variants
                WHERE product_id = :productId""")
                .bind("productId", productId)
                .mapTo(int.class)
                .one());
    }

    public List<Size> getAllSizes() {
        return getJdbi().withHandle(handle -> handle.createQuery("""
                SELECT id, code
                FROM sizes
                ORDER BY sort_order""")
                .mapToBean(Size.class)
                .list());
    }

    public List<Color> getAllColors() {
        return getJdbi().withHandle(handle -> handle.createQuery("""
                SELECT id, name
                FROM colors
                ORDER BY name""")
                .mapToBean(Color.class)
                .list());
    }

    public ProductVariant getVariantById(int id) {
        return getJdbi().withHandle(handle -> handle.createQuery("""
            SELECT pv.id, pv.product_id, pv.size_id, pv.color_id, pv.stock,
                   s.code AS sizeName, c.name AS colorName
            FROM product_variants pv
            LEFT JOIN sizes s ON pv.size_id = s.id
            LEFT JOIN colors c ON pv.color_id = c.id
            WHERE pv.id = :id""")
            .bind("id", id)
            .mapToBean(ProductVariant.class)
            .one());
    }

    public void createVariant(ProductVariant variant) {
        getJdbi().useHandle(handle -> handle.createUpdate("""
            INSERT INTO product_variants(product_id, size_id, color_id, stock)
            VALUES (:productId, :sizeId, :colorId, :stock)""")
            .bindBean(variant)
            .execute());
    }

    public void updateVariant(ProductVariant variant) {
        getJdbi().useHandle(handle -> handle.createUpdate("""
                UPDATE product_variants
                SET size_id = :sizeId, color_id = :colorId, stock = :stock
                WHERE id = :id""")
            .bindBean(variant)
            .execute());
    }

    public void deleteVariant(int id) {
        getJdbi().useHandle(handle -> handle.createUpdate("""
                DELETE FROM product_variants
                WHERE id = :id""")
                .bind("id", id)
                .execute());
    }

    public List<ProductVariant> getProductVariantByProductId(int productId) {
        return getJdbi().withHandle(handle -> handle.createQuery("""
            SELECT pv.id, pv.product_id, pv.size_id, pv.color_id, pv.stock, s.code AS sizeName, c.name AS colorName
            FROM product_variants pv
            JOIN sizes s ON pv.size_id = s.id
            JOIN colors c ON pv.color_id = c.id
            WHERE pv.product_id = :productId
            """)
            .bind("productId", productId)
            .mapToBean(ProductVariant.class)
            .list());
    }

    public List<ProductVariant> getAllVariantsWithDetails() {
        return getJdbi().withHandle(handle -> handle.createQuery("""
            SELECT pv.id, pv.product_id, pv.size_id, pv.color_id, pv.stock,
                   p.name AS productName, s.code AS sizeName, c.name AS colorName
            FROM product_variants pv
            JOIN products p ON pv.product_id = p.id
            LEFT JOIN sizes s ON pv.size_id = s.id
            LEFT JOIN colors c ON pv.color_id = c.id
            ORDER BY p.name, c.name, s.sort_order
            """)
            .mapToBean(ProductVariant.class)
            .list());
    }

    public Integer findVariantId(int productId, int colorId, int sizeId) {
        return getJdbi().withHandle(handle -> handle.createQuery("""
            SELECT id FROM product_variants
            WHERE product_id = :productId AND color_id = :colorId AND size_id = :sizeId
            """)
            .bind("productId", productId)
            .bind("colorId", colorId)
            .bind("sizeId", sizeId)
            .mapTo(Integer.class)
            .findOne()
            .orElse(null));
    }

    public int createAndReturnId(ProductVariant variant) {
        return getJdbi().withHandle(handle -> handle.createUpdate("""
            INSERT INTO product_variants(product_id, size_id, color_id, stock)
            VALUES (:productId, :sizeId, :colorId, 0)
            """)
            .bindBean(variant)
            .executeAndReturnGeneratedKeys("id")
            .mapTo(int.class)
            .one());
    }
}
