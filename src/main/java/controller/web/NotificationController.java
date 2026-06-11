package controller.web;

import dao.user.NotificationDao;
import model.Notification;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/my-notifications")
public class NotificationController extends HttpServlet {
    private final NotificationDao notificationDao = new NotificationDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User userLog = (User) request.getSession().getAttribute("userlogin");
        if (userLog == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<Notification> notes = notificationDao.findLatestForUser(userLog.getId());
        request.setAttribute("notes", notes);

        notificationDao.markAllReadForUser(userLog.getId());

        List<Notification> allNotifications = notificationDao.findAllByUserId(userLog.getId());
        request.setAttribute("allNotifications", allNotifications);
        request.setAttribute("pageTitle", "Thông báo của tôi");

        request.getRequestDispatcher("/WEB-INF/views/notification.jsp").forward(request, response);
    }
}