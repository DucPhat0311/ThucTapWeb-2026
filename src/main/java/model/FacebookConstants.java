package model;

public class FacebookConstants {
    public static final String FACEBOOK_APP_ID = System.getenv("FACEBOOK_APP_ID");
    public static final String FACEBOOK_APP_SECRET = System.getenv("FACEBOOK_APP_SECRET");
    public static final String FACEBOOK_REDIRECT_URL = "http://localhost:8080/ShopQuanAo_war_exploded/auth/facebook";

    // url login FB
    public static final String FACEBOOK_LOGIN_URL = "https://www.facebook.com/v19.0/dialog/oauth?client_id="
            + FACEBOOK_APP_ID
            + "&redirect_uri=" + FACEBOOK_REDIRECT_URL
            + "&scope=email,public_profile";
}

