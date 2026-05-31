package model.constant;

import java.util.Map;

public final class OrderStatusLabel {
    private static final Map<String, String> ADMIN_LABELS = Map.of(
            OrderStatus.PENDING_PAYMENT, "Chờ thanh toán",
            OrderStatus.PENDING, "Cần xác nhận",
            OrderStatus.PROCESSING, "Đang chuẩn bị hàng",
            OrderStatus.SHIPPING, "Đang giao hàng",
            OrderStatus.COMPLETED, "Đã hoàn thành",
            OrderStatus.CANCELLED, "Đã hủy"
    );

    private static final Map<String, String> CUSTOMER_LABELS = Map.of(
            OrderStatus.PENDING_PAYMENT, "Chờ thanh toán",
            OrderStatus.PENDING, "Chờ xác nhận",
            OrderStatus.PROCESSING, "Đang chuẩn bị hàng",
            OrderStatus.SHIPPING, "Đang giao hàng",
            OrderStatus.COMPLETED, "Đã hoàn thành",
            OrderStatus.CANCELLED, "Đã hủy"
    );

    private OrderStatusLabel() {
    }

    public static Map<String, String> adminLabels() {
        return ADMIN_LABELS;
    }

    public static String adminLabel(String status) {
        return ADMIN_LABELS.getOrDefault(status, status);
    }

    public static String customerLabel(String status) {
        if (status == null) {
            return "Không xác định";
        }
        return CUSTOMER_LABELS.getOrDefault(status, status);
    }

    public static String customerCssClass(String status) {
        if (OrderStatus.PENDING_PAYMENT.equals(status)) {
            return "pending-payment";
        }
        if (OrderStatus.PROCESSING.equals(status)) {
            return "processing";
        }
        if (OrderStatus.SHIPPING.equals(status)) {
            return "shipping";
        }
        if (OrderStatus.COMPLETED.equals(status)) {
            return "delivered";
        }
        if (OrderStatus.CANCELLED.equals(status)) {
            return "cancelled";
        }
        return "pending";
    }
}
