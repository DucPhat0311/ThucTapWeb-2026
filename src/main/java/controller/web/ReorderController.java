package controller.web;

import dao.user.OrderDao;
import dao.user.OrderItemDao;
import dao.user.ProductDao;
import dao.user.ProductVariantDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.CartItem;
import model.Order;
import model.OrderItem;
import model.Product;
import model.ProductVariant;
import model.User;
import model.constant.OrderStatus;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "ReorderController", value = "/reorder")
public class ReorderController extends HttpServlet {
    private static final String REORDER_CHECKOUT_ITEMS = "reorderCheckoutItems";
    private static final String BUY_NOW_ITEM = "buyNowItem";
    private static final String CHECKOUT_SELECTED_IDS = "checkoutSelectedIds";

    private OrderDao orderDao;
    private OrderItemDao orderItemDao;
    private ProductDao productDao;
    private ProductVariantDao productVariantDao;

    @Override
    public void init() {
        orderDao = new OrderDao();
        orderItemDao = new OrderItemDao();
        productDao = new ProductDao();
        productVariantDao = new ProductVariantDao();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userlogin") == null) {
            response.sendRedirect("login");
            return;
        }

        User user = (User) session.getAttribute("userlogin");
        Integer orderId = parseOrderId(request.getParameter("orderId"));
        if (orderId == null) {
            response.sendRedirect("order-user?reorder=invalid");
            return;
        }

        Order order = orderDao.getById(orderId);
        if (order == null || order.getUserId() != user.getId()) {
            response.sendRedirect("order-user?reorder=invalid");
            return;
        }

        if (!isReorderable(order.getOrderStatus())) {
            response.sendRedirect("order-user?reorder=not_reorderable");
            return;
        }

        List<OrderItem> orderItems = orderItemDao.getByOrderId(orderId);
        if (orderItems.isEmpty()) {
            response.sendRedirect("order-user?status=CANCELLED&reorder=invalid");
            return;
        }

        List<CartItem> checkoutItems = new ArrayList<>();
        for (OrderItem orderItem : orderItems) {
            CartItem checkoutItem = buildCheckoutItem(orderItem);
            if (checkoutItem == null) {
                response.sendRedirect("order-user?status=CANCELLED&reorder=unavailable");
                return;
            }

            if (productVariantDao.getStockByVariantId(orderItem.getVariantId()) < orderItem.getQuantity()) {
                response.sendRedirect("order-user?status=CANCELLED&reorder=out_of_stock");
                return;
            }

            checkoutItems.add(checkoutItem);
        }

        session.setAttribute(REORDER_CHECKOUT_ITEMS, checkoutItems);
        session.removeAttribute(BUY_NOW_ITEM);
        session.removeAttribute(CHECKOUT_SELECTED_IDS);

        response.sendRedirect("checkout");
    }

    private CartItem buildCheckoutItem(OrderItem orderItem) {
        ProductVariant variant = productVariantDao.getVariantDetails(orderItem.getVariantId());
        if (variant == null || orderItem.getQuantity() <= 0) {
            return null;
        }

        Product product = productDao.findById(variant.getProductId());
        if (product == null || !isProductAvailable(product)) {
            return null;
        }

        CartItem checkoutItem = new CartItem();
        checkoutItem.setVariantId(orderItem.getVariantId());
        checkoutItem.setQuantity(orderItem.getQuantity());
        checkoutItem.setPrice(productVariantDao.getPriceByVariantId(orderItem.getVariantId()));
        checkoutItem.setSize(variant.getSizeName());
        checkoutItem.setColor(variant.getColorName());
        checkoutItem.setProduct(product);
        return checkoutItem;
    }

    private boolean isProductAvailable(Product product) {
        String status = product.getStatus();
        return status == null || !"Đã xoá".equalsIgnoreCase(status.trim());
    }

    private boolean isReorderable(String orderStatus) {
        return OrderStatus.CANCELLED.equals(orderStatus) || OrderStatus.COMPLETED.equals(orderStatus);
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
}
