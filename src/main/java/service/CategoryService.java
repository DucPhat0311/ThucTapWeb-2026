package service;

import dao.user.CategoryDao;
import model.Category;

import java.util.ArrayList;
import java.util.List;

public class CategoryService {
    private CategoryDao categoryDao;

    public CategoryService() {
        this.categoryDao = new CategoryDao();
    }

    public List<Category> handleGetAllCategories(){
        return categoryDao.getAllCategories();
    }

    public Category handleGetCategoryById(int id){
        return categoryDao.getCategoryById(id);
    }

    public List<Category> handleGetParentCategories() {
        return categoryDao.getParentCategories();
    }

    public List<Category> handleGetSubCategories(int parentId) {
        return categoryDao.getSubCategories(parentId);
    }


}
