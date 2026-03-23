package dao.user;

import dao.core.BaseDao;

public class CartItemDao extends BaseDao {

    public int countTotalQuantity(int cartId) {
        return getJdbi().withHandle(h ->
                h.createQuery("SELECT COALESCE(SUM(quantity),0) FROM cart_items WHERE cart_id = :cid")
                        .bind("cid", cartId)
                        .mapTo(int.class)
                        .one()
        );
    }
    
}
