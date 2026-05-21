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

    public String handleGetCategoryIdsWithChildren(String categoryIdStr) {
        if (categoryIdStr == null || categoryIdStr.isEmpty()) {
            return "";
        }

        List<String> allIds = new ArrayList<>();
        String[] fIds = categoryIdStr.split(",");

        for (String idStr : fIds) {
            try {
                int catId = Integer.parseInt(idStr.trim());
                allIds.add(String.valueOf(catId));
                getAllSubCategoryIds(catId, allIds);
            } catch (NumberFormatException e) {
            }
        }

        System.out.println("debug");
        System.out.println("id Danh mục t ấn " + categoryIdStr);
        System.out.println("tất cả ID con tìm được: " + String.join(", ", allIds));
        return String.join(",", allIds);
    }


    private void getAllSubCategoryIds(int parentId, List<String> allIds) {
        List<Category> subCategories = categoryDao.getSubCategories(parentId);
        if (subCategories != null && !subCategories.isEmpty()) {
            for (Category sub : subCategories) {
                allIds.add(String.valueOf(sub.getId()));
                getAllSubCategoryIds(sub.getId(), allIds);
            }
        }
    }


}
