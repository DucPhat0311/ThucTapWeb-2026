package service;

import model.Order;
import model.constant.OrderStatus;

import java.util.Set;

public class OrderCancellationService {
    private static final String DEMO_TRACKING_PREFIX = "DEMO-ORD-";
    private static final Set<String> GHN_CANCELLABLE_STATUSES = Set.of(
            "ready_to_pick",
            "picking",
            "money_collect_picking"
    );

    public CancellationCheck checkUserCancellation(Order order, int userId) {
        CancellationCheck baseCheck = checkBaseCancellation(order);
        if (!baseCheck.cancellable()) {
            return baseCheck;
        }
        if (order.getUserId() != userId) {
            return CancellationCheck.rejected("Bạn không có quyền hủy đơn hàng này.");
        }
        String status = trimToEmpty(order.getOrderStatus());
        if (!OrderStatus.PENDING.equals(status) && !OrderStatus.PENDING_PAYMENT.equals(status)) {
            return CancellationCheck.rejected("Chỉ có thể hủy đơn hàng đang chờ xác nhận hoặc chờ thanh toán.");
        }
        return CancellationCheck.accepted();
    }

    public CancellationCheck checkAdminCancellation(Order order) {
        CancellationCheck baseCheck = checkBaseCancellation(order);
        if (!baseCheck.cancellable()) {
            return baseCheck;
        }

        String status = trimToEmpty(order.getOrderStatus());
        String trackingCode = trimToEmpty(order.getGhnOrderCode());
        String ghnStatus = trimToEmpty(order.getGhnStatus());

        if (OrderStatus.PENDING.equals(status) || OrderStatus.PENDING_PAYMENT.equals(status)) {
            return CancellationCheck.accepted();
        }

        if (OrderStatus.PROCESSING.equals(status) && trackingCode.isBlank()) {
            return CancellationCheck.accepted();
        }

        if (!trackingCode.isBlank() && isDemoTrackingCode(trackingCode) && OrderStatus.SHIPPING.equals(status)) {
            return CancellationCheck.accepted();
        }

        if (!trackingCode.isBlank() && GHN_CANCELLABLE_STATUSES.contains(ghnStatus)) {
            return CancellationCheck.accepted();
        }

        if (!trackingCode.isBlank()) {
            return CancellationCheck.rejected("Đơn đã có vận đơn và GHN đã qua bước cho phép hủy. Vui lòng xử lý theo luồng giao thất bại, hoàn hàng hoặc đổi trả.");
        }

        return CancellationCheck.rejected("Admin chỉ có thể hủy đơn chưa xác nhận, đang chuẩn bị hàng hoặc vận đơn GHN còn chờ lấy hàng.");
    }

    private CancellationCheck checkBaseCancellation(Order order) {
        if (order == null) {
            return CancellationCheck.rejected("Không tìm thấy đơn hàng.");
        }
        String status = trimToEmpty(order.getOrderStatus());
        if (OrderStatus.CANCELLED.equals(status)) {
            return CancellationCheck.rejected("Đơn hàng đã được hủy trước đó.");
        }
        if (OrderStatus.COMPLETED.equals(status)) {
            return CancellationCheck.rejected("Đơn hàng đã hoàn thành nên không thể hủy.");
        }
        if (OrderStatus.RETURNED.equals(status)) {
            return CancellationCheck.rejected("Đơn hàng đã hoàn trả nên không thể hủy.");
        }
        return CancellationCheck.accepted();
    }

    private String trimToEmpty(String value) {
        return value == null ? "" : value.trim();
    }

    private boolean isDemoTrackingCode(String trackingCode) {
        return trackingCode.startsWith(DEMO_TRACKING_PREFIX);
    }

    public record CancellationCheck(boolean cancellable, String message) {
        public static CancellationCheck accepted() {
            return new CancellationCheck(true, "");
        }

        public static CancellationCheck rejected(String message) {
            return new CancellationCheck(false, message);
        }
    }
}
