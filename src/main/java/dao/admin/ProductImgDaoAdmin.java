package dao.admin;

import dao.core.BaseDao;

import model.ProductImage;

public class ProductImgDaoAdmin extends BaseDao {

      public ProductImage getImageById(int id) {
        return getJdbi().withHandle(handle -> handle.createQuery("""
                SELECT id, product_id, image_url, is_main AS main
                FROM product_images
                WHERE id = :id
                """)
                .bind("id", id)
                .mapToBean(ProductImage.class)
                .findOne()
                .orElse(null));
    }

    public void insert(ProductImage image) {
        getJdbi().useHandle(handle -> handle.createUpdate("""
                INSERT INTO product_images (product_id, image_url, is_main)
                VALUES (:productId, :imageUrl, :main)
                """)
                .bind("productId", image.getProductId())
                .bind("imageUrl", image.getImageUrl())
                .bind("main", image.getMain())
                .execute());
    }

    public void update(ProductImage image) {
        getJdbi().useHandle(handle -> handle.createUpdate("""
                UPDATE product_images
                SET image_url = :imageUrl, is_main = :main
                WHERE id = :id
                """)
                .bind("id", image.getId())
                .bind("imageUrl", image.getImageUrl())
                .bind("main", image.getMain())
                .execute());
    }

    public void delete(int id) {
        getJdbi().useHandle(handle -> handle.createUpdate("""
                DELETE FROM product_images WHERE id = :id
                """)
                .bind("id", id)
                .execute());
    }
}
