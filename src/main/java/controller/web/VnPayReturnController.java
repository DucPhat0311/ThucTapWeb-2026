package controller.web;

import dao.user.CartItemDao;
import dao.user.OrderDao;
import dao.user.OrderItemDao;
import dao.user.PaymentTransactionDao;
import dao.user.ProductVariantDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Order;
import model.OrderItem;
import model.constant.OrderStatus;
import model.constant.PaymentStatus;
import model.constant.PaymentTransactionStatus;
import service.VnPayService;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "VnPayReturnController", value = "/vnpay-return")
public class VnPayReturnController extends HttpServlet {
    private static final String VNPAY_SUCCESS_CODE = "00";

    private VnPayService vnPayService;
    private PaymentTransactionDao paymentTransactionDao;
    private OrderDao orderDao;
    private OrderItemDao orderItemDao;
    private ProductVariantDao productVariantDao;
    private CartItemDao cartItemDao;

    @Override
    public void init() {
        vnPayService = new VnPayService();
        paymentTransactionDao = new PaymentTransactionDao();
        orderDao = new OrderDao();
        orderItemDao = new OrderItemDao();
        productVariantDao = new ProductVariantDao();
        cartItemDao = new CartItemDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userlogin") == null) {
            response.sendRedirect("login");
            return;
        }

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

        if (VNPAY_SUCCESS_CODE.equals(responseCode)) {
            if (!PaymentStatus.PAID.equals(order.getPaymentStatuses())) {
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

                finalizePaidOrder(orderId, session);
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
        orderDao.updatePaymentAndOrderStatus(
                orderId,
                PaymentStatus.FAILED,
                OrderStatus.PENDING_PAYMENT
        );
        response.sendRedirect("checkout?error=payment_failed");
    }

    private void finalizePaidOrder(int orderId, HttpSession session) {
        Integer cartId = (Integer) session.getAttribute("cartId");
        List<OrderItem> orderItems = orderItemDao.getByOrderId(orderId);

        for (OrderItem orderItem : orderItems) {
            productVariantDao.decreaseStock(orderItem.getVariantId(), orderItem.getQuantity());
            if (cartId != null) {
                cartItemDao.delete(cartId, orderItem.getVariantId());
            }
        }

        if (cartId != null) {
            int remainingCart = cartItemDao.countTotalQuantity(cartId);
            session.setAttribute("cartSize", remainingCart);
        }
    }

    private String trimToEmpty(String value) {
        return value == null ? "" : value.trim();
    }
}
