package controller.web;

import dao.user.CartItemDao;
import dao.user.OrderDao;
import dao.user.OrderItemDao;
import dao.user.ProductVariantDao;
import model.CartItem;
import model.ProductVariant;
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

        String[] variantIds = request.getParameterValues("variantIds");
        String[] quantities = request.getParameterValues("quantities");

        if (variantIds == null || variantIds.length == 0) {
            response.sendRedirect("my-cart");
            return;
        }

        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String note = request.getParameter("note");
        String paymentMethod = request.getParameter("paymentMethod");

        double totalPrice = 0;
        for (int i = 0; i < variantIds.length; i++) {
            int variantId = Integer.parseInt(variantIds[i]);
            int qty = Integer.parseInt(quantities[i]);

            int stock = variantDao.getStockByVariantId(variantId);
            if (stock < qty) {
                response.sendRedirect("checkout?error=out_of_stock");
                return;
            }
            double price = variantDao.getPriceByVariantId(variantId);
            totalPrice += price * qty;
        }

        int orderId = orderDao.createOrder(user.getId(), name, phone, address, note, paymentMethod, totalPrice);

        for (int i = 0; i < variantIds.length; i++) {
            int variantId = Integer.parseInt(variantIds[i]);
            int qty = Integer.parseInt(quantities[i]);

            var varientDetail = variantDao.getVariantDetails(variantId);
            double price = variantDao.getPriceByVariantId(variantId);

            orderItemDao.insert(
                    orderId,
                    varientDetail.getProductId(),
                    variantId,
                    varientDetail.getSizeName(),
                    varientDetail.getColorName(),
                    qty,
                    price,
                    price * qty
            );
            // xoa stock
            variantDao.decreaseStock(variantId, qty);

            // xoa cart
            cartItemDao.delete(cartId, variantId);
        }


        int remainingCart = cartItemDao.countTotalQuantity(cartId);
        session.setAttribute("cartSize", remainingCart);
        session.setAttribute("lastOrderId", orderId);

        response.sendRedirect("order-success");
    }
}

