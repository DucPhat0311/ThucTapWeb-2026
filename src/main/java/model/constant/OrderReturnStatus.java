package model.constant;

public final class OrderReturnStatus {
    public static final String REQUESTED = "REQUESTED";
    public static final String APPROVED = "APPROVED";
    public static final String REJECTED = "REJECTED";
    public static final String RETURNING = "RETURNING";
    public static final String RETURNED = "RETURNED";

    public static final String SOURCE_CUSTOMER = "CUSTOMER";
    public static final String REFUND_NOT_REQUIRED = "NOT_REQUIRED";

    private OrderReturnStatus() {
    }
}
