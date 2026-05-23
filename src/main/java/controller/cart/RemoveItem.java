package controller.cart;


import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import dao.user.CartItemDao;
import java.io.IOException;


@WebServlet(name = "RemoveItem", value = "/del-item")
public class RemoveItem extends HttpServlet {
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
            cartItemDao.delete(cartId, variantId);
            int cartSize = cartItemDao.countTotalQuantity(cartId);
            session.setAttribute("cartSize", cartSize);
            response.getWriter().write("{\"success\": true, \"cartSize\": " + cartSize + "}");


        } catch (Exception e) {
            response.getWriter().write("{\"success\": false, \"message\": \"Dữ liệu không hợp lệ\"}");
        }
    }
}

