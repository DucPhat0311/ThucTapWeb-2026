package model.constant;

import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.Map;

public final class OrderReturnReason {
    public static final String DEFECTIVE_PRODUCT = "DEFECTIVE_PRODUCT";
    public static final String WRONG_PRODUCT = "WRONG_PRODUCT";
    public static final String WRONG_SIZE_OR_COLOR = "WRONG_SIZE_OR_COLOR";
    public static final String NOT_SUITABLE = "NOT_SUITABLE";
    public static final String OTHER = "OTHER";

    private static final Map<String, String> CUSTOMER_REASONS = createCustomerReasons();

    private OrderReturnReason() {
    }

    public static boolean isCustomerReason(String reasonCode) {
        return CUSTOMER_REASONS.containsKey(reasonCode);
    }

    public static Map<String, String> getCustomerReasons() {
        return CUSTOMER_REASONS;
    }

    private static Map<String, String> createCustomerReasons() {
        Map<String, String> reasons = new LinkedHashMap<>();
        reasons.put(DEFECTIVE_PRODUCT, "Sản phẩm bị lỗi");
        reasons.put(WRONG_PRODUCT, "Giao sai sản phẩm");
        reasons.put(WRONG_SIZE_OR_COLOR, "Sai kích cỡ hoặc màu sắc");
        reasons.put(NOT_SUITABLE, "Sản phẩm không phù hợp");
        reasons.put(OTHER, "Lý do khác");
        return Collections.unmodifiableMap(reasons);
    }
}
