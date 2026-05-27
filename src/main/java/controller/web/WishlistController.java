package controller.web;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import dao.user.WishlistDao;
import model.User;

@WebServlet(name = "Wishlist", value = "/wishlist")
public class WishlistController extends HttpServlet {

    private WishlistDao wishlistDao = new WishlistDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userlogin");

        if (user == null) {
            response.getWriter().write("{\"status\":\"redirect\",\"url\":\"" + request.getContextPath() + "/login\"}");            return;
        }

        try {
            int userId = user.getId();
            int productId = Integer.parseInt(request.getParameter("productId"));

            boolean hasLiked = wishlistDao.isExist(userId, productId);

            if (hasLiked) {
                boolean success = wishlistDao.removeWishlist(userId, productId);
                if (success) {
                    response.getWriter().write("{\"success\":true,\"action\":\"removed\",\"message\":\"Đã xóa khỏi danh sách yêu thích\"}");
                } else {
                    response.getWriter().write("{\"success\":false,\"message\":\"Không thể xóa khỏi danh sách yêu thích\"}");
                }
            } else {
                boolean success = wishlistDao.addWishlist(userId, productId);
                if (success) {
                    response.getWriter().write("{\"success\":true,\"action\":\"added\",\"message\":\"Đã thêm vào danh sách yêu thích\"}");
                } else {
                    response.getWriter().write("{\"success\":false,\"message\":\"Không thể thêm vào danh sách yêu thích\"}");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write(
                    "{\"success\":false,\"message\":\"Lỗi hệ thống: " + e.getMessage() + "\"}"
            );
        }
    }
}