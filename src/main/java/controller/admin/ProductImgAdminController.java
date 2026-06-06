package controller.admin;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import service.ProductImageService;
import model.ProductImage;
import util.CloudinaryUtil;

@WebServlet(name = "ProductImgAdminController", value = "/productImgAdmin")
@MultipartConfig(maxFileSize = 10 * 1024 * 1024, maxRequestSize = 50 * 1024 * 1024)
public class ProductImgAdminController extends HttpServlet {
    private ProductImageService productImageService;

    @Override
    public void init() {
        productImageService = new ProductImageService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String productIdParam = request.getParameter("productId");
        if (productIdParam == null || productIdParam.isEmpty()) {
            response.sendRedirect("productAdmin");
            return;
        }

        int productId = Integer.parseInt(productIdParam);
        String mode = request.getParameter("mode");

        if (mode == null) {
            List<ProductImage> images = productImageService.getImageByProduct(productId);

            request.setAttribute("images", images);
            request.setAttribute("productId", productId);
            request.setAttribute("totalImages", images.size());
            request.setAttribute("page", "product");

            request.getRequestDispatcher("/WEB-INF/admin/img-productAdmin.jsp").forward(request, response);
            return;
        }

        if ("add".equals(mode)) {
            request.setAttribute("mode", "add");
            request.setAttribute("productId", productId);
            request.setAttribute("page", "product");
            request.getRequestDispatcher("/WEB-INF/admin/form-productImgAdmin.jsp").forward(request, response);
            return;
        }

        if ("edit".equals(mode)) {
            int id = Integer.parseInt(request.getParameter("id"));
            ProductImage image = productImageService.getImageById(id);

            request.setAttribute("image", image);
            request.setAttribute("productId", productId);
            request.setAttribute("mode", "edit");
            request.setAttribute("page", "product");
            request.getRequestDispatcher("/WEB-INF/admin/form-productImgAdmin.jsp").forward(request, response);
            return;
        }

        if ("view".equals(mode)) {
            int id = Integer.parseInt(request.getParameter("id"));
            ProductImage image = productImageService.getImageById(id);

            request.setAttribute("image", image);
            request.setAttribute("productId", productId);
            request.setAttribute("page", "product");
            request.setAttribute("mode", "view");
            request.getRequestDispatcher("/WEB-INF/admin/form-productImgAdmin.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        int productId = Integer.parseInt(request.getParameter("productId"));

        try {
            switch (action) {
                case "create" -> createImage(request, response, productId);
                case "update" -> updateImage(request, response, productId);
                case "delete" -> deleteImage(request, response, productId);
                default -> response.sendRedirect("productImgAdmin?productId=" + productId);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("productImgAdmin?productId=" + productId + "&error=true");
        }
    }

    private void createImage(HttpServletRequest request, HttpServletResponse response, int productId)
            throws ServletException, IOException {

        List<Part> fileParts = request.getParts().stream()
                .filter(part -> "imageFiles".equals(part.getName()) && part.getSize() > 0
                        && part.getSubmittedFileName() != null)
                .toList();

        if (fileParts.isEmpty()) {
            response.sendRedirect("productImgAdmin?productId=" + productId + "&error=no_image");
            return;
        }

        String mainIndexParam = request.getParameter("mainImageIndex");
        int mainIndex = -1;
        if (mainIndexParam != null && !mainIndexParam.isEmpty()) {
            try {
                mainIndex = Integer.parseInt(mainIndexParam);
            } catch (NumberFormatException ignored) {
            }
        }

        int index = 0;
        for (Part part : fileParts) {
            String imagePath = CloudinaryUtil.uploadImage(part, "products");
            if (imagePath != null && !imagePath.isEmpty()) {
                ProductImage image = new ProductImage();
                image.setProductId(productId);
                image.setImageUrl(imagePath);

                boolean isMain = (index == mainIndex);
                image.setMain(isMain);

                if (isMain) {
                    productImageService.resetMainImageAndSetThumbnail(productId, imagePath);
                }

                productImageService.createImage(image);
            }
            index++;
        }

        response.sendRedirect("productImgAdmin?productId=" + productId);
    }

    private void updateImage(HttpServletRequest request, HttpServletResponse response, int productId)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        String isMainParam = request.getParameter("isMain");

        ProductImage image = productImageService.getImageById(id);
        boolean isMain = isMainParam != null && isMainParam.equals("true");
        image.setMain(isMain);

        List<Part> fileParts = request.getParts().stream()
                .filter(part -> "imageFiles".equals(part.getName()) && part.getSize() > 0 && part.getSubmittedFileName() != null)
                .toList();

        if (!fileParts.isEmpty()) {
            String newImage = CloudinaryUtil.uploadImage(fileParts.get(0), "products");
            if (newImage != null && !newImage.isEmpty()) {
                image.setImageUrl(newImage);
            }
        }

        if (isMain) {
            productImageService.resetMainImageAndSetThumbnail(productId, image.getImageUrl());
        }

        productImageService.updateImage(image);
        response.sendRedirect("productImgAdmin?productId=" + productId);
    }

    private void deleteImage(HttpServletRequest request, HttpServletResponse response, int productId)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        productImageService.deleteImage(id);
        response.sendRedirect("productImgAdmin?productId=" + productId);
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
}
