package controller.web;

import dao.user.CartItemDao;
import model.CartItem;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "CheckoutController", value = "/checkout")
public class CheckoutController extends HttpServlet {

    private CartItemDao cartItemDao;

    @Override
    public void init() {
        cartItemDao = new CartItemDao();
    }



    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String[] selectedIds = req.getParameterValues("selectedIds");

        if (selectedIds == null || selectedIds.length == 0) {
            resp.sendRedirect("my-cart");
            return;
        }

        HttpSession session = req.getSession();
        Integer cartId = (Integer) session.getAttribute("cartId");

        List<CartItem> allItems = cartItemDao.getItemsByCartId(cartId);
        List<CartItem> checkoutItems = new ArrayList<>();

        for (String idStr : selectedIds) {
            int id = Integer.parseInt(idStr);
            for (CartItem item : allItems) {
                if (item.getVariantId() == id) {
                    checkoutItems.add(item); // chỉ add nhứng thứu đã chọn
                    break;
                }
            }
        }

        req.setAttribute("checkoutItems", checkoutItems);
        System.out.println(checkoutItems.toString());
        req.getRequestDispatcher("/WEB-INF/views/checkout.jsp").forward(req, resp);
    }
}

