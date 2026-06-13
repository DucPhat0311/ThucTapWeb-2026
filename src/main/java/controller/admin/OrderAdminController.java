package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.constant.OrderStatus;
import model.constant.OrderStatusLabel;
import model.constant.PaymentMethod;
import model.constant.PaymentStatus;
import service.EmailService;
import service.OrderService;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet(name = "OrderAdminController", value = "/orderAdmin")
public class OrderAdminController extends HttpServlet {

    private OrderService orderService;

    @Override
    public void init() {
        orderService = new OrderService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        orderService.expirePendingPaymentOrders();

        req.setAttribute("orderStatusLabels", getOrderStatusLabels());
        req.setAttribute("paymentMethodLabels", getPaymentMethodLabels());
        req.setAttribute("paymentStatusLabels", getPaymentStatusLabels());

        String mode = req.getParameter("mode");

        if (mode == null) {
            int page = 1;
            int pageSize = 6;

            String pageParam = req.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    page = Integer.parseInt(pageParam);
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }

            var allOrders = orderService.getAllOrders();
            int totalOrders = allOrders.size();

            long pending = allOrders.stream()
                    .filter(o -> OrderStatus.PENDING.equals(o.getOrderStatus()))
                    .count();

            long pendingPayment = allOrders.stream()
                    .filter(o -> OrderStatus.PENDING_PAYMENT.equals(o.getOrderStatus()))
                    .count();

            long processing = allOrders.stream()
                    .filter(o -> OrderStatus.PROCESSING.equals(o.getOrderStatus()))
                    .count();

            long completed = allOrders.stream()
                    .filter(o -> OrderStatus.COMPLETED.equals(o.getOrderStatus()))
                    .count();

                long shipping = allOrders.stream()
                    .filter(o -> OrderStatus.SHIPPING.equals(o.getOrderStatus()))
                    .count();

                long cancelled = allOrders.stream()
                    .filter(o -> OrderStatus.CANCELLED.equals(o.getOrderStatus()))
                    .count();

            String status = req.getParameter("status");
            var filteredOrders = allOrders;
            if (status != null && !status.trim().isEmpty()) {
                String normalizedStatus = status.trim();
                if (getOrderStatusLabels().containsKey(normalizedStatus)) {
                    filteredOrders = allOrders.stream()
                            .filter(o -> normalizedStatus.equals(o.getOrderStatus()))
                            .collect(Collectors.toList());
                    req.setAttribute("currentStatus", normalizedStatus);
                }
            }

            int filteredTotal = filteredOrders.size();
            int totalPages = (int) Math.ceil((double) filteredTotal / pageSize);

            if (page < 1) {
                page = 1;
            }
            if (page > totalPages && totalPages > 0) {
                page = totalPages;
            }

            int start = (page - 1) * pageSize;
            int end = Math.min(start + pageSize, filteredTotal);
            var orders = filteredOrders.subList(start, end);

            req.setAttribute("orders", orders);
            req.setAttribute("total", totalOrders);
            req.setAttribute("totalOrders", filteredTotal);
            req.setAttribute("countPending", pending);
            req.setAttribute("countPendingPayment", pendingPayment);
            req.setAttribute("countProcessing", processing);
            req.setAttribute("countCompleted", completed);
            req.setAttribute("countShipping", shipping);
            req.setAttribute("countCancelled", cancelled);
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("pageSize", pageSize);

            req.setAttribute("page", "order");
            req.getRequestDispatcher("/WEB-INF/admin/orderAdmin.jsp").forward(req, resp);
            return;
        }

        if ("view".equals(mode)) {
            int id = Integer.parseInt(req.getParameter("id"));
            var order = orderService.findById(id);
            var trackingLogs = orderService.getTrackingLogs(id);
            req.setAttribute("order", order);
            req.setAttribute("items", orderService.getOrderItems(id));
            req.setAttribute("trackingLogs", trackingLogs);
            req.setAttribute("demoTrackingStatuses", orderService.getDemoTrackingStatusLabels());
            req.setAttribute("demoTracking", order != null && orderService.isDemoTrackingCode(order.getGhnOrderCode()));
            req.setAttribute("demoTrackingLocation", orderService.getLatestDemoTrackingLocation(trackingLogs));
            req.setAttribute("page", "order");
            req.getRequestDispatcher("/WEB-INF/admin/order-detailAdmin.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        orderService.expirePendingPaymentOrders();

        String action = req.getParameter("action");
        if ("createDemoTracking".equals(action)) {
            createDemoTracking(req, resp);
            return;
        }

        if ("updateDemoTracking".equals(action)) {
            updateDemoTracking(req, resp);
            return;
        }

        if ("createGhnOrder".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            resp.sendRedirect("orderAdmin?mode=view&id=" + id + "&error=ghn_disabled");
            return;
        }

        if (!"update".equals(action)) {
            return;
        }

        int id = Integer.parseInt(req.getParameter("id"));
        String orderAction = req.getParameter("orderAction");

        var order = orderService.findById(id);
        if (order == null) {
            resp.sendRedirect("orderAdmin");
            return;
        }

        String currentStatus = order.getOrderStatus();
        String paymentMethod = order.getPaymentMethods();
        String paymentStatus = order.getPaymentStatuses();

        if ("confirmRefund".equals(orderAction)) {
            if (!orderService.markRefunded(id)) {
                resp.sendRedirect("orderAdmin?mode=view&id=" + id + "&error=invalid_order_action");
                return;
            }
            resp.sendRedirect("orderAdmin?mode=view&id=" + id + "&success=refund_confirmed");
            return;
        }

        String newStatus = resolveNextStatus(orderAction, currentStatus);

        if (OrderStatus.COMPLETED.equals(currentStatus) || OrderStatus.CANCELLED.equals(currentStatus)) {
            resp.sendRedirect("orderAdmin?mode=view&id=" + id);
            return;
        }

        if (newStatus == null) {
            resp.sendRedirect("orderAdmin?mode=view&id=" + id + "&error=invalid_order_action");
            return;
        }

        boolean unpaidOnlineOrder = PaymentMethod.VNPAY.equals(paymentMethod)
                && !PaymentStatus.PAID.equals(paymentStatus);
        if (unpaidOnlineOrder && !OrderStatus.CANCELLED.equals(newStatus)) {
            resp.sendRedirect("orderAdmin?mode=view&id=" + id + "&error=unpaid_online_order");
            return;
        }

        if (OrderStatus.CANCELLED.equals(newStatus)) {
            var cancellationCheck = orderService.cancelAdminOrder(id);
            if (!cancellationCheck.cancellable()) {
                redirectWithMessage(resp, id, "cancel_not_allowed", cancellationCheck.message());
                return;
            }
        } else {
            orderService.updateStatus(id, newStatus);
        }

        String userEmail = orderService.getUserEmailByOrderId(id);

        EmailService.sendEmail(
                userEmail,
                "Cập nhật trạng thái đơn hàng #" + id,
                "Đơn hàng của bạn đã chuyển sang trạng thái: " + getOrderStatusLabel(newStatus)
        );

        resp.sendRedirect("orderAdmin?mode=view&id=" + id);
    }

    private String resolveNextStatus(String orderAction, String currentStatus) {
        if (orderAction == null || orderAction.isBlank()) {
            return null;
        }

        return switch (orderAction.trim()) {
            case "confirm" -> OrderStatus.PENDING.equals(currentStatus) ? OrderStatus.PROCESSING : null;
            case "cancel" -> isCancellableFromAdminAction(currentStatus) ? OrderStatus.CANCELLED : null;
            default -> null;
        };
    }

    private boolean isCancellableFromAdminAction(String currentStatus) {
        return OrderStatus.PENDING.equals(currentStatus)
                || OrderStatus.PENDING_PAYMENT.equals(currentStatus)
                || OrderStatus.PROCESSING.equals(currentStatus);
    }

    private void createDemoTracking(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        var order = orderService.findById(id);
        if (order == null) {
            resp.sendRedirect("orderAdmin");
            return;
        }

        boolean unpaidOnlineOrder = PaymentMethod.VNPAY.equals(order.getPaymentMethods())
                && !PaymentStatus.PAID.equals(order.getPaymentStatuses());
        if (unpaidOnlineOrder) {
            resp.sendRedirect("orderAdmin?mode=view&id=" + id + "&error=unpaid_online_order");
            return;
        }

        if (!orderService.canCreateGhnShippingOrder(order)) {
            resp.sendRedirect("orderAdmin?mode=view&id=" + id + "&error=demo_not_allowed");
            return;
        }

        try {
            orderService.createDemoTracking(id);
            resp.sendRedirect("orderAdmin?mode=view&id=" + id + "&success=demo_created");
        } catch (RuntimeException e) {
            String message = e.getMessage() == null ? "Không thể tạo hành trình mô phỏng." : e.getMessage();
            redirectWithMessage(resp, id, "demo_create_failed", message);
        }
    }

    private void updateDemoTracking(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        String trackingStatus = req.getParameter("trackingStatus");
        String location = req.getParameter("trackingLocation");

        try {
            orderService.updateDemoTracking(id, trackingStatus, location);
            resp.sendRedirect("orderAdmin?mode=view&id=" + id + "&success=demo_updated");
        } catch (RuntimeException e) {
            String message = e.getMessage() == null ? "Không thể cập nhật hành trình mô phỏng." : e.getMessage();
            redirectWithMessage(resp, id, "demo_update_failed", message);
        }
    }

    private void redirectWithMessage(HttpServletResponse resp, int id, String error, String message) throws IOException {
        resp.sendRedirect("orderAdmin?mode=view&id=" + id + "&error=" + error + "&message=" + URLEncoder.encode(message, StandardCharsets.UTF_8));
    }

    public static String getOrderStatusLabel(String status) {
        return OrderStatusLabel.adminLabel(status);
    }

    public static String getPaymentMethodLabel(String paymentMethod) {
        return getPaymentMethodLabels().getOrDefault(paymentMethod, paymentMethod);
    }

    public static String getPaymentStatusLabel(String paymentStatus) {
        return getPaymentStatusLabels().getOrDefault(paymentStatus, paymentStatus);
    }

    public static Map<String, String> getOrderStatusLabels() {
        return OrderStatusLabel.adminLabels();
    }

    public static Map<String, String> getPaymentMethodLabels() {
        return Map.of(
                PaymentMethod.COD, "Thanh toán khi nhận hàng",
                PaymentMethod.VNPAY, "VNPay"
        );
    }

    public static Map<String, String> getPaymentStatusLabels() {
        return Map.of(
                PaymentStatus.UNPAID, "Chưa thanh toán",
                PaymentStatus.PENDING, "Đang chờ thanh toán",
                PaymentStatus.PAID, "Đã thanh toán",
                PaymentStatus.FAILED, "Thanh toán thất bại",
                PaymentStatus.REFUND_PENDING, "Chờ hoàn tiền",
                PaymentStatus.REFUNDED, "Đã hoàn tiền"
        );
    }
}
