package controller.web;

import dao.user.CartItemDao;
import dao.user.OrderDao;
import dao.user.OrderItemDao;
import dao.user.ProductVariantDao;
import model.Address;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import service.AddressService;

import java.io.IOException;

@WebServlet(name = "PlaceOrderController", value = "/place-order")
public class PlaceOrderController extends HttpServlet {

    private OrderDao orderDao;
    private OrderItemDao orderItemDao;
    private CartItemDao cartItemDao;
    private ProductVariantDao variantDao;
    private AddressService addressService;

    @Override
    public void init() {
        orderDao = new OrderDao();
        orderItemDao = new OrderItemDao();
        cartItemDao = new CartItemDao();
        variantDao = new ProductVariantDao();
        addressService = new AddressService();
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

        String note = trimToEmpty(request.getParameter("note"));
        String paymentMethod = trimToEmpty(request.getParameter("paymentMethod"));
        Address shippingAddress = addressService.getPrimaryByUser(user.getId());
        if (shippingAddress == null) {
            session.setAttribute("addressError", "Vui lòng thêm địa chỉ giao hàng trước khi đặt đơn.");
            response.sendRedirect("checkout");
            return;
        }

        String name = trimToEmpty(shippingAddress.getName());
        String phone = trimToEmpty(shippingAddress.getPhone());
        String address = trimToEmpty(formatAddress(shippingAddress));

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

    private String trimToEmpty(String value) {
        return value == null ? "" : value.trim();
    }

    private String formatAddress(Address address) {
        return String.join(", ",
                trimToEmpty(address.getDetailAddress()),
                trimToEmpty(address.getWard()),
                trimToEmpty(address.getDistrict()),
                trimToEmpty(address.getCity()));
    }
}

