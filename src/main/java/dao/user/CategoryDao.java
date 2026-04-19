package dao.user;

import dao.core.BaseDao;
import model.Category;

import java.util.List;

public class CategoryDao extends BaseDao {

    // lấy danh mục lớn + nhỏ
    public List<Category> getAllCategories() {
        List<Category> parents = getParentCategories();
        for (Category p : parents) {
            p.setSubCategories(getSubCategories(p.getId()));
        }
        return parents;
    }

    // lấy danh mục lớn
    public List<Category> getParentCategories() {
        String sql = "SELECT * FROM categories WHERE (parent_id IS NULL OR parent_id = 0) AND status = 1";
        return getJdbi().withHandle(h ->
                h.createQuery(sql)
                        .mapToBean(Category.class)
                        .list()
        );
    }

    // lấy danh mục nhỏ
    public List<Category> getSubCategories(int parentId) {
        String sql = "SELECT * FROM categories WHERE parent_id = :pid AND status = 1";
        return getJdbi().withHandle(h ->
                h.createQuery(sql)
                        .bind("pid", parentId)
                        .mapToBean(Category.class)
                        .list()
        );
    }

    public List<Category> getCategoryChild(int parentId) {
        String sql = "SELECT * FROM categories WHERE parent_id = :pid AND status = 1";
        return getJdbi().withHandle(h ->
                h.createQuery(sql)
                        .bind("pid", parentId)
                        .mapToBean(Category.class)
                        .list()
        );
    }

    public List<Category> getCategoryTree() {
        List<Category> parents = getActiveParentCategories();
        for (Category p : parents) {
            p.setSubCategories(getCategoryChild(p.getId()));
        }
        return parents;
    }

    public List<Category> getActiveParentCategories() {
        String sql = "SELECT * FROM categories WHERE (parent_id IS NULL OR parent_id = 0) AND status = 1";
        return getJdbi().withHandle(h ->
                h.createQuery(sql)
                        .mapToBean(Category.class)
                        .list()
        );
    }
}
