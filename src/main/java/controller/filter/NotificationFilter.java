package controller.filter;

import dao.user.NotificationDao;
import model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class NotificationFilter implements Filter {
    private final NotificationDao notificationDao = new NotificationDao();

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpSession session = req.getSession(false);

        if (session != null && session.getAttribute("userlogin") != null) {
            User userLog = (User) session.getAttribute("userlogin");

            if (req.getAttribute("notes") == null) {
                req.setAttribute("notes", notificationDao.findLatestForUser(userLog.getId()));
            }

            if (req.getAttribute("unreadNotifCount") == null) {
                int totalNotif = notificationDao.findAllByUserId(userLog.getId()).size();
                req.setAttribute("unreadNotifCount", totalNotif);
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void destroy() {}
}