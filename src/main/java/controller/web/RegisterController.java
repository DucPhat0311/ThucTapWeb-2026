package controller.web;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.UserService;

@WebServlet(name = "RegisterController", value = "/register")
public class RegisterController extends HttpServlet {

    private UserService userService;

    @Override
    public void init() {
        userService = new UserService();
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/auth/register.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String repassword = request.getParameter("repassword");
        String fullName = request.getParameter("full_name");
        String birthdayStr = request.getParameter("birthday");
        String gender = request.getParameter("gender");

        if (username == null || email == null ||
                password == null || repassword == null ||
                fullName == null || birthdayStr == null || gender == null ||
                username.isEmpty() || email.isEmpty() ||
                password.isEmpty() || repassword.isEmpty() ||
                fullName.isEmpty() || birthdayStr.isEmpty() || gender.isEmpty()) {

            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin");
            request.getRequestDispatcher("/WEB-INF/auth/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(repassword)) {
            request.setAttribute("error", "Mật khẩu nhập lại không khớp");
            request.getRequestDispatcher("/WEB-INF/auth/register.jsp").forward(request, response);
            return;
        }

        try {
            userService.registerSendOtp(username, email, password, fullName, birthdayStr, gender);

            response.sendRedirect(
                    request.getContextPath() + "/otp?email=" + email
            );

        } catch (RuntimeException e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/auth/register.jsp").forward(request, response);
        }

    }
}
