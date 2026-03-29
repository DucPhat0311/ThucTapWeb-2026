package controller.admin;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.admin.CategoryAdminDao;
import model.Category;

@WebServlet("/categoryAdmin")

public class CategoryAdminController extends HttpServlet {

    private final CategoryAdminDao categoryAdminDao = new CategoryAdminDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String mode = req.getParameter("mode");
        String idParam = req.getParameter("id");


        if (mode != null) {
            req.setAttribute("mode", mode);
            req.setAttribute("parentCategories", categoryAdminDao.getParentCategories());

            if ("add".equals(mode)) {
                req.getRequestDispatcher("/WEB-INF/admin/form-categoryAdmin.jsp").forward(req, resp);
                return;
            }

            if (idParam != null && ("edit".equals(mode) || "view".equals(mode))) {
                int id = Integer.parseInt(idParam);
                Category category = categoryAdminDao.findById(id);
                req.setAttribute("category", category);
                req.getRequestDispatcher("/WEB-INF/admin/form-categoryAdmin.jsp").forward(req, resp);
                return;
            }
        }

        String action = req.getParameter("action");
        if ("view".equals(action)) {
            int id = Integer.parseInt(idParam);
            Category c = categoryAdminDao.findById(id);

            resp.setContentType("application/json;charset=UTF-8");
            PrintWriter out = resp.getWriter();

            out.print("{");
            out.print("\"id\":" + c.getId() + ",");
            out.print("\"name\":\"" + escape(c.getName()) + "\",");
            out.print("\"status\":\"" + c.getStatus() + "\"");
            out.print("}");
            return;
        }

        String search = req.getParameter("search");
        List<Category> categories;
        
        if (search != null && !search.trim().isEmpty()) {
            categories = categoryAdminDao.searchByName(search);
        } else {
            categories = categoryAdminDao.findAll();
        }

        List<Category> parentCategoriesList = new java.util.ArrayList<>();
        List<Category> childCategoriesList = new java.util.ArrayList<>();
        java.util.Map<Integer, String> parentNameMap = new java.util.HashMap<>();


        for (Category c : categories) {
            if (c.getParentId() == 0) {
                parentCategoriesList.add(c);
                parentNameMap.put(c.getId(), c.getName());
            }
        }
        for (Category c : categories) {
            if (c.getParentId() != 0) {
                childCategoriesList.add(c);
            }
        }

        req.setAttribute("categories", categories);
        req.setAttribute("parentCategoriesList", parentCategoriesList);
        req.setAttribute("childCategoriesList", childCategoriesList);
        req.setAttribute("parentNameMap", parentNameMap);
        req.setAttribute("totalCategories", categories.size());
        req.setAttribute("activeCategories",
                categories.stream().filter(c -> c.getStatus() == 1).count());
        req.setAttribute("lockedCategories",
                categories.stream().filter(c -> c.getStatus() == 0).count());

        req.setAttribute("page", "category");
        req.getRequestDispatcher("/WEB-INF/admin/categoryAdmin.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        try {
            switch (action) {
                case "create":
                    createCategory(req, resp);
                    break;
                case "update":
                    updateCategory(req, resp);
                    break;
                case "toggle-status":
                    toggleStatus(req, resp);
                    break;
                case "search":
                    searchCategory(req, resp);
                    break;
                default:
                    resp.sendRedirect(req.getContextPath() + "/categoryAdmin");
            }

        } catch (Exception e) {
            e.printStackTrace();
            String errorMsg = URLEncoder.encode(e.getMessage() != null ? e.getMessage() : "Unknown error", StandardCharsets.UTF_8);
            resp.sendRedirect(req.getContextPath() + "/categoryAdmin?error=" + errorMsg);
        }
    }

    private void createCategory(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String name = req.getParameter("name");
        String parentIdStr = req.getParameter("parentId");
        int parentId = (parentIdStr != null && !parentIdStr.isEmpty()) ? Integer.parseInt(parentIdStr) : 0;
        
        String statusStr = req.getParameter("status");
        int statusVal = 1;
        if (statusStr != null) {
            try {
                statusVal = Integer.parseInt(statusStr);
            } catch (Exception e) {
                statusVal = "Đang dùng".equals(statusStr) ? 1 : 0;
            }
        }

        Category category = new Category();
        category.setName(name);
        category.setStatus(statusVal);
        category.setParentId(parentId);

        categoryAdminDao.insert(category);
        resp.sendRedirect(req.getContextPath() + "/categoryAdmin");
    }

    private void updateCategory(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int id = Integer.parseInt(req.getParameter("id"));
        String name = req.getParameter("name");
        String statusStr = req.getParameter("status");
        String parentIdStr = req.getParameter("parentId");
        int parentId = (parentIdStr != null && !parentIdStr.isEmpty()) ? Integer.parseInt(parentIdStr) : 0;

        Category category = categoryAdminDao.findById(id);
        category.setName(name);
        category.setParentId(parentId);
        
        if (statusStr != null) {
            try {
                category.setStatus(Integer.parseInt(statusStr));
            } catch (Exception e) {
                category.setStatus(statusStr);
            }
        }

        categoryAdminDao.update(category);
        resp.sendRedirect(req.getContextPath() + "/categoryAdmin");
    }

    private void toggleStatus(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int id = Integer.parseInt(req.getParameter("id"));
        Category category = categoryAdminDao.findById(id);

        int newStatus = (category.getStatus() == 1) ? 0 : 1;
        category.setStatus(newStatus);

        categoryAdminDao.update(category);
        resp.sendRedirect(req.getContextPath() + "/categoryAdmin");
    }

    private void searchCategory(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String keyword = req.getParameter("keyword");
        List<Category> categories = categoryAdminDao.searchByName(keyword);

        List<Category> parentCategoriesList = new java.util.ArrayList<>();
        List<Category> childCategoriesList = new java.util.ArrayList<>();
        java.util.Map<Integer, String> parentNameMap = new java.util.HashMap<>();


        for (Category c : categories) {
            if (c.getParentId() == 0) {
                parentCategoriesList.add(c);
                parentNameMap.put(c.getId(), c.getName());
            }
        }
        for (Category c : categories) {
            if (c.getParentId() != 0) {
                childCategoriesList.add(c);
                if (!parentNameMap.containsKey(c.getParentId())) {
                    Category parent = categoryAdminDao.findById(c.getParentId());
                    if (parent != null) {
                        parentNameMap.put(parent.getId(), parent.getName());
                    }
                }
            }
        }

        req.setAttribute("categories", categories);
        req.setAttribute("parentCategoriesList", parentCategoriesList);
        req.setAttribute("childCategoriesList", childCategoriesList);
        req.setAttribute("parentNameMap", parentNameMap);

        req.setAttribute("totalCategories", categories.size());
        req.setAttribute("activeCategories",
                categories.stream().filter(c -> c.getStatus() == 1).count());
        req.setAttribute("lockedCategories",
                categories.stream().filter(c -> c.getStatus() == 0).count());

        req.setAttribute("page", "category");
        req.getRequestDispatcher("/WEB-INF/admin/categoryAdmin.jsp").forward(req, resp);
    }

        private String escape(String s) {
        if (s == null) return "";
        return s.replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }

}


