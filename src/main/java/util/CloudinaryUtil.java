package util;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;
import java.util.Map;

public final class CloudinaryUtil {

    private static final Cloudinary CLOUDINARY = new Cloudinary(ObjectUtils.asMap(
            "cloud_name", "dp8ttx3jh",
            "api_key", "732752992924324",
            "api_secret", "TB0aEDEQh8kS-tMpBbqSAo2Oh7c"));

    private CloudinaryUtil() {
    }

    public static String uploadImage(Part filePart, String folder) throws IOException {
        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }

        try (InputStream inputStream = filePart.getInputStream()) {
            byte[] fileBytes = inputStream.readAllBytes();
            Map<?, ?> result = CLOUDINARY.uploader().upload(
                    fileBytes,
                    ObjectUtils.asMap(
                            "folder", "shopquanao/" + folder,
                            "resource_type", "image"));
            return (String) result.get("secure_url");
        }
    }

    public static String uploadImage(InputStream inputStream, String folder) throws IOException {
        byte[] fileBytes = inputStream.readAllBytes();
        Map<?, ?> result = CLOUDINARY.uploader().upload(
                fileBytes,
                ObjectUtils.asMap(
                        "folder", "shopquanao/" + folder,
                        "resource_type", "image"));
        return (String) result.get("secure_url");
    }

    public static void deleteImage(String publicId) throws IOException {
        if (publicId == null || publicId.isBlank())
            return;
        CLOUDINARY.uploader().destroy(publicId, ObjectUtils.emptyMap());
    }
}
