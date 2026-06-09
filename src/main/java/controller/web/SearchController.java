package controller.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Product;
import model.User;
import service.ProductService;


import java.io.IOException;
import java.util.List;


@WebServlet("/search")
public class SearchController extends HttpServlet {
    private ProductService productService;


    @Override
    public void init() {
        productService = new ProductService();
    }


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String keyword = request.getParameter("keyword");
        int page = 1;
        int pageSize = 15;

        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.trim().isEmpty()) {
            page = Integer.parseInt(pageStr);
        }
        int offset = (page - 1) * pageSize;
        List<Product> list = productService.handlePaginateForSearch(keyword, pageSize, offset);
        int totalProducts = productService.countSearchProducts(keyword);
        int totalPages = (int) Math.ceil((double) totalProducts / pageSize);
        if (totalPages == 0) totalPages = 1;

        request.setAttribute("list", list);
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);

        User userLog = (User) request.getSession().getAttribute("userlogin");
        if (userLog != null && keyword != null && !keyword.trim().isEmpty()) {
            productService.saveSearchHistory(userLog.getId(), keyword.trim());
        }

        request.getRequestDispatcher("/WEB-INF/views/search.jsp").forward(request, response);
    }
}
