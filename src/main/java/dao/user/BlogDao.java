package dao.user;

import dao.core.BaseDao;
import model.Blog;

import java.util.List;
import java.util.Optional;

public class BlogDao extends BaseDao {

    public Optional<Blog> getBlogById(int id) {
        return getJdbi().withHandle(handle ->
                handle.createQuery("SELECT * FROM blogs WHERE id = :id")
                        .bind("id", id)
                        .mapToBean(Blog.class)
                        .findFirst()
        );
    }

    public int getTotalBlogCount() {
        return getJdbi().withHandle(handle ->
                handle.createQuery("SELECT COUNT(*) FROM blogs WHERE status = 1")
                        .mapTo(Integer.class)
                        .one()
        );
    }
    public List<Blog> getRelatedBlog(int currentId, int limit) {
        return getJdbi().withHandle(handle ->
                handle.createQuery("SELECT * FROM blogs WHERE id != :currentId AND status = 1 ORDER BY created_at DESC LIMIT :limit")
                        .bind("currentId", currentId)
                        .bind("limit", limit)
                        .mapToBean(Blog.class)
                        .list()
        );
    }
    public List<Blog> searchBlog(String keyword) {
        String pattern = "%" + keyword + "%";
        return getJdbi().withHandle(handle ->
                handle.createQuery("SELECT * FROM blogs WHERE status = 1 AND (title LIKE :keyword OR description LIKE :keyword) ORDER BY created_at DESC")
                        .bind("keyword", pattern)
                        .mapToBean(Blog.class)
                        .list()
        );
    }
    public List<Blog> getBlogPaginated(int limit, int offset) {
        return getJdbi().withHandle(handle ->
                handle.createQuery("SELECT * FROM blogs WHERE status = 1 ORDER BY created_at DESC LIMIT :limit OFFSET :offset")
                        .bind("limit", limit)
                        .bind("offset", offset)
                        .mapToBean(Blog.class)
                        .list()
        );
    }
}
