package dao.user;

import dao.core.BaseDao;
import model.ProductImage;

import java.util.List;

public class ProductImageDao extends BaseDao {
    public List<ProductImage> getImageByProduct(int id) {
        return getJdbi().withHandle(handle -> handle.createQuery("""
                SELECT id, product_id, image_url, is_main AS main
                FROM product_images
                WHERE product_id = :id
                ORDER BY is_main DESC, id DESC
                """)
                .bind("id", id)
                .mapToBean(ProductImage.class)
                .list());
    }
}
