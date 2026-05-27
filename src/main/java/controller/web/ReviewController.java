package controller.web;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.Review;
import model.User;
import service.ReviewService;

import java.io.IOException;
import java.util.Collection;

@WebServlet("/review")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 20, // 20MB
        maxRequestSize = 1024 * 1024 * 100 // 100MB
)
public class ReviewController extends HttpServlet {

    private ReviewService reviewService;

    @Override
    public void init() {
        reviewService = new ReviewService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        User user = (User) request.getSession().getAttribute("userlogin");

        if (user == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        try {
            int productId = Integer.parseInt(request.getParameter("product_id"));
            int orderItemId = Integer.parseInt(request.getParameter("order_item_id"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");

            Review review = new Review();
            review.setProductId(productId);
            review.setUserId(user.getId());
            review.setRating(rating);
            review.setComment(comment);

            // lấy id
            int reviewId = reviewService.addReview(review);

            Collection<Part> parts = request.getParts();
            for (Part part : parts) {
                if (part.getName().equals("reviewImages") && part.getSize() > 0) {

                    String imageUrl = util.CloudinaryUtil.uploadImage(part, "reviews");
                    if (imageUrl != null) {
                        reviewService.saveReviewImage(reviewId, imageUrl);
                    }
                }
            }

            // set đã đáh gias
            reviewService.markOrderItemReviewed(orderItemId);

            response.setStatus(HttpServletResponse.SC_OK);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
