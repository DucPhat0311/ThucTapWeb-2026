package controller.admin;

import dao.admin.BlogAdminDao;
import model.Blog;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "BlogAdminServlet", value = "/blogAdmin")
@MultipartConfig
public class BlogAdminController extends HttpServlet {
    private final BlogAdminDao blogDAO = new BlogAdminDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            blogDAO.deleteBlog(id);
            response.sendRedirect("blogAdmin");
            return;
        }

        String mode = request.getParameter("mode");

        if ("add".equals(mode)) {
            request.setAttribute("mode", "add");
            request.setAttribute("page", "blog");
        request.getRequestDispatcher("/WEB-INF/admin/form-blogAdmin.jsp").forward(request, response);
            return;
        }

        if ("edit".equals(mode) || "view".equals(mode)) {
            int id = Integer.parseInt(request.getParameter("id"));
            blogDAO.getBlogById(id).ifPresent(n ->
                    request.setAttribute("blog", n)
            );
            request.setAttribute("mode", mode);
            request.setAttribute("page", "blog");
        request.getRequestDispatcher("/WEB-INF/admin/form-blogAdmin.jsp").forward(request, response);
            return;
        }

        List<Blog> allBlog = blogDAO.getAllBlog();
        int total = allBlog.size();
        int totalActive = (int) allBlog.stream().filter(n -> n.getStatus() == 1).count();
        int totalHidden = (int) allBlog.stream().filter(n -> n.getStatus() == 0).count();

        String status = request.getParameter("status");
        if (status != null && !status.trim().isEmpty()) {
            try {
                int statusFilter = Integer.parseInt(status);
                allBlog = allBlog.stream()
                        .filter(n -> n.getStatus() == statusFilter)
                        .collect(java.util.stream.Collectors.toList());
                request.setAttribute("currentStatus", status);
            } catch (NumberFormatException ignored) {}
        }

        request.setAttribute("blogList", allBlog);
        request.setAttribute("total", total);
        request.setAttribute("totalActive", totalActive);
        request.setAttribute("totalHidden", totalHidden);

        request.setAttribute("page", "blog");
        request.getRequestDispatcher("/WEB-INF/admin/blogAdmin.jsp").forward(request, response);
    }



    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String action = request.getParameter("action");
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String content = request.getParameter("content");
        String statusRaw = request.getParameter("status");
        int status = (statusRaw != null) ? Integer.parseInt(statusRaw) : 0;

        String imgPath = null;
        try {
            jakarta.servlet.http.Part filePart = request.getPart("imageFile");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = filePart.getSubmittedFileName();
                String extension = "";
                int lastDotIndex = fileName.lastIndexOf(".");
                if (lastDotIndex > 0) {
                    extension = fileName.substring(lastDotIndex);
                }
                String uniqueFileName = "blog_img_" + System.currentTimeMillis() + extension;
                uniqueFileName = uniqueFileName.replaceAll("[^a-zA-Z0-9._-]", "_");
                String uploadPath = getServletContext().getRealPath("/img");
                java.io.File uploadDir = new java.io.File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();
                String filePath = uploadPath + java.io.File.separator + uniqueFileName;
                filePart.write(filePath);
                imgPath = "img/" + uniqueFileName;
            }
        } catch (Exception e) {

        }

        if ("create".equals(action)) {
            Blog blog = new Blog();
            blog.setTitle(title);
            blog.setDescription(description);
            blog.setContent(content);
            blog.setStatus(status);
            blog.setAuthorId(1);
            if (imgPath != null) blog.setImg(imgPath);
            blogDAO.createBlog(blog);
        }

        if ("update".equals(action)) {
            String idRaw = request.getParameter("id");
            if (idRaw != null) {
                int id = Integer.parseInt(idRaw);
                Blog oldBlog = blogDAO.getBlogById(id).orElse(null);
                Blog blog = new Blog();
                blog.setId(id);
                blog.setTitle(title);
                blog.setDescription(description);
                blog.setContent(content);
                blog.setStatus(status);
                if (imgPath != null) {
                    blog.setImg(imgPath);
                } else if (oldBlog != null) {
                    blog.setImg(oldBlog.getImg());
                }
                blogDAO.updateBlog(blog);
            }
        }

        if ("delete".equals(action)) {
            String idRaw = request.getParameter("id");
            if (idRaw != null) {
                int id = Integer.parseInt(idRaw);
                blogDAO.deleteBlog(id);
            }
            response.sendRedirect("blogAdmin");
            return;
        }

        response.sendRedirect("blogAdmin");
    }
}


