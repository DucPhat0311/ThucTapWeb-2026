package controller.web;

import dao.user.OrderDao;
import dao.user.OrderItemDao;
import dao.user.PaymentTransactionDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import model.constant.OrderStatus;
import model.constant.PaymentMethod;
import model.constant.PaymentStatus;
import model.constant.PaymentTransactionStatus;
import service.VnPayService;

import java.io.IOException;

@WebServlet(name = "PaymentFailedController", value = "/payment-failed")
public class PaymentFailedController extends HttpServlet {
    private OrderDao orderDao;
    private OrderItemDao orderItemDao;
    private PaymentTransactionDao paymentTransactionDao;
    private VnPayService vnPayService;

    @Override
    public void init() {
        orderDao = new OrderDao();
        orderItemDao = new OrderItemDao();
        paymentTransactionDao = new PaymentTransactionDao();
        vnPayService = new VnPayService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userlogin") == null) {
            response.sendRedirect("login");
            return;
        }

        Integer orderId = (Integer) session.getAttribute("failedOrderId");
        if (orderId == null) {
            response.sendRedirect("checkout?error=payment_failed");
            return;
        }

        var order = orderDao.getById(orderId);
        if (order == null) {
            response.sendRedirect("checkout?error=payment_not_found");
            return;
        }

        var orderItems = orderItemDao.getByOrderId(orderId);

        request.setAttribute("order", order);
        request.setAttribute("orderItems", orderItems);
        request.setAttribute("paymentMethodLabel", getPaymentMethodLabel(order.getPaymentMethods()));
        request.setAttribute("paymentStatusLabel", getPaymentStatusLabel(order.getPaymentStatuses()));
        request.setAttribute("failedTitle", getSessionValue(session, "failedTitle", "Thanh toán không thành công"));
        request.setAttribute("failedMessage", getSessionValue(session, "failedMessage", "Đơn hàng của bạn đã được ghi nhận nhưng chưa hoàn tất thanh toán."));

        session.removeAttribute("failedOrderId");
        session.removeAttribute("failedTitle");
        session.removeAttribute("failedMessage");

        request.getRequestDispatcher("/WEB-INF/views/payment-failed.jsp")
                .forward(request, response);
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
        Integer orderId = parseOrderId(request.getParameter("orderId"));
        if (orderId == null) {
            response.sendRedirect("order-user");
            return;
        }

        var order = orderDao.getById(orderId);
        if (order == null || order.getUserId() != user.getId()) {
            response.sendRedirect("order-user");
            return;
        }

        if (!PaymentMethod.VNPAY.equals(order.getPaymentMethods()) || PaymentStatus.PAID.equals(order.getPaymentStatuses())) {
            response.sendRedirect("order-user");
            return;
        }

        orderDao.updatePaymentAndOrderStatus(orderId, PaymentStatus.PENDING, OrderStatus.PENDING_PAYMENT);

        String txnRef = vnPayService.generateTxnRef(orderId);
        double amount = resolvePayableAmount(order.getFinalAmount(), order.getTotalPrice());
        paymentTransactionDao.createInitiatedTransaction(
                orderId,
                PaymentMethod.VNPAY,
                txnRef,
                amount,
                PaymentTransactionStatus.INITIATED
        );

        String paymentUrl = vnPayService.buildPaymentUrl(new VnPayService.PaymentRequest(
                txnRef,
                amount,
                "Thanh toan don hang #" + orderId,
                resolveClientIp(request),
                null,
                null,
                null
        ));
        response.sendRedirect(paymentUrl);
    }

    private String getPaymentMethodLabel(String paymentMethod) {
        if (PaymentMethod.VNPAY.equals(paymentMethod)) {
            return "Thanh toán qua VNPay";
        }
        return "Thanh toán khi nhận hàng (COD)";
    }

    private String getPaymentStatusLabel(String paymentStatus) {
        if (PaymentStatus.PAID.equals(paymentStatus)) {
            return "Đã thanh toán";
        }
        if (PaymentStatus.PENDING.equals(paymentStatus)) {
            return "Đang chờ thanh toán";
        }
        if (PaymentStatus.FAILED.equals(paymentStatus)) {
            return "Thanh toán thất bại";
        }
        return "Chưa thanh toán";
    }

    private String getSessionValue(HttpSession session, String name, String fallback) {
        Object value = session.getAttribute(name);
        if (value instanceof String text && !text.isBlank()) {
            return text;
        }
        return fallback;
    }

    private Integer parseOrderId(String rawOrderId) {
        if (rawOrderId == null || rawOrderId.isBlank()) {
            return null;
        }
        try {
            return Integer.parseInt(rawOrderId.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private double resolvePayableAmount(double finalAmount, double totalPrice) {
        return finalAmount > 0 ? finalAmount : totalPrice;
    }

    private String resolveClientIp(HttpServletRequest request) {
        String forwardedFor = trimToEmpty(request.getHeader("X-Forwarded-For"));
        if (!forwardedFor.isBlank()) {
            int commaIndex = forwardedFor.indexOf(',');
            return commaIndex >= 0 ? forwardedFor.substring(0, commaIndex).trim() : forwardedFor;
        }
        return trimToEmpty(request.getRemoteAddr());
    }

    private String trimToEmpty(String value) {
        return value == null ? "" : value.trim();
    }
}
