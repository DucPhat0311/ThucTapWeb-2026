package controller.web;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.UserService;

@WebServlet(name = "SendOTPController", value = "/sendOTP")

public class SendOTPController extends HttpServlet {

    private UserService userService;

    @Override
    public void init() {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/auth/registerOTP.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("resend".equals(action)) {
            String email = request.getParameter("email");

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            try {
                userService.sendOtpResetPassword(email);
                response.getWriter().write("{\"success\":true}");
            } catch (RuntimeException e) {
                response.getWriter().write(
                        "{\"success\":false,\"message\":\"" + e.getMessage() + "\"}"
                );
            }
            return;
        }

        String email = request.getParameter("email");
        String otp = request.getParameter("otp");
        String type = request.getParameter("type");

        System.out.println("EMAIL = " + email);
        System.out.println("OTP = " + otp);
        System.out.println("TYPE = " + type);


        boolean Done;

        if ("reset".equals(type)) {
            Done = userService.lastCheckOtp(email, otp);
        } else {
            Done = userService.verifyOtp(email, otp);
        }

        if (Done) {
            if ("reset".equals(type)) {
                request.setAttribute("email", email);
                request.setAttribute("otp", otp);
                request.getRequestDispatcher("/WEB-INF/auth/resetPass.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/login");
            }
        } else {
            request.setAttribute("error", "OTP sai hoặc đã hết hạn");
            request.getRequestDispatcher("/WEB-INF/auth/verify.jsp").forward(request, response);
        }

    }
}
