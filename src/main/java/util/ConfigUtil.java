package util;

import java.io.IOException;
import java.util.Properties;

public final class ConfigUtil {
    private static final Properties LOCAL_PROPS = loadLocalProperties();

    private ConfigUtil() {
    }

    public static String get(String name) {
        String envValue = System.getenv(name);
        if (envValue != null && !envValue.isBlank()) {
            return envValue.trim();
        }

        String localValue = LOCAL_PROPS.getProperty(name);
        return localValue == null ? "" : localValue.trim();
    }

    public static String getOrDefault(String name, String defaultValue) {
        String value = get(name);
        return value.isBlank() ? defaultValue : value;
    }

    public static String getRequired(String name) {
        String value = get(name);
        if (value.isBlank()) {
            throw new IllegalStateException("Missing required configuration: " + name);
        }
        return value;
    }

    private static Properties loadLocalProperties() {
        Properties props = new Properties();
        try (var input = ConfigUtil.class.getClassLoader().getResourceAsStream("local.properties")) {
            if (input != null) {
                props.load(input);
            }
        } catch (IOException ignored) {
        }
        return props;
    }
}
