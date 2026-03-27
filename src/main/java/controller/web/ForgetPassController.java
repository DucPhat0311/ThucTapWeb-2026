package controller.web;
import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.UserService;

@WebServlet(name = "ForgetPasswordController", value = "/forgetPass")
public class ForgetPassController extends HttpServlet {

    private UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException { request.getRequestDispatcher("/WEB-INF/auth/forgetPass.jsp").forward(request, response); }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String email = request.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập email");
            request.getRequestDispatcher("/WEB-INF/auth/forgetPass.jsp").forward(request, response);
            return;
        }

        try {

            userService.sendOtpResetPassword(email);
            request.setAttribute("email", email);
            request.setAttribute("type", "reset");
            request.getRequestDispatcher("/WEB-INF/auth/verify.jsp").forward(request, response);

        } catch (RuntimeException e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/auth/forgetPass.jsp").forward(request, response);
        }
    }
}
