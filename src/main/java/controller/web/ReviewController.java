package controller.web;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.Review;
import model.User;
import service.ReviewService;

import java.io.IOException;

@WebServlet("/review")
public class ReviewController extends HttpServlet {

    private ReviewService reviewService;

    @Override
    public void init(){
        reviewService = new ReviewService();
    }


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {



    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        User user = (User) request.getSession().getAttribute("userlogin");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        int productId = Integer.parseInt(request.getParameter("product_id"));
        int orderItemId = Integer.parseInt(request.getParameter("order_item_id"));
        int rating = Integer.parseInt(request.getParameter("rating"));
        String comment = request.getParameter("comment");

        Review review = new Review();
        review.setProductId(productId);
        review.setUserId(user.getId());
        review.setRating(rating);
        review.setComment(comment);

        reviewService.addOrUpdateReview(review);

        reviewService.markOrderItemReviewed(orderItemId);
        response.sendRedirect("detail-product?id=" + productId);
    }
}
