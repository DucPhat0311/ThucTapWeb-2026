package controller.admin;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import dao.admin.CategoryAdminDao;
import dao.admin.ProductDaoAdmin;
import model.Category;
import model.Product;
import util.CloudinaryUtil;

@WebServlet("/productAdmin")
@MultipartConfig(

        maxFileSize = 10 * 1024 * 1024, maxRequestSize = 20 * 1024 * 1024)
public class ProductAdminController extends HttpServlet {

    private final ProductDaoAdmin productDaoAdmin = new ProductDaoAdmin();
    private final CategoryAdminDao categoryDaoAdmin = new CategoryAdminDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String mode = req.getParameter("mode");
        String idParam = req.getParameter("id");

        if (mode != null) {
            List<Category> categories = categoryDaoAdmin.findAll();
            req.setAttribute("categories", categories);
            req.setAttribute("mode", mode);

            if ("add".equals(mode)) {
                req.getRequestDispatcher("/WEB-INF/admin/form-productAdmin.jsp").forward(req, resp);
                return;
            }

            if (idParam != null && ("edit".equals(mode) || "view".equals(mode))) {
                int id = Integer.parseInt(idParam);
                Product product = productDaoAdmin.findById(id);
                req.setAttribute("product", product);
                req.getRequestDispatcher("/WEB-INF/admin/form-productAdmin.jsp").forward(req, resp);
                return;
            }
        }

        String action = req.getParameter("action");
        if ("toggle-active".equals(action)) {
            int id = Integer.parseInt(idParam != null ? idParam : req.getParameter("id"));
            Product p = productDaoAdmin.findById(id);
            String newStatus = "Đang hoạt động".equals(p.getStatus()) ? "Đã ẩn" : "Đang hoạt động";
            p.setStatus(newStatus);
            productDaoAdmin.update(p);

            String redirectUrl = req.getContextPath() + "/productAdmin";
            String pageVal = req.getParameter("page");
            String statusVal = req.getParameter("status");

            java.util.StringJoiner query = new java.util.StringJoiner("&");
            if (pageVal != null && !pageVal.isEmpty()) {
                query.add("page=" + pageVal);
            }
            if (statusVal != null && !statusVal.isEmpty()) {
                query.add("status=" + java.net.URLEncoder.encode(statusVal, java.nio.charset.StandardCharsets.UTF_8));
            }
            if (query.length() > 0) {
                redirectUrl += "?" + query.toString();
            }

            resp.sendRedirect(redirectUrl);
            return;
        }

        if ("view".equals(action)) {
            int id = Integer.parseInt(idParam);
            Product p = productDaoAdmin.findById(id);

            resp.setContentType("application/json;charset=UTF-8");
            PrintWriter out = resp.getWriter();

            out.print("{");
            out.print("\"id\":" + p.getId() + ",");
            out.print("\"name\":\"" + escape(p.getName()) + "\",");
            out.print("\"price\":" + p.getPrice() + ",");
            out.print("\"category_id\":" + p.getCategory_id() + ",");
            out.print("\"thumbnail\":\"" + escape(p.getThumbnail()) + "\",");
            out.print("\"categoryName\":\"" + escape(p.getCategoryName()) + "\",");
            out.print("\"status\":\"" + escape(p.getStatus()) + "\"");
            out.print("}");
            return;
        }

        // Phân trang
        int page = 1;
        int pageSize = 5;

        String pageParam = req.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        List<Product> allProducts = productDaoAdmin.findAll();

        long totalProductsCount = allProducts.size();
        long activeProductsCount = allProducts.stream().filter(p -> "Đang hoạt động".equals(p.getStatus())).count();
        long inactiveProductsCount = allProducts.stream().filter(p -> "Đã ẩn".equals(p.getStatus())).count();

        String status = req.getParameter("status");
        List<Product> filteredProducts = allProducts;
        if (status != null && !status.isEmpty()) {
            filteredProducts = allProducts.stream()
                    .filter(p -> status.equals(p.getStatus()))
                    .collect(java.util.stream.Collectors.toList());
        }

        int totalProducts = filteredProducts.size();
        int totalPages = (int) Math.ceil((double) totalProducts / pageSize);

        if (page < 1)
            page = 1;
        if (page > totalPages && totalPages > 0)
            page = totalPages;

        int start = (page - 1) * pageSize;
        int end = Math.min(start + pageSize, totalProducts);
        List<Product> products = filteredProducts.subList(start, end);

        req.setAttribute("products", products);
        req.setAttribute("totalProducts", totalProductsCount);
        req.setAttribute("totalProductsDisplay", totalProducts); // Số lượng sau khi lọc
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("pageSize", pageSize);
        req.setAttribute("activeProducts", activeProductsCount);
        req.setAttribute("inactiveProducts", inactiveProductsCount);
        req.setAttribute("currentStatus", status);

        req.setAttribute("page", "product");
        req.getRequestDispatcher("/WEB-INF/admin/productAdmin.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        String action = req.getParameter("action");

        switch (action) {
            case "search" -> {
                String kw = req.getParameter("keyword");
                req.setAttribute("products", productDaoAdmin.searchByName(kw));
                req.setAttribute("page", "product");
                req.getRequestDispatcher("/WEB-INF/admin/productAdmin.jsp").forward(req, resp);
                return;
            }
            case "add" -> {
                Product p = new Product();
                p.setName(req.getParameter("name"));
                p.setPrice(Double.parseDouble(req.getParameter("price")));
                String salePriceStr = req.getParameter("sale_price");
                if (salePriceStr != null && !salePriceStr.trim().isEmpty()) {
                    p.setSale_price(Double.parseDouble(salePriceStr));
                } else {
                    p.setSale_price(0);
                }
                p.setCategory_id(Integer.parseInt(req.getParameter("category_id")));

                String imagePath = handleFileUpload(req, "imageFile");
                if (imagePath != null && !imagePath.isEmpty()) {
                    p.setThumbnail(imagePath);
                }
                p.setStatus(req.getParameter("status"));
                p.setDescription(req.getParameter("description"));
                productDaoAdmin.insert(p);

                int productId = productDaoAdmin.findAll().get(0).getId();

                String[] sizes = req.getParameterValues("variant_size[]");
                String[] colors = req.getParameterValues("variant_color[]");
                String[] stocks = req.getParameterValues("variant_stock[]");

                if (sizes != null && colors != null) {
                    dao.admin.SizeDaoAdmin sizeDao = new dao.admin.SizeDaoAdmin();
                    dao.admin.ColorDaoAdmin colorDao = new dao.admin.ColorDaoAdmin();
                    dao.admin.ProductVariantDaoAdmin variantDao = new dao.admin.ProductVariantDaoAdmin();

                    for (int i = 0; i < sizes.length; i++) {
                        String sVal = sizes[i];
                        String cVal = colors[i];
                        int stVal = 0;
                        if (stocks != null && stocks.length > i) {
                            try {
                                stVal = Integer.parseInt(stocks[i]);
                            } catch (NumberFormatException e) {
                                stVal = 0;
                            }
                        }

                        if (sVal != null && !sVal.trim().isEmpty() && cVal != null && !cVal.trim().isEmpty()) {
                            int sizeId = sizeDao.findOrCreateSize(sVal.trim());
                            int colorId = colorDao.findOrCreateColor(cVal.trim());

                            model.ProductVariant variant = new model.ProductVariant();
                            variant.setProductId(productId);
                            variant.setSizeId(sizeId);
                            variant.setColorId(colorId);
                            variant.setStock(stVal);

                            variantDao.createVariant(variant);
                        }
                    }
                }
            }
            case "update" -> {
                Product p = new Product();
                p.setId(Integer.parseInt(req.getParameter("id")));
                p.setName(req.getParameter("name"));
                p.setPrice(Double.parseDouble(req.getParameter("price")));
                String salePriceStr = req.getParameter("sale_price");
                if (salePriceStr != null && !salePriceStr.trim().isEmpty()) {
                    p.setSale_price(Double.parseDouble(salePriceStr));
                } else {
                    p.setSale_price(0);
                }
                p.setCategory_id(Integer.parseInt(req.getParameter("category_id")));
                p.setDescription(req.getParameter("description"));
                String imagePath = handleFileUpload(req, "imageFile");
                if (imagePath != null && !imagePath.isEmpty()) {
                    p.setThumbnail(imagePath);
                } else {
                    Product oldProduct = productDaoAdmin.findById(p.getId());
                    if (oldProduct != null && oldProduct.getThumbnail() != null) {
                        p.setThumbnail(oldProduct.getThumbnail());
                    }
                }
                p.setDescription(req.getParameter("description"));
                p.setStatus(req.getParameter("status"));
                productDaoAdmin.update(p);
            }

            case "toggle-status" -> {
                int id = Integer.parseInt(req.getParameter("id"));
                Product p = productDaoAdmin.findById(id);
                String newStatus = "Đang hoạt động".equals(p.getStatus()) ? "Đã ẩn" : "Đang hoạt động";
                p.setStatus(newStatus);
                productDaoAdmin.update(p);
            }

            case "delete" -> {

                productDaoAdmin.softDelete(

                        Integer.parseInt(req.getParameter("id")));
            }
        }

        resp.sendRedirect(req.getContextPath() + "/productAdmin");
    }

    private String handleFileUpload(HttpServletRequest req, String fieldName)
            throws IOException, ServletException {

        Part filePart = req.getPart(fieldName);
        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }

        String fileName = filePart.getSubmittedFileName();
        if (fileName == null || fileName.isEmpty()) {
            return null;
        }

        return CloudinaryUtil.uploadImage(filePart, "products");
    }

    private String escape(String s) {
        return s == null ? "" : s.replace("\"", "\\\"");
    }
}
