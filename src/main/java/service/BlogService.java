package service;

import dao.user.BlogDao;
import model.Blog;

import java.util.List;

public class BlogService {
    private final BlogDao blogDao = new BlogDao();

    public List<Blog> getBlogPage(int page, int pageSize) {
        if (page < 1) page = 1;
        return blogDao.getBlogPaginated(page, pageSize);
    }

    public int getTotalPages(int pageSize) {
        int totalRecords = blogDao.getTotalBlogCount();
        return (int) Math.ceil((double) totalRecords / pageSize);
    }

    public List<Blog> search(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return List.of();
        }
        return blogDao.searchBlog(keyword.trim());
    }

    public List<Blog> getRelated(int currentId, int limit) {
        return blogDao.getRelatedBlog(currentId, limit);
    }
}
