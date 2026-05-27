package service;

import dao.admin.OrderDaoAdmin;
import dao.user.OrderDao;
import dao.user.ProductVariantDao;
import dao.user.OrderTrackingLogDao;
import model.*;
import model.constant.OrderStatus;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class OrderService {
    private static final int PENDING_PAYMENT_HOLD_MINUTES = 30;
    private static final String DEMO_TRACKING_PREFIX = "DEMO-ORD-";
    private static final String DEMO_INITIAL_STATUS = "RECEIVED";
    private static final String DEMO_INITIAL_STATUS_NAME = "Đã tiếp nhận đơn hàng";
    private static final DateTimeFormatter DEMO_CODE_TIME_FORMAT = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
    private static final Map<String, String> DEMO_TRACKING_STATUS_LABELS = createDemoTrackingStatusLabels();
    
    private OrderDaoAdmin dao = new OrderDaoAdmin();
    private OrderDao orderDao = new OrderDao();
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

    public List<OrderTrackingLog> getTrackingLogs(int orderId) {
        return trackingLogDao.getByOrderId(orderId);
    }

    public String getLatestDemoTrackingLocation(List<OrderTrackingLog> trackingLogs) {
        for (OrderTrackingLog log : trackingLogs) {
            if (!"DEMO".equals(log.getProvider())) {
                continue;
            }
            String description = trimToEmpty(log.getDescription());
            String prefix = trimToEmpty(log.getStatusName()) + " tại ";
            if (!description.startsWith(prefix)) {
                return "";
            }
            String location = description.substring(prefix.length());
            return location.endsWith(".") ? location.substring(0, location.length() - 1) : location;
        }
        return "";
    }

    public void updateStatus(int id, String status) {
        dao.updateStatus(id, status);
    }

    public int getPendingPaymentHoldMinutes() {
        return PENDING_PAYMENT_HOLD_MINUTES;
    }

    public List<Integer> findExpiredPendingPaymentOrderIds() {
        return orderDao.findExpiredPendingVnPayOrderIds(PENDING_PAYMENT_HOLD_MINUTES);
    }

    public List<Integer> findExpiredPendingPaymentOrderIdsByUserId(int userId) {
        return orderDao.findExpiredPendingVnPayOrderIdsByUserId(userId, PENDING_PAYMENT_HOLD_MINUTES);
    }

    public boolean isPendingPaymentExpired(int orderId) {
        return orderDao.isExpiredPendingVnPayOrder(orderId, PENDING_PAYMENT_HOLD_MINUTES);
    }

    public int expirePendingPaymentOrders() {
        int expiredOrders = 0;
        for (Integer orderId : findExpiredPendingPaymentOrderIds()) {
            if (expirePendingPaymentOrder(orderId)) {
                expiredOrders++;
            }
        }
        return expiredOrders;
    }

    public int expirePendingPaymentOrdersByUserId(int userId) {
        int expiredOrders = 0;
        for (Integer orderId : findExpiredPendingPaymentOrderIdsByUserId(userId)) {
            if (expirePendingPaymentOrder(orderId)) {
                expiredOrders++;
            }
        }
        return expiredOrders;
    }

    public boolean expirePendingPaymentOrder(int orderId) {
        return orderDao.expirePendingVnPayOrderAndRestoreStock(orderId, PENDING_PAYMENT_HOLD_MINUTES);
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

    public String createDemoTracking(int orderId) {
        Order order = dao.findById(orderId);
        if (!canCreateGhnShippingOrder(order)) {
            throw new IllegalStateException("Đơn hàng không thể tạo hành trình mô phỏng hoặc đã có mã theo dõi.");
        }

        LocalDateTime now = LocalDateTime.now();
        String trackingCode = DEMO_TRACKING_PREFIX + orderId + "-" + now.format(DEMO_CODE_TIME_FORMAT);
        dao.updateDemoTrackingCreated(orderId, trackingCode, DEMO_INITIAL_STATUS, DEMO_INITIAL_STATUS_NAME);
        trackingLogDao.insertIfStatusChanged(
                orderId,
                "DEMO",
                trackingCode,
                DEMO_INITIAL_STATUS,
                DEMO_INITIAL_STATUS_NAME,
                "Đơn hàng đã được tiếp nhận tại AURA Studio.",
                now
        );
        return trackingCode;
    }

    public void updateDemoTracking(int orderId, String trackingStatus, String location) {
        Order order = dao.findById(orderId);
        if (order == null || !isDemoTrackingCode(order.getGhnOrderCode())) {
            throw new IllegalStateException("Đơn hàng chưa có hành trình mô phỏng.");
        }
        if (OrderStatus.COMPLETED.equals(order.getOrderStatus()) || OrderStatus.CANCELLED.equals(order.getOrderStatus())) {
            throw new IllegalStateException("Hành trình của đơn hàng đã kết thúc, không thể cập nhật thêm.");
        }

        String normalizedStatus = trimToEmpty(trackingStatus);
        String statusName = DEMO_TRACKING_STATUS_LABELS.get(normalizedStatus);
        if (statusName == null) {
            throw new IllegalArgumentException("Trạng thái vận chuyển mô phỏng không hợp lệ.");
        }

        String newOrderStatus = "DELIVERED".equals(normalizedStatus) ? OrderStatus.COMPLETED : OrderStatus.SHIPPING;
        String description = buildDemoTrackingDescription(statusName, location);
        LocalDateTime now = LocalDateTime.now();

        dao.updateDemoTrackingStatus(orderId, normalizedStatus, statusName, newOrderStatus);
        trackingLogDao.insert(
                orderId,
                "DEMO",
                order.getGhnOrderCode(),
                normalizedStatus,
                statusName,
                description,
                now
        );
    }

    public Map<String, String> getDemoTrackingStatusLabels() {
        return DEMO_TRACKING_STATUS_LABELS;
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
        if (isDemoTrackingCode(order.getGhnOrderCode())) {
            return;
        }
        ghnOrderCancellationService.cancelOrder(order.getGhnOrderCode());
    }

    public boolean isDemoTrackingCode(String trackingCode) {
        return trackingCode != null && trackingCode.startsWith(DEMO_TRACKING_PREFIX);
    }

    private String buildDemoTrackingDescription(String statusName, String location) {
        String normalizedLocation = trimToEmpty(location);
        if (normalizedLocation.isBlank()) {
            return statusName + ".";
        }
        return statusName + " tại " + normalizedLocation + ".";
    }

    private static Map<String, String> createDemoTrackingStatusLabels() {
        Map<String, String> statuses = new LinkedHashMap<>();
        statuses.put("PACKED", "Đã đóng gói");
        statuses.put("HANDED_OVER", "Đã bàn giao vận chuyển");
        statuses.put("SORTING", "Đang ở kho phân loại");
        statuses.put("IN_TRANSIT", "Đang vận chuyển");
        statuses.put("OUT_FOR_DELIVERY", "Đang giao hàng");
        statuses.put("DELIVERY_FAILED", "Giao hàng thất bại");
        statuses.put("DELIVERED", "Đã giao thành công");
        return Collections.unmodifiableMap(statuses);
    }

    private String trimToEmpty(String value) {
        return value == null ? "" : value.trim();
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
        if (isDemoTrackingCode(order.getGhnOrderCode())) {
            String statusName = "Đã hủy vận chuyển";
            dao.updateGhnOrderCancelled(order.getId(), order.getGhnOrderCode(), "CANCELLED", statusName, order.getGhnExpectedDeliveryTime());
            trackingLogDao.insert(
                    order.getId(),
                    "DEMO",
                    order.getGhnOrderCode(),
                    "CANCELLED",
                    statusName,
                    "Hành trình mô phỏng đã được hủy.",
                    LocalDateTime.now()
            );
            return;
        }
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
