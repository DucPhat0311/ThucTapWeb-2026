package service;

import dao.user.CategoryDao;
import model.Category;

import java.util.List;

public class CategoryService {
    private CategoryDao categoryDao = new CategoryDao();

    public CategoryService() {
        this.categoryDao = categoryDao;
    }

    public List<Category> handleGetAllCategories(){
        return categoryDao.getAllCategories();
    }
}
