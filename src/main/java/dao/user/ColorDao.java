package dao.user;

import dao.core.BaseDao;
import model.Color;

import java.util.List;

public class ColorDao extends BaseDao {
    public List<Color> getColorByProductId(int id) {
        return getJdbi().withHandle(handle -> handle.createQuery("""
                SELECT DISTINCT c.id, c.name
                FROM product_variants p
                JOIN colors c ON p.color_id = c.id
                WHERE p.product_id = :id
                """)
                .bind("id",id)
                .mapToBean(Color.class)
                .list());
    }
}
