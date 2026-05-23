package controller.cart;


import dao.user.CartItemDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.CartItem;
import model.User;


import java.io.IOException;
import java.util.ArrayList;
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
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userlogin");
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        Integer cartId = (Integer) session.getAttribute("cartId");

        if (cartId == null) {
            cartId = cartItemDao.getCartIdByUserId(user.getId());
            if (cartId != null) {
                session.setAttribute("cartId", cartId);
            }
        }

        List<CartItem> items;
        if (cartId != null) {
            items = cartItemDao.getItemsByCartId(cartId);

            int total = cartItemDao.countTotalQuantity(cartId);
            session.setAttribute("cartSize", total);


        } else {
            items = new ArrayList<>();
            session.setAttribute("cartSize", 0);
        }

        request.setAttribute("cartItems", items);
        request.getRequestDispatcher("/WEB-INF/views/cart.jsp").forward(request, response);
    }


}

