package controller.web;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.AvatarStorageUtil;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Locale;

@WebServlet("/media/avatar/*")
public class AvatarMediaController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String fileName = extractSafeFileName(request.getPathInfo());
        if (fileName == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        Path avatarDir;
        try {
            avatarDir = AvatarStorageUtil.getAvatarDirectory();
        } catch (IOException ex) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            return;
        }

        Path avatarFile = avatarDir.resolve(fileName).normalize();
        if (!avatarFile.startsWith(avatarDir) || !Files.isRegularFile(avatarFile)) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        response.setContentType(resolveContentType(avatarFile));
        response.setHeader("Cache-Control", "public, max-age=86400");
        response.setContentLengthLong(Files.size(avatarFile));

        try (InputStream inputStream = Files.newInputStream(avatarFile);
             OutputStream outputStream = response.getOutputStream()) {
            inputStream.transferTo(outputStream);
        }
    }

    private String extractSafeFileName(String pathInfo) {
        if (pathInfo == null || pathInfo.isBlank() || "/".equals(pathInfo)) {
            return null;
        }

        String normalized = pathInfo.startsWith("/") ? pathInfo.substring(1) : pathInfo;
        if (normalized.isBlank()) {
            return null;
        }

        if (normalized.contains("/") || normalized.contains("\\") || normalized.contains("..")) {
            return null;
        }

        return normalized;
    }

    private String resolveContentType(Path filePath) throws IOException {
        String contentType = Files.probeContentType(filePath);
        if (contentType != null && !contentType.isBlank()) {
            return contentType;
        }

        String fileName = filePath.getFileName().toString().toLowerCase(Locale.ROOT);
        if (fileName.endsWith(".png")) {
            return "image/png";
        }
        if (fileName.endsWith(".webp")) {
            return "image/webp";
        }
        return "image/jpeg";
    }
}
