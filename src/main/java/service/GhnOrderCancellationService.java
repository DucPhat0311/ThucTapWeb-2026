package service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import model.ApiConstant;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.List;
import java.util.Map;

public class GhnOrderCancellationService {
    private static final Duration REQUEST_TIMEOUT = Duration.ofSeconds(10);

    private final HttpClient httpClient;
    private final ObjectMapper objectMapper;

    public GhnOrderCancellationService() {
        this.httpClient = HttpClient.newBuilder()
                .connectTimeout(REQUEST_TIMEOUT)
                .build();
        this.objectMapper = new ObjectMapper();
    }

    public void cancelOrder(String orderCode) {
        String normalizedOrderCode = trimToEmpty(orderCode);
        if (normalizedOrderCode.isBlank()) {
            return;
        }
        validateConfig();

        try {
            String payload = objectMapper.writeValueAsString(Map.of("order_codes", List.of(normalizedOrderCode)));
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(ApiConstant.ghnApiUrl("/v2/switch-status/cancel")))
                    .timeout(REQUEST_TIMEOUT)
                    .header("Content-Type", "application/json")
                    .header("Token", ApiConstant.GHN_TOKEN)
                    .header("ShopId", ApiConstant.GHN_SHOP_ID)
                    .POST(HttpRequest.BodyPublishers.ofString(payload))
                    .build();

            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
            JsonNode root = objectMapper.readTree(response.body());
            int code = root.path("code").asInt(response.statusCode());
            if (response.statusCode() < 200 || response.statusCode() >= 300 || code != 200) {
                String message = root.path("message").asText("Không thể hủy vận đơn GHN.");
                throw new IllegalStateException(message);
            }

            JsonNode data = root.path("data");
            if (!data.isArray() || data.isEmpty()) {
                return;
            }

            JsonNode result = data.get(0);
            if (!result.path("result").asBoolean(false)) {
                String message = result.path("message").asText("GHN từ chối hủy vận đơn.");
                throw new IllegalStateException(message);
            }
        } catch (IOException e) {
            throw new IllegalStateException("Không thể đọc dữ liệu hủy vận đơn từ GHN.", e);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new IllegalStateException("Yêu cầu hủy vận đơn GHN bị gián đoạn.", e);
        } catch (IllegalArgumentException e) {
            throw new IllegalStateException("Cấu hình đường dẫn GHN không hợp lệ.", e);
        }
    }

    private void validateConfig() {
        if (trimToEmpty(ApiConstant.GHN_TOKEN).isBlank()) {
            throw new IllegalStateException("Thiếu cấu hình GHN_TOKEN.");
        }
        if (trimToEmpty(ApiConstant.GHN_SHOP_ID).isBlank()) {
            throw new IllegalStateException("Thiếu cấu hình GHN_SHOP_ID.");
        }
    }

    private static String trimToEmpty(String value) {
        return value == null ? "" : value.trim();
    }
}
