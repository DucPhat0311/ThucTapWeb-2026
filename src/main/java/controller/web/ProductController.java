package controller.web;

import dao.user.CategoryDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Category;
import model.Product;
import service.ProductService;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/product")
public class ProductController extends HttpServlet {
    private ProductService productService;
    private CategoryDao categoryDao;

    @Override
    public void init() {
        productService = new ProductService();
        categoryDao = new CategoryDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String group = request.getParameter("group");
        String category = request.getParameter("category");
        String sort = request.getParameter("sort");

        List<Product> products;

        Integer categoryId = null;
        if (category != null && !category.isEmpty()) {
            try{
                categoryId = Integer.parseInt(category);
            } catch (NumberFormatException e){}
        }

        if (categoryId != null){
            // Lấy cả sản phẩm của danh mục con
            List<Category> subCategories = categoryDao.getCategoryChild(categoryId);
            List<Integer> catIds = new ArrayList<>();
            catIds.add(categoryId);
            if (subCategories != null) {
                for (Category sub : subCategories) {
                    catIds.add(sub.getId());
                }
            }
            products = productService.getProductsByCategories(catIds);
            // Lọc theo group
        } else if ("nam".equals(group)) {
            products = productService.getProductsByCategories(List.of(1, 2, 3, 9));
        } else if ("nu".equals(group)) {
            products = productService.getProductsByCategories(List.of(4, 5, 6, 7, 9));
        } else if ("phukien".equals(group)) {
            products = productService.getProductsByCategories(List.of(8,9, 10));

        } else {
            products = productService.getAllProducts();
        }


        if ( sort != null && !sort.isEmpty()){
            switch (sort) {
                case "new":
                    products = productService.sortByNewest(products);
                    break;


                case "best":
                    products = productService.sortByBestSeller(products);
                    break;


                case "sale":
                    products = productService.sortBySale(products);
                    break;


                case "price_asc":
                    products = productService.sortByPriceAsc(products);
                    break;


                case "price_desc":
                    products = productService.sortByPriceDesc(products);
                    break;
            }


        }

        List<Category> categoryTree = categoryDao.getCategoryTree();
        request.setAttribute("categories", categoryTree);

        request.setAttribute("list", products);

        request.getRequestDispatcher("/WEB-INF/views/product.jsp").forward(request, response);

    }
}
