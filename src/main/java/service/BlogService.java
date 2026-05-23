package service;

import dao.user.BlogDao;
import model.Blog;

import java.util.List;
import java.util.Optional;

public class BlogService {
    private final BlogDao blogDao = new BlogDao();

    public List<Blog> getBlogPage(int pageSize, int offset) {
        return blogDao.getBlogPaginated(pageSize, offset);
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

    public int handleTotalBlogCount(){
        return blogDao.getTotalBlogCount();
    }

    public Optional<Blog> handleGetBlogById(int id){
        return blogDao.getBlogById(id);
    }

    public List<Blog> getRelated(int currentId, int limit) {
        return blogDao.getRelatedBlog(currentId, limit);
    }
}
