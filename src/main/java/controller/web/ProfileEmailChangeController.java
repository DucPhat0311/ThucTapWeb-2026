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
    private static final String NEW_EMAIL_STEP = "new";

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

        String action = trimToEmpty(request.getParameter("action"));
        String step = request.getParameter("step");
        if ("resendNewOtp".equals(action)) {
            resendNewEmailOtp(request, response, session, pendingChange);
            return;
        }

        if ("old".equals(step)) {
            verifyOldEmailOtp(request, response, session, pendingChange);
            return;
        }

        if (NEW_EMAIL_STEP.equals(step)) {
            verifyNewEmailOtp(request, response, session, user, pendingChange);
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
            response.sendRedirect("profile-email-change?step=new&sent=1");
        } catch (RuntimeException e) {
            forwardWithError(request, response, pendingChange, e.getMessage(), DEFAULT_STEP);
        }
    }

    private void resendNewEmailOtp(HttpServletRequest request,
                                   HttpServletResponse response,
                                   HttpSession session,
                                   ProfileController.PendingProfileEmailChange pendingChange) throws ServletException, IOException {
        if (pendingChange.newEmailOtp() == null || pendingChange.newEmailOtpExpiredAt() == null) {
            response.sendRedirect("profile-email-change");
            return;
        }

        try {
            var newEmailVerification = userService.createProfileEmailChangeNewEmailVerification(pendingChange.newEmail());
            session.setAttribute(PENDING_EMAIL_CHANGE_ATTR, pendingChange.withNewEmailVerification(
                    newEmailVerification.newEmailOtp(),
                    newEmailVerification.newEmailOtpExpiredAt()
            ));
            response.sendRedirect("profile-email-change?step=new&resent=1");
        } catch (RuntimeException e) {
            forwardWithError(request, response, pendingChange, e.getMessage(), NEW_EMAIL_STEP);
        }
    }

    private void verifyNewEmailOtp(HttpServletRequest request,
                                   HttpServletResponse response,
                                   HttpSession session,
                                   User user,
                                   ProfileController.PendingProfileEmailChange pendingChange) throws ServletException, IOException {
        String otp = trimToEmpty(request.getParameter("otp"));
        if (pendingChange.newEmailOtp() == null || pendingChange.newEmailOtpExpiredAt() == null) {
            response.sendRedirect("profile-email-change");
            return;
        }

        if (otp.isBlank() || LocalDateTime.now().isAfter(pendingChange.newEmailOtpExpiredAt())
                || !otp.equals(pendingChange.newEmailOtp())) {
            forwardWithError(request, response, pendingChange, "OTP email mới không đúng hoặc đã hết hạn.", NEW_EMAIL_STEP);
            return;
        }

        try {
            User refreshedUser = userService.completeProfileEmailChange(
                    user.getId(),
                    pendingChange.fullName(),
                    pendingChange.phone(),
                    pendingChange.newEmail(),
                    pendingChange.birthday(),
                    pendingChange.gender()
            );
            session.setAttribute("userlogin", refreshedUser);
            session.removeAttribute(PENDING_EMAIL_CHANGE_ATTR);
            response.sendRedirect("profile?emailChange=completed");
        } catch (RuntimeException e) {
            forwardWithError(request, response, pendingChange, e.getMessage(), NEW_EMAIL_STEP);
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
        if (NEW_EMAIL_STEP.equals(requestedStep) && pendingChange.newEmailOtp() != null) {
            return NEW_EMAIL_STEP;
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
