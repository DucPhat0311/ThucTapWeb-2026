package controller.web;

import dao.user.CartItemDao;
import dao.user.PaymentTransactionDao;
import dao.user.ProductDao;
import dao.user.ProductVariantDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Product;
import model.User;
import model.constant.PaymentMethod;
import model.constant.PaymentTransactionStatus;
import service.CheckoutService;
import service.OrderPlacementService;
import service.VnPayService;

import java.io.IOException;
import java.time.DateTimeException;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;

@WebServlet(name = "PlaceOrderController", value = "/place-order")
public class PlaceOrderController extends HttpServlet {
    private static final int TRANSIENT_CHECKOUT_CART_ID = -1;
    private static final String BUY_NOW_ITEM = "buyNowItem";
    private static final String REORDER_CHECKOUT_ITEMS = "reorderCheckoutItems";
    private static final String CHECKOUT_SELECTED_IDS = "checkoutSelectedIds";

    private CartItemDao cartItemDao;
    private PaymentTransactionDao paymentTransactionDao;
    private CheckoutService checkoutService;
    private OrderPlacementService orderPlacementService;
    private VnPayService vnPayService;
    private ProductDao productDao;

    @Override
    public void init() {
        cartItemDao = new CartItemDao();
        paymentTransactionDao = new PaymentTransactionDao();
        checkoutService = new CheckoutService();
        orderPlacementService = new OrderPlacementService();
        vnPayService = new VnPayService();
        productDao = new ProductDao();
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
        boolean transientCheckout = isTransientCheckout(session);
        Integer checkoutCartId = transientCheckout && cartIdObj == null ? TRANSIENT_CHECKOUT_CART_ID : cartIdObj;
        String[] variantIds = request.getParameterValues("variantIds");
        String[] quantities = request.getParameterValues("quantities");

        String note = trimToEmpty(request.getParameter("note"));
        String paymentMethod = trimToEmpty(request.getParameter("paymentMethod"));

        CheckoutService.PreparedCheckout preparedCheckout;
        CheckoutService.OrderPlacement orderPlacement;
        try {
            preparedCheckout = checkoutService.prepareOrder(user.getId(), checkoutCartId, variantIds, quantities);
            orderPlacement = checkoutService.resolveOrderPlacement(paymentMethod);

            if (preparedCheckout != null && preparedCheckout.items() != null) {
                for (CheckoutService.PreparedOrderItem item : preparedCheckout.items()) {
                    if (item.variantDetail() != null) {
                        int productId = item.variantDetail().getProductId();
                        Product product = productDao.findById(productId);
                        if (product == null || !"Đang hoạt động".equals(product.getStatus())) {
                            request.setAttribute("checkoutError", "Đơn hàng chứa sản phẩm đã ngừng kinh doanh. Vui lòng quay lại giỏ hàng.");
                            request.getRequestDispatcher("/checkout").forward(request, response);
                            return;
                        }
                    }
                }
            }

        } catch (CheckoutService.CheckoutValidationException e) {
            handleCheckoutValidationError(e, session, response);
            return;
        }

        String shippingFeeStr = request.getParameter("shippingFee");
        double shippingFee = 0;
        shippingFee = Double.parseDouble(shippingFeeStr);
        double finalAmount = preparedCheckout.totalPrice() + shippingFee;
        LocalDateTime expectedDeliveryTime = parseExpectedDeliveryTime(
                request.getParameter("expectedDeliveryEpochSeconds")
        );

        int cartId = transientCheckout ? TRANSIENT_CHECKOUT_CART_ID : checkoutCartId;
        int orderId;
        try {
            orderId = orderPlacementService.placeOrder(
                    user.getId(),
                    cartId,
                    preparedCheckout,
                    orderPlacement,
                    note,
                    shippingFee,
                    finalAmount,
                    expectedDeliveryTime
            );
        } catch (ProductVariantDao.InsufficientStockException e) {
            response.sendRedirect("checkout?error=out_of_stock");
            return;
        }

        clearTransientCheckout(session);

        int remainingCart = cartIdObj == null ? 0 : cartItemDao.countTotalQuantity(cartIdObj);
        session.setAttribute("cartSize", remainingCart);

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

        session.setAttribute("lastOrderId", orderId);

        response.sendRedirect("order-success");
    }

    private boolean isTransientCheckout(HttpSession session) {
        return session.getAttribute(BUY_NOW_ITEM) != null
                || session.getAttribute(REORDER_CHECKOUT_ITEMS) != null;
    }

    private void clearTransientCheckout(HttpSession session) {
        session.removeAttribute(BUY_NOW_ITEM);
        session.removeAttribute(REORDER_CHECKOUT_ITEMS);
        session.removeAttribute(CHECKOUT_SELECTED_IDS);
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

    private LocalDateTime parseExpectedDeliveryTime(String epochSeconds) {
        String normalizedEpochSeconds = trimToEmpty(epochSeconds);
        if (normalizedEpochSeconds.isBlank()) {
            return null;
        }
        try {
            return Instant.ofEpochSecond(Long.parseLong(normalizedEpochSeconds))
                    .atZone(ZoneId.of("Asia/Ho_Chi_Minh"))
                    .toLocalDateTime();
        } catch (NumberFormatException | DateTimeException e) {
            return null;
        }
    }
}
