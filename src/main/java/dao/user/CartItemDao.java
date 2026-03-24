package dao.user;

import dao.core.BaseDao;
import model.CartItem;
import model.Product;

import java.util.List;

public class CartItemDao extends BaseDao {

    public int countTotalQuantity(int cartId) {
        return getJdbi().withHandle(h ->
                h.createQuery("SELECT COALESCE(SUM(quantity),0) FROM cart_items WHERE cart_id = :cid")
                        .bind("cid", cartId)
                        .mapTo(int.class)
                        .one()
        );
    }

    public List<CartItem> getItemsByCartId(int cartId) {
        String sql = """
        SELECT
            ci.variant_id,
            ci.quantity,
            ci.price,
            p.id   AS pid,
            p.name,
            p.thumbnail,
            s.code AS size,
            c.name AS color
        FROM cart_items ci
        JOIN product_variants v ON ci.variant_id = v.id
        JOIN products p ON v.product_id = p.id
        JOIN sizes s ON v.size_id = s.id
        JOIN colors c ON v.color_id = c.id
        WHERE ci.cart_id = :cid
    """;

        return getJdbi().withHandle(h ->
                h.createQuery(sql)
                        .bind("cid", cartId)
                        .map((rs, ctx) -> {
                            CartItem item = new CartItem();
                            item.setVariantId(rs.getInt("variant_id"));
                            item.setQuantity(rs.getInt("quantity"));
                            item.setPrice(rs.getDouble("price"));
                            item.setSize(rs.getString("size"));
                            item.setColor(rs.getString("color"));

                            Product p = new Product();
                            p.setId(rs.getInt("pid"));
                            p.setName(rs.getString("name"));
                            p.setThumbnail(rs.getString("thumbnail"));

                            item.setProduct(p);
                            return item;
                        })
                        .list()
        );
    }
    public void clearCart(int cartId) {
        getJdbi().useHandle(h ->
                h.createUpdate("DELETE FROM cart_items WHERE cart_id = :cid")
                        .bind("cid", cartId)
                        .execute()
        );
    }
    
}
