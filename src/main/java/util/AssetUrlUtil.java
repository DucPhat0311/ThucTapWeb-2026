package util;

public final class AssetUrlUtil {
    private AssetUrlUtil() {
    }

    public static String resolve(String contextPath, String basePath, String storedPath, String fallbackPath) {
        String path = firstNonBlank(storedPath, fallbackPath);
        if (path.isBlank()) {
            return "";
        }

        if (isAbsoluteUrl(path)) {
            return path;
        }

        String normalizedPath = normalizeSlashes(path);
        String normalizedContext = normalizeContextPath(contextPath);

        if (startsWithPath(normalizedPath, "img")) {
            return joinPath(normalizedContext, normalizedPath.startsWith("/") ? normalizedPath : "/" + normalizedPath);
        }

        String normalizedBase = normalizeBasePath(basePath);
        if (normalizedBase.isBlank()) {
            return joinPath(normalizedContext, normalizedPath.startsWith("/") ? normalizedPath : "/" + normalizedPath);
        }

        String relativePath = normalizedPath.startsWith("/") ? normalizedPath : "/" + normalizedPath;
        return joinPath(normalizedContext, normalizedBase + relativePath);
    }

    private static String firstNonBlank(String value, String fallback) {
        if (value != null && !value.trim().isBlank()) {
            return value.trim();
        }
        if (fallback != null && !fallback.trim().isBlank()) {
            return fallback.trim();
        }
        return "";
    }

    private static boolean isAbsoluteUrl(String path) {
        String lower = path.toLowerCase();
        return lower.startsWith("http://") || lower.startsWith("https://");
    }

    private static boolean startsWithPath(String path, String segment) {
        String noLeadingSlash = path.startsWith("/") ? path.substring(1) : path;
        return noLeadingSlash.equals(segment) || noLeadingSlash.startsWith(segment + "/");
    }

    private static String normalizeContextPath(String contextPath) {
        if (contextPath == null || contextPath.isBlank() || "/".equals(contextPath.trim())) {
            return "";
        }
        String normalized = normalizeSlashes(contextPath.trim());
        return normalized.startsWith("/") ? normalized : "/" + normalized;
    }

    private static String normalizeBasePath(String basePath) {
        if (basePath == null || basePath.trim().isBlank() || "/".equals(basePath.trim())) {
            return "";
        }
        String normalized = normalizeSlashes(basePath.trim());
        if (!normalized.startsWith("/")) {
            normalized = "/" + normalized;
        }
        while (normalized.endsWith("/") && normalized.length() > 1) {
            normalized = normalized.substring(0, normalized.length() - 1);
        }
        return normalized;
    }

    private static String normalizeSlashes(String value) {
        return value.replace('\\', '/').replaceAll("/{2,}", "/");
    }

    private static String joinPath(String contextPath, String path) {
        if (path == null || path.isBlank()) {
            return contextPath;
        }
        String normalizedPath = path.startsWith("/") ? path : "/" + path;
        return contextPath + normalizedPath;
    }
}
