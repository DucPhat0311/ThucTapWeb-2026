    package controller.web;

    import dao.user.CategoryDao;
    import dao.user.WishlistDao;
    import jakarta.servlet.ServletException;
    import jakarta.servlet.annotation.WebServlet;
    import jakarta.servlet.http.HttpServlet;
    import jakarta.servlet.http.HttpServletRequest;
    import jakarta.servlet.http.HttpServletResponse;
    import jakarta.servlet.http.HttpSession;
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
        private WishlistDao wishlistDao; 


        @Override
        public void init()  {
            productService = new ProductService();
            reviewService = new ReviewService();
            productImageService = new ProductImageService();
            colorService = new ColorService();
            sizeService = new SizeService();
            productVariantService = new ProductVariantService();
            categoryService = new CategoryService();
            wishlistDao = new WishlistDao();
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

            if (reviews != null) {
                for (Review rv : reviews) {
                    List<String> imgList = reviewService.getImagesByReviewId(rv.getId());
                    rv.setImages(imgList);
                }
            }

            int count5Star = 0;
            int count4Star = 0;
            int count3Star = 0;
            int count2Star = 0;
            int count1Star = 0;
            if (reviews != null) {
                for (Review rv : reviews) {
                    List<String> imgList = reviewService.getImagesByReviewId(rv.getId());
                    rv.setImages(imgList);
                    switch (rv.getRating()) {
                        case 5:
                            count5Star++;
                            break;
                        case 4:
                            count4Star++;
                            break;
                        case 3:
                            count3Star++;
                            break;
                        case 2:
                            count2Star++;
                            break;
                        case 1:
                            count1Star++;
                            break;
                    }
                }
            }

            Category productCategory = categoryService.handleGetCategoryById(product.getCategoryId());
            String sizeChartImg = "";


            if (productCategory != null && productCategory.getSizeImage() != null && !productCategory.getSizeImage().trim().isEmpty()) {
                sizeChartImg = productCategory.getSizeImage();
            }
            request.setAttribute("sizeChartImg", sizeChartImg);


            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("userlogin");
            boolean isWishlisted = false;

            if (user != null) {
                isWishlisted = wishlistDao.isExist(user.getId(), id);
            }
            request.setAttribute("isWishlisted", isWishlisted);

            request.setAttribute("count5Star", count5Star);
            request.setAttribute("count4Star", count4Star);
            request.setAttribute("count3Star", count3Star);
            request.setAttribute("count2Star", count2Star);
            request.setAttribute("count1Star", count1Star);
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
