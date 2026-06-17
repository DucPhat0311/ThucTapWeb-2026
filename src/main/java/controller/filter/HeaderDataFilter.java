package controller.filter;

import dao.user.CartItemDao;
import dao.user.NotificationDao;
import model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDateTime;

@WebFilter("/*")
public class HeaderDataFilter implements Filter {
    private final NotificationDao notificationDao = new NotificationDao();
    private final CartItemDao cartItemDao = new CartItemDao();

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpSession session = req.getSession(false);

        if (session != null && session.getAttribute("userlogin") != null) {
            User userLog = (User) session.getAttribute("userlogin");

            dao.user.UserDao userDao = new dao.user.UserDao();
            User authInfo = userDao.getAuthInfo(userLog.getId());
            
            if (authInfo == null || "BLOCKED".equalsIgnoreCase(authInfo.getStatus()) || "LOCKED_BY_SYSTEM".equalsIgnoreCase(authInfo.getStatus())) {
                session.invalidate();
                HttpServletResponse resp = (HttpServletResponse) response;
                resp.sendRedirect(req.getContextPath() + "/login?error=account_locked");
                return;
            }

            LocalDateTime loginTime = (LocalDateTime) session.getAttribute("loginTime");
            if (loginTime != null && authInfo.getTokenUpdatedAt() != null) {
                if (authInfo.getTokenUpdatedAt().isAfter(loginTime)) {
                    session.invalidate();
                    HttpServletResponse resp = (HttpServletResponse) response;
                    resp.sendRedirect(req.getContextPath() + "/login?error=session_expired");
                    return;
                }
            }

            if (req.getAttribute("notes") == null) {
                req.setAttribute("notes", notificationDao.findLatestForUser(userLog.getId()));
            }
            if (req.getAttribute("unreadNotifCount") == null) {
                req.setAttribute("unreadNotifCount", notificationDao.findAllByUserId(userLog.getId()).size());
            }

            if (session.getAttribute("cartSize") == null) {
                Integer cartId = (Integer) session.getAttribute("cartId");
                if (cartId == null) {
                    cartId = cartItemDao.getCartIdByUserId(userLog.getId());
                    if (cartId != null) {
                        session.setAttribute("cartId", cartId);
                    }
                }

                int total = 0;
                if (cartId != null) {
                    total = cartItemDao.countTotalQuantity(cartId);
                }
                session.setAttribute("cartSize", total);
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}
    @Override
    public void destroy() {}
}