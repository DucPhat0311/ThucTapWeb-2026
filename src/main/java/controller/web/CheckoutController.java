package controller.web;

import dao.user.CartItemDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Address;
import model.CartItem;
import model.User;
import service.AddressService;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "CheckoutController", value = "/checkout")
public class CheckoutController extends HttpServlet {
    private static final String CHECKOUT_SELECTED_IDS = "checkoutSelectedIds";

    private CartItemDao cartItemDao;
    private AddressService addressService;

    @Override
    public void init() {
        cartItemDao = new CartItemDao();
        addressService = new AddressService();
    }



    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userlogin") == null) {
            response.sendRedirect("login");
            return;
        }

        String[] selectedIds = (String[]) session.getAttribute(CHECKOUT_SELECTED_IDS);
        if (selectedIds == null || selectedIds.length == 0) {
            response.sendRedirect("my-cart");
            return;
        }

        renderCheckout(request, response, session, selectedIds);
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
        session.setAttribute(CHECKOUT_SELECTED_IDS, selectedIds);
        renderCheckout(req, resp, session, selectedIds);
    }

    private void renderCheckout(HttpServletRequest req, HttpServletResponse resp, HttpSession session, String[] selectedIds)
            throws ServletException, IOException {
        Integer cartId = (Integer) session.getAttribute("cartId");
        User user = (User) session.getAttribute("userlogin");

        if (cartId == null || user == null) {
            resp.sendRedirect("my-cart");
            return;
        }

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

        if (checkoutItems.isEmpty()) {
            resp.sendRedirect("my-cart");
            return;
        }

        Address selectedAddress = addressService.getPrimaryByUser(user.getId());
        moveFlashMessageToRequest(session, req);

        req.setAttribute("selectedAddress", selectedAddress);
        req.setAttribute("checkoutItems", checkoutItems);
        req.getRequestDispatcher("/WEB-INF/views/checkout.jsp").forward(req, resp);
    }

    private void moveFlashMessageToRequest(HttpSession session, HttpServletRequest req) {
        Object addressError = session.getAttribute("addressError");
        if (addressError != null) {
            req.setAttribute("addressError", addressError);
            session.removeAttribute("addressError");
        }
    }
}

