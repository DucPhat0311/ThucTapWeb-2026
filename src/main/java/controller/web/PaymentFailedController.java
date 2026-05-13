package controller.web;

import dao.user.OrderDao;
import dao.user.OrderItemDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.constant.PaymentMethod;
import model.constant.PaymentStatus;

import java.io.IOException;

@WebServlet(name = "PaymentFailedController", value = "/payment-failed")
public class PaymentFailedController extends HttpServlet {
    private OrderDao orderDao;
    private OrderItemDao orderItemDao;

    @Override
    public void init() {
        orderDao = new OrderDao();
        orderItemDao = new OrderItemDao();
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
}
