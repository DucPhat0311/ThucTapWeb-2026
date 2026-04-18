package controller.web;

import com.restfb.DefaultFacebookClient;
import com.restfb.FacebookClient;
import com.restfb.types.User;
import com.restfb.Parameter;
import com.restfb.Version;
import com.restfb.types.User;
import dao.user.UserDao;
import model.FacebookConstants;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDateTime;

@WebServlet(name = "LoginFacebookController", value = "/auth/facebook")
public class LoginFacebookController extends HttpServlet {

        @Override
        protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            // lấy code khi login r
            String code = request.getParameter("code");

            // chưa có code ==> về trang login FB
            if (code == null || code.isEmpty()) {
                response.sendRedirect(FacebookConstants.FACEBOOK_LOGIN_URL);
                return;
            }

            try {
                // tạo Fbclient
                FacebookClient client = new DefaultFacebookClient(Version.LATEST);

                // dùng code lấy access token
                FacebookClient.AccessToken accessToken = client.obtainUserAccessToken(
                        FacebookConstants.FACEBOOK_APP_ID,
                        FacebookConstants.FACEBOOK_APP_SECRET,
                        FacebookConstants.FACEBOOK_REDIRECT_URL,
                        code);

                // access token truy vấn ttin ng dùng
                FacebookClient authenticatedClient = new DefaultFacebookClient(accessToken.getAccessToken(), Version.LATEST);

                // gọi Fb API lấy fields cần lấy
                User fbUser = authenticatedClient.fetchObject("me", User.class,
                        Parameter.with("fields", "id,name,email"));

                // handle login
                processLogin(request, response, fbUser);

            } catch (Exception e) {
                e.printStackTrace();
                // nếu lỗi ==> về trang login
                response.sendRedirect("login?error=facebook_auth_failed");
            }
        }

    private void processLogin(HttpServletRequest request, HttpServletResponse response, User fbUser) throws IOException {
        HttpSession session = request.getSession();
        UserDao userDao = new UserDao();

        // kiem tra email ton tai
        model.User userSystem = userDao.findByEmail(fbUser.getEmail());

        if (userSystem == null) {
            // not yet => create a new one
            userSystem = new model.User();
            userSystem.setUsername("fb_" + fbUser.getId());
            userSystem.setEmail(fbUser.getEmail());
            userSystem.setFullName(fbUser.getName());
            userSystem.setRole("USER");
            userSystem.setAuthProvider("FACEBOOK");
            userSystem.setIsActive(1);
            userSystem.setStatus("ACTIVE");
            userSystem.setCreatedAt(LocalDateTime.now());

            // insert vao DB
            int newId = userDao.insert(userSystem);
            userSystem.setId(newId);
        }

        // luuw user vao session
        session.setAttribute("userlogin", userSystem);

        // debug
        System.out.println("Đăng nhập thành công! User ID hệ thống: " + userSystem.getId());
        response.sendRedirect(request.getContextPath() + "/home");
    }
}