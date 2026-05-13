package model;

public class ApiConstant {
    public static final String GHN_TOKEN = System.getenv("GHN_TOKEN");
    public static final String GHN_BASE_URL = System.getenv("GHN_BASE_URL") == null || System.getenv("GHN_BASE_URL").isBlank()
            ? "https://dev-online-gateway.ghn.vn/shiip/public-api"
            : System.getenv("GHN_BASE_URL");
}
