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

@WebServlet(name = "OrderSuccessController", value = "/order-success")
public class OrderSuccessController extends HttpServlet {
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

        Integer orderId = (Integer) session.getAttribute("lastOrderId");
        if (orderId == null) {
            response.sendRedirect("home");
            return;
        }

        var order = orderDao.getById(orderId);
        if (order == null) {
            response.sendRedirect("home");
            return;
        }

        var orderItems = orderItemDao.getByOrderId(orderId);

        request.setAttribute("order", order);
        request.setAttribute("orderItems", orderItems);
        request.setAttribute("paymentMethodLabel", getPaymentMethodLabel(order.getPaymentMethods()));
        request.setAttribute("paymentStatusLabel", getPaymentStatusLabel(order.getPaymentStatuses()));
        request.setAttribute("successMessage", getSuccessMessage(order.getPaymentMethods(), order.getName()));

        session.removeAttribute("lastOrderId");

        request.getRequestDispatcher("/WEB-INF/views/checkout-success.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

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

    private String getSuccessMessage(String paymentMethod, String customerName) {
        String safeName = customerName == null ? "bạn" : customerName;
        if (PaymentMethod.VNPAY.equals(paymentMethod)) {
            return "Cảm ơn " + safeName + ", thanh toán VNPay của bạn đã thành công!";
        }
        return "Cảm ơn " + safeName + ", đơn hàng đã được đặt thành công!";
    }
}
