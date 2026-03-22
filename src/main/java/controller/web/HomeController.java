package controller.web;

import dao.user.ProductDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.ProductService;
import java.io.IOException;


@WebServlet("/home")
public class HomeController extends HttpServlet {

    private ProductService productService;
    private ProductDao productDao;

    @Override
    public void init() {
        productService = new ProductService();
        productDao = new ProductDao();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // 8 sản phẩm mới nhất
        req.setAttribute("latestProducts",
                productService.getLatestProducts(8));

        req.getRequestDispatcher("/WEB-INF/views/home.jsp").forward(req, resp);
    }
}

