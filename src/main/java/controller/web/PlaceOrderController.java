package controller.web;

import dao.user.CartItemDao;
import dao.user.OrderDao;
import dao.user.OrderItemDao;
import dao.user.ProductVariantDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import service.CheckoutService;

import java.io.IOException;

@WebServlet(name = "PlaceOrderController", value = "/place-order")
public class PlaceOrderController extends HttpServlet {

    private OrderDao orderDao;
    private OrderItemDao orderItemDao;
    private CartItemDao cartItemDao;
    private ProductVariantDao variantDao;
    private CheckoutService checkoutService;

    @Override
    public void init() {
        orderDao = new OrderDao();
        orderItemDao = new OrderItemDao();
        cartItemDao = new CartItemDao();
        variantDao = new ProductVariantDao();
        checkoutService = new CheckoutService();
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

        int cartId = cartIdObj;
        int orderId = orderDao.createOrder(
                user.getId(),
                preparedCheckout.recipientName(),
                preparedCheckout.recipientPhone(),
                preparedCheckout.shippingAddress(),
                note,
                orderPlacement.paymentMethod(),
                orderPlacement.paymentStatus(),
                orderPlacement.orderStatus(),
                preparedCheckout.totalPrice()
        );

        for (CheckoutService.PreparedOrderItem item : preparedCheckout.items()) {
            var variantDetail = item.variantDetail();

            orderItemDao.insert(
                    orderId,
                    variantDetail.getProductId(),
                    item.variantId(),
                    variantDetail.getSizeName(),
                    variantDetail.getColorName(),
                    item.quantity(),
                    item.unitPrice(),
                    item.lineTotal()
            );
            variantDao.decreaseStock(item.variantId(), item.quantity());
            cartItemDao.delete(cartId, item.variantId());
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

    private String trimToEmpty(String value) {
        return value == null ? "" : value.trim();
    }
}
