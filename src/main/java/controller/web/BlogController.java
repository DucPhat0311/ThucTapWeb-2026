package controller.web;

import java.io.IOException;
import java.util.List;
import java.util.Optional;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.user.BlogDao;
import model.Blog;
import service.BlogService;

@WebServlet("/blog")
public class BlogController extends HttpServlet {

    private BlogService blogService;

    @Override
    public void init() {
        blogService = new BlogService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        String search = request.getParameter("search");

        if (idParam != null && !idParam.isEmpty()) {
            showDetail(request, response, idParam);
            return;
        }

        if (search != null && !search.trim().isEmpty()) {
            searchBlog(request, response, search);
            return;
        }

        showList(request, response);
    }

    private void showList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int page = 1;
        int pageSize = 9;

        String pageStr = request.getParameter("page");

        if (pageStr != null) page = Integer.parseInt(pageStr);

        int offset = (page - 1) * pageSize;

        List<Blog> blogList = blogService.getBlogPage(pageSize, offset);
        int totalRecords = blogService.handleTotalBlogCount();
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

        request.setAttribute("blogList", blogList);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);

        request.getRequestDispatcher("/WEB-INF/views/blog.jsp").forward(request, response);
    }

    private void showDetail(HttpServletRequest request, HttpServletResponse response, String idParam) throws ServletException, IOException {
        int id = 0;
        try {
            id = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/blog");
            return;
        }

        Optional<Blog> opt = blogService.handleGetBlogById(id);

        if (opt.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/blog");
            return;
        }

        Blog blog = opt.get();
        List<Blog> relatedBlogs = blogService.getRelated(blog.getId(), 4);

        request.setAttribute("blog", blog);
        request.setAttribute("relatedBlogs", relatedBlogs);
        request.getRequestDispatcher("/WEB-INF/views/blog-detail.jsp").forward(request, response);
    }

    private void searchBlog(HttpServletRequest request, HttpServletResponse response, String keyword) throws ServletException, IOException {
        List<Blog> result = blogService.search(keyword);

        request.setAttribute("blogList", result);
        request.setAttribute("searchKeyword", keyword);

        request.getRequestDispatcher("/WEB-INF/views/blog.jsp").forward(request, response);
    }
}
