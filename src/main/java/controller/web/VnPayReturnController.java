package controller.web;

import dao.user.CartItemDao;
import dao.user.OrderDao;
import dao.user.PaymentTransactionDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Order;
import model.constant.OrderStatus;
import model.constant.PaymentStatus;
import model.constant.PaymentTransactionStatus;
import service.OrderService;
import service.EmailService;
import dao.user.NotificationDao;
import service.VnPayService;

import java.io.IOException;
import java.util.Map;

public class VnPayReturnController extends HttpServlet {
    private static final String VNPAY_SUCCESS_CODE = "00";

    private VnPayService vnPayService;
    private PaymentTransactionDao paymentTransactionDao;
    private OrderDao orderDao;
    private CartItemDao cartItemDao;
    private OrderService orderService;

    @Override
    public void init() {
        vnPayService = new VnPayService();
        paymentTransactionDao = new PaymentTransactionDao();
        orderDao = new OrderDao();
        cartItemDao = new CartItemDao();
        orderService = new OrderService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        Map<String, String> vnpParams = vnPayService.extractVnPayParams(request.getParameterMap());
        if (!vnPayService.verifySignature(vnpParams)) {
            response.sendRedirect("checkout?error=invalid_payment_signature");
            return;
        }

        String txnRef = trimToEmpty(vnpParams.get("vnp_TxnRef"));
        Integer orderId = paymentTransactionDao.findOrderIdByTxnRef(txnRef);
        if (orderId == null) {
            response.sendRedirect("checkout?error=payment_not_found");
            return;
        }

        Order order = orderDao.getById(orderId);
        if (order == null) {
            response.sendRedirect("checkout?error=payment_not_found");
            return;
        }

        String responseCode = trimToEmpty(vnpParams.get("vnp_ResponseCode"));
        String transactionNo = trimToEmpty(vnpParams.get("vnp_TransactionNo"));
        String bankCode = trimToEmpty(vnpParams.get("vnp_BankCode"));
        String transactionStatus = paymentTransactionDao.findTransactionStatusByTxnRef(txnRef);

        if (!PaymentStatus.PAID.equals(order.getPaymentStatuses()) && orderService.expirePendingPaymentOrder(orderId)) {
            paymentTransactionDao.updatePaymentResult(
                    txnRef,
                    transactionNo,
                    bankCode,
                    responseCode,
                    PaymentTransactionStatus.FAILED
            );
            prepareExpiredPaymentSession(session, orderId);
            response.sendRedirect("payment-failed");
            return;
        }

        if (PaymentTransactionStatus.SUCCESS.equals(transactionStatus) || PaymentStatus.PAID.equals(order.getPaymentStatuses())) {
            session.setAttribute("lastOrderId", orderId);
            response.sendRedirect("order-success");
            return;
        }

        if (VNPAY_SUCCESS_CODE.equals(responseCode)) {
            paymentTransactionDao.updatePaymentResult(
                    txnRef,
                    transactionNo,
                    bankCode,
                    responseCode,
                    PaymentTransactionStatus.SUCCESS
            );

            orderDao.updatePaymentAndOrderStatus(
                    orderId,
                    PaymentStatus.PAID,
                    OrderStatus.PENDING
            );

            finalizePaidOrder(order, session);

            try {
                String userEmail = orderService.getUserEmailByOrderId(orderId);
                String customerName = order.getName() == null || order.getName().isBlank() ? "Bạn" : order.getName();
                String subject = "Thanh toán thành công cho đơn hàng #" + orderId;
                String content = "<p>Chào " + customerName + ",</p>"
                        + "<p>Thanh toán cho đơn hàng <strong>#" + orderId + "</strong> đã được xác nhận thành công.</p>"
                        + "<p>Số tiền: <strong>" + String.format("%,.0f", order.getFinalAmount()) + " VND</strong></p>"
                        + "<p>Cảm ơn bạn đã thanh toán. Đơn hàng đang trong quá trình xử lý.</p>"
                        + "<p>Trân trọng,<br/>AURA Studio</p>";
                if (userEmail != null && !userEmail.isBlank()) {
                    try {
                        EmailService.sendEmail(userEmail, subject, content);
                    } catch (RuntimeException e) {
                        e.printStackTrace();
                    }
                    try {
                        NotificationDao nd = new NotificationDao();
                        String title = "Thanh toán thành công #" + orderId;
                        String message = "Thanh toán cho đơn hàng của bạn đã thành công. Mã đơn: #" + orderId;
                        String url = request.getContextPath() + "/order-user?orderId=" + orderId;
                        nd.createNotification(order.getUserId(), title, message, url);
                    } catch (Exception ignored) {

                    }
                }


            } catch (Exception ignored) {
            }

            session.setAttribute("lastOrderId", orderId);
            response.sendRedirect("order-success");
            return;
        }

        paymentTransactionDao.updatePaymentResult(
                txnRef,
                transactionNo,
                bankCode,
                responseCode,
                PaymentTransactionStatus.FAILED
        );
        if (!PaymentStatus.PAID.equals(order.getPaymentStatuses())) {
            orderDao.updatePaymentAndOrderStatus(
                    orderId,
                    PaymentStatus.FAILED,
                    OrderStatus.PENDING_PAYMENT
            );
        }
        prepareFailedPaymentSession(session, orderId, responseCode);
        response.sendRedirect("payment-failed");
    }

    private void finalizePaidOrder(Order order, HttpSession session) {
        Integer cartId = (Integer) session.getAttribute("cartId");
        if (cartId == null) {
            cartId = cartItemDao.getCartIdByUserId(order.getUserId());
        }

        if (cartId != null) {
            int remainingCart = cartItemDao.countTotalQuantity(cartId);
            session.setAttribute("cartSize", remainingCart);
        }
    }

    private String trimToEmpty(String value) {
        return value == null ? "" : value.trim();
    }

    private void prepareFailedPaymentSession(HttpSession session, int orderId, String responseCode) {
        session.setAttribute("failedOrderId", orderId);
        if ("24".equals(responseCode)) {
            session.setAttribute("failedTitle", "Bạn đã hủy thanh toán");
            session.setAttribute("failedMessage", "Đơn hàng của bạn vẫn đang chờ thanh toán. Bạn có thể thử thanh toán lại hoặc xem lại trong danh sách đơn hàng.");
            return;
        }
        session.setAttribute("failedTitle", "Thanh toán không thành công");
        session.setAttribute("failedMessage", "VNPay chưa ghi nhận thanh toán thành công cho đơn hàng này. Bạn có thể thử thanh toán lại hoặc chọn phương thức khác.");
    }

    private void prepareExpiredPaymentSession(HttpSession session, int orderId) {
        session.setAttribute("failedOrderId", orderId);
        session.setAttribute("failedTitle", "Đơn hàng đã quá hạn thanh toán");
        session.setAttribute("failedMessage", "Đơn VNPay đã quá thời gian giữ hàng và đã được hoàn tồn kho.");
    }
}
