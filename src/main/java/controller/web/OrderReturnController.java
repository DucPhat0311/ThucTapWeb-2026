package controller.web;

import dao.user.OrderDao;
import dao.user.OrderReturnDao;
import dao.user.OrderTrackingLogDao;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Order;
import model.User;
import model.constant.OrderReturnReason;
import model.constant.OrderStatus;

import java.io.IOException;
import java.sql.SQLIntegrityConstraintViolationException;
import java.time.LocalDateTime;

@WebServlet("/order-return")
public class OrderReturnController extends HttpServlet {
    private static final int RETURN_PERIOD_DAYS = 7;
    private static final int DESCRIPTION_MAX_LENGTH = 1000;

    private OrderDao orderDao;
    private OrderReturnDao orderReturnDao;
    private OrderTrackingLogDao trackingLogDao;

    @Override
    public void init() {
        orderDao = new OrderDao();
        orderReturnDao = new OrderReturnDao();
        trackingLogDao = new OrderTrackingLogDao();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userlogin") == null) {
            response.sendRedirect("login");
            return;
        }

        Integer orderId = parseOrderId(request.getParameter("orderId"));
        if (orderId == null) {
            response.sendRedirect("order-user");
            return;
        }

        User user = (User) session.getAttribute("userlogin");
        Order order = orderDao.getById(orderId);
        if (order == null || order.getUserId() != user.getId()) {
            response.sendRedirect("order-user");
            return;
        }

        if (!OrderStatus.COMPLETED.equals(order.getOrderStatus())) {
            redirectWithError(response, orderId, "not_delivered");
            return;
        }

        LocalDateTime deliveredAt = trackingLogDao.findDeliveredAt(orderId).orElse(null);
        if (deliveredAt == null || LocalDateTime.now().isAfter(deliveredAt.plusDays(RETURN_PERIOD_DAYS))) {
            redirectWithError(response, orderId, "expired");
            return;
        }

        if (orderReturnDao.existsByOrderId(orderId)) {
            redirectWithError(response, orderId, "duplicate");
            return;
        }

        String reasonCode = trimToEmpty(request.getParameter("reasonCode"));
        String description = trimToEmpty(request.getParameter("description"));
        if (!OrderReturnReason.isCustomerReason(reasonCode)
                || description.isBlank()
                || description.length() > DESCRIPTION_MAX_LENGTH) {
            redirectWithError(response, orderId, "invalid");
            return;
        }

        try {
            orderReturnDao.createCustomerRequest(orderId, user.getId(), reasonCode, description);
        } catch (RuntimeException e) {
            if (isDuplicateRequest(e)) {
                redirectWithError(response, orderId, "duplicate");
                return;
            }
            throw e;
        }

        response.sendRedirect("order-detail?id=" + orderId + "&returnRequest=success");
    }

    private void redirectWithError(HttpServletResponse response, int orderId, String error) throws IOException {
        response.sendRedirect("order-detail?id=" + orderId + "&returnError=" + error);
    }

    private boolean isDuplicateRequest(Throwable throwable) {
        Throwable cause = throwable;
        while (cause != null) {
            if (cause instanceof SQLIntegrityConstraintViolationException) {
                return true;
            }
            cause = cause.getCause();
        }
        return false;
    }

    private Integer parseOrderId(String rawOrderId) {
        try {
            return Integer.parseInt(trimToEmpty(rawOrderId));
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private String trimToEmpty(String value) {
        return value == null ? "" : value.trim();
    }
}
