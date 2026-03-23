package controller.web;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.UserService;

@WebServlet(name = "ResetPasswordController", value = "/resetPass")
public class ResetPassController extends HttpServlet {
    private UserService userService;

    @Override
    public void init() {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String otp = request.getParameter("otp");
        String password = request.getParameter("password");

        try {
            userService.resetPass(email, otp, password);
            response.sendRedirect("login");
        } catch (RuntimeException e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("email", email);
            request.setAttribute("otp", otp);
            request.getRequestDispatcher("/WEB-INF/auth/resetPass.jsp").forward(request, response);
        }
    }
}
