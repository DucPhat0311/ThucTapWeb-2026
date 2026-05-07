package controller.web;

import dao.user.CategoryDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.*;
import service.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;


@WebServlet("/detail-product")
public class ProductDetailController extends HttpServlet {
    private ProductService productService;
    private ReviewService reviewService;
    private ColorService colorService;
    private SizeService sizeService;
    private ProductImageService productImageService;
    private ProductVariantService productVariantService;
    private CategoryService categoryService;


    @Override
    public void init()  {
        productService = new ProductService();
        reviewService = new ReviewService();
        productImageService = new ProductImageService();
        colorService = new ColorService();
        sizeService = new SizeService();
        productVariantService = new ProductVariantService();
        categoryService = new CategoryService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idRaw = request.getParameter("id"); // id: type string

        int id = Integer.parseInt(idRaw);
        Product product = productService.getProductById(id);

        List<Review> reviews = reviewService.getReviewByProductID(id);


        List<Product> ralatedProducts = productService.ralatedProduct(id, 4);

        double avgRating = reviewService.getAvgRating(id);
        int totalReviews = reviewService.getTotalReviews(id);

        int displayStar = (int) Math.round(avgRating);


        List<ProductImage> listImage = productImageService.getImageByProduct(id);

        List<Color> listColor = colorService.getColorByProductId(id);

        List<Size> listSize = sizeService.getSizeByProductId(id);

        List<ProductVariant> listVariant = productVariantService.getVariantByProductId(id);

        List<Category> breadcrumbs = new ArrayList<>();

        Category currentCat = categoryService.handleGetCategoryById(product.getCategoryId());
        while (currentCat != null) {
            breadcrumbs.add(0, currentCat);

            if (currentCat.getParentId() > 0) {
                currentCat = categoryService.handleGetCategoryById(currentCat.getParentId());
            } else {
                currentCat = null;
            }
        }
        request.setAttribute("breadcrumbs", breadcrumbs);

        request.setAttribute("variants", listVariant);
        request.setAttribute("sizes", listSize);
        request.setAttribute("colors", listColor);
        request.setAttribute("images", listImage);
        request.setAttribute("product", product);
        request.setAttribute("displayStar", displayStar);
        request.setAttribute("totalReviews", totalReviews);
        request.setAttribute("reviews",reviews);
        request.setAttribute("ralatedProducts",ralatedProducts);
        request.getRequestDispatcher("/WEB-INF/views/detail-product.jsp").forward(request, response);
    }

}
