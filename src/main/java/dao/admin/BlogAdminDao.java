package dao.admin;

import dao.core.BaseDao;
import model.Blog;

import java.util.List;
import java.util.Optional;

public class BlogAdminDao extends BaseDao {
    public List<Blog> getAllBlog() {
        return getJdbi().withHandle(handle ->
                handle.createQuery("SELECT * FROM blogs ORDER BY created_at DESC")
                        .mapToBean(Blog.class)
                        .list()
        );
    }

    public Optional<Blog> getBlogById(int id) {
        return getJdbi().withHandle(handle ->
                handle.createQuery("SELECT * FROM blogs WHERE id = :id")
                        .bind("id", id)
                        .mapToBean(Blog.class)
                        .findFirst()
        );
    }






    public int createBlog(Blog blog) {
        return getJdbi().withHandle(handle ->
                handle.createUpdate("INSERT INTO blogs (title, img, description, content, author_id, status, created_at) VALUES (:title, :img, :description, :content, :authorId, :status, NOW())")
                        .bind("title", blog.getTitle())
                        .bind("img", blog.getImg())
                        .bind("description", blog.getDescription())
                        .bind("content", blog.getContent())
                        .bind("authorId", blog.getAuthorId())
                        .bind("status", blog.getStatus())
                        .executeAndReturnGeneratedKeys("id")
                        .mapTo(Integer.class)
                        .one()
        );
    }

    public boolean updateBlog(Blog blog) {
        int rows = getJdbi().withHandle(handle ->
                handle.createUpdate("UPDATE blogs SET title = :title, img = :img, description = :description, content = :content, status = :status, updated_at = NOW() WHERE id = :id")
                        .bind("id", blog.getId())
                        .bind("title", blog.getTitle())
                        .bind("img", blog.getImg())
                        .bind("description", blog.getDescription())
                        .bind("content", blog.getContent())
                        .bind("status", blog.getStatus())
                        .execute()
        );
        return rows > 0;
    }


    public boolean deleteBlog(int id) {
        int rows = getJdbi().withHandle(handle ->
                handle.createUpdate("DELETE FROM blogs WHERE id = :id")
                        .bind("id", id)
                        .execute()
        );
        return rows > 0;
    }

}
