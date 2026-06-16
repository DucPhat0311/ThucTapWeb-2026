package service;

import dao.user.OrderDao;
import model.Order;

public class GhnWebhookService {
    private final OrderDao orderDao;
    private final GhnOrderTrackingService ghnOrderTrackingService;

    public GhnWebhookService() {
        this.orderDao = new OrderDao();
        this.ghnOrderTrackingService = new GhnOrderTrackingService();
    }

    public SyncResult syncOrderStatus(String orderCode, String statusCode, String statusName) {
        String normalizedOrderCode = trimToEmpty(orderCode);
        String normalizedStatusCode = trimToEmpty(statusCode);
        if (normalizedOrderCode.isBlank() || normalizedStatusCode.isBlank()) {
            return SyncResult.invalid();
        }

        Order order = orderDao.getByGhnOrderCode(normalizedOrderCode);
        if (order == null) {
            return SyncResult.notFound(normalizedOrderCode, normalizedStatusCode);
        }

        String resolvedStatusName = trimToEmpty(statusName);
        if (resolvedStatusName.isBlank()) {
            resolvedStatusName = ghnOrderTrackingService.resolveStatusName(normalizedStatusCode);
        }

        String resolvedOrderStatus = ghnOrderTrackingService.resolveOrderStatus(
                normalizedStatusCode,
                order.getOrderStatus()
        );
        if (resolvedOrderStatus == null || resolvedOrderStatus.isBlank()) {
            resolvedOrderStatus = trimToEmpty(order.getOrderStatus());
        }

        boolean changed = !normalizedStatusCode.equals(trimToEmpty(order.getGhnStatus()))
                || !resolvedStatusName.equals(trimToEmpty(order.getGhnStatusName()))
                || !resolvedOrderStatus.equals(trimToEmpty(order.getOrderStatus()));

        if (changed) {
            orderDao.updateGhnWebhookStatus(
                    order.getId(),
                    normalizedStatusCode,
                    resolvedStatusName,
                    resolvedOrderStatus
            );
        }

        return SyncResult.synced(
                order.getId(),
                normalizedOrderCode,
                normalizedStatusCode,
                resolvedStatusName,
                resolvedOrderStatus,
                changed
        );
    }

    private String trimToEmpty(String value) {
        return value == null ? "" : value.trim();
    }

    public record SyncResult(
            boolean valid,
            boolean orderFound,
            boolean updated,
            Integer orderId,
            String orderCode,
            String statusCode,
            String statusName,
            String orderStatus
    ) {
        private static SyncResult invalid() {
            return new SyncResult(false, false, false, null, "", "", "", "");
        }

        private static SyncResult notFound(String orderCode, String statusCode) {
            return new SyncResult(true, false, false, null, orderCode, statusCode, "", "");
        }

        private static SyncResult synced(int orderId,
                                         String orderCode,
                                         String statusCode,
                                         String statusName,
                                         String orderStatus,
                                         boolean updated) {
            return new SyncResult(true, true, updated, orderId, orderCode, statusCode, statusName, orderStatus);
        }
    }
}
