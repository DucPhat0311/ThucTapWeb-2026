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
        String groupId = request.getParameter("groupId");
        String categoryId = request.getParameter("categoryId");
        String sortType = request.getParameter("sortType");

        String minPrice = request.getParameter("minPrice");
        String maxPrice = request.getParameter("maxPrice");

        List<Product> productList = productService.handleFilterProducts(groupId, categoryId, sortType, minPrice, maxPrice);

        request.setAttribute("categoryList", categoryService.handleGetAllCategories());
        request.setAttribute("productList", productList);

        request.getRequestDispatcher("/WEB-INF/views/product.jsp").forward(request, response);
    }
}

