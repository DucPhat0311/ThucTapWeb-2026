package controller.web;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import dao.user.WishlistDao;
import model.User;
import model.Product;

@WebServlet(name = "MyWishlist", value = "/my-wishlist")
public class MyWishlist extends HttpServlet {

    private WishlistDao wishlistDao = new WishlistDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userlogin");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<Product> wishlistProducts = wishlistDao.getWishlistProductsByUserId(user.getId());
        request.setAttribute("wishlistProducts", wishlistProducts);
        request.getRequestDispatcher("/WEB-INF/views/my-wishlist.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}