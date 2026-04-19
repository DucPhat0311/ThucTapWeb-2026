package service.location;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import model.location.LocationItem;

import java.io.IOException;
import java.net.Proxy;
import java.net.ProxySelector;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.ArrayList;
import java.util.List;

public class ProvinceOpenApiClient {
    private static final Duration REQUEST_TIMEOUT = Duration.ofSeconds(10);
    private static final ProxySelector NO_PROXY_SELECTOR = new ProxySelector() {
        @Override
        public List<Proxy> select(URI uri) {
            return List.of(Proxy.NO_PROXY);
        }

        @Override
        public void connectFailed(URI uri, java.net.SocketAddress sa, IOException ioe) {
        }
    };

    private final HttpClient httpClient;
    private final ObjectMapper objectMapper;

    public ProvinceOpenApiClient() {
        this.httpClient = HttpClient.newBuilder()
                .connectTimeout(REQUEST_TIMEOUT)
                .proxy(NO_PROXY_SELECTOR)
                .build();
        this.objectMapper = new ObjectMapper();
    }

    public List<LocationItem> fetchProvinces(String baseUrl) {
        JsonNode root = getJson(baseUrl, "/?depth=1");
        return readLocationItems(root);
    }

    public List<LocationItem> fetchDistricts(String baseUrl, int provinceCode) {
        JsonNode root = getJson(baseUrl, "/p/" + provinceCode + "?depth=2");
        return readLocationItems(root.path("districts"));
    }

    public List<LocationItem> fetchWards(String baseUrl, int districtCode) {
        JsonNode root = getJson(baseUrl, "/d/" + districtCode + "?depth=2");
        return readLocationItems(root.path("wards"));
    }

    private JsonNode getJson(String baseUrl, String path) {
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(normalizeBaseUrl(baseUrl) + path))
                .timeout(REQUEST_TIMEOUT)
                .header("Accept", "application/json")
                .header("User-Agent", "ShopQuanAo/1.0")
                .GET()
                .build();

        try {
            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
            if (response.statusCode() < 200 || response.statusCode() >= 300) {
                throw new LocationApiException("Province Open API trả về HTTP " + response.statusCode());
            }
            return objectMapper.readTree(response.body());
        } catch (IOException e) {
            throw new LocationApiException("Không thể đọc dữ liệu địa chỉ từ Province Open API", e);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new LocationApiException("Yêu cầu tải dữ liệu địa chỉ bị gián đoạn", e);
        } catch (IllegalArgumentException e) {
            throw new LocationApiException("URL Province Open API không hợp lệ", e);
        }
    }

    private List<LocationItem> readLocationItems(JsonNode arrayNode) {
        List<LocationItem> items = new ArrayList<>();
        if (arrayNode == null || !arrayNode.isArray()) {
            return items;
        }

        for (JsonNode itemNode : arrayNode) {
            JsonNode codeNode = itemNode.get("code");
            JsonNode nameNode = itemNode.get("name");
            if (codeNode == null || nameNode == null || !codeNode.canConvertToInt()) {
                continue;
            }

            String name = nameNode.asText(null);
            if (name == null || name.isBlank()) {
                continue;
            }

            items.add(new LocationItem(codeNode.asInt(), name));
        }

        return items;
    }

    private String normalizeBaseUrl(String baseUrl) {
        if (baseUrl == null || baseUrl.isBlank()) {
            throw new IllegalArgumentException("Base URL is blank");
        }

        String normalized = baseUrl.trim();
        while (normalized.endsWith("/")) {
            normalized = normalized.substring(0, normalized.length() - 1);
        }
        return normalized;
    }
}
