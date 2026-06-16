package controller.web;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.ApiConstant;
import service.GhnWebhookService;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet(name = "GhnWebhookController", value = "/api/ghn/webhook/order-status")
public class GhnWebhookController extends HttpServlet {
    private ObjectMapper objectMapper;
    private GhnWebhookService ghnWebhookService;

    @Override
    public void init() {
        objectMapper = new ObjectMapper();
        ghnWebhookService = new GhnWebhookService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        writeJson(response, HttpServletResponse.SC_OK, Map.of(
                "success", true,
                "message", "GHN webhook endpoint is ready"
        ));
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        if (!isAuthorized(request)) {
            writeJson(response, HttpServletResponse.SC_UNAUTHORIZED, Map.of(
                    "success", false,
                    "message", "Invalid GHN webhook secret"
            ));
            return;
        }

        String rawPayload = request.getReader()
                .lines()
                .collect(Collectors.joining(System.lineSeparator()));
        if (rawPayload.isBlank()) {
            writeJson(response, HttpServletResponse.SC_BAD_REQUEST, Map.of(
                    "success", false,
                    "message", "Webhook payload is required"
            ));
            return;
        }

        GhnWebhookPayload payload;
        try {
            payload = parsePayload(rawPayload);
        } catch (JsonProcessingException e) {
            writeJson(response, HttpServletResponse.SC_BAD_REQUEST, Map.of(
                    "success", false,
                    "message", "Webhook payload must be valid JSON"
            ));
            return;
        }

        if (payload.orderCode().isBlank() || payload.statusCode().isBlank()) {
            writeJson(response, HttpServletResponse.SC_UNPROCESSABLE_CONTENT, Map.of(
                    "success", false,
                    "message", "Webhook payload must include order_code and status"
            ));
            return;
        }

        GhnWebhookService.SyncResult syncResult = ghnWebhookService.syncOrderStatus(
                payload.orderCode(),
                payload.statusCode(),
                payload.statusName(),
                payload.eventTime(),
                payload.description()
        );

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("orderCode", payload.orderCode());
        data.put("statusCode", payload.statusCode());
        data.put("statusName", syncResult.statusName().isBlank() ? payload.statusName() : syncResult.statusName());
        data.put("eventTime", payload.eventTime());
        data.put("orderFound", syncResult.orderFound());
        data.put("orderUpdated", syncResult.updated());
        data.put("trackingLogged", syncResult.trackingLogged());
        data.put("ignored", syncResult.ignored());
        data.put("ignoreReason", syncResult.ignoreReason());
        data.put("orderId", syncResult.orderId());
        data.put("orderStatus", syncResult.orderStatus());
        data.put("paymentStatus", syncResult.paymentStatus());

        writeJson(response, HttpServletResponse.SC_OK, Map.of(
                "success", true,
                "message", resolveResponseMessage(syncResult),
                "data", data
        ));
    }

    private String resolveResponseMessage(GhnWebhookService.SyncResult syncResult) {
        if (!syncResult.orderFound()) {
            return "GHN webhook payload accepted but order was not found";
        }
        if (syncResult.ignored()) {
            return "GHN webhook payload ignored because order is already terminal";
        }
        return "GHN webhook payload synced";
    }

    private boolean isAuthorized(HttpServletRequest request) {
        String configuredSecret = trimToEmpty(ApiConstant.GHN_WEBHOOK_SECRET);
        if (configuredSecret.isBlank()) {
            return true;
        }

        String requestSecret = firstNonBlank(
                request.getParameter("secret"),
                request.getHeader("X-GHN-Webhook-Secret"),
                request.getHeader("X-Webhook-Secret")
        );
        return configuredSecret.equals(requestSecret);
    }

    private GhnWebhookPayload parsePayload(String rawPayload) throws JsonProcessingException {
        JsonNode root = objectMapper.readTree(rawPayload);
        JsonNode data = root.path("data").isMissingNode() || root.path("data").isNull()
                ? root
                : root.path("data");

        return new GhnWebhookPayload(
                firstNonBlank(
                        textAt(root, "order_code"),
                        textAt(root, "OrderCode"),
                        textAt(data, "order_code"),
                        textAt(data, "OrderCode"),
                        textAt(data, "orderCode")
                ),
                firstNonBlank(
                        textAt(root, "status"),
                        textAt(root, "Status"),
                        textAt(root, "current_status"),
                        textAt(data, "status"),
                        textAt(data, "Status"),
                        textAt(data, "current_status")
                ),
                firstNonBlank(
                        textAt(root, "status_name"),
                        textAt(root, "StatusName"),
                        textAt(data, "status_name"),
                        textAt(data, "StatusName")
                ),
                firstNonBlank(
                        textAt(root, "updated_date"),
                        textAt(root, "UpdatedDate"),
                        textAt(root, "event_time"),
                        textAt(root, "EventTime"),
                        textAt(data, "updated_date"),
                        textAt(data, "UpdatedDate"),
                        textAt(data, "event_time"),
                        textAt(data, "EventTime")
                ),
                firstNonBlank(
                        textAt(root, "description"),
                        textAt(root, "Description"),
                        textAt(root, "reason"),
                        textAt(root, "Reason"),
                        textAt(root, "message"),
                        textAt(data, "description"),
                        textAt(data, "Description"),
                        textAt(data, "reason"),
                        textAt(data, "Reason"),
                        textAt(data, "message")
                )
        );
    }

    private String textAt(JsonNode node, String fieldName) {
        if (node == null || node.isMissingNode() || node.isNull()) {
            return "";
        }
        JsonNode value = node.path(fieldName);
        if (value.isMissingNode() || value.isNull()) {
            return "";
        }
        return trimToEmpty(value.asText());
    }

    private String firstNonBlank(String... values) {
        if (values == null) {
            return "";
        }
        for (String value : values) {
            String normalizedValue = trimToEmpty(value);
            if (!normalizedValue.isBlank()) {
                return normalizedValue;
            }
        }
        return "";
    }

    private void writeJson(HttpServletResponse response, int status, Object body) throws IOException {
        response.setStatus(status);
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write(objectMapper.writeValueAsString(body));
    }

    private String trimToEmpty(String value) {
        return value == null ? "" : value.trim();
    }

    private record GhnWebhookPayload(
            String orderCode,
            String statusCode,
            String statusName,
            String eventTime,
            String description
    ) {
    }
}
