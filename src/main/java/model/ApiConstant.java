package model;

public class ApiConstant {
    private static final String DEFAULT_GHN_BASE_URL = "https://online-gateway.ghn.vn/shiip/public-api";

    public static final String GHN_TOKEN = envOrDefault("GHN_TOKEN", "");
    public static final String GHN_BASE_URL = normalizeBaseUrl(envOrDefault("GHN_BASE_URL", DEFAULT_GHN_BASE_URL));
    public static final String GHN_CLIENT_ID = envOrDefault("GHN_CLIENT_ID", "");
    public static final String GHN_WEBHOOK_SECRET = envOrDefault("GHN_WEBHOOK_SECRET", "");
    public static final String GHN_SHOP_ID = envOrDefault("GHN_SHOP_ID", "200719");
    public static final String GHN_FROM_NAME = envOrDefault("GHN_FROM_NAME", "AURA Studio");
    public static final String GHN_FROM_PHONE = envOrDefault("GHN_FROM_PHONE", "0365403194");
    public static final String GHN_FROM_ADDRESS = envOrDefault(
            "GHN_FROM_ADDRESS",
            "Trường Đại học Nông Lâm TP.HCM, Khu phố 6"
    );
    public static final String GHN_FROM_WARD_NAME = envOrDefault("GHN_FROM_WARD_NAME", "Phường Linh Trung");
    public static final String GHN_FROM_DISTRICT_NAME = envOrDefault("GHN_FROM_DISTRICT_NAME", "TP. Thủ Đức");
    public static final String GHN_FROM_PROVINCE_NAME = envOrDefault("GHN_FROM_PROVINCE_NAME", "TP. Hồ Chí Minh");
    public static final String GHN_FROM_DISTRICT_ID = envOrDefault("GHN_FROM_DISTRICT_ID", "3695");
    public static final String GHN_FROM_WARD_CODE = envOrDefault("GHN_FROM_WARD_CODE", "90737");
    public static final String GHN_DEFAULT_SERVICE_TYPE_ID = envOrDefault("GHN_DEFAULT_SERVICE_TYPE_ID", "2");

    public static String ghnApiUrl(String path) {
        String normalizedPath = path == null ? "" : path.trim();
        if (normalizedPath.isBlank()) {
            return GHN_BASE_URL;
        }
        return normalizedPath.startsWith("/")
                ? GHN_BASE_URL + normalizedPath
                : GHN_BASE_URL + "/" + normalizedPath;
    }

    private static String envOrDefault(String key, String defaultValue) {
        String value = System.getenv(key);
        return value == null || value.isBlank() ? defaultValue : value.trim();
    }

    private static String normalizeBaseUrl(String baseUrl) {
        String normalizedBaseUrl = baseUrl == null ? "" : baseUrl.trim();
        while (normalizedBaseUrl.endsWith("/")) {
            normalizedBaseUrl = normalizedBaseUrl.substring(0, normalizedBaseUrl.length() - 1);
        }
        return normalizedBaseUrl.isBlank() ? DEFAULT_GHN_BASE_URL : normalizedBaseUrl;
    }
}
