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
import util.CloudinaryUtil;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.Serializable;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.time.LocalDate;
import java.time.LocalDateTime;
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
    private static final String PENDING_EMAIL_CHANGE_ATTR = "pendingProfileEmailChange";
    private static final String PROFILE_FLASH_ERROR_ATTR = "profileFlashError";
    private static final long MAX_AVATAR_SIZE = 5 * 1024 * 1024;
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
        moveFlashMessages(session, request);

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

        String gender = request.getParameter("gender");

        User user = userService.findById(userSession.getId());
        String normalizedPhone = normalizePhone(phone);
        if (!isValidVietnamesePhone(normalizedPhone)) {
            response.sendRedirect(DEFAULT_REDIRECT + "?profileError=invalid_phone");
            return;
        }

        LocalDate birthday = null;
        if (birthdayStr == null || birthdayStr.isBlank()) {
            birthday = null;
        } else {
            try {
                birthday = LocalDate.parse(birthdayStr);
            } catch (DateTimeParseException ex) {
                response.sendRedirect(DEFAULT_REDIRECT + "?profileError=invalid_birthday");
                return;
            }
        }

        String normalizedEmail = normalizeEmail(email);
        if (normalizedEmail.isBlank()) {
            response.sendRedirect(DEFAULT_REDIRECT + "?profileError=invalid_email");
            return;
        }

        if (isEmailChanged(user.getEmail(), normalizedEmail)) {
            try {
                var verification = userService.createProfileEmailChangeOldEmailVerification(
                        user.getId(),
                        user.getEmail(),
                        normalizedEmail
                );
                session.setAttribute(PENDING_EMAIL_CHANGE_ATTR, new PendingProfileEmailChange(
                        fullName,
                        normalizedPhone,
                        verification.newEmail(),
                        birthday,
                        gender,
                        verification.oldEmailOtp(),
                        verification.oldEmailOtpExpiredAt(),
                        null,
                        null
                ));
                response.sendRedirect("profile-email-change");
            } catch (RuntimeException e) {
                session.setAttribute(PROFILE_FLASH_ERROR_ATTR, e.getMessage());
                response.sendRedirect(DEFAULT_REDIRECT + "?profileError=email_change_failed");
            }
            return;
        }

        user.setFullName(fullName);
        user.setPhone(normalizedPhone);
        user.setEmail(normalizedEmail);
        user.setGender(gender);
        user.setBirthday(birthday);

        userService.update(user);
        User refreshedUser = userService.findById(userSession.getId());
        session.setAttribute("userlogin", refreshedUser);

        response.sendRedirect(DEFAULT_REDIRECT + "?profileUpdated=1");
    }

    private void moveFlashMessages(HttpSession session, HttpServletRequest request) {
        Object profileFlashError = session.getAttribute(PROFILE_FLASH_ERROR_ATTR);
        if (profileFlashError != null) {
            request.setAttribute("profileFlashError", profileFlashError);
            session.removeAttribute(PROFILE_FLASH_ERROR_ATTR);
        }
    }

    private String normalizeEmail(String email) {
        return email == null ? "" : email.trim().toLowerCase(Locale.ROOT);
    }

    private boolean isEmailChanged(String currentEmail, String submittedEmail) {
        return !normalizeEmail(currentEmail).equals(submittedEmail);
    }

    private String normalizePhone(String phone) {
        if (phone == null) {
            return "";
        }
        return phone.trim().replaceAll("[\\s.-]", "");
    }

    private boolean isValidVietnamesePhone(String phone) {
        if (phone.isBlank()) {
            return true;
        }
        return phone.matches("0[35789][0-9]{8}");
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

        String avatarUrl = CloudinaryUtil.uploadImage(avatarPart, "avatars");
        if (avatarUrl != null) {
            userService.updateAvatar(userSession.getId(), avatarUrl);
            deleteManagedAvatar(oldAvatarUrl, avatarUrl);
        }

        User refreshedUser = userService.findById(userSession.getId());
        session.setAttribute("userlogin", refreshedUser);

        response.sendRedirect(redirectTarget + "?avatarUpdated=1");
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

        try {
            int uploadIndex = oldAvatarUrl.indexOf("/upload/");
            if (uploadIndex != -1) {
                String pathAfterUpload = oldAvatarUrl.substring(uploadIndex + 8);
                
                int versionSlashIndex = pathAfterUpload.indexOf('/');
                if (versionSlashIndex != -1) {
                    String publicIdWithExt = pathAfterUpload.substring(versionSlashIndex + 1);
                    int lastDotIndex = publicIdWithExt.lastIndexOf('.');
                    String publicId = lastDotIndex != -1 ? publicIdWithExt.substring(0, lastDotIndex) : publicIdWithExt;
                    CloudinaryUtil.deleteImage(publicId);
                }
            }
        } catch (IOException ignored) {
        }
    }

    private boolean isManagedAvatarPath(String avatarUrl) {
        return avatarUrl != null && avatarUrl.contains("cloudinary.com");
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

    public record PendingProfileEmailChange(
            String fullName,
            String phone,
            String newEmail,
            LocalDate birthday,
            String gender,
            String oldEmailOtp,
            LocalDateTime oldEmailOtpExpiredAt,
            String newEmailOtp,
            LocalDateTime newEmailOtpExpiredAt
    ) implements Serializable {
        public PendingProfileEmailChange withNewEmailVerification(String newEmailOtp,
                                                                  LocalDateTime newEmailOtpExpiredAt) {
            return new PendingProfileEmailChange(
                    fullName,
                    phone,
                    newEmail,
                    birthday,
                    gender,
                    oldEmailOtp,
                    oldEmailOtpExpiredAt,
                    newEmailOtp,
                    newEmailOtpExpiredAt
            );
        }
    }
}
