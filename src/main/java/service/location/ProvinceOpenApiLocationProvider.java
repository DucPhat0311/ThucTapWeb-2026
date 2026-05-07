package service.location;

import model.location.LocationItem;

import java.util.List;

public class ProvinceOpenApiLocationProvider implements LocationProvider {
    private static final String DEFAULT_BASE_URL = "https://provinces.open-api.vn/api/v1";
    private static final String BASE_URL_PROPERTY = "location.api.base-url";
    private static final String BASE_URL_ENV = "LOCATION_API_BASE_URL";
    private static final String PROVIDER_KEY = "province-open-api";

    private final ProvinceOpenApiClient apiClient;

    public ProvinceOpenApiLocationProvider(ProvinceOpenApiClient apiClient) {
        this.apiClient = apiClient;
    }

    @Override
    public String getProviderKey() {
        return PROVIDER_KEY;
    }

    @Override
    public List<LocationItem> getProvinces() {
        return apiClient.fetchProvinces(getBaseUrl());
    }

    @Override
    public List<LocationItem> getDistricts(int provinceCode) {
        return apiClient.fetchDistricts(getBaseUrl(), provinceCode);
    }

    @Override
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
