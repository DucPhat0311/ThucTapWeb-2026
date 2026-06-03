package model;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import util.ConfigUtil;

public class FacebookConstants {
    public static final String FACEBOOK_APP_ID = ConfigUtil.get("FACEBOOK_APP_ID");
    public static final String FACEBOOK_APP_SECRET = ConfigUtil.get("FACEBOOK_APP_SECRET");
    public static final String FACEBOOK_REDIRECT_URL = ConfigUtil.get("FACEBOOK_REDIRECT_URL");
    public static final String FACEBOOK_API_VERSION = ConfigUtil.getOrDefault("FACEBOOK_API_VERSION", "v19.0");

    // url login FB
    public static final String FACEBOOK_LOGIN_URL = "https://www.facebook.com/" + FACEBOOK_API_VERSION
            + "/dialog/oauth?client_id=" + urlEncode(FACEBOOK_APP_ID)
            + "&redirect_uri=" + urlEncode(FACEBOOK_REDIRECT_URL)
            + "&scope=email,public_profile";

    private static String urlEncode(String value) {
        return URLEncoder.encode(value == null ? "" : value, StandardCharsets.UTF_8);
    }
}

