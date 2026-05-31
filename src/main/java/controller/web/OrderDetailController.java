package controller.web;

import dao.user.OrderDao;
import dao.user.OrderItemDao;
import dao.user.OrderReturnDao;
import dao.user.OrderTrackingLogDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Order;
import model.OrderReturn;
import model.User;
import model.constant.OrderReturnStatus;
import model.constant.OrderStatus;
import model.constant.OrderStatusLabel;
import model.constant.PaymentMethod;
import model.constant.PaymentStatus;
import model.constant.OrderReturnReason;
import service.GhnOrderTrackingService;
import service.OrderService;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@WebServlet("/order-detail")
public class OrderDetailController extends HttpServlet {
    private OrderDao orderDao;
    private OrderItemDao orderItemDao;
    private OrderTrackingLogDao trackingLogDao;
    private OrderReturnDao orderReturnDao;
    private GhnOrderTrackingService ghnOrderTrackingService;
    private OrderService orderService;

    @Override
    public void init() {
        orderDao = new OrderDao();
        orderItemDao = new OrderItemDao();
        trackingLogDao = new OrderTrackingLogDao();
        orderReturnDao = new OrderReturnDao();
        ghnOrderTrackingService = new GhnOrderTrackingService();
        orderService = new OrderService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userlogin") == null) {
            response.sendRedirect("login");
            return;
        }

        Integer orderId = parseOrderId(request.getParameter("id"));
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

        if (orderService.expirePendingPaymentOrder(orderId)) {
            order = orderDao.getById(orderId);
        }

        syncGhnTracking(order, request);

        request.setAttribute("order", order);
        request.setAttribute("demoTracking", orderService.isDemoTrackingCode(order.getGhnOrderCode()));
        request.setAttribute("orderItems", orderItemDao.getByOrderId(orderId));
        request.setAttribute("trackingLogs", trackingLogDao.getByOrderId(orderId));
        request.setAttribute("orderStatusLabel", getOrderStatusLabel(order.getOrderStatus()));
        request.setAttribute("orderStatusClass", getOrderStatusClass(order.getOrderStatus()));
        request.setAttribute("paymentMethodLabel", getPaymentMethodLabel(order.getPaymentMethods()));
        request.setAttribute("paymentStatusLabel", getPaymentStatusLabel(order.getPaymentStatuses()));
        setReturnRequestAttributes(request, order);

        request.getRequestDispatcher("/WEB-INF/views/order-detail.jsp")
                .forward(request, response);
    }

    private void setReturnRequestAttributes(HttpServletRequest request, Order order) {
        OrderReturn orderReturn = orderReturnDao.findByOrderId(order.getId()).orElse(null);
        boolean existingRequest = orderReturn != null;
        LocalDateTime deliveredAt = trackingLogDao.findDeliveredAt(order.getId()).orElse(null);
        LocalDateTime returnDeadline = deliveredAt == null ? null : deliveredAt.plusDays(7);
        boolean eligible = OrderStatus.COMPLETED.equals(order.getOrderStatus())
                && !existingRequest
                && returnDeadline != null
                && !LocalDateTime.now().isAfter(returnDeadline);

        request.setAttribute("returnRequestExists", existingRequest);
        request.setAttribute("returnRequestEligible", eligible);
        request.setAttribute("returnReasons", OrderReturnReason.getCustomerReasons());
        request.setAttribute("orderReturn", orderReturn);
        if (orderReturn != null) {
            request.setAttribute("returnReasonLabel", OrderReturnReason.getLabel(orderReturn.getReasonCode()));
            request.setAttribute("returnStatusLabel", OrderReturnStatus.getReturnLabel(orderReturn.getReturnStatus()));
            request.setAttribute("refundStatusLabel", OrderReturnStatus.getRefundLabel(orderReturn.getRefundStatus()));
        }
        request.setAttribute("returnDeadline", returnDeadline == null
                ? ""
                : returnDeadline.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")));
    }

    private void syncGhnTracking(Order order, HttpServletRequest request) {
        String orderCode = trimToEmpty(order.getGhnOrderCode());
        if (orderCode.isBlank() || orderService.isDemoTrackingCode(orderCode)) {
            return;
        }

        try {
            var result = ghnOrderTrackingService.getOrderInfo(orderCode);
            LocalDateTime eventTime = result.eventTime() == null ? LocalDateTime.now() : result.eventTime();

            orderDao.updateGhnTrackingInfo(
                    order.getId(),
                    result.orderCode(),
                    result.statusCode(),
                    result.statusName(),
                    result.expectedDeliveryTime()
            );
            syncOrderStatusFromGhn(order, result.statusCode());

            trackingLogDao.insertIfStatusChanged(
                    order.getId(),
                    result.provider(),
                    result.orderCode(),
                    result.statusCode(),
                    result.statusName(),
                    result.description(),
                    eventTime
            );

            order.setGhnOrderCode(result.orderCode());
            order.setGhnStatus(result.statusCode());
            order.setGhnStatusName(result.statusName());
            order.setGhnExpectedDeliveryTime(result.expectedDeliveryTime());
            order.setGhnLastUpdatedAt(LocalDateTime.now());
        } catch (RuntimeException e) {
            request.setAttribute("trackingError", e.getMessage());
        }
    }

    private void syncOrderStatusFromGhn(Order order, String ghnStatusCode) {
        String syncedOrderStatus = ghnOrderTrackingService.resolveOrderStatus(ghnStatusCode, order.getOrderStatus());
        if (syncedOrderStatus == null || syncedOrderStatus.equals(order.getOrderStatus())) {
            return;
        }
        orderDao.updateOrderStatus(order.getId(), syncedOrderStatus);
        order.setOrderStatus(syncedOrderStatus);
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

    private String getOrderStatusLabel(String status) {
        return OrderStatusLabel.customerLabel(status);
    }

    private String getOrderStatusClass(String status) {
        return OrderStatusLabel.customerCssClass(status);
    }

    private String getPaymentMethodLabel(String paymentMethod) {
        if (PaymentMethod.VNPAY.equals(paymentMethod)) {
            return "VNPay";
        }
        return "COD";
    }

    private String getPaymentStatusLabel(String paymentStatus) {
        if (paymentStatus == null) {
            return "Không xác định";
        }
        return switch (paymentStatus) {
            case PaymentStatus.PAID -> "Đã thanh toán";
            case PaymentStatus.PENDING -> "Đang chờ thanh toán";
            case PaymentStatus.FAILED -> "Thanh toán thất bại";
            case PaymentStatus.UNPAID -> "Chưa thanh toán";
            case PaymentStatus.REFUND_PENDING -> "Chờ hoàn tiền";
            case PaymentStatus.REFUNDED -> "Đã hoàn tiền";
            default -> paymentStatus;
        };
    }

    private String trimToEmpty(String value) {
        return value == null ? "" : value.trim();
    }
}
