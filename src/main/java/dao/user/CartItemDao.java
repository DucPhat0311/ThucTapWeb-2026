package dao.user;

import dao.core.BaseDao;
import model.CartItem;
import model.Product;

import java.util.List;

public class CartItemDao extends BaseDao {

    public int getQuantityByVariant(int cartId, int variantId) {
        return getJdbi().withHandle(h ->
                h.createQuery("""
            SELECT COALESCE(quantity, 0)
            FROM cart_items
            WHERE cart_id = :cid AND variant_id = :vid
        """)
                        .bind("cid", cartId)
                        .bind("vid", variantId)
                        .mapTo(int.class)
                        .findOne()
                        .orElse(0)
        );
    }

    public int countTotalQuantity(int cartId) {
        return getJdbi().withHandle(h ->
                h.createQuery("SELECT COALESCE(SUM(quantity),0) FROM cart_items WHERE cart_id = :cid")
                        .bind("cid", cartId)
                        .mapTo(int.class)
                        .one()
        );
    }

    public int getQuantity(int cartId, int variantId) {
        return getJdbi().withHandle(h ->
                h.createQuery("""
            SELECT COALESCE(quantity, 0)
            FROM cart_items
            WHERE cart_id = :cid AND variant_id = :vid
        """)
                        .bind("cid", cartId)
                        .bind("vid", variantId)
                        .mapTo(int.class)
                        .findOne()
                        .orElse(0)
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

    public void addOrUpdate(int cartId, int variantId, int productId, int quantity, double price) {
        getJdbi().useHandle(h -> {
            Integer exists = h.createQuery("""
            SELECT id FROM cart_items
            WHERE cart_id = :cid AND variant_id = :vid
        """)
                    .bind("cid", cartId)
                    .bind("vid", variantId)
                    .mapTo(Integer.class)
                    .findOne()
                    .orElse(null);

            if (exists != null) {
                h.createUpdate("""
                UPDATE cart_items
                SET quantity = quantity + :q
                WHERE id = :id
            """)
                        .bind("q", quantity)
                        .bind("id", exists)
                        .execute();
            } else {
                h.createUpdate("""
                INSERT INTO cart_items(cart_id, variant_id, quantity, price)
                VALUES (:cid, :vid, :q, :price)
            """)
                        .bind("cid", cartId)
                        .bind("vid", variantId)
                        .bind("q", quantity)
                        .bind("price", price)
                        .execute();
            }
        });
    }


    public void delete(int cartId, int variantId) {
        getJdbi().useHandle(h ->
                h.createUpdate("""
            DELETE FROM cart_items
            WHERE cart_id = :cid AND variant_id = :vid
        """)
                        .bind("cid", cartId)
                        .bind("vid", variantId)
                        .execute()
        );
    }

    public void updateQuantity(int cartId, int variantId, int quantity) {
        getJdbi().useHandle(h ->
                h.createUpdate("""
            UPDATE cart_items
            SET quantity = :q
            WHERE cart_id = :cid AND variant_id = :vid
        """)
                        .bind("q", quantity)
                        .bind("cid", cartId)
                        .bind("vid", variantId)
                        .execute()
        );
    }

    // lấy id card dựa vào id user
    public Integer getCartIdByUserId(int userId) {
        return getJdbi().withHandle(h ->
                h.createQuery("SELECT id FROM carts WHERE user_id = :userId")
                        .bind("userId", userId)
                        .mapTo(Integer.class)
                        .findFirst()
                        .orElse(null)
        );
    }

    // tạo giỏ hàng mới
    public int createCart(int userId) {
        return getJdbi().withHandle(h ->
                h.createUpdate("INSERT INTO carts (user_id, created_at) VALUES (:userId, NOW())")
                        .bind("userId", userId)
                        .executeAndReturnGeneratedKeys("id")
                        .mapTo(int.class)
                        .one()
        );
    }


}
