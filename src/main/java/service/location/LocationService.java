package service.location;

import model.location.LocationItem;

import java.time.Duration;
import java.time.Instant;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.function.Supplier;

public class LocationService {
    private static final Duration CACHE_TTL = Duration.ofHours(24);
    private static final LocationService INSTANCE = new LocationService(
            new GhnLocationProvider()
    );

    private final LocationProvider locationProvider;
    private final Map<String, CacheEntry> cache = new ConcurrentHashMap<>();

    public LocationService(LocationProvider locationProvider) {
        this.locationProvider = locationProvider;
    }

    public static LocationService getInstance() {
        return INSTANCE;
    }

    public List<LocationItem> getProvinces() {
        return getCached(
                buildCacheKey("provinces"),
                locationProvider::getProvinces
        );
    }

    public List<LocationItem> getDistricts(int provinceCode) {
        return getCached(
                buildCacheKey("districts", provinceCode),
                () -> locationProvider.getDistricts(provinceCode)
        );
    }

    public List<LocationItem> getWards(int districtCode) {
        return getCached(
                buildCacheKey("wards", districtCode),
                () -> locationProvider.getWards(districtCode)
        );
    }

    public boolean isValidLocation(Integer provinceCode, Integer districtCode, String wardCode) {
        if (provinceCode == null || districtCode == null || wardCode == null || wardCode.isBlank()) {
            return false;
        }

        return containsCode(getProvinces(), provinceCode)
                && containsCode(getDistricts(provinceCode), districtCode)
                && containsCodeString(getWards(districtCode), wardCode);
    }

    private boolean containsCode(List<LocationItem> items, int code) {
        return items.stream().anyMatch(item -> item.getCode() != null && item.getCode() == code);
    }

    private boolean containsCodeString(List<LocationItem> items, String code) {
        return items.stream().anyMatch(item -> code.equals(item.getCodeString()));
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

    private String buildCacheKey(String resourceName) {
        return locationProvider.getProviderKey() + ":" + resourceName;
    }

    private String buildCacheKey(String resourceName, int code) {
        return buildCacheKey(resourceName) + ":" + code;
    }

    private record CacheEntry(List<LocationItem> items, Instant expiresAt) {
        private boolean isExpired() {
            return Instant.now().isAfter(expiresAt);
        }
    }
}
