package service;

import model.Order;
import model.constant.OrderStatus;
import model.constant.PaymentMethod;
import model.constant.PaymentStatus;

public class OrderCancellationService {
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
        if (OrderStatus.PENDING.equals(status)
                || OrderStatus.PENDING_PAYMENT.equals(status)
                || OrderStatus.PROCESSING.equals(status)) {
            return CancellationCheck.accepted();
        }
        if (OrderStatus.SHIPPING.equals(status) && !trimToEmpty(order.getGhnOrderCode()).isBlank()) {
            return CancellationCheck.accepted();
        }
        return CancellationCheck.rejected("Admin chỉ có thể hủy đơn chưa giao hoặc đơn có vận đơn GHN còn được GHN cho phép hủy.");
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
        if (PaymentMethod.VNPAY.equals(order.getPaymentMethods()) && PaymentStatus.PAID.equals(order.getPaymentStatuses())) {
            return CancellationCheck.rejected("Đơn VNPay đã thanh toán cần xử lý hoàn tiền trước khi hủy.");
        }
        return CancellationCheck.accepted();
    }

    private String trimToEmpty(String value) {
        return value == null ? "" : value.trim();
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
