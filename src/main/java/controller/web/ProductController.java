package controller.web;

import dao.user.CategoryDao;
import dao.user.ProductDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Category;
import model.Color;
import model.Product;
import model.Size;
import service.CategoryService;
import service.ColorService;
import service.ProductService;
import service.SizeService;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;


@WebServlet("/product")
public class ProductController extends HttpServlet {
    private ProductService productService;
    private CategoryService categoryService;
    private ColorService colorService;
    private SizeService sizeService;


    @Override
    public void init() {
        productService = new ProductService();
        categoryService = new CategoryService();
        colorService = new ColorService();
        sizeService = new SizeService();
    }


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int page = 1;
        int pageSize = 12;

        String pageStr = request.getParameter("page");
        if (pageStr != null) page = Integer.parseInt(pageStr);
        int offset = (page - 1) * pageSize;

        String categoryIdStr = request.getParameter("categoryId");
        List<Category> displayTags = new ArrayList<>();
        List<Category> breadcrumbList = new ArrayList<>();
        Category currentCategory = null;

        if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
            int catId = Integer.parseInt(categoryIdStr.split(",")[0]);
            currentCategory = categoryService.handleGetCategoryById(catId);
            if (currentCategory != null) {
                Category temp = currentCategory;
                while (temp != null) {
                    breadcrumbList.add(0, temp);
                    if (temp.getParentId() != 0) {
                        temp = categoryService.handleGetCategoryById(temp.getParentId());
                    } else {
                        temp = null;
                    }
                }

                displayTags = categoryService.handleGetSubCategories(catId);


                if (displayTags.isEmpty()) {
                    displayTags = categoryService.handleGetSubCategories(currentCategory.getParentId());
                }
            }
        } else {
            displayTags = categoryService.handleGetParentCategories();
        }

        List<Size> allSizes = sizeService.handleGetAllSizes(); // Lấy từ bảng size trong DB
        List<Color> allColors = colorService.handleGetAllColors(); // Lấy từ bảng color trong DB

        request.setAttribute("sizes", allSizes);
        request.setAttribute("colors", allColors);

        String sortType = request.getParameter("sortType");
        String minPrice = request.getParameter("minPrice");
        String maxPrice = request.getParameter("maxPrice");
        String sizes = request.getParameter("sizes");
        String colors = request.getParameter("colors");
        String rating = request.getParameter("rating");

        String categoryIds = categoryService.handleGetCategoryIdsWithChildren(categoryIdStr);

        if (sizes == null || sizes.trim().isEmpty()) sizes = null;
        if (colors == null || colors.trim().isEmpty()) colors = null;
        if (rating == null || rating.trim().isEmpty()) rating = null;
        if (minPrice == null || minPrice.trim().isEmpty()) minPrice = null;
        if (maxPrice == null || maxPrice.trim().isEmpty()) maxPrice = null;
        if (sortType == null || sortType.trim().isEmpty()) sortType = "latest"; // default


        List<Product> productList = productService.handleFilterProducts(categoryIds, sortType, minPrice, maxPrice, sizes, colors, rating, pageSize, offset);
        int totalProducts = productService.handleCountProducts(categoryIds, minPrice, maxPrice, sizes, colors, rating);
        int totalPages = (int) Math.ceil((double) totalProducts / pageSize);

        request.setAttribute("productList", productList);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);

        request.setAttribute("breadcrumbList", breadcrumbList);
        request.setAttribute("displayTags", displayTags);
        request.setAttribute("currentCategory", currentCategory);
        request.getRequestDispatcher("/WEB-INF/views/product.jsp").forward(request, response);
    }
}
