package controller.web;


import dao.user.CartItemDao;
import dao.user.ProductDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.CartItem;
import model.Product;
import model.User;
import java.io.IOException;


@WebServlet("/buy-now")
public class BuyNowController extends HttpServlet {


    private CartItemDao cartItemDao;
    private ProductDao productDao;


    @Override
    public void init() {
        cartItemDao = new CartItemDao();
        productDao = new ProductDao();
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("userlogin");


            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            String variantIdStr = request.getParameter("variantId");
            String quantityStr = request.getParameter("quantity");
            String pIdStr = request.getParameter("productId");

            if (variantIdStr == null || quantityStr == null || pIdStr == null
                    || variantIdStr.isBlank() || quantityStr.isBlank() || pIdStr.isBlank()) {
                System.out.println("=== [BUY NOW ERROR]: Tham số từ JS gửi sang bị thiếu hoặc rỗng! ===");
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }

            int variantId = Integer.parseInt(variantIdStr);
            int quantity = Integer.parseInt(quantityStr);
            int productId = Integer.parseInt(pIdStr);

            double finalPrice = cartItemDao.getPriceByVariantId(variantId);

            Product product = productDao.findById(productId);
            if (product == null) {
                System.out.println("Error" + productId);
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }

            CartItem buyNowItem = new CartItem();
            buyNowItem.setVariantId(variantId);
            buyNowItem.setQuantity(quantity);
            buyNowItem.setPrice(finalPrice);
            buyNowItem.setProduct(product);

            CartItem details = cartItemDao.getVariantDetailsForBuyNow(variantId);
            if (details != null) {
                buyNowItem.setSize(details.getSize());
                buyNowItem.setColor(details.getColor());
            }

            session.setAttribute("buyNowItem", buyNowItem);
            session.removeAttribute("checkoutSelectedIds");

            response.sendRedirect(request.getContextPath() + "/checkout");

        } catch (Exception e) {
            System.out.println("error");
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}

