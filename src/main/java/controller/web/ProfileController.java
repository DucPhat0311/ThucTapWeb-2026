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

import java.io.File;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

@WebServlet("/profile")
@MultipartConfig(
        maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 6 * 1024 * 1024
)
public class ProfileController extends HttpServlet {

    private static final String DEFAULT_REDIRECT = "profile";
    private static final long MAX_AVATAR_SIZE = 5 * 1024 * 1024;

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
        Part avatarPart = request.getPart("avatarFile");
        if (avatarPart == null || avatarPart.getSize() == 0) {
            response.sendRedirect(DEFAULT_REDIRECT + "?avatarError=empty");
            return;
        }

        if (avatarPart.getSize() > MAX_AVATAR_SIZE) {
            response.sendRedirect(DEFAULT_REDIRECT + "?avatarError=size");
            return;
        }

        String extension = extractExtension(avatarPart.getSubmittedFileName());
        if (!isAllowedExtension(extension) || !isImageContentType(avatarPart.getContentType())) {
            response.sendRedirect(DEFAULT_REDIRECT + "?avatarError=type");
            return;
        }

        String avatarUrl = saveAvatarFile(userSession.getId(), avatarPart, extension);
        userService.updateAvatar(userSession.getId(), avatarUrl);

        User refreshedUser = userService.findById(userSession.getId());
        session.setAttribute("userlogin", refreshedUser);

        response.sendRedirect(DEFAULT_REDIRECT + "?avatarUpdated=1");
    }

    private String saveAvatarFile(int userId, Part avatarPart, String extension) throws IOException {
        String uploadPath = getServletContext().getRealPath("/img/avatar");
        if (uploadPath == null) {
            throw new IOException("Cannot resolve upload path for avatar.");
        }

        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists() && !uploadDir.mkdirs()) {
            throw new IOException("Cannot create avatar upload directory.");
        }

        String uniqueFileName = "avatar_user_" + userId + "_" + System.currentTimeMillis() + "." + extension;
        uniqueFileName = uniqueFileName.replaceAll("[^a-zA-Z0-9._-]", "_");

        File destinationFile = new File(uploadDir, uniqueFileName);
        avatarPart.write(destinationFile.getAbsolutePath());

        return "img/avatar/" + uniqueFileName;
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
}
