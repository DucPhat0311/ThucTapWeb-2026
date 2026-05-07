package service.location;

import model.location.LocationItem;

import java.time.Duration;
import java.time.Instant;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.function.Supplier;

public class VietnamLocationService {
    private static final Duration CACHE_TTL = Duration.ofHours(24);
    private static final VietnamLocationService INSTANCE = new VietnamLocationService(
            new ProvinceOpenApiLocationProvider(new ProvinceOpenApiClient())
    );

    private final LocationProvider locationProvider;
    private final Map<String, CacheEntry> cache = new ConcurrentHashMap<>();

    public VietnamLocationService(LocationProvider locationProvider) {
        this.locationProvider = locationProvider;
    }

    public static VietnamLocationService getInstance() {
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
        if (provinceCode == null || districtCode == null || wardCode == null) {
            return false;
        }

        return containsCode(getProvinces(), provinceCode)
                && containsCode(getDistricts(provinceCode), districtCode)
                && containsCode(getWards(districtCode), Integer.parseInt(wardCode)); // wardCode string -> int
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
