package service.location;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import model.ApiConstant;
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

public class GhnLocationProvider implements LocationProvider {
    private static final String PROVIDER_KEY = "ghn";
    private static final String BASE_URL = "https://online-gateway.ghn.vn/shiip/public-api/master-data";
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

    public GhnLocationProvider() {
        this.httpClient = HttpClient.newBuilder()
                .connectTimeout(REQUEST_TIMEOUT)
                .proxy(NO_PROXY_SELECTOR)
                .build();
        this.objectMapper = new ObjectMapper();
    }

    @Override
    public String getProviderKey() {
        return PROVIDER_KEY;
    }

    @Override
    public List<LocationItem> getProvinces() {
        JsonNode dataNode = sendRequest("/province", "GET", null);
        return readNumberCodeItems(dataNode, "ProvinceID", "ProvinceName");
    }

    @Override
    public List<LocationItem> getDistricts(int provinceCode) {
        JsonNode dataNode = sendRequest("/district", "POST", "{\"province_id\":" + provinceCode + "}");
        return readNumberCodeItems(dataNode, "DistrictID", "DistrictName");
    }

    @Override
    public List<LocationItem> getWards(int districtCode) {
        JsonNode dataNode = sendRequest("/ward", "POST", "{\"district_id\":" + districtCode + "}");
        return readStringCodeItems(dataNode, "WardCode", "WardName");
    }

    private JsonNode sendRequest(String path, String method, String payload) {
        String token = ApiConstant.GHN_TOKEN;
        if (token == null || token.isBlank()) {
            throw new LocationApiException("Thiếu cấu hình GHN_TOKEN cho dịch vụ địa chỉ.");
        }

        HttpRequest.Builder requestBuilder = HttpRequest.newBuilder()
                .uri(URI.create(BASE_URL + path))
                .timeout(REQUEST_TIMEOUT)
                .header("Token", token)
                .header("Accept", "application/json")
                .header("Content-Type", "application/json")
                .header("User-Agent", "ShopQuanAo/1.0");

        HttpRequest request = "POST".equals(method)
                ? requestBuilder.POST(HttpRequest.BodyPublishers.ofString(payload == null ? "{}" : payload)).build()
                : requestBuilder.GET().build();

        try {
            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
            if (response.statusCode() < 200 || response.statusCode() >= 300) {
                throw new LocationApiException("GHN trả về HTTP " + response.statusCode() + " khi tải dữ liệu địa chỉ.");
            }

            JsonNode root = objectMapper.readTree(response.body());
            int code = root.path("code").asInt(-1);
            if (code != 200) {
                String message = root.path("message").asText("GHN không trả về dữ liệu địa chỉ hợp lệ.");
                throw new LocationApiException(message);
            }

            return root.path("data");
        } catch (IOException e) {
            throw new LocationApiException("Không thể đọc dữ liệu địa chỉ từ GHN.", e);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new LocationApiException("Yêu cầu tải dữ liệu địa chỉ từ GHN bị gián đoạn.", e);
        } catch (IllegalArgumentException e) {
            throw new LocationApiException("URL dịch vụ địa chỉ GHN không hợp lệ.", e);
        }
    }

    private List<LocationItem> readNumberCodeItems(JsonNode arrayNode, String codeField, String nameField) {
        List<LocationItem> items = new ArrayList<>();
        if (arrayNode == null || !arrayNode.isArray()) {
            return items;
        }

        for (JsonNode itemNode : arrayNode) {
            JsonNode codeNode = itemNode.get(codeField);
            JsonNode nameNode = itemNode.get(nameField);
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

    private List<LocationItem> readStringCodeItems(JsonNode arrayNode, String codeField, String nameField) {
        List<LocationItem> items = new ArrayList<>();
        if (arrayNode == null || !arrayNode.isArray()) {
            return items;
        }

        for (JsonNode itemNode : arrayNode) {
            JsonNode codeNode = itemNode.get(codeField);
            JsonNode nameNode = itemNode.get(nameField);
            if (codeNode == null || nameNode == null) {
                continue;
            }

            String code = codeNode.asText(null);
            String name = nameNode.asText(null);
            if (code == null || code.isBlank() || name == null || name.isBlank()) {
                continue;
            }

            items.add(new LocationItem(code, name));
        }

        return items;
    }
}
