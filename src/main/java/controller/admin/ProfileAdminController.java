package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import service.admin.ProfileAdminService;

import java.io.IOException;
import java.time.LocalDate;

@WebServlet("/profileAdmin")
public class ProfileAdminController extends HttpServlet {
    private final ProfileAdminService profileAdminService = ProfileAdminService.getInstance();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User admin = (User) session.getAttribute("admin");

        if (admin != null) {
            User currentAdmin = profileAdminService.getAdminById(admin.getId());
            request.setAttribute("adminInfo", currentAdmin);
        }

        request.setAttribute("page", "profile");
        request.getRequestDispatcher("/WEB-INF/admin/profileAdmin.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        User admin = (User) session.getAttribute("admin");

        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if ("updateProfile".equals(action)) {
            updateProfile(request, response, admin);
        } else if ("changePassword".equals(action)) {
            changePassword(request, response, admin.getId());
        }

        doGet(request, response);
    }

    private void updateProfile(HttpServletRequest request, HttpServletResponse response, User admin) throws IOException {
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String birthdayStr = request.getParameter("birthday");
        String gender = request.getParameter("gender");

        admin.setFullName(fullName);
        admin.setEmail(email);
        admin.setPhone(phone);
        admin.setAddress(address);
        if (birthdayStr != null && !birthdayStr.isEmpty()) {
            admin.setBirthday(LocalDate.parse(birthdayStr));
        }
        admin.setGender(gender);

        try {
            profileAdminService.updateAdmin(admin);
            request.getSession().setAttribute("admin", admin);
            request.setAttribute("success", "Cập nhật thông tin thành công!");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Cập nhật thông tin thất bại!");
        }
    }

    private void changePassword(HttpServletRequest request, HttpServletResponse response, int adminId) throws IOException {
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        boolean success = profileAdminService.changePassword(adminId, currentPassword, newPassword, confirmPassword);
        if (success) {
            request.setAttribute("success", "Đổi mật khẩu thành công!");
        } else {
            request.setAttribute("error", "Đổi mật khẩu thất bại! Vui lòng kiểm tra lại mật khẩu hiện tại và mật khẩu mới.");
        }
    }
}
