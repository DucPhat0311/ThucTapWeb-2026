package controller.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.User;
import service.UserService;
import util.AvatarStorageUtil;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.time.format.DateTimeFormatter;
import java.util.Locale;
import java.util.Set;

@WebServlet("/profile")
@MultipartConfig(
        maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 6 * 1024 * 1024
)
public class ProfileController extends HttpServlet {

    private static final String DEFAULT_REDIRECT = "profile";
    private static final long MAX_AVATAR_SIZE = 5 * 1024 * 1024;
    private static final String AVATAR_MEDIA_PREFIX = AvatarStorageUtil.AVATAR_MEDIA_PREFIX;
    private static final Set<String> AVATAR_REDIRECT_TARGETS = Set.of(
            "profile",
            "address",
            "order-user",
            "change-password"
    );

    private UserService userService;

    @Override
    public void init() {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userlogin") == null) {
            response.sendRedirect("login");
            return;
        }

        User user = (User) session.getAttribute("userlogin");

        User fullUser = userService.findById(user.getId());

        request.setAttribute("user", fullUser);

        if (fullUser.getBirthday() != null) {
            request.setAttribute(
                    "birthdayDate",
                    java.sql.Date.valueOf(fullUser.getBirthday())
            );
        }


        if (fullUser.getCreatedAt() != null) {
            DateTimeFormatter formatter =
                    DateTimeFormatter.ofPattern("dd/MM/yyyy");

            request.setAttribute(
                    "createdAtFormatted",
                    fullUser.getCreatedAt().format(formatter)
            );
        }


        request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userlogin") == null) {
            response.sendRedirect("login");
            return;
        }


        User userSession = (User) session.getAttribute("userlogin");
        String action = request.getParameter("action");

        if ("updateAvatar".equals(action)) {
            try {
                handleAvatarUpdate(request, response, session, userSession);
            } catch (IOException | ServletException ex) {
                response.sendRedirect(DEFAULT_REDIRECT + "?avatarError=upload");
            }
            return;
        }

        handleProfileUpdate(request, response, session, userSession);
    }

    private void handleProfileUpdate(HttpServletRequest request,
                                     HttpServletResponse response,
                                     HttpSession session,
                                     User userSession) throws IOException {
        String fullName = request.getParameter("fullname");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String birthdayStr = request.getParameter("birthday");
        String address = request.getParameter("address");

        String gender = request.getParameter("gender");

        User user = userService.findById(userSession.getId());

        user.setFullName(fullName);
        user.setPhone(phone);
        user.setEmail(email);
        user.setAddress(address);


        user.setGender(gender);

        if (birthdayStr == null || birthdayStr.isBlank()) {
            user.setBirthday(null);
        } else {
            try {
                user.setBirthday(LocalDate.parse(birthdayStr));
            } catch (DateTimeParseException ex) {
                response.sendRedirect(DEFAULT_REDIRECT + "?profileError=invalid_birthday");
                return;
            }
        }

        userService.update(user);
        User refreshedUser = userService.findById(userSession.getId());
        session.setAttribute("userlogin", refreshedUser);

        response.sendRedirect(DEFAULT_REDIRECT + "?profileUpdated=1");
    }

    private void handleAvatarUpdate(HttpServletRequest request,
                                    HttpServletResponse response,
                                    HttpSession session,
                                    User userSession) throws ServletException, IOException {
        String redirectTarget = resolveAvatarRedirectTarget(request);
        Part avatarPart = request.getPart("avatarFile");
        if (avatarPart == null || avatarPart.getSize() == 0) {
            response.sendRedirect(redirectTarget + "?avatarError=empty");
            return;
        }

        if (avatarPart.getSize() > MAX_AVATAR_SIZE) {
            response.sendRedirect(redirectTarget + "?avatarError=size");
            return;
        }

        String extension = extractExtension(avatarPart.getSubmittedFileName());
        if (!isAllowedExtension(extension) || !isImageContentType(avatarPart.getContentType())) {
            response.sendRedirect(redirectTarget + "?avatarError=type");
            return;
        }

        User currentUser = userService.findById(userSession.getId());
        String oldAvatarUrl = currentUser != null ? currentUser.getAvatarUrl() : null;

        String avatarUrl = saveAvatarFile(userSession.getId(), avatarPart, extension);
        userService.updateAvatar(userSession.getId(), avatarUrl);
        deleteManagedAvatar(oldAvatarUrl, avatarUrl);

        User refreshedUser = userService.findById(userSession.getId());
        session.setAttribute("userlogin", refreshedUser);

        response.sendRedirect(redirectTarget + "?avatarUpdated=1");
    }

    private String saveAvatarFile(int userId, Part avatarPart, String extension) throws IOException {
        Path avatarDir = AvatarStorageUtil.getAvatarDirectory();

        String uniqueFileName = "avatar_user_" + userId + "_" + System.currentTimeMillis() + "." + extension;
        uniqueFileName = uniqueFileName.replaceAll("[^a-zA-Z0-9._-]", "_");

        Path destinationPath = avatarDir.resolve(uniqueFileName).normalize();
        if (!destinationPath.startsWith(avatarDir)) {
            throw new IOException("Invalid avatar destination path.");
        }

        try (InputStream inputStream = avatarPart.getInputStream()) {
            Files.copy(inputStream, destinationPath, StandardCopyOption.REPLACE_EXISTING);
        }

        return AvatarStorageUtil.buildAvatarMediaPath(uniqueFileName);
    }

    private String extractExtension(String fileName) {
        if (fileName == null || fileName.isBlank()) {
            return "";
        }

        String safeName = new File(fileName).getName();
        int lastDot = safeName.lastIndexOf('.');
        if (lastDot < 0 || lastDot == safeName.length() - 1) {
            return "";
        }

        return safeName.substring(lastDot + 1).toLowerCase(Locale.ROOT);
    }

    private boolean isAllowedExtension(String extension) {
        return "jpg".equals(extension)
                || "jpeg".equals(extension)
                || "png".equals(extension)
                || "webp".equals(extension);
    }

    private boolean isImageContentType(String contentType) {
        return contentType != null && contentType.toLowerCase(Locale.ROOT).startsWith("image/");
    }

    private void deleteManagedAvatar(String oldAvatarUrl, String newAvatarUrl) {
        if (!isManagedAvatarPath(oldAvatarUrl) || oldAvatarUrl.equals(newAvatarUrl)) {
            return;
        }

        String oldFileName = oldAvatarUrl.substring(AVATAR_MEDIA_PREFIX.length());
        if (oldFileName.isBlank()) {
            return;
        }

        try {
            Path avatarDir = AvatarStorageUtil.getAvatarDirectory();
            Path oldFilePath = avatarDir.resolve(oldFileName).normalize();
            if (oldFilePath.startsWith(avatarDir)) {
                Files.deleteIfExists(oldFilePath);
            }
        } catch (IOException ignored) {
        }
    }

    private boolean isManagedAvatarPath(String avatarUrl) {
        return avatarUrl != null && avatarUrl.startsWith(AVATAR_MEDIA_PREFIX);
    }

    private String resolveAvatarRedirectTarget(HttpServletRequest request) {
        String redirectTo = request.getParameter("redirectTo");
        if (redirectTo == null || redirectTo.isBlank()) {
            return DEFAULT_REDIRECT;
        }

        String normalized = redirectTo.trim();
        if (normalized.startsWith("/")) {
            normalized = normalized.substring(1);
        }

        if (AVATAR_REDIRECT_TARGETS.contains(normalized)) {
            return normalized;
        }

        return DEFAULT_REDIRECT;
    }
}
