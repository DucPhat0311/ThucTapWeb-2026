package controller.cart;

import dao.user.CartItemDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.CartItem;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "MyCart", value = "/my-cart")
public class MyCart extends HttpServlet {
    private CartItemDao cartItemDao;

    @Override
    public void init() {
        cartItemDao = new CartItemDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("cartId") == null) {
            response.sendRedirect("login");
            return;
        }

        Integer cartId = (Integer) session.getAttribute("cartId");

        List<CartItem> items = cartItemDao.getItemsByCartId(cartId);
        request.setAttribute("cartItems", items);

        request.getRequestDispatcher("/WEB-INF/views/cart.jsp").forward(request, response);
    }

}
