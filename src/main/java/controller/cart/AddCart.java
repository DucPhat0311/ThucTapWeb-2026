package controller.cart;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import dao.user.CartItemDao;
import dao.user.ProductVariantDao;

@WebServlet(name = "AddCart", value = "/add-cart")
public class AddCart extends HttpServlet {

    private CartItemDao cartItemDao = new CartItemDao();
    private ProductVariantDao variantDao = new ProductVariantDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();

        Integer cartId = (Integer) session.getAttribute("cartId");
        if (cartId == null) {
            response.getWriter().write("{\"error\":\"not_logged_in\"}");
            return;
        }

        try {
            int variantId = Integer.parseInt(request.getParameter("variantId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            int stock = variantDao.getStockByVariantId(variantId);
            int currentQty = cartItemDao.getQuantityByVariant(cartId, variantId);

            int remain = stock - currentQty;

            if (remain <= 0) {
                response.getWriter().write(
                        "{\"success\":false,\"message\":\"Sản phẩm đã hết hàng\",\"remain\":0}"
                );
                return;
            }

            if (quantity > remain) {
                response.getWriter().write(
                        "{\"success\":false,\"message\":\"Bạn chỉ có thể thêm tối đa " + remain + " sản phẩm\",\"remain\":" + remain + "}"
                );
                return;
            }

            double price = variantDao.getPriceByVariantId(variantId);
            int productId = variantDao.getProductIdByVariantId(variantId);

            cartItemDao.addOrUpdate(cartId, variantId, productId, quantity, price);

            int total = cartItemDao.countTotalQuantity(cartId);
            session.setAttribute("cartSize", total);

            response.getWriter().write(
                    "{\"success\":true,\"totalQuantity\":" + total + "}"
            );

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write(
                    "{\"success\":false,\"message\":\"Lỗi server\"}"
            );
        }
    }
}