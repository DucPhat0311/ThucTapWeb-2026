package controller.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import service.GoogleOAuthService;

import java.io.IOException;
import java.security.SecureRandom;
import java.util.Base64;

@WebServlet(name = "GoogleLoginController", value = "/auth/google")
public class GoogleLoginController extends HttpServlet {

    private GoogleOAuthService googleOAuthService;

    @Override
    public void init() {
        googleOAuthService = new GoogleOAuthService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!googleOAuthService.isConfigured()) {
            request.setAttribute("error", "Google Login chưa được cấu hình. Hãy thêm GOOGLE_CLIENT_ID và GOOGLE_CLIENT_SECRET.");
            request.getRequestDispatcher("/WEB-INF/auth/login.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession(true);
        String state = generateState();
        session.setAttribute("google_oauth_state", state);

        String redirectUri = buildRedirectUri(request);
        String authUrl = googleOAuthService.buildAuthorizationUrl(state, redirectUri);
        response.sendRedirect(authUrl);
    }

    private String generateState() {
        byte[] bytes = new byte[24];
        new SecureRandom().nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
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