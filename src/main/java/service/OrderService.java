package service;

import dao.admin.OrderDaoAdmin;
import dao.user.ProductVariantDao;
import dao.user.OrderTrackingLogDao;
import model.*;
import model.constant.OrderStatus;

import java.util.List;

public class OrderService {
    
    private OrderDaoAdmin dao = new OrderDaoAdmin();
    private OrderTrackingLogDao trackingLogDao = new OrderTrackingLogDao();
    private GhnOrderCreationService ghnOrderCreationService = new GhnOrderCreationService();
    private GhnOrderTrackingService ghnOrderTrackingService = new GhnOrderTrackingService();
    private AddressService addressService = new AddressService();
    private OrderCancellationService orderCancellationService = new OrderCancellationService();
    private GhnOrderCancellationService ghnOrderCancellationService = new GhnOrderCancellationService();
    private ProductVariantDao productVariantDao = new ProductVariantDao();

    public List<Order> getAllOrders() {
        return dao.getAll();
}

    public Order findById(int id) {
        return dao.findById(id);
    }

    public List<OrderItem> getOrderItems(int orderId) {
        return dao.getItems(orderId);
    }

    public void updateStatus(int id, String status) {
        dao.updateStatus(id, status);
    }

    public OrderCancellationService.CancellationCheck checkUserCancellation(Order order, int userId) {
        return orderCancellationService.checkUserCancellation(order, userId);
    }

    public OrderCancellationService.CancellationCheck checkAdminCancellation(Order order) {
        return orderCancellationService.checkAdminCancellation(order);
    }

    public OrderCancellationService.CancellationCheck cancelUserOrder(int orderId, int userId) {
        Order order = dao.findById(orderId);
        var cancellationCheck = orderCancellationService.checkUserCancellation(order, userId);
        if (!cancellationCheck.cancellable()) {
            return cancellationCheck;
        }

        try {
            syncGhnCancellation(order);
        } catch (RuntimeException e) {
            return OrderCancellationService.CancellationCheck.rejected(e.getMessage());
        }

        restoreStockIfNeeded(order);
        updateCancelledOrder(order);
        return OrderCancellationService.CancellationCheck.accepted();
    }

    public OrderCancellationService.CancellationCheck cancelAdminOrder(int orderId) {
        Order order = dao.findById(orderId);
        var cancellationCheck = orderCancellationService.checkAdminCancellation(order);
        if (!cancellationCheck.cancellable()) {
            return cancellationCheck;
        }

        try {
            syncGhnCancellation(order);
        } catch (RuntimeException e) {
            return OrderCancellationService.CancellationCheck.rejected(e.getMessage());
        }

        restoreStockIfNeeded(order);
        updateCancelledOrder(order);
        return OrderCancellationService.CancellationCheck.accepted();
    }

    public GhnOrderCreationService.CreateOrderResult createGhnShippingOrder(int orderId) {
        Order order = dao.findById(orderId);
        List<OrderItem> items = dao.getItems(orderId);
        Address address = order == null ? null : addressService.getPrimaryByUser(order.getUserId());
        var result = ghnOrderCreationService.createOrder(order, items, address);
        String statusCode = "ready_to_pick";
        String statusName = ghnOrderTrackingService.resolveStatusName(statusCode);

        dao.updateGhnOrderCreated(
                orderId,
                result.orderCode(),
                statusCode,
                statusName,
                result.expectedDeliveryTime()
        );
        trackingLogDao.insertIfStatusChanged(
                orderId,
                "GHN",
                result.orderCode(),
                statusCode,
                statusName,
                "Tạo vận đơn GHN thành công.",
                java.time.LocalDateTime.now()
        );
        return result;
    }

    public boolean canCreateGhnShippingOrder(Order order) {
        if (order == null) {
            return false;
        }
        if (OrderStatus.COMPLETED.equals(order.getOrderStatus()) || OrderStatus.CANCELLED.equals(order.getOrderStatus())) {
            return false;
        }
        return order.getGhnOrderCode() == null || order.getGhnOrderCode().isBlank();
    }

    public String getUserEmailByOrderId(int orderId) {
        return dao.getUserEmailByOrderId(orderId);
    }

    private void syncGhnCancellation(Order order) {
        if (order == null || order.getGhnOrderCode() == null || order.getGhnOrderCode().isBlank()) {
            return;
        }
        ghnOrderCancellationService.cancelOrder(order.getGhnOrderCode());
    }

    private void restoreStockIfNeeded(Order order) {
        if (!OrderStatus.PENDING_PAYMENT.equals(order.getOrderStatus())
                && !OrderStatus.PENDING.equals(order.getOrderStatus())
                && !OrderStatus.SHIPPING.equals(order.getOrderStatus())) {
            return;
        }
        for (OrderItem item : dao.getItems(order.getId())) {
            productVariantDao.increaseStock(item.getVariantId(), item.getQuantity());
        }
    }

    private void updateCancelledOrder(Order order) {
        String statusName = ghnOrderTrackingService.resolveStatusName("cancel");
        if (order.getGhnOrderCode() != null && !order.getGhnOrderCode().isBlank()) {
            dao.updateGhnOrderCancelled(order.getId(), order.getGhnOrderCode(), "cancel", statusName, order.getGhnExpectedDeliveryTime());
            trackingLogDao.insertIfStatusChanged(
                    order.getId(),
                    "GHN",
                    order.getGhnOrderCode(),
                    "cancel",
                    statusName,
                    "Hủy vận đơn GHN thành công.",
                    java.time.LocalDateTime.now()
            );
            return;
        }
        dao.updateStatus(order.getId(), OrderStatus.CANCELLED);
    }

}
