package model.constant;

import java.util.Map;

public final class OrderReturnStatus {
    public static final String REQUESTED = "REQUESTED";
    public static final String APPROVED = "APPROVED";
    public static final String REJECTED = "REJECTED";
    public static final String RETURNING = "RETURNING";
    public static final String RETURNED = "RETURNED";

    public static final String SOURCE_CUSTOMER = "CUSTOMER";
    public static final String REFUND_NOT_REQUIRED = "NOT_REQUIRED";
    public static final String REFUND_PENDING = "PENDING";
    public static final String REFUNDED = "REFUNDED";

    private static final Map<String, String> RETURN_LABELS = Map.of(
            REQUESTED, "Đang chờ duyệt",
            APPROVED, "Đã chấp nhận",
            REJECTED, "Đã từ chối",
            RETURNING, "Đang hoàn hàng",
            RETURNED, "Đã hoàn hàng"
    );

    private static final Map<String, String> REFUND_LABELS = Map.of(
            REFUND_NOT_REQUIRED, "Chưa phát sinh hoàn tiền",
            REFUND_PENDING, "Chờ hoàn tiền",
            REFUNDED, "Đã hoàn tiền"
    );

    private OrderReturnStatus() {
    }

    public static String getReturnLabel(String status) {
        return RETURN_LABELS.getOrDefault(status, status);
    }

    public static String getRefundLabel(String status) {
        return REFUND_LABELS.getOrDefault(status, status);
    }
}
