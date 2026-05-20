package controller.web;

import dao.user.CategoryDao;
import dao.user.ProductDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Category;
import model.Product;
import service.CategoryService;
import service.ProductService;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;


@WebServlet("/product")
public class ProductController extends HttpServlet {
    private ProductService productService;
    private CategoryService categoryService;


    @Override
    public void init() {
        productService = new ProductService();
        categoryService = new CategoryService();
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

        request.setAttribute("breadcrumbList", breadcrumbList);
        request.setAttribute("displayTags", displayTags);
        request.setAttribute("currentCategory", currentCategory);
        request.getRequestDispatcher("/WEB-INF/views/product.jsp").forward(request, response);
    }
}
