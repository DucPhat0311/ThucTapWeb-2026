package controller.cart;

import dao.user.CartItemDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "UpdateCart", value = "/update-cart")
public class UpdateCart extends HttpServlet {
    private CartItemDao cartItemDao;

    @Override
    public void init() {
        cartItemDao = new CartItemDao();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("cartId") == null) {
            response.getWriter().write("{\"error\": \"not_logged_in\"}");
            return;
        }

        int cartId = (Integer) session.getAttribute("cartId");

        try {
            int variantId = Integer.parseInt(request.getParameter("variantId"));
            int quantity  = Integer.parseInt(request.getParameter("quantity"));

            if (quantity <= 0) {
                cartItemDao.delete(cartId, variantId);
            } else {
                cartItemDao.updateQuantity(cartId, variantId, quantity);
            }

            int cartSize = cartItemDao.countTotalQuantity(cartId);
            session.setAttribute("cartSize", cartSize);

            response.getWriter().write("{\"success\": true, \"cartSize\": " + cartSize + "}");


        } catch (Exception e) {
            response.getWriter().write("{\"success\": false, \"message\": \"Dữ liệu không hợp lệ\"}");
        }
    }
}
