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
    private static final String BUY_NOW_ITEM = "buyNowItem";
    private static final String REORDER_CHECKOUT_ITEMS = "reorderCheckoutItems";

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

        // check phải luồng mua ngay ko
        if (session.getAttribute(BUY_NOW_ITEM) != null || session.getAttribute(REORDER_CHECKOUT_ITEMS) != null) {
            renderCheckout(request, response, session, null);
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

        HttpSession session = req.getSession();
        String[] selectedIds = req.getParameterValues("selectedIds");


        if (selectedIds == null || selectedIds.length == 0) {
            resp.sendRedirect("my-cart");
            return;
        }


        session.setAttribute(CHECKOUT_SELECTED_IDS, selectedIds);
        session.removeAttribute(BUY_NOW_ITEM);
        session.removeAttribute(REORDER_CHECKOUT_ITEMS);

        renderCheckout(req, resp, session, selectedIds);
    }

    private void renderCheckout(HttpServletRequest req,
                                HttpServletResponse resp,
                                HttpSession session,
                                String[] selectedIds) throws ServletException, IOException {
        User user = (User) session.getAttribute("userlogin");
        if (user == null) {
            resp.sendRedirect("login");
            return;
        }

        List<CartItem> checkoutItems = new ArrayList<>();

        CartItem buyNowItem = (CartItem) session.getAttribute(BUY_NOW_ITEM);
        if (buyNowItem != null) {
            checkoutItems.add(buyNowItem);
        }
        else if (session.getAttribute(REORDER_CHECKOUT_ITEMS) instanceof List<?> reorderItems) {
            for (Object item : reorderItems) {
                if (item instanceof CartItem cartItem) {
                    checkoutItems.add(cartItem);
                }
            }
        }
        else {
            Integer cartId = (Integer) session.getAttribute("cartId");
            if (cartId == null || selectedIds == null) {
                resp.sendRedirect("my-cart");
                return;
            }

            List<CartItem> allItems = cartItemDao.getItemsByCartId(cartId);
            for (String idStr : selectedIds) {
                int id = Integer.parseInt(idStr);
                for (CartItem item : allItems) {
                    if (item.getVariantId() == id) {
                        checkoutItems.add(item);
                        break;
                    }
                }
            }
        }

        if (checkoutItems.isEmpty()) {
            resp.sendRedirect("my-cart");
            return;
        }

        int totalWeight = 0;
        int totalLength = 0;
        int totalWidth = 0;
        int totalHeight = 0;

        for (CartItem item : checkoutItems) {
            int qty = item.getQuantity();

            int itemWeight = item.getProduct().getWeight();
            int itemLength = item.getProduct().getLength();
            int itemWidth = item.getProduct().getWidth();
            int itemHeight = item.getProduct().getHeight();

            totalWeight += (itemWeight * qty);

            if (itemLength > totalLength) {
                totalLength = itemLength;
            }
            if (itemWidth > totalWidth) {
                totalWidth = itemWidth;
            }
            totalHeight += (itemHeight * qty);
        }

        req.setAttribute("totalWeight", totalWeight);
        req.setAttribute("totalLength", totalLength);
        req.setAttribute("totalWidth", totalWidth);
        req.setAttribute("totalHeight", totalHeight);

        Address selectedAddress = addressService.getPrimaryByUser(user.getId());
        moveFlashMessageToRequest(session, req);
        moveCheckoutErrorToRequest(req);

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

    private void moveCheckoutErrorToRequest(HttpServletRequest req) {
        String error = req.getParameter("error");
        if (error == null || error.isBlank()) {
            return;
        }

        String errorMessage = switch (error) {
            case "out_of_stock" -> "Một số sản phẩm trong giỏ đã vượt quá số lượng tồn kho.";
            case "invalid_payment_method" -> "Phương thức thanh toán không hợp lệ. Vui lòng thử lại.";
            case "invalid_payment_signature" -> "Không thể xác minh kết quả thanh toán VNPay. Vui lòng thử lại.";
            case "payment_not_found" -> "Không tìm thấy giao dịch thanh toán tương ứng với đơn hàng của bạn.";
            case "payment_cancelled" -> "Bạn đã hủy thanh toán VNPay. Đơn hàng vẫn đang chờ thanh toán.";
            case "payment_failed" -> "Thanh toán VNPay không thành công. Vui lòng thử lại.";
            default -> null;
        };

        if (errorMessage != null) {
            req.setAttribute("checkoutError", errorMessage);
        }
    }
}
