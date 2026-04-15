package service.location;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import model.location.LocationItem;

import java.io.IOException;
import java.net.URI;
import java.net.Proxy;
import java.net.ProxySelector;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.ArrayList;
import java.util.List;

public class ProvinceOpenApiClient {

    private static final Duration CONNECT_TIMEOUT = Duration.ofSeconds(10);
    private static final Duration REQUEST_TIMEOUT = Duration.ofSeconds(20);
    private static final ProxySelector NO_PROXY_SELECTOR = new ProxySelector() {
        @Override
        public List<Proxy> select(URI uri) {
            return List.of(Proxy.NO_PROXY);
        }

        @Override
        public void connectFailed(URI uri, java.net.SocketAddress sa, IOException ioe) {
            // no-op
        }
    };

    private final HttpClient httpClient;
    private final ObjectMapper objectMapper;

    public ProvinceOpenApiClient() {
        this.httpClient = HttpClient.newBuilder()
                .connectTimeout(CONNECT_TIMEOUT)
                .proxy(NO_PROXY_SELECTOR)
                .build();
        this.objectMapper = new ObjectMapper();
    }

    public List<LocationItem> fetchProvinces(String baseUrl) {
        JsonNode root = getJson(buildUrl(baseUrl, "/?depth=1"));
        JsonNode provinces = unwrapArray(root);
        if (provinces == null) {
            throw new LocationApiException("Response does not contain province list.");
        }
        return parseLocationArray(provinces);
    }

    public List<LocationItem> fetchDistricts(String baseUrl, int provinceCode) {
        JsonNode root = getJson(buildUrl(baseUrl, "/p/" + provinceCode + "?depth=2"));
        JsonNode districts = root.get("districts");
        if (districts == null || !districts.isArray()) {
            throw new LocationApiException("Response does not contain districts array.");
        }
        return parseLocationArray(districts);
    }

    public List<LocationItem> fetchWards(String baseUrl, int districtCode) {
        JsonNode root = getJson(buildUrl(baseUrl, "/d/" + districtCode + "?depth=2"));
        JsonNode wards = root.get("wards");
        if (wards == null || !wards.isArray()) {
            throw new LocationApiException("Response does not contain wards array.");
        }
        return parseLocationArray(wards);
    }

    private JsonNode getJson(String url) {
        try {
            HttpRequest request = HttpRequest.newBuilder(URI.create(url))
                    .timeout(REQUEST_TIMEOUT)
                    .header("Accept", "application/json")
                    .header("User-Agent", "ShopQuanAo-LocationClient/1.0")
                    .GET()
                    .build();

            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));
            if (response.statusCode() != 200) {
                throw new LocationApiException("Location API returned status " + response.statusCode());
            }

            return objectMapper.readTree(response.body());
        } catch (IOException | InterruptedException ex) {
            if (ex instanceof InterruptedException) {
                Thread.currentThread().interrupt();
            }
            throw new LocationApiException("Cannot load location data from remote API.", ex);
        }
    }

    private List<LocationItem> parseLocationArray(JsonNode arrayNode) {
        List<LocationItem> results = new ArrayList<>();
        for (JsonNode node : arrayNode) {
            JsonNode codeNode = node.get("code");
            JsonNode nameNode = node.get("name");

            if (codeNode == null || !codeNode.canConvertToInt() || nameNode == null || nameNode.isNull()) {
                continue;
            }

            String name = nameNode.asText().trim();
            if (name.isEmpty()) {
                continue;
            }

            results.add(new LocationItem(codeNode.asInt(), name));
        }
        return results;
    }

    private JsonNode unwrapArray(JsonNode node) {
        if (node == null) {
            return null;
        }

        if (node.isArray()) {
            return node;
        }

        JsonNode dataNode = node.get("data");
        if (dataNode != null && dataNode.isArray()) {
            return dataNode;
        }

        return null;
    }

    private String buildUrl(String baseUrl, String pathAndQuery) {
        String normalizedBase = baseUrl.endsWith("/") ? baseUrl.substring(0, baseUrl.length() - 1) : baseUrl;
        String normalizedPath = pathAndQuery.startsWith("/") ? pathAndQuery : "/" + pathAndQuery;
        return normalizedBase + normalizedPath;
    }
}
