package service.location;

import model.location.LocationItem;

import java.time.Duration;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.concurrent.ConcurrentHashMap;

public class VietnamLocationService {

    private static final String BASE_URL_SYSTEM_PROPERTY = "location.api.base-url";
    private static final String BASE_URL_ENV = "LOCATION_API_BASE_URL";
    private static final Duration CACHE_TTL = Duration.ofHours(24);
    private static final String LEGACY_LOCATION_API_BASE_URL = "https://provinces.open-api.vn/api/v1";
    private static final String CURRENT_LOCATION_API_BASE_URL = "https://provinces.open-api.vn/api/v2";

    private final ProvinceOpenApiClient apiClient;
    private final List<String> baseUrls;

    private volatile CacheEntry<List<LocationItem>> provinceCache;
    private final Map<Integer, CacheEntry<List<LocationItem>>> districtCache = new ConcurrentHashMap<>();
    private final Map<Integer, CacheEntry<List<LocationItem>>> wardCache = new ConcurrentHashMap<>();

    public VietnamLocationService() {
        this.apiClient = new ProvinceOpenApiClient();
        this.baseUrls = resolveBaseUrls();
    }

    public List<LocationItem> getProvinces() {
        CacheEntry<List<LocationItem>> cache = provinceCache;
        if (isValid(cache)) {
            return cache.value;
        }

        synchronized (this) {
            cache = provinceCache;
            if (isValid(cache)) {
                return cache.value;
            }

            List<LocationItem> loaded = sortByName(loadWithFallback(apiClient::fetchProvinces));
            provinceCache = new CacheEntry<>(loaded, System.currentTimeMillis() + CACHE_TTL.toMillis());
            return loaded;
        }
    }

    public List<LocationItem> getDistricts(int provinceCode) {
        if (provinceCode <= 0) {
            throw new IllegalArgumentException("provinceCode must be greater than 0.");
        }

        CacheEntry<List<LocationItem>> cache = districtCache.get(provinceCode);
        if (isValid(cache)) {
            return cache.value;
        }

        List<LocationItem> loaded = sortByName(loadWithFallback(baseUrl -> apiClient.fetchDistricts(baseUrl, provinceCode)));
        districtCache.put(provinceCode, new CacheEntry<>(loaded, System.currentTimeMillis() + CACHE_TTL.toMillis()));
        return loaded;
    }

    public List<LocationItem> getWards(int districtCode) {
        if (districtCode <= 0) {
            throw new IllegalArgumentException("districtCode must be greater than 0.");
        }

        CacheEntry<List<LocationItem>> cache = wardCache.get(districtCode);
        if (isValid(cache)) {
            return cache.value;
        }

        List<LocationItem> loaded = sortByName(loadWithFallback(baseUrl -> apiClient.fetchWards(baseUrl, districtCode)));
        wardCache.put(districtCode, new CacheEntry<>(loaded, System.currentTimeMillis() + CACHE_TTL.toMillis()));
        return loaded;
    }

    private List<LocationItem> loadWithFallback(LocationLoader loader) {
        LocationApiException lastError = null;
        for (String baseUrl : baseUrls) {
            try {
                List<LocationItem> items = loader.load(baseUrl);
                if (items != null && !items.isEmpty()) {
                    return List.copyOf(items);
                }
            } catch (LocationApiException ex) {
                lastError = ex;
            }
        }

        throw new LocationApiException("Cannot load location data from any configured base URL.", lastError);
    }

    private List<String> resolveBaseUrls() {
        String configured = System.getProperty(BASE_URL_SYSTEM_PROPERTY);
        if (configured == null || configured.isBlank()) {
            configured = System.getenv(BASE_URL_ENV);
        }

        if (configured != null && !configured.isBlank()) {
            return List.of(configured.trim());
        }

        return List.of(
                LEGACY_LOCATION_API_BASE_URL,
                CURRENT_LOCATION_API_BASE_URL
        );
    }

    private boolean isValid(CacheEntry<List<LocationItem>> cache) {
        return cache != null && cache.expiresAt > System.currentTimeMillis() && cache.value != null && !cache.value.isEmpty();
    }

    private List<LocationItem> sortByName(List<LocationItem> items) {
        List<LocationItem> sorted = new ArrayList<>(items);
        sorted.sort(Comparator.comparing(LocationItem::getName, String.CASE_INSENSITIVE_ORDER));
        return List.copyOf(sorted);
    }

    @FunctionalInterface
    private interface LocationLoader {
        List<LocationItem> load(String baseUrl);
    }

    private static final class CacheEntry<T> {
        private final T value;
        private final long expiresAt;

        private CacheEntry(T value, long expiresAt) {
            this.value = Objects.requireNonNull(value);
            this.expiresAt = expiresAt;
        }
    }
}
