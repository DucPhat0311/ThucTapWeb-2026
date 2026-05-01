package service;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.text.Normalizer;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Properties;
import java.util.TreeMap;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

public class VnPayService {
    private static final String DEFAULT_VERSION = "2.1.0";
    private static final String DEFAULT_COMMAND = "pay";
    private static final String DEFAULT_ORDER_TYPE = "other";
    private static final String DEFAULT_LOCALE = "vn";
    private static final String DEFAULT_CURRENCY = "VND";
    private static final ZoneId VIETNAM_ZONE = ZoneId.of("Asia/Ho_Chi_Minh");
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");

    private final String tmnCode;
    private final String hashSecret;
    private final String payUrl;
    private final String returnUrl;
    private final String version;
    private final String command;
    private final String defaultOrderType;

    public VnPayService() {
        Properties props = loadConfig();
        this.tmnCode = readConfig("VNPAY_TMN_CODE", "vnpay.tmn_code", props);
        this.hashSecret = readConfig("VNPAY_HASH_SECRET", "vnpay.hash_secret", props);
        this.payUrl = readConfig("VNPAY_PAY_URL", "vnpay.pay_url", props);
        this.returnUrl = readConfig("VNPAY_RETURN_URL", "vnpay.return_url", props);
        this.version = readConfigOrDefault("VNPAY_VERSION", "vnpay.version", props, DEFAULT_VERSION);
        this.command = readConfigOrDefault("VNPAY_COMMAND", "vnpay.command", props, DEFAULT_COMMAND);
        this.defaultOrderType = readConfigOrDefault("VNPAY_ORDER_TYPE", "vnpay.order_type", props, DEFAULT_ORDER_TYPE);
    }

    public boolean isConfigured() {
        return !tmnCode.isBlank() && !hashSecret.isBlank() && !payUrl.isBlank() && !returnUrl.isBlank();
    }

    public String buildPaymentUrl(PaymentRequest request) {
        ensureConfigured();

        Map<String, String> params = new TreeMap<>();
        params.put("vnp_Version", version);
        params.put("vnp_Command", command);
        params.put("vnp_TmnCode", tmnCode);
        params.put("vnp_Amount", formatAmount(request.amount()));
        params.put("vnp_CurrCode", DEFAULT_CURRENCY);
        params.put("vnp_TxnRef", requireNotBlank(request.txnRef(), "Mã giao dịch VNPay"));
        params.put("vnp_OrderInfo", sanitizeOrderInfo(request.orderInfo()));
        params.put("vnp_OrderType", firstNonBlank(request.orderType(), defaultOrderType));
        params.put("vnp_ReturnUrl", returnUrl);
        params.put("vnp_IpAddr", firstNonBlank(request.ipAddress(), "127.0.0.1"));
        params.put("vnp_CreateDate", formatDate(LocalDateTime.now(VIETNAM_ZONE)));
        params.put("vnp_ExpireDate", formatDate(LocalDateTime.now(VIETNAM_ZONE).plusMinutes(15)));
        params.put("vnp_Locale", firstNonBlank(request.locale(), DEFAULT_LOCALE));

        if (!trimToEmpty(request.bankCode()).isBlank()) {
            params.put("vnp_BankCode", request.bankCode().trim());
        }

        String queryString = buildQueryString(params);
        String secureHash = hmacSha512(hashSecret, queryString);
        return payUrl + "?" + queryString + "&vnp_SecureHash=" + secureHash;
    }

    public boolean verifySignature(Map<String, String> responseParams) {
        ensureConfigured();
        if (responseParams == null || responseParams.isEmpty()) {
            return false;
        }

        String receivedHash = trimToEmpty(responseParams.get("vnp_SecureHash"));
        if (receivedHash.isBlank()) {
            return false;
        }

        Map<String, String> signParams = new TreeMap<>();
        for (Map.Entry<String, String> entry : responseParams.entrySet()) {
            String key = entry.getKey();
            String value = entry.getValue();

            if (key == null || value == null) {
                continue;
            }
            if ("vnp_SecureHash".equals(key) || "vnp_SecureHashType".equals(key)) {
                continue;
            }
            signParams.put(key, value);
        }

        String signData = buildQueryString(signParams);
        String expectedHash = hmacSha512(hashSecret, signData);
        return expectedHash.equalsIgnoreCase(receivedHash);
    }

    public Map<String, String> extractVnPayParams(Map<String, String[]> parameterMap) {
        Map<String, String> params = new LinkedHashMap<>();
        if (parameterMap == null || parameterMap.isEmpty()) {
            return params;
        }

        for (Map.Entry<String, String[]> entry : parameterMap.entrySet()) {
            String key = entry.getKey();
            if (key == null || !key.startsWith("vnp_")) {
                continue;
            }

            String[] values = entry.getValue();
            if (values == null || values.length == 0 || values[0] == null) {
                continue;
            }
            params.put(key, values[0]);
        }
        return params;
    }

    private void ensureConfigured() {
        if (isConfigured()) {
            return;
        }
        throw new IllegalStateException("Thiếu cấu hình VNPay. Hãy khai báo vnpay.properties hoặc biến môi trường VNPay.");
    }

    private String formatAmount(double amount) {
        BigDecimal normalizedAmount = BigDecimal.valueOf(amount)
                .movePointRight(2)
                .setScale(0, RoundingMode.HALF_UP);
        return normalizedAmount.toPlainString();
    }

    private String sanitizeOrderInfo(String orderInfo) {
        String normalized = Normalizer.normalize(firstNonBlank(orderInfo, "Thanh toan don hang"), Normalizer.Form.NFD)
                .replaceAll("\\p{M}+", "");
        String compact = normalized.replaceAll("[^A-Za-z0-9 .,:_-]", " ").replaceAll("\\s+", " ").trim();
        return compact.isBlank() ? "Thanh toan don hang" : compact;
    }

    private String formatDate(LocalDateTime dateTime) {
        return dateTime.format(DATE_FORMATTER);
    }

    private String buildQueryString(Map<String, String> params) {
        StringBuilder builder = new StringBuilder();
        boolean first = true;

        for (Map.Entry<String, String> entry : params.entrySet()) {
            if (!first) {
                builder.append('&');
            }
            builder.append(urlEncode(entry.getKey()))
                    .append('=')
                    .append(urlEncode(entry.getValue()));
            first = false;
        }

        return builder.toString();
    }

    private String hmacSha512(String secretKey, String data) {
        try {
            Mac hmac = Mac.getInstance("HmacSHA512");
            SecretKeySpec keySpec = new SecretKeySpec(secretKey.getBytes(StandardCharsets.UTF_8), "HmacSHA512");
            hmac.init(keySpec);
            byte[] hashBytes = hmac.doFinal(data.getBytes(StandardCharsets.UTF_8));

            StringBuilder builder = new StringBuilder(hashBytes.length * 2);
            for (byte hashByte : hashBytes) {
                builder.append(String.format("%02x", hashByte));
            }
            return builder.toString();
        } catch (NoSuchAlgorithmException | InvalidKeyException e) {
            throw new IllegalStateException("Không thể tạo chữ ký VNPay", e);
        }
    }

    private static Properties loadConfig() {
        Properties props = new Properties();
        try (var input = VnPayService.class.getClassLoader().getResourceAsStream("vnpay.properties")) {
            if (input != null) {
                props.load(input);
            }
        } catch (IOException ignored) {
        }
        return props;
    }

    private static String readConfig(String envName, String propName, Properties props) {
        String env = System.getenv(envName);
        if (env != null && !env.isBlank()) {
            return env.trim();
        }

        String value = props.getProperty(propName);
        return value == null ? "" : value.trim();
    }

    private static String readConfigOrDefault(String envName, String propName, Properties props, String defaultValue) {
        String value = readConfig(envName, propName, props);
        return value.isBlank() ? defaultValue : value;
    }

    private static String requireNotBlank(String value, String fieldName) {
        String normalized = trimToEmpty(value);
        if (normalized.isBlank()) {
            throw new IllegalArgumentException(fieldName + " không được để trống.");
        }
        return normalized;
    }

    private static String firstNonBlank(String first, String fallback) {
        return trimToEmpty(first).isBlank() ? fallback : first.trim();
    }

    private static String trimToEmpty(String value) {
        return value == null ? "" : value.trim();
    }

    private static String urlEncode(String value) {
        return URLEncoder.encode(value, StandardCharsets.UTF_8);
    }

    public record PaymentRequest(
            String txnRef,
            double amount,
            String orderInfo,
            String ipAddress,
            String orderType,
            String locale,
            String bankCode
    ) {
    }
}
