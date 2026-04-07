package service;

import model.GoogleUserInfo;

import java.io.IOException;
import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class GoogleOAuthService {

    private static final String GOOGLE_AUTH_ENDPOINT = "https://accounts.google.com/o/oauth2/v2/auth";
    private static final String GOOGLE_TOKEN_ENDPOINT = "https://oauth2.googleapis.com/token";
    private static final String GOOGLE_TOKEN_INFO_ENDPOINT = "https://oauth2.googleapis.com/tokeninfo";

    private final HttpClient httpClient = HttpClient.newHttpClient();
    private final String clientId;
    private final String clientSecret;

    public GoogleOAuthService() {
        Properties props = loadGoogleConfig();
        this.clientId = readConfig("GOOGLE_CLIENT_ID", "google.client.id", props);
        this.clientSecret = readConfig("GOOGLE_CLIENT_SECRET", "google.client.secret", props);
    }

    public boolean isConfigured() {
        return !clientId.isBlank() && !clientSecret.isBlank();
    }

    public String buildAuthorizationUrl(String state, String redirectUri) {
        ensureConfigured();

        return GOOGLE_AUTH_ENDPOINT +
                "?client_id=" + urlEncode(clientId) +
                "&redirect_uri=" + urlEncode(redirectUri) +
                "&response_type=code" +
                "&scope=" + urlEncode("openid email profile") +
                "&access_type=online" +
                "&prompt=select_account" +
                "&state=" + urlEncode(state);
    }

    public GoogleUserInfo getUserInfoFromAuthorizationCode(String code, String redirectUri) {
        ensureConfigured();
        TokenPair tokenPair = exchangeCodeForToken(code, redirectUri);
        return verifyIdTokenAndExtractUser(tokenPair.idToken());
    }

    private TokenPair exchangeCodeForToken(String code, String redirectUri) {
        String form = "code=" + urlEncode(code) +
                "&client_id=" + urlEncode(clientId) +
                "&client_secret=" + urlEncode(clientSecret) +
                "&redirect_uri=" + urlEncode(redirectUri) +
                "&grant_type=authorization_code";

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(GOOGLE_TOKEN_ENDPOINT))
                .header("Content-Type", "application/x-www-form-urlencoded")
                .POST(HttpRequest.BodyPublishers.ofString(form))
                .build();

        try {
            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
            Map<String, String> data = parseFlatJson(response.body());

            if (response.statusCode() != 200) {
                throw new RuntimeException("Không thể lấy token từ Google: " + firstNonBlank(data.get("error_description"), data.get("error"), "unknown"));
            }

            String idToken = data.get("id_token");
            if (idToken == null || idToken.isBlank()) {
                throw new RuntimeException("Google không trả về id_token");
            }

            String accessToken = data.get("access_token");
            return new TokenPair(accessToken, idToken);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new RuntimeException("Lỗi khi kết nối Google OAuth", e);
        } catch (IOException e) {
            throw new RuntimeException("Lỗi khi kết nối Google OAuth", e);
        }
    }

    private GoogleUserInfo verifyIdTokenAndExtractUser(String idToken) {
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(GOOGLE_TOKEN_INFO_ENDPOINT + "?id_token=" + urlEncode(idToken)))
                .GET()
                .build();

        try {
            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
            Map<String, String> claims = parseFlatJson(response.body());

            if (response.statusCode() != 200) {
                throw new RuntimeException("id_token không hợp lệ");
            }

            String aud = claims.get("aud");
            if (!clientId.equals(aud)) {
                throw new RuntimeException("id_token không đúng client_id");
            }

            String exp = claims.get("exp");
            if (exp != null && !exp.isBlank()) {
                long expiredAt = Long.parseLong(exp);
                if (Instant.now().getEpochSecond() >= expiredAt) {
                    throw new RuntimeException("id_token đã hết hạn");
                }
            }

            GoogleUserInfo userInfo = new GoogleUserInfo();
            userInfo.setSub(claims.get("sub"));
            userInfo.setEmail(claims.get("email"));
            userInfo.setEmailVerified(parseBoolean(claims.get("email_verified")));
            userInfo.setName(firstNonBlank(claims.get("name"), extractNameFromEmail(claims.get("email")), "Google User"));
            userInfo.setPicture(claims.get("picture"));

            if (userInfo.getSub() == null || userInfo.getSub().isBlank()) {
                throw new RuntimeException("Không đọc được sub từ Google");
            }
            if (userInfo.getEmail() == null || userInfo.getEmail().isBlank()) {
                throw new RuntimeException("Không đọc được email từ Google");
            }

            return userInfo;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new RuntimeException("Lỗi khi xác thực id_token", e);
        } catch (IOException e) {
            throw new RuntimeException("Lỗi khi xác thực id_token", e);
        }
    }

    private static String readConfig(String envName, String propName, Properties props) {
        String env = System.getenv(envName);
        if (env != null && !env.isBlank()) return env.trim();

        String propValue = props.getProperty(propName);
        return propValue == null ? "" : propValue.trim();
    }

    private static Properties loadGoogleConfig() {
        Properties props = new Properties();
        try (var input = GoogleOAuthService.class.getClassLoader().getResourceAsStream("google-oauth.properties")) {
            if (input != null) {
                props.load(input);
            }
        } catch (IOException ignored) {
        }
        return props;
    }

    private void ensureConfigured() {
        if (isConfigured()) return;

        throw new RuntimeException("Thiếu cấu hình Google OAuth. Hãy khai báo GOOGLE_CLIENT_ID và GOOGLE_CLIENT_SECRET (hoặc file google-oauth.properties).");
    }

    private static String urlEncode(String value) {
        return URLEncoder.encode(value, StandardCharsets.UTF_8);
    }

    private static boolean parseBoolean(String value) {
        if (value == null) return false;
        return "true".equalsIgnoreCase(value) || "1".equals(value);
    }

    private static String extractNameFromEmail(String email) {
        if (email == null) return null;
        int idx = email.indexOf('@');
        return idx > 0 ? email.substring(0, idx) : email;
    }

    private static String firstNonBlank(String... values) {
        for (String value : values) {
            if (value != null && !value.isBlank()) return value;
        }
        return "";
    }

    private static Map<String, String> parseFlatJson(String json) {
        Map<String, String> result = new HashMap<>();
        if (json == null || json.isBlank()) return result;

        Pattern pattern = Pattern.compile("\"([^\"]+)\"\\s*:\\s*(\"((?:\\\\.|[^\"])*)\"|true|false|null|-?\\d+(?:\\.\\d+)?)");
        Matcher matcher = pattern.matcher(json);

        while (matcher.find()) {
            String key = matcher.group(1);
            String rawValue = matcher.group(2);
            if (rawValue == null) continue;

            if (rawValue.startsWith("\"") && rawValue.endsWith("\"")) {
                String value = rawValue.substring(1, rawValue.length() - 1);
                result.put(key, unescapeJson(value));
            } else if (!"null".equals(rawValue)) {
                result.put(key, rawValue);
            }
        }

        return result;
    }

    private static String unescapeJson(String value) {
        StringBuilder sb = new StringBuilder(value.length());
        for (int i = 0; i < value.length(); i++) {
            char ch = value.charAt(i);
            if (ch != '\\') {
                sb.append(ch);
                continue;
            }

            if (i + 1 >= value.length()) {
                sb.append(ch);
                continue;
            }

            char next = value.charAt(++i);
            switch (next) {
                case '"' -> sb.append('"');
                case '\\' -> sb.append('\\');
                case '/' -> sb.append('/');
                case 'b' -> sb.append('\b');
                case 'f' -> sb.append('\f');
                case 'n' -> sb.append('\n');
                case 'r' -> sb.append('\r');
                case 't' -> sb.append('\t');
                case 'u' -> {
                    if (i + 4 < value.length()) {
                        String hex = value.substring(i + 1, i + 5);
                        try {
                            sb.append((char) Integer.parseInt(hex, 16));
                            i += 4;
                        } catch (NumberFormatException e) {
                            sb.append("\\u").append(hex);
                            i += 4;
                        }
                    } else {
                        sb.append("\\u");
                    }
                }
                default -> sb.append(next);
            }
        }
        return sb.toString();
    }

    private record TokenPair(String accessToken, String idToken) {
    }
}