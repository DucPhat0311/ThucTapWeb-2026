package service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import model.ApiConstant;
import model.constant.OrderStatus;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.Map;
import java.util.Set;

public class GhnOrderTrackingService {
    private static final String PROVIDER = "GHN";
    private static final ZoneId VIETNAM_ZONE = ZoneId.of("Asia/Ho_Chi_Minh");
    private static final Map<String, String> STATUS_LABELS = Map.ofEntries(
            Map.entry("ready_to_pick", "Chờ GHN lấy hàng"),
            Map.entry("picking", "Đang lấy hàng"),
            Map.entry("money_collect_picking", "Đang thu tiền khi lấy hàng"),
            Map.entry("picked", "Đã lấy hàng"),
            Map.entry("storing", "Đang lưu kho"),
            Map.entry("transporting", "Đang vận chuyển"),
            Map.entry("sorting", "Đang phân loại"),
            Map.entry("delivering", "Đang giao hàng"),
            Map.entry("money_collect_delivering", "Đang thu tiền khi giao hàng"),
            Map.entry("delivered", "Đã giao hàng"),
            Map.entry("delivery_fail", "Giao hàng thất bại"),
            Map.entry("waiting_to_return", "Chờ hoàn hàng"),
            Map.entry("return", "Đang hoàn hàng"),
            Map.entry("returned", "Đã hoàn hàng"),
            Map.entry("cancel", "Đã hủy")
    );
    private static final Set<String> SHIPPING_STATUSES = Set.of(
            "ready_to_pick",
            "picking",
            "money_collect_picking",
            "picked",
            "storing",
            "transporting",
            "sorting",
            "delivering",
            "money_collect_delivering",
            "delivery_fail",
            "waiting_to_return",
            "return"
    );
    private static final Set<String> CANCELLED_STATUSES = Set.of(
            "cancel",
            "returned"
    );

    private final HttpClient httpClient;
    private final ObjectMapper objectMapper;

    public GhnOrderTrackingService() {
        this.httpClient = HttpClient.newHttpClient();
        this.objectMapper = new ObjectMapper();
    }

    public TrackingResult getOrderInfo(String orderCode) {
        String normalizedOrderCode = trimToEmpty(orderCode);
        if (normalizedOrderCode.isBlank()) {
            throw new IllegalArgumentException("Mã vận đơn GHN không được để trống.");
        }
        if (trimToEmpty(ApiConstant.GHN_TOKEN).isBlank()) {
            throw new IllegalStateException("Thiếu cấu hình GHN_TOKEN.");
        }

        try {
            String payload = objectMapper.writeValueAsString(Map.of("order_code", normalizedOrderCode));
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(trimBaseUrl(ApiConstant.GHN_BASE_URL) + "/v2/shipping-order/detail"))
                    .header("Content-Type", "application/json")
                    .header("Token", ApiConstant.GHN_TOKEN)
                    .POST(HttpRequest.BodyPublishers.ofString(payload))
                    .build();

            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
            JsonNode root = objectMapper.readTree(response.body());
            int code = root.path("code").asInt(response.statusCode());
            if (response.statusCode() < 200 || response.statusCode() >= 300 || code != 200) {
                String message = root.path("message").asText("Không thể tra cứu trạng thái đơn GHN.");
                throw new IllegalStateException(message);
            }

            JsonNode data = root.path("data");
            String statusCode = data.path("status").asText("");
            String statusName = resolveStatusName(statusCode);
            LocalDateTime leadTime = parseGhnDateTime(data.path("leadtime"));
            LocalDateTime updatedAt = parseGhnDateTime(data.path("updated_date"));

            return new TrackingResult(
                    PROVIDER,
                    data.path("order_code").asText(normalizedOrderCode),
                    statusCode,
                    statusName,
                    root.path("message").asText(""),
                    leadTime,
                    updatedAt
            );
        } catch (IOException e) {
            throw new IllegalStateException("Không thể đọc dữ liệu theo dõi đơn hàng từ GHN.", e);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new IllegalStateException("Yêu cầu theo dõi đơn hàng GHN bị gián đoạn.", e);
        }
    }

    public String resolveStatusName(String statusCode) {
        String normalizedStatusCode = trimToEmpty(statusCode);
        if (normalizedStatusCode.isBlank()) {
            return "Chưa có trạng thái GHN";
        }
        return STATUS_LABELS.getOrDefault(normalizedStatusCode, normalizedStatusCode);
    }

    public String resolveOrderStatus(String ghnStatusCode, String currentOrderStatus) {
        String normalizedGhnStatusCode = trimToEmpty(ghnStatusCode);
        String normalizedOrderStatus = trimToEmpty(currentOrderStatus);

        if (OrderStatus.CANCELLED.equals(normalizedOrderStatus)) {
            return OrderStatus.CANCELLED;
        }
        if (OrderStatus.COMPLETED.equals(normalizedOrderStatus)) {
            return OrderStatus.COMPLETED;
        }
        if ("delivered".equals(normalizedGhnStatusCode)) {
            return OrderStatus.COMPLETED;
        }
        if (CANCELLED_STATUSES.contains(normalizedGhnStatusCode)) {
            return OrderStatus.CANCELLED;
        }
        if (SHIPPING_STATUSES.contains(normalizedGhnStatusCode)) {
            return OrderStatus.SHIPPING;
        }
        return normalizedOrderStatus.isBlank() ? null : normalizedOrderStatus;
    }

    private LocalDateTime parseGhnDateTime(JsonNode node) {
        if (node == null || node.isNull()) {
            return null;
        }
        if (node.isNumber()) {
            long value = node.asLong();
            if (value <= 0) {
                return null;
            }
            return LocalDateTime.ofInstant(Instant.ofEpochSecond(value), VIETNAM_ZONE);
        }
        String rawValue = trimToEmpty(node.asText());
        if (rawValue.isBlank()) {
            return null;
        }
        try {
            return LocalDateTime.parse(rawValue, DateTimeFormatter.ISO_DATE_TIME);
        } catch (DateTimeParseException ignored) {
            return null;
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

    public record TrackingResult(
            String provider,
            String orderCode,
            String statusCode,
            String statusName,
            String description,
            LocalDateTime expectedDeliveryTime,
            LocalDateTime eventTime
    ) {
    }
}
