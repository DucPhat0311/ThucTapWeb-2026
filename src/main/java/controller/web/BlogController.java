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

    private transient BlogService blogService;
    private transient BlogDao blogDao;

    @Override
    public void init() {
        blogService = new BlogService();
        blogDao = new BlogDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        String search = request.getParameter("search");
        String pageParam = request.getParameter("page");

        if (idParam != null && !idParam.isEmpty()) {
            showDetail(request, response, idParam);
            return;
        }

        if (search != null && !search.trim().isEmpty()) {
            searchBlog(request, response, search);
            return;
        }

        showList(request, response, pageParam);
    }

    private void showList(HttpServletRequest request, HttpServletResponse response, String pageParam) throws ServletException, IOException {
        int pageSize = 9;
        int currentPage = 1;

        try {
            if (pageParam != null) {
                currentPage = Integer.parseInt(pageParam);
            }
        } catch (NumberFormatException ignored) {}

        List<Blog> blogList = blogService.getBlogPage(currentPage, pageSize);
        int totalRecords = blogDao.getTotalBlogCount();
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

        request.setAttribute("blogList", blogList);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);

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

        Optional<Blog> opt = blogDao.getBlogById(id);

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
