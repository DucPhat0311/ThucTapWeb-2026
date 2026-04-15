package service.location;

import model.location.LocationItem;

import java.util.List;

public class VietnamLocationService {
    private static final String DEFAULT_BASE_URL = "https://provinces.open-api.vn/api/v1";
    private static final String BASE_URL_PROPERTY = "location.api.base-url";
    private static final String BASE_URL_ENV = "LOCATION_API_BASE_URL";
    private static final VietnamLocationService INSTANCE = new VietnamLocationService(new ProvinceOpenApiClient());

    private final ProvinceOpenApiClient apiClient;

    public VietnamLocationService(ProvinceOpenApiClient apiClient) {
        this.apiClient = apiClient;
    }

    public static VietnamLocationService getInstance() {
        return INSTANCE;
    }

    public List<LocationItem> getProvinces() {
        return apiClient.fetchProvinces(getBaseUrl());
    }

    public List<LocationItem> getDistricts(int provinceCode) {
        return apiClient.fetchDistricts(getBaseUrl(), provinceCode);
    }

    public List<LocationItem> getWards(int districtCode) {
        return apiClient.fetchWards(getBaseUrl(), districtCode);
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
}
