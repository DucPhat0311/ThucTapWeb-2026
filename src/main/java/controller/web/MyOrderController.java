package controller.web;

import dao.user.OrderDao;
import dao.user.OrderItemDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Order;
import model.User;
import model.constant.OrderStatus;
import model.constant.PaymentMethod;
import model.constant.PaymentStatus;

import java.io.IOException;
import java.util.List;

@WebServlet("/order-user")
public class MyOrderController extends HttpServlet {

    private final OrderDao orderDao = new OrderDao();
    private final OrderItemDao orderItemDao = new OrderItemDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userlogin") == null) {
            resp.sendRedirect("login");
            return;
        }

        User user = (User) session.getAttribute("userlogin");
        String status = req.getParameter("status");

        List<Order> orders;
        if (status != null && !status.isEmpty() && !"all".equals(status)) {
            orders = orderDao.getByUserIdAndStatus(user.getId(), status);
        } else {
            orders = orderDao.getByUserId(user.getId());
        }

        for (Order order : orders) {
            order.setItems(orderItemDao.getByOrderId(order.getId()));
        }

        req.setAttribute("orders", orders);
        req.setAttribute("currentStatus", status != null ? status : "all");
        req.getRequestDispatcher("/WEB-INF/views/order-user.jsp").forward(req, resp);
    }

    public static String getOrderStatusLabel(String status) {
        if (status == null) {
            return "Không xác định";
        }
        return switch (status) {
            case OrderStatus.PENDING -> "Chờ xác nhận";
            case OrderStatus.PENDING_PAYMENT -> "Chờ thanh toán";
            case OrderStatus.SHIPPING -> "Đang giao hàng";
            case OrderStatus.COMPLETED -> "Đã hoàn thành";
            case OrderStatus.CANCELLED -> "Đã hủy";
            default -> status;
        };
    }

    public static String getPaymentMethodLabel(String paymentMethod) {
        if (PaymentMethod.VNPAY.equals(paymentMethod)) {
            return "VNPay";
        }
        return "COD";
    }

    public static String getPaymentStatusLabel(String paymentStatus) {
        if (paymentStatus == null) {
            return "Không xác định";
        }
        return switch (paymentStatus) {
            case PaymentStatus.PAID -> "Đã thanh toán";
            case PaymentStatus.PENDING -> "Đang chờ thanh toán";
            case PaymentStatus.FAILED -> "Thanh toán thất bại";
            case PaymentStatus.UNPAID -> "Chưa thanh toán";
            default -> paymentStatus;
        };
    }
}
