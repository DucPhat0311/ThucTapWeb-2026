package controller.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import service.UserService;

import java.io.IOException;
import java.time.LocalDateTime;

@WebServlet("/profile-email-change")
public class ProfileEmailChangeController extends HttpServlet {
    private static final String PENDING_EMAIL_CHANGE_ATTR = "pendingProfileEmailChange";
    private static final String DEFAULT_STEP = "old";

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

        var pendingChange = getPendingChange(session);
        if (pendingChange == null) {
            response.sendRedirect("profile");
            return;
        }

        request.setAttribute("step", resolveStep(request, pendingChange));
        request.setAttribute("newEmail", pendingChange.newEmail());
        request.getRequestDispatcher("/WEB-INF/views/profile-email-change.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userlogin") == null) {
            response.sendRedirect("login");
            return;
        }

        User user = (User) session.getAttribute("userlogin");
        var pendingChange = getPendingChange(session);
        if (pendingChange == null || user == null) {
            response.sendRedirect("profile");
            return;
        }

        String step = request.getParameter("step");
        if ("old".equals(step)) {
            verifyOldEmailOtp(request, response, session, pendingChange);
            return;
        }

        response.sendRedirect("profile-email-change");
    }

    private void verifyOldEmailOtp(HttpServletRequest request,
                                   HttpServletResponse response,
                                   HttpSession session,
                                   ProfileController.PendingProfileEmailChange pendingChange) throws ServletException, IOException {
        String otp = trimToEmpty(request.getParameter("otp"));
        if (otp.isBlank() || LocalDateTime.now().isAfter(pendingChange.oldEmailOtpExpiredAt())
                || !otp.equals(pendingChange.oldEmailOtp())) {
            forwardWithError(request, response, pendingChange, "OTP email hiện tại không đúng hoặc đã hết hạn.", DEFAULT_STEP);
            return;
        }

        try {
            var newEmailVerification = userService.createProfileEmailChangeNewEmailVerification(pendingChange.newEmail());
            session.setAttribute(PENDING_EMAIL_CHANGE_ATTR, pendingChange.withNewEmailVerification(
                    newEmailVerification.newEmailOtp(),
                    newEmailVerification.newEmailOtpExpiredAt()
            ));
            response.sendRedirect("profile-email-change?step=new");
        } catch (RuntimeException e) {
            forwardWithError(request, response, pendingChange, e.getMessage(), DEFAULT_STEP);
        }
    }

    private void forwardWithError(HttpServletRequest request,
                                  HttpServletResponse response,
                                  ProfileController.PendingProfileEmailChange pendingChange,
                                  String error,
                                  String step) throws ServletException, IOException {
        request.setAttribute("error", error);
        request.setAttribute("step", step);
        request.setAttribute("newEmail", pendingChange.newEmail());
        request.getRequestDispatcher("/WEB-INF/views/profile-email-change.jsp").forward(request, response);
    }

    private String resolveStep(HttpServletRequest request, ProfileController.PendingProfileEmailChange pendingChange) {
        String requestedStep = trimToEmpty(request.getParameter("step"));
        if ("new".equals(requestedStep) && pendingChange.newEmailOtp() != null) {
            return "new";
        }
        return DEFAULT_STEP;
    }

    private ProfileController.PendingProfileEmailChange getPendingChange(HttpSession session) {
        Object pendingChange = session.getAttribute(PENDING_EMAIL_CHANGE_ATTR);
        if (pendingChange instanceof ProfileController.PendingProfileEmailChange profileEmailChange) {
            return profileEmailChange;
        }
        return null;
    }

    private String trimToEmpty(String value) {
        return value == null ? "" : value.trim();
    }
}
