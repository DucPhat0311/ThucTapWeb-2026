package service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import model.Address;
import model.ApiConstant;
import model.Order;
import model.OrderItem;
import model.constant.PaymentMethod;

import java.io.IOException;
import java.net.URI;
import java.time.Duration;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.LocalDateTime;
import java.time.OffsetDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class GhnOrderCreationService {
    private static final Duration REQUEST_TIMEOUT = Duration.ofSeconds(10);
    private static final int DEFAULT_ITEM_WEIGHT = 300;
    private static final int MIN_ORDER_WEIGHT = 500;
    private static final int DEFAULT_LENGTH = 10;
    private static final int DEFAULT_WIDTH = 10;
    private static final int DEFAULT_HEIGHT = 10;

    private final HttpClient httpClient;
    private final ObjectMapper objectMapper;

    public GhnOrderCreationService() {
        this.httpClient = HttpClient.newBuilder()
                .connectTimeout(REQUEST_TIMEOUT)
                .build();
        this.objectMapper = new ObjectMapper();
    }

    public CreateOrderResult createOrder(Order order, List<OrderItem> items, Address address) {
        validateConfig();
        validateOrder(order, items, address);

        try {
            Map<String, Object> payload = buildPayload(order, items, address);
            String payloadJson = objectMapper.writeValueAsString(payload);

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(trimBaseUrl(ApiConstant.GHN_BASE_URL) + "/v2/shipping-order/create"))
                    .timeout(REQUEST_TIMEOUT)
                    .header("Content-Type", "application/json")
                    .header("Token", ApiConstant.GHN_TOKEN)
                    .header("ShopId", ApiConstant.GHN_SHOP_ID)
                    .POST(HttpRequest.BodyPublishers.ofString(payloadJson))
                    .build();

            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
            JsonNode root = objectMapper.readTree(response.body());
            int code = root.path("code").asInt(response.statusCode());
            if (response.statusCode() < 200 || response.statusCode() >= 300 || code != 200) {
                String message = root.path("message").asText("Không thể tạo vận đơn GHN.");
                throw new IllegalStateException(message);
            }

            JsonNode data = root.path("data");
            String orderCode = data.path("order_code").asText("");
            if (orderCode.isBlank()) {
                throw new IllegalStateException("GHN chưa trả về mã vận đơn.");
            }

            return new CreateOrderResult(
                    orderCode,
                    parseDateTime(data.path("expected_delivery_time").asText("")),
                    data.path("total_fee").asInt(0)
            );
        } catch (IOException e) {
            throw new IllegalStateException("Không thể đọc dữ liệu tạo vận đơn từ GHN.", e);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new IllegalStateException("Yêu cầu tạo vận đơn GHN bị gián đoạn.", e);
        } catch (IllegalArgumentException e) {
            throw new IllegalStateException("Cấu hình đường dẫn GHN không hợp lệ.", e);
        }
    }

    private Map<String, Object> buildPayload(Order order, List<OrderItem> items, Address address) {
        AddressParts addressParts = AddressParts.from(order.getShippingAddress());
        int codAmount = PaymentMethod.COD.equals(order.getPaymentMethods()) ? toMoney(order.getFinalAmount()) : 0;

        Map<String, Object> payload = new LinkedHashMap<>();
        payload.put("payment_type_id", 1);
        payload.put("required_note", "CHOXEMHANGKHONGTHU");
        payload.put("note", trimToEmpty(order.getNote()).isBlank() ? "Giao hàng đơn #" + order.getId() : order.getNote());
        payload.put("client_order_code", "AURA-" + order.getId());
        payload.put("from_name", ApiConstant.GHN_FROM_NAME);
        payload.put("from_phone", ApiConstant.GHN_FROM_PHONE);
        payload.put("from_address", ApiConstant.GHN_FROM_ADDRESS);
        payload.put("from_ward_name", ApiConstant.GHN_FROM_WARD_NAME);
        payload.put("from_district_name", ApiConstant.GHN_FROM_DISTRICT_NAME);
        payload.put("from_province_name", ApiConstant.GHN_FROM_PROVINCE_NAME);
        payload.put("to_name", order.getName());
        payload.put("to_phone", order.getPhone());
        payload.put("to_address", order.getShippingAddress());
        payload.put("to_ward_code", address.getWardCode());
        payload.put("to_district_id", address.getDistrictCode());
        payload.put("to_ward_name", trimToEmpty(address.getWard()).isBlank() ? addressParts.ward() : address.getWard());
        payload.put("to_district_name", trimToEmpty(address.getDistrict()).isBlank() ? addressParts.district() : address.getDistrict());
        payload.put("to_province_name", trimToEmpty(address.getCity()).isBlank() ? addressParts.province() : address.getCity());
        payload.put("cod_amount", codAmount);
        payload.put("content", "Đơn hàng Aura Studio #" + order.getId());
        payload.put("weight", calculateWeight(items));
        payload.put("length", DEFAULT_LENGTH);
        payload.put("width", DEFAULT_WIDTH);
        payload.put("height", DEFAULT_HEIGHT);
        payload.put("insurance_value", Math.min(toMoney(order.getTotalPrice()), 5_000_000));
        payload.put("service_type_id", 2);
        payload.put("items", buildItems(items));
        return payload;
    }

    private List<Map<String, Object>> buildItems(List<OrderItem> items) {
        List<Map<String, Object>> ghnItems = new ArrayList<>();
        for (OrderItem item : items) {
            Map<String, Object> ghnItem = new LinkedHashMap<>();
            ghnItem.put("name", trimToEmpty(item.getProductName()).isBlank() ? "Sản phẩm" : item.getProductName());
            ghnItem.put("code", "SP-" + item.getProductId());
            ghnItem.put("quantity", item.getQuantity());
            ghnItem.put("price", toMoney(item.getPrice()));
            ghnItem.put("length", DEFAULT_LENGTH);
            ghnItem.put("width", DEFAULT_WIDTH);
            ghnItem.put("height", DEFAULT_HEIGHT);
            ghnItem.put("weight", DEFAULT_ITEM_WEIGHT);
            ghnItems.add(ghnItem);
        }
        return ghnItems;
    }

    private void validateConfig() {
        if (trimToEmpty(ApiConstant.GHN_TOKEN).isBlank()) {
            throw new IllegalStateException("Thiếu cấu hình GHN_TOKEN.");
        }
        if (trimToEmpty(ApiConstant.GHN_SHOP_ID).isBlank()) {
            throw new IllegalStateException("Thiếu cấu hình GHN_SHOP_ID.");
        }
    }

    private void validateOrder(Order order, List<OrderItem> items, Address address) {
        if (order == null) {
            throw new IllegalArgumentException("Không tìm thấy đơn hàng.");
        }
        if (!trimToEmpty(order.getGhnOrderCode()).isBlank()) {
            throw new IllegalStateException("Đơn hàng đã có mã vận đơn GHN.");
        }
        if (items == null || items.isEmpty()) {
            throw new IllegalStateException("Đơn hàng chưa có sản phẩm để tạo vận đơn GHN.");
        }
        if (trimToEmpty(order.getPhone()).isBlank() || trimToEmpty(order.getShippingAddress()).isBlank()) {
            throw new IllegalStateException("Đơn hàng thiếu thông tin người nhận.");
        }
        if (address == null || address.getDistrictCode() == null || trimToEmpty(address.getWardCode()).isBlank()) {
            throw new IllegalStateException("Địa chỉ giao hàng chưa có mã quận hoặc mã phường GHN.");
        }
        AddressParts addressParts = AddressParts.from(order.getShippingAddress());
        if (addressParts.ward().isBlank() || addressParts.district().isBlank() || addressParts.province().isBlank()) {
            throw new IllegalStateException("Địa chỉ giao hàng chưa đủ phường, quận và tỉnh để tạo vận đơn GHN.");
        }
    }

    private int calculateWeight(List<OrderItem> items) {
        int totalWeight = items.stream()
                .mapToInt(item -> Math.max(item.getQuantity(), 1) * DEFAULT_ITEM_WEIGHT)
                .sum();
        return Math.max(totalWeight, MIN_ORDER_WEIGHT);
    }

    private int toMoney(double amount) {
        return Math.max(0, (int) Math.round(amount));
    }

    private LocalDateTime parseDateTime(String value) {
        String normalizedValue = trimToEmpty(value);
        if (normalizedValue.isBlank()) {
            return null;
        }
        try {
            return OffsetDateTime.parse(normalizedValue, DateTimeFormatter.ISO_DATE_TIME).toLocalDateTime();
        } catch (DateTimeParseException e) {
            try {
                return LocalDateTime.parse(normalizedValue, DateTimeFormatter.ISO_DATE_TIME);
            } catch (DateTimeParseException ignored) {
                return null;
            }
        }
    }

    private String trimBaseUrl(String baseUrl) {
        String normalizedBaseUrl = trimToEmpty(baseUrl);
        while (normalizedBaseUrl.endsWith("/")) {
            normalizedBaseUrl = normalizedBaseUrl.substring(0, normalizedBaseUrl.length() - 1);
        }
        return normalizedBaseUrl;
    }

    private static String trimToEmpty(String value) {
        return value == null ? "" : value.trim();
    }

    private record AddressParts(String ward, String district, String province) {
        private static AddressParts from(String shippingAddress) {
            String[] parts = trimToEmpty(shippingAddress).split(",");
            if (parts.length < 4) {
                return new AddressParts("", "", "");
            }
            return new AddressParts(
                    parts[parts.length - 3].trim(),
                    parts[parts.length - 2].trim(),
                    parts[parts.length - 1].trim()
            );
        }
    }

    public record CreateOrderResult(
            String orderCode,
            LocalDateTime expectedDeliveryTime,
            int totalFee
    ) {
    }
}
