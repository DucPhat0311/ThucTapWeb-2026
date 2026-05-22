package controller.web;

import dao.user.CartItemDao;
import dao.user.PaymentTransactionDao;
import dao.user.ProductVariantDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import model.constant.PaymentMethod;
import model.constant.PaymentTransactionStatus;
import service.CheckoutService;
import service.OrderPlacementService;
import service.VnPayService;

import java.io.IOException;

@WebServlet(name = "PlaceOrderController", value = "/place-order")
public class PlaceOrderController extends HttpServlet {

    private CartItemDao cartItemDao;
    private PaymentTransactionDao paymentTransactionDao;
    private CheckoutService checkoutService;
    private OrderPlacementService orderPlacementService;
    private VnPayService vnPayService;

    @Override
    public void init() {
        cartItemDao = new CartItemDao();
        paymentTransactionDao = new PaymentTransactionDao();
        checkoutService = new CheckoutService();
        orderPlacementService = new OrderPlacementService();
        vnPayService = new VnPayService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

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
        Integer cartIdObj = (Integer) session.getAttribute("cartId");
        String[] variantIds = request.getParameterValues("variantIds");
        String[] quantities = request.getParameterValues("quantities");

        String note = trimToEmpty(request.getParameter("note"));
        String paymentMethod = trimToEmpty(request.getParameter("paymentMethod"));

        CheckoutService.PreparedCheckout preparedCheckout;
        CheckoutService.OrderPlacement orderPlacement;
        try {
            preparedCheckout = checkoutService.prepareOrder(user.getId(), cartIdObj, variantIds, quantities);
            orderPlacement = checkoutService.resolveOrderPlacement(paymentMethod);
        } catch (CheckoutService.CheckoutValidationException e) {
            handleCheckoutValidationError(e, session, response);
            return;
        }

        String shippingFeeStr = request.getParameter("shippingFee");
        double shippingFee = 0;
        shippingFee = Double.parseDouble(shippingFeeStr);
        double finalAmount = preparedCheckout.totalPrice() + shippingFee;

        int cartId = cartIdObj;
        int orderId;
        try {
            orderId = orderPlacementService.placeOrder(
                    user.getId(),
                    cartId,
                    preparedCheckout,
                    orderPlacement,
                    note,
                    shippingFee,
                    finalAmount
            );
        } catch (ProductVariantDao.InsufficientStockException e) {
            response.sendRedirect("checkout?error=out_of_stock");
            return;
        }

        if (PaymentMethod.VNPAY.equals(orderPlacement.paymentMethod())) {
            String txnRef = vnPayService.generateTxnRef(orderId);
            paymentTransactionDao.createInitiatedTransaction(
                    orderId,
                    PaymentMethod.VNPAY,
                    txnRef,
                    finalAmount,
                    PaymentTransactionStatus.INITIATED
            );

            String paymentUrl = vnPayService.buildPaymentUrl(new VnPayService.PaymentRequest(
                    txnRef,
                    finalAmount,
                    "Thanh toan don hang #" + orderId,
                    resolveClientIp(request),
                    null,
                    null,
                    null
            ));
            response.sendRedirect(paymentUrl);
            return;
        }

        int remainingCart = cartItemDao.countTotalQuantity(cartId);
        session.setAttribute("cartSize", remainingCart);
        session.setAttribute("lastOrderId", orderId);

        response.sendRedirect("order-success");
    }

    private void handleCheckoutValidationError(CheckoutService.CheckoutValidationException exception,
                                               HttpSession session,
                                               HttpServletResponse response) throws IOException {
        switch (exception.getError()) {
            case ADDRESS_REQUIRED -> {
                session.setAttribute("addressError", "Vui lòng thêm địa chỉ giao hàng trước khi đặt đơn.");
                response.sendRedirect("checkout");
            }
            case OUT_OF_STOCK -> response.sendRedirect("checkout?error=out_of_stock");
            case INVALID_PAYMENT_METHOD -> response.sendRedirect("checkout?error=invalid_payment_method");
            case CART_NOT_FOUND, EMPTY_SELECTION, INVALID_REQUEST -> response.sendRedirect("my-cart");
        }
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
