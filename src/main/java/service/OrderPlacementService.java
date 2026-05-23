package service;

import dao.admin.InventoryReceiptDaoAdmin;
import dao.core.BaseDao;
import dao.user.ProductVariantDao;
import model.OrderItem;
import org.jdbi.v3.core.Handle;
import java.util.ArrayList;
import java.util.List;

public class OrderPlacementService extends BaseDao {

    private final InventoryReceiptDaoAdmin inventoryReceiptDao = new InventoryReceiptDaoAdmin();

    public int placeOrder(int userId,
                          int cartId,
                          CheckoutService.PreparedCheckout preparedCheckout,
                          CheckoutService.OrderPlacement orderPlacement,
                          String note,
                          double shippingFee,
                          double finalAmount) {
        return getJdbi().inTransaction(handle -> {
            int orderId = createOrder(
                    handle,
                    userId,
                    preparedCheckout.recipientName(),
                    preparedCheckout.recipientPhone(),
                    preparedCheckout.shippingAddress(),
                    note,
                    orderPlacement.paymentMethod(),
                    orderPlacement.paymentStatus(),
                    orderPlacement.orderStatus(),
                    preparedCheckout.totalPrice(),
                    shippingFee,
                    finalAmount
            );

            for (CheckoutService.PreparedOrderItem item : preparedCheckout.items()) {
                var variantDetail = item.variantDetail();

                insertOrderItem(
                        handle,
                        orderId,
                        variantDetail.getProductId(),
                        item.variantId(),
                        variantDetail.getSizeName(),
                        variantDetail.getColorName(),
                        item.quantity(),
                        item.unitPrice(),
                        item.lineTotal()
                );
            }

            for (CheckoutService.PreparedOrderItem item : preparedCheckout.items()) {
                decreaseStock(handle, item.variantId(), item.quantity());
                deleteCartItem(handle, cartId, item.variantId());
            }

            // Tạo phiếu xuất kho tự động trong cùng transaction
            List<OrderItem> exportItems = new ArrayList<>();
            for (CheckoutService.PreparedOrderItem item : preparedCheckout.items()) {
                OrderItem oi = new OrderItem();
                oi.setVariantId(item.variantId());
                oi.setQuantity(item.quantity());
                oi.setPrice(item.unitPrice());
                exportItems.add(oi);
            }
            inventoryReceiptDao.createExportReceiptInHandle(handle, orderId, exportItems, userId);

            return orderId;
        });
    }

    private int createOrder(Handle handle,
                            int userId,
                            String name,
                            String phone,
                            String address,
                            String note,
                            String paymentMethod,
                            String paymentStatus,
                            String orderStatus,
                            double totalPrice,
                            double shippingFee,
                            double finalAmount) {
        return handle.createUpdate("""
            INSERT INTO orders(
                user_id, name, phone, shipping_address, note,
                total_price, discount, shipping_fee, final_amount,
                payment_methods, payment_statuses, order_status, created_at
            )
            VALUES(
                :uid, :name, :phone, :address, :note,
                :total, 0, :ship, :final,
                :payment, :paymentStatus, :orderStatus, NOW()
            )
        """)
                .bind("uid", userId)
                .bind("name", name)
                .bind("phone", phone)
                .bind("address", address)
                .bind("note", note)
                .bind("total", totalPrice)
                .bind("ship", shippingFee)
                .bind("final", finalAmount)
                .bind("payment", paymentMethod)
                .bind("paymentStatus", paymentStatus)
                .bind("orderStatus", orderStatus)
                .executeAndReturnGeneratedKeys("id")
                .mapTo(int.class)
                .one();
    }

    private void insertOrderItem(Handle handle,
                                 int orderId,
                                 int productId,
                                 int variantId,
                                 String size,
                                 String color,
                                 int quantity,
                                 double price,
                                 double total) {
        handle.createUpdate("""
            INSERT INTO order_items
            (order_id, product_id, variant_id, size, color, quantity, price, total)
            VALUES (:oid, :pid, :vid, :size, :color, :qty, :price, :total)
        """)
                .bind("oid", orderId)
                .bind("pid", productId)
                .bind("vid", variantId)
                .bind("size", size)
                .bind("color", color)
                .bind("qty", quantity)
                .bind("price", price)
                .bind("total", total)
                .execute();
    }

    private void decreaseStock(Handle handle, int variantId, int quantity) {
        int affectedRows = handle.createUpdate("""
            UPDATE product_variants
            SET stock = stock - :quantity
            WHERE id = :variantId AND stock >= :quantity
        """)
                .bind("quantity", quantity)
                .bind("variantId", variantId)
                .execute();

        if (affectedRows == 0) {
            throw new ProductVariantDao.InsufficientStockException(variantId, quantity);
        }
    }

    private void deleteCartItem(Handle handle, int cartId, int variantId) {
        handle.createUpdate("""
            DELETE FROM cart_items
            WHERE cart_id = :cartId AND variant_id = :variantId
        """)
                .bind("cartId", cartId)
                .bind("variantId", variantId)
                .execute();
    }
}
