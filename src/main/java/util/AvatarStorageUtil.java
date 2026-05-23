package util;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

public final class AvatarStorageUtil {

    public static final String AVATAR_MEDIA_PREFIX = "media/avatar/";
    private static final String BASE_DIR_SYSTEM_PROPERTY = "shop.upload.base-dir";
    private static final String BASE_DIR_ENV = "SHOP_UPLOAD_BASE_DIR";
    private static final String DEFAULT_BASE_DIR_NAME = "ShopQuanAoUploads";
    private static final String AVATAR_SUB_DIR = "avatar";

    private AvatarStorageUtil() {
    }

    public static Path getAvatarDirectory() throws IOException {
        Path avatarDir = resolveBaseDirectory().resolve(AVATAR_SUB_DIR).toAbsolutePath().normalize();
        Files.createDirectories(avatarDir);
        return avatarDir;
    }

    public static String buildAvatarMediaPath(String fileName) {
        return AVATAR_MEDIA_PREFIX + fileName;
    }

    private static Path resolveBaseDirectory() {
        String configured = System.getProperty(BASE_DIR_SYSTEM_PROPERTY);
        if (configured == null || configured.isBlank()) {
            configured = System.getenv(BASE_DIR_ENV);
        }

        Path baseDir;
        if (configured != null && !configured.isBlank()) {
            baseDir = Paths.get(configured.trim());
        } else {
            String userHome = System.getProperty("user.home");
            baseDir = Paths.get(userHome, DEFAULT_BASE_DIR_NAME);
        }

        return baseDir.toAbsolutePath().normalize();
    }
}
