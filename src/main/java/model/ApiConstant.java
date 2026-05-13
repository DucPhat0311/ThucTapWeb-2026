package model;

public class ApiConstant {
    public static final String GHN_TOKEN = System.getenv("GHN_TOKEN");
    public static final String GHN_BASE_URL = System.getenv("GHN_BASE_URL") == null || System.getenv("GHN_BASE_URL").isBlank()
            ? "https://online-gateway.ghn.vn/shiip/public-api"
            : System.getenv("GHN_BASE_URL");
    public static final String GHN_SHOP_ID = System.getenv("GHN_SHOP_ID") == null || System.getenv("GHN_SHOP_ID").isBlank()
            ? "6412985"
            : System.getenv("GHN_SHOP_ID");
    public static final String GHN_FROM_NAME = System.getenv("GHN_FROM_NAME") == null || System.getenv("GHN_FROM_NAME").isBlank()
            ? "0982832647"
            : System.getenv("GHN_FROM_NAME");
    public static final String GHN_FROM_PHONE = System.getenv("GHN_FROM_PHONE") == null || System.getenv("GHN_FROM_PHONE").isBlank()
            ? "0982832647"
            : System.getenv("GHN_FROM_PHONE");
    public static final String GHN_FROM_ADDRESS = System.getenv("GHN_FROM_ADDRESS") == null || System.getenv("GHN_FROM_ADDRESS").isBlank()
            ? "37/4 Đinh Công Tráng, Tân Định, Quận 1, Thành phố Hồ Chí Minh"
            : System.getenv("GHN_FROM_ADDRESS");
    public static final String GHN_FROM_WARD_NAME = System.getenv("GHN_FROM_WARD_NAME") == null || System.getenv("GHN_FROM_WARD_NAME").isBlank()
            ? "Tân Định"
            : System.getenv("GHN_FROM_WARD_NAME");
    public static final String GHN_FROM_DISTRICT_NAME = System.getenv("GHN_FROM_DISTRICT_NAME") == null || System.getenv("GHN_FROM_DISTRICT_NAME").isBlank()
            ? "Quận 1"
            : System.getenv("GHN_FROM_DISTRICT_NAME");
    public static final String GHN_FROM_PROVINCE_NAME = System.getenv("GHN_FROM_PROVINCE_NAME") == null || System.getenv("GHN_FROM_PROVINCE_NAME").isBlank()
            ? "Thành phố Hồ Chí Minh"
            : System.getenv("GHN_FROM_PROVINCE_NAME");
}
