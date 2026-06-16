package service;

import dao.user.OrderDao;
import dao.user.OrderTrackingLogDao;
import model.Order;
import model.constant.OrderStatus;
import model.constant.PaymentMethod;
import model.constant.PaymentStatus;

import java.time.Instant;
import java.time.LocalDateTime;
import java.time.OffsetDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

public class GhnWebhookService {
    private static final String PROVIDER = "GHN";
    private static final ZoneId VIETNAM_ZONE = ZoneId.of("Asia/Ho_Chi_Minh");
    private static final DateTimeFormatter SPACE_DATE_TIME = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    private static final DateTimeFormatter VIETNAMESE_DATE_TIME = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");
    private static final DateTimeFormatter VIETNAMESE_MINUTE_TIME = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    private static final String STATUS_DELIVERED = "delivered";
    private static final String STATUS_CANCELLED = "cancel";
    private static final String STATUS_RETURNED = "returned";

    private final OrderDao orderDao;
    private final OrderTrackingLogDao trackingLogDao;
    private final GhnOrderTrackingService ghnOrderTrackingService;

    public GhnWebhookService() {
        this.orderDao = new OrderDao();
        this.trackingLogDao = new OrderTrackingLogDao();
        this.ghnOrderTrackingService = new GhnOrderTrackingService();
    }

    public SyncResult syncOrderStatus(String orderCode,
                                      String statusCode,
                                      String statusName,
                                      String eventTime,
                                      String description) {
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

        TerminalConflict terminalConflict = resolveTerminalConflict(order, normalizedStatusCode);
        if (terminalConflict.conflicted()) {
            return SyncResult.ignored(
                    order.getId(),
                    normalizedOrderCode,
                    normalizedStatusCode,
                    resolvedStatusName,
                    trimToEmpty(order.getOrderStatus()),
                    trimToEmpty(order.getPaymentStatuses()),
                    terminalConflict.reason()
            );
        }

        String resolvedOrderStatus = ghnOrderTrackingService.resolveOrderStatus(
                normalizedStatusCode,
                order.getOrderStatus()
        );
        if (resolvedOrderStatus == null || resolvedOrderStatus.isBlank()) {
            resolvedOrderStatus = trimToEmpty(order.getOrderStatus());
        }
        String resolvedPaymentStatus = resolvePaymentStatus(order, resolvedOrderStatus);

        boolean changed = !normalizedStatusCode.equals(trimToEmpty(order.getGhnStatus()))
                || !resolvedStatusName.equals(trimToEmpty(order.getGhnStatusName()))
                || !resolvedOrderStatus.equals(trimToEmpty(order.getOrderStatus()))
                || !resolvedPaymentStatus.equals(trimToEmpty(order.getPaymentStatuses()));

        if (changed) {
            orderDao.updateGhnWebhookStatus(
                    order.getId(),
                    normalizedStatusCode,
                    resolvedStatusName,
                    resolvedOrderStatus,
                    resolvedPaymentStatus
            );
        }

        LocalDateTime parsedEventTime = parseEventTime(eventTime);
        boolean trackingLogged = trackingLogDao.insertIfNewEvent(
                order.getId(),
                PROVIDER,
                normalizedOrderCode,
                normalizedStatusCode,
                resolvedStatusName,
                buildDescription(resolvedStatusName, description),
                parsedEventTime
        );

        return SyncResult.synced(
                order.getId(),
                normalizedOrderCode,
                normalizedStatusCode,
                resolvedStatusName,
                resolvedOrderStatus,
                resolvedPaymentStatus,
                changed,
                trackingLogged
        );
    }

    public SyncResult syncOrderStatus(String orderCode, String statusCode, String statusName) {
        return syncOrderStatus(orderCode, statusCode, statusName, "", "");
    }

    private TerminalConflict resolveTerminalConflict(Order order, String ghnStatusCode) {
        String currentOrderStatus = trimToEmpty(order.getOrderStatus());
        String normalizedGhnStatusCode = trimToEmpty(ghnStatusCode);

        if (OrderStatus.COMPLETED.equals(currentOrderStatus)
                && !STATUS_DELIVERED.equals(normalizedGhnStatusCode)) {
            return TerminalConflict.conflicted(
                    "Đơn hàng đã hoàn thành, bỏ qua trạng thái GHN đến sau: " + normalizedGhnStatusCode + "."
            );
        }
        if (OrderStatus.CANCELLED.equals(currentOrderStatus)
                && !STATUS_CANCELLED.equals(normalizedGhnStatusCode)) {
            return TerminalConflict.conflicted(
                    "Đơn hàng đã hủy, bỏ qua trạng thái GHN đến sau: " + normalizedGhnStatusCode + "."
            );
        }
        if (OrderStatus.RETURNED.equals(currentOrderStatus)
                && !STATUS_RETURNED.equals(normalizedGhnStatusCode)) {
            return TerminalConflict.conflicted(
                    "Đơn hàng đã hoàn trả, bỏ qua trạng thái GHN đến sau: " + normalizedGhnStatusCode + "."
            );
        }

        return TerminalConflict.allowed();
    }

    private String buildDescription(String statusName, String description) {
        String normalizedDescription = trimToEmpty(description);
        if (!normalizedDescription.isBlank()) {
            return normalizedDescription;
        }
        String normalizedStatusName = trimToEmpty(statusName);
        if (normalizedStatusName.isBlank()) {
            return "GHN đã cập nhật trạng thái vận đơn.";
        }
        return "GHN cập nhật trạng thái: " + normalizedStatusName + ".";
    }

    private LocalDateTime parseEventTime(String rawEventTime) {
        String normalizedEventTime = trimToEmpty(rawEventTime);
        if (normalizedEventTime.isBlank()) {
            return null;
        }
        if (normalizedEventTime.matches("\\d+")) {
            long epochValue;
            try {
                epochValue = Long.parseLong(normalizedEventTime);
            } catch (NumberFormatException e) {
                return null;
            }
            if (epochValue <= 0) {
                return null;
            }
            if (normalizedEventTime.length() > 10) {
                return LocalDateTime.ofInstant(Instant.ofEpochMilli(epochValue), VIETNAM_ZONE);
            }
            return LocalDateTime.ofInstant(Instant.ofEpochSecond(epochValue), VIETNAM_ZONE);
        }
        LocalDateTime parsedTime = parseWithOffset(normalizedEventTime);
        if (parsedTime != null) {
            return parsedTime;
        }
        parsedTime = parseWithFormatter(normalizedEventTime, DateTimeFormatter.ISO_LOCAL_DATE_TIME);
        if (parsedTime != null) {
            return parsedTime;
        }
        parsedTime = parseWithFormatter(normalizedEventTime, SPACE_DATE_TIME);
        if (parsedTime != null) {
            return parsedTime;
        }
        parsedTime = parseWithFormatter(normalizedEventTime, VIETNAMESE_DATE_TIME);
        if (parsedTime != null) {
            return parsedTime;
        }
        return parseWithFormatter(normalizedEventTime, VIETNAMESE_MINUTE_TIME);
    }

    private String resolvePaymentStatus(Order order, String orderStatus) {
        String currentPaymentStatus = trimToEmpty(order.getPaymentStatuses());
        if (OrderStatus.COMPLETED.equals(orderStatus)
                && PaymentMethod.COD.equals(order.getPaymentMethods())) {
            return PaymentStatus.PAID;
        }
        if ((OrderStatus.CANCELLED.equals(orderStatus) || OrderStatus.RETURNED.equals(orderStatus))
                && PaymentMethod.VNPAY.equals(order.getPaymentMethods())
                && PaymentStatus.PAID.equals(currentPaymentStatus)) {
            return PaymentStatus.REFUND_PENDING;
        }
        return currentPaymentStatus;
    }

    private LocalDateTime parseWithOffset(String value) {
        try {
            return OffsetDateTime.parse(value, DateTimeFormatter.ISO_DATE_TIME)
                    .atZoneSameInstant(VIETNAM_ZONE)
                    .toLocalDateTime();
        } catch (DateTimeParseException e) {
            return null;
        }
    }

    private LocalDateTime parseWithFormatter(String value, DateTimeFormatter formatter) {
        try {
            return LocalDateTime.parse(value, formatter);
        } catch (DateTimeParseException e) {
            return null;
        }
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
            String orderStatus,
            String paymentStatus,
            boolean trackingLogged,
            boolean ignored,
            String ignoreReason
    ) {
        private static SyncResult invalid() {
            return new SyncResult(false, false, false, null, "", "", "", "", "", false, false, "");
        }

        private static SyncResult notFound(String orderCode, String statusCode) {
            return new SyncResult(true, false, false, null, orderCode, statusCode, "", "", "", false, false, "");
        }

        private static SyncResult ignored(int orderId,
                                          String orderCode,
                                          String statusCode,
                                          String statusName,
                                          String orderStatus,
                                          String paymentStatus,
                                          String ignoreReason) {
            return new SyncResult(true, true, false, orderId, orderCode, statusCode, statusName, orderStatus,
                    paymentStatus, false, true, ignoreReason);
        }

        private static SyncResult synced(int orderId,
                                         String orderCode,
                                         String statusCode,
                                         String statusName,
                                         String orderStatus,
                                         String paymentStatus,
                                         boolean updated,
                                         boolean trackingLogged) {
            return new SyncResult(true, true, updated, orderId, orderCode, statusCode, statusName, orderStatus,
                    paymentStatus, trackingLogged, false, "");
        }
    }

    private record TerminalConflict(boolean conflicted, String reason) {
        private static TerminalConflict allowed() {
            return new TerminalConflict(false, "");
        }

        private static TerminalConflict conflicted(String reason) {
            return new TerminalConflict(true, reason);
        }
    }
}
