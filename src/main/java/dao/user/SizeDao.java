package dao.user;

import dao.core.BaseDao;
import model.Size;

import java.util.List;

public class SizeDao extends BaseDao {
    public List<Size> getSizeByProductId(int id) {
        return getJdbi().withHandle(handle -> handle.createQuery("""
                        SELECT DISTINCT s.id, s.code, s.sort_order
                        FROM product_variants p
                        JOIN sizes s ON p.size_id = s.id
                        WHERE p.product_id = :id
                        ORDER BY s.sort_order
                        """)
                .bind("id", id)
                .mapToBean(Size.class)
                .list());
    }
}