package controller.web;

import dao.user.CartItemDao;
import dao.user.OrderDao;
import dao.user.OrderItemDao;
import dao.user.ProductVariantDao;
import model.CartItem;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "PlaceOrderController", value = "/place-order")
public class PlaceOrderController extends HttpServlet {

    private OrderDao orderDao;
    private OrderItemDao orderItemDao;
    private CartItemDao cartItemDao;
    private ProductVariantDao variantDao;

    @Override
    public void init() {
        orderDao = new OrderDao();
        orderItemDao = new OrderItemDao();
        cartItemDao = new CartItemDao();
        variantDao = new ProductVariantDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userlogin") == null) {
            response.sendRedirect("login");
            return;
        }

        User user = (User) session.getAttribute("userlogin");

        Integer cartIdObj = (Integer) session.getAttribute("cartId");
        if (cartIdObj == null) {
            response.sendRedirect("my-cart");
            return;
        }
        int cartId = cartIdObj;

        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String note = request.getParameter("note");
        String paymentMethod = request.getParameter("paymentMethod");

        if (name == null || phone == null || address == null) {
            response.sendRedirect("checkout");
            return;
        }
        List<CartItem> cartItems = cartItemDao.getItemsByCartId(cartId);
        if (cartItems.isEmpty()) {
            response.sendRedirect("my-cart");
            return;
        }

        for (CartItem item : cartItems) {
            int stock = variantDao.getStockByVariantId(item.getVariantId());
            if (stock < item.getQuantity()) {
                response.sendRedirect("checkout?error=out_of_stock");
                return;
            }
        }

        double totalPrice = 0;
        for (CartItem item : cartItems) {
            totalPrice += item.getPrice() * item.getQuantity();
        }

        int orderId = orderDao.createOrder(
                user.getId(),
                name,
                phone,
                address,
                note,
                paymentMethod,
                totalPrice
        );

        for (CartItem item : cartItems) {
            int variantId = item.getVariantId();
            int qty = item.getQuantity();
            double price = item.getPrice();

            orderItemDao.insert(
                    orderId,
                    variantId,
                    item.getProduct().getName(),
                    item.getSize(),
                    item.getColor(),
                    qty,
                    price,
                    price * qty
            );

            variantDao.decreaseStock(variantId, qty);
        }

        cartItemDao.clearCart(cartId);

        session.setAttribute("cartSize", 0);
        session.setAttribute("lastOrderId", orderId);
        response.sendRedirect("order-success");
    }
}

