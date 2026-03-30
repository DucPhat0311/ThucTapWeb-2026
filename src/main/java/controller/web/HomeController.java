package controller.web;

import dao.user.CategoryDao;
import dao.user.ProductDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Category;
import service.ProductService;
import service.BannerService;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;


@WebServlet("/home")
public class HomeController extends HttpServlet {

    private ProductService productService;
    private BannerService bannerService;
    private ProductDao productDao;
    private CategoryDao categoryDao;


    @Override
    public void init() {
        productService = new ProductService();
        bannerService = new BannerService();
        productDao = new ProductDao();
        categoryDao = new CategoryDao();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setAttribute("banners",
            bannerService.getActiveBanners());

        req.setAttribute("latestProducts",
                productService.getLatestProducts(8));


        List<Category> allCategories = categoryDao.getAllCategories();
        for (Category parent : allCategories) {
            List<Integer> cateIds = new ArrayList<>();
            cateIds.add(parent.getId());
            if (parent.getSubCategories() != null) {
                for (Category sub : parent.getSubCategories()) {
                    cateIds.add(sub.getId());
                }
            }
            parent.setProducts(productDao.findLatestByCategories(cateIds, 8));
        }
        req.setAttribute("allCategories", allCategories);


        req.getRequestDispatcher("/WEB-INF/views/home.jsp").forward(req, resp);
    }
}

