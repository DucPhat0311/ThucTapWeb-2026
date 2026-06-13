package controller.web;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dao.user.CartDao;
import dao.user.CartItemDao;
import service.UserService;
import model.User;

@WebServlet(name = "LoginController", value = "/login")
public class LoginController extends HttpServlet {

    private UserService userService;
    private CartDao cartDao;

    @Override
    public void init() {
        userService = new UserService();
        cartDao = new CartDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        userService.cleanupExpiredPendingRegistrations();
        request.getRequestDispatcher("/WEB-INF/auth/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        userService.cleanupExpiredPendingRegistrations();

        String usernameRaw = request.getParameter("username");
        String password = request.getParameter("password");
        String username = usernameRaw == null ? "" : usernameRaw.trim();

        boolean hasValidationError = false;
        if (username.isEmpty()) {
            request.setAttribute("errorUsername", "Vui lòng nhập email hoặc tên đăng nhập.");
            hasValidationError = true;
        }
        if (password == null || password.trim().isEmpty()) {
            request.setAttribute("errorPassword", "Vui lòng nhập mật khẩu.");
            hasValidationError = true;
        }

        if (hasValidationError) {
            request.setAttribute("username", username);
            request.getRequestDispatcher("/WEB-INF/auth/login.jsp").forward(request, response);
            return;
        }

        UserService.LoginResult result = userService.loginWithAttempt(username, password);

        if (result.alreadyLocked()) {
            request.setAttribute("lockedBySystem", true);
            request.setAttribute("error", "Tài khoản của bạn đã bị khoá do nhập sai mật khẩu quá 5 lần. Vui lòng liên hệ Admin để được hỗ trợ mở khoá.");
            request.setAttribute("username", username);
            request.getRequestDispatcher("/WEB-INF/auth/login.jsp").forward(request, response);
            return;
        }

        if (result.user() == null) {
            if (result.justLocked()) {
                request.setAttribute("lockedBySystem", true);
                request.setAttribute("error", "Tài khoản của bạn đã bị khoá do nhập sai mật khẩu quá 5 lần liên tiếp. Vui lòng liên hệ Admin để được hỗ trợ mở khoá.");
            } else if (result.failedAttempts() >= 2) {
                int remaining = 5 - result.failedAttempts();
                request.setAttribute("warning", "Mật khẩu không đúng! Bạn còn " + remaining + " lần thử. "
                        + "Tài khoản sẽ bị khoá tự động sau 5 lần nhập sai liên tiếp.");
                request.setAttribute("failedAttempts", result.failedAttempts());
            } else {
                request.setAttribute("error", "Email/ tên đăng nhập hoặc mật khẩu không đúng");
            }
            request.setAttribute("username", username);
            request.getRequestDispatcher("/WEB-INF/auth/login.jsp").forward(request, response);
            return;
        }

        User user = result.user();

        if (user.getStatus() == null) {
            request.setAttribute("error", "Tài khoản chưa được kích hoạt");
            request.getRequestDispatcher("/WEB-INF/auth/login.jsp").forward(request, response);
            return;
        }

        if ("BLOCKED".equalsIgnoreCase(user.getStatus())) {
            request.setAttribute("error", "Tài khoản đã bị khóa. Vui lòng liên hệ với bộ phận hỗ trợ để biết thêm chi tiết.");
            request.getRequestDispatcher("/WEB-INF/auth/login.jsp").forward(request, response);
            return;
        }

        if (user.getIsActive() == 0) {
            request.setAttribute("error", "Tài khoản chưa xác nhận OTP. Vui lòng kiểm tra email.");
            request.setAttribute("username", username);
            request.getRequestDispatcher("/WEB-INF/auth/login.jsp").forward(request, response);
            return;
        }

        HttpSession oldSession = request.getSession(false);
        if (oldSession != null) {
            oldSession.invalidate();
        }

        HttpSession session = request.getSession(true);
        session.setAttribute("userId", user.getId());
        session.setAttribute("userlogin", user);

        if ("ADMIN".equals(user.getRole())) {
            session.setAttribute("admin", user);
        }

        Integer cartId = cartDao.findCartIdByUser(user.getId());
        if (cartId == null) {
            cartId = cartDao.createCart(user.getId());
        }
        session.setAttribute("cartId", cartId);
        int cartSize = new CartItemDao().countTotalQuantity(cartId);
        session.setAttribute("cartSize", cartSize);

        if ("admin".equalsIgnoreCase(user.getRole())) {
            session.setAttribute("admin", user);
            response.sendRedirect(request.getContextPath() + "/dashboardAdmin");
        } else {
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}

