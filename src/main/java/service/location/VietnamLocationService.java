package service.location;

import model.location.LocationItem;

import java.time.Duration;
import java.time.Instant;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.function.Supplier;

public class VietnamLocationService {
    private static final String DEFAULT_BASE_URL = "https://provinces.open-api.vn/api/v1";
    private static final String BASE_URL_PROPERTY = "location.api.base-url";
    private static final String BASE_URL_ENV = "LOCATION_API_BASE_URL";
    private static final Duration CACHE_TTL = Duration.ofHours(24);
    private static final VietnamLocationService INSTANCE = new VietnamLocationService(new ProvinceOpenApiClient());

    private final ProvinceOpenApiClient apiClient;
    private final Map<String, CacheEntry> cache = new ConcurrentHashMap<>();

    public VietnamLocationService(ProvinceOpenApiClient apiClient) {
        this.apiClient = apiClient;
    }

    public static VietnamLocationService getInstance() {
        return INSTANCE;
    }

    public List<LocationItem> getProvinces() {
        String baseUrl = getBaseUrl();
        return getCached("provinces:" + baseUrl, () -> apiClient.fetchProvinces(baseUrl));
    }

    public List<LocationItem> getDistricts(int provinceCode) {
        String baseUrl = getBaseUrl();
        return getCached(
                "districts:" + baseUrl + ":" + provinceCode,
                () -> apiClient.fetchDistricts(baseUrl, provinceCode)
        );
    }

    public List<LocationItem> getWards(int districtCode) {
        String baseUrl = getBaseUrl();
        return getCached(
                "wards:" + baseUrl + ":" + districtCode,
                () -> apiClient.fetchWards(baseUrl, districtCode)
        );
    }

    public boolean isValidLocation(Integer provinceCode, Integer districtCode, Integer wardCode) {
        if (provinceCode == null || districtCode == null || wardCode == null) {
            return false;
        }

        return containsCode(getProvinces(), provinceCode)
                && containsCode(getDistricts(provinceCode), districtCode)
                && containsCode(getWards(districtCode), wardCode);
    }

    private boolean containsCode(List<LocationItem> items, int code) {
        return items.stream().anyMatch(item -> item.getCode() == code);
    }

    private List<LocationItem> getCached(String key, Supplier<List<LocationItem>> supplier) {
        CacheEntry cached = cache.get(key);
        if (cached != null && !cached.isExpired()) {
            return cached.items();
        }

        synchronized (cache) {
            cached = cache.get(key);
            if (cached != null && !cached.isExpired()) {
                return cached.items();
            }

            List<LocationItem> freshItems = List.copyOf(supplier.get());
            cache.put(key, new CacheEntry(freshItems, Instant.now().plus(CACHE_TTL)));
            return freshItems;
        }
    }

    private String getBaseUrl() {
        String propertyValue = System.getProperty(BASE_URL_PROPERTY);
        if (propertyValue != null && !propertyValue.isBlank()) {
            return propertyValue;
        }

        String envValue = System.getenv(BASE_URL_ENV);
        if (envValue != null && !envValue.isBlank()) {
            return envValue;
        }

        return DEFAULT_BASE_URL;
    }

    private record CacheEntry(List<LocationItem> items, Instant expiresAt) {
        private boolean isExpired() {
            return Instant.now().isAfter(expiresAt);
        }
    }
}
