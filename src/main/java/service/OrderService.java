package service;

import dao.admin.OrderDaoAdmin;
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

}
