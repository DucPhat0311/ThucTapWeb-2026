package dao.admin;

import model.Category;
import dao.core.BaseDao;
import java.util.List;

import org.jdbi.v3.core.Jdbi;

public class CategoryAdminDao extends BaseDao {

    public List<Category> findAll() {
        Jdbi jdbi = getJdbi();
        String sql = "SELECT * FROM categories ORDER BY id DESC";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .mapToBean(Category.class)
                        .list()
        );
    }

    public Category findById(int id) {
        Jdbi jdbi = getJdbi();
        String sql = "SELECT * FROM categories WHERE id = :id";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("id", id)
                        .mapToBean(Category.class)
                        .findOne()
                        .orElse(null)
        );
    }

    public List<Category> getParentCategories() {
        String sql = "SELECT * FROM categories WHERE (parent_id IS NULL OR parent_id = 0)";
        return getJdbi().withHandle(h ->
                h.createQuery(sql)
                        .mapToBean(Category.class)
                        .list()
        );
    }

    public List<Category> searchByName(String keyword) {
        String sql = "SELECT * FROM categories WHERE name LIKE :keyword ORDER BY id";
        return getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("keyword", "%" + keyword + "%")
                        .mapToBean(Category.class)
                        .list()
        );
    }

    public void insert(Category category) {
        getJdbi().useHandle(handle ->
                handle.createUpdate("""
                INSERT INTO categories (name, status, parent_id)
                VALUES (:name, :status, :parentId)
            """)
                        .bind("name", category.getName())
                        .bind("status", category.getStatus())
                        .bind("parentId", category.getParentId() == 0 ? null : category.getParentId())
                        .execute()
        );
    }

    public void update(Category category) {
        getJdbi().useHandle(handle ->
                handle.createUpdate("""
                UPDATE categories
                SET name = :name,
                    status = :status,
                    parent_id = :parentId
                WHERE id = :id
            """)
                        .bind("id", category.getId())
                        .bind("name", category.getName())
                        .bind("status", category.getStatus())
                        .bind("parentId", category.getParentId() == 0 ? null : category.getParentId())
                        .execute()
        );
    }

     






    
}
