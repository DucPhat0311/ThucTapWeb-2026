package controller.web;

import dao.user.CartDao;
import dao.user.CartItemDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.GoogleUserInfo;
import model.User;
import service.GoogleOAuthService;
import service.UserService;

import java.io.IOException;

@WebServlet(name = "GoogleCallbackController", value = "/auth/google/callback")
public class GoogleCallbackController extends HttpServlet {

    private GoogleOAuthService googleOAuthService;
    private UserService userService;
    private CartDao cartDao;

    @Override
    public void init() {
        googleOAuthService = new GoogleOAuthService();
        userService = new UserService();
        cartDao = new CartDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String providerError = request.getParameter("error");
        if (providerError != null && !providerError.isBlank()) {
            returnToLoginWithError(request, response, "Bạn đã hủy đăng nhập Google.");
            return;
        }

        HttpSession currentSession = request.getSession(false);
        String savedState = currentSession == null ? null : (String) currentSession.getAttribute("google_oauth_state");
        String state = request.getParameter("state");
        if (currentSession != null) {
            currentSession.removeAttribute("google_oauth_state");
        }

        if (savedState == null || state == null || !savedState.equals(state)) {
            returnToLoginWithError(request, response, "Phiên đăng nhập Google không hợp lệ. Vui lòng thử lại.");
            return;
        }

        String code = request.getParameter("code");
        if (code == null || code.isBlank()) {
            returnToLoginWithError(request, response, "Không nhận được mã xác thực từ Google.");
            return;
        }

        User user;
        try {
            String redirectUri = buildRedirectUri(request);
            GoogleUserInfo googleUser = googleOAuthService.getUserInfoFromAuthorizationCode(code, redirectUri);
            user = userService.loginWithGoogle(googleUser);
        } catch (RuntimeException ex) {
            returnToLoginWithError(request, response, ex.getMessage());
            return;
        }

        if (user == null) {
            returnToLoginWithError(request, response, "Không thể đăng nhập bằng Google. Vui lòng thử lại.");
            return;
        }

        if (user.getStatus() == null) {
            returnToLoginWithError(request, response, "Tài khoản chưa được kích hoạt");
            return;
        }

        if ("BLOCKED".equalsIgnoreCase(user.getStatus())) {
            returnToLoginWithError(request, response, "Tài khoản đã bị khóa. Vui lòng liên hệ với bộ phận hỗ trợ để biết thêm chi tiết.");
            return;
        }

        if (user.getIsActive() == 0) {
            returnToLoginWithError(request, response, "Tài khoản chưa xác nhận OTP. Vui lòng kiểm tra email.");
            return;
        }

        HttpSession oldSession = request.getSession(false);
        if (oldSession != null) {
            oldSession.invalidate();
        }

        HttpSession session = request.getSession(true);
        session.setAttribute("userId", user.getId());
        session.setAttribute("userlogin", user);

        Integer cartId = cartDao.findCartIdByUser(user.getId());
        if (cartId == null) {
            cartId = cartDao.createCart(user.getId());
        }
        session.setAttribute("cartId", cartId);
        int cartSize = new CartItemDao().countTotalQuantity(cartId);
        session.setAttribute("cartSize", cartSize);

        if ("admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/dashboardAdmin");
        } else {
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }

    private void returnToLoginWithError(HttpServletRequest request, HttpServletResponse response, String message)
            throws ServletException, IOException {
        request.setAttribute("error", message);
        request.getRequestDispatcher("/WEB-INF/auth/login.jsp").forward(request, response);
    }

    private String buildRedirectUri(HttpServletRequest request) {
        String scheme = request.getScheme();
        String host = request.getServerName();
        int port = request.getServerPort();

        boolean defaultHttp = "http".equalsIgnoreCase(scheme) && port == 80;
        boolean defaultHttps = "https".equalsIgnoreCase(scheme) && port == 443;
        String portPart = (defaultHttp || defaultHttps) ? "" : ":" + port;

        return scheme + "://" + host + portPart + request.getContextPath() + "/auth/google/callback";
    }
}