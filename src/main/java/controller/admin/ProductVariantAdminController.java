package controller.admin;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.ProductVariantService;
import model.ProductVariant;

@WebServlet(name = "ProductVariantAdminController", value = "/productVariantAdmin")
public class ProductVariantAdminController extends HttpServlet {
    private ProductVariantService productVariantService;

    @Override
    public void init(){
        productVariantService = new ProductVariantService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String productIdRaw = request.getParameter("productId");
        if (productIdRaw == null || productIdRaw.isEmpty()) {
            response.sendRedirect("productAdmin");
            return;
        }

        String mode = request.getParameter("mode");
        int productId = Integer.parseInt(request.getParameter("productId"));

        if (mode == null) {

            List<ProductVariant> variants =
                    productVariantService.getProductVariantByProductId(productId);

            request.setAttribute("variants", variants);
            request.setAttribute("productId", productId);

            request.setAttribute("total", productVariantService.countVariant(productId));
            request.setAttribute("totalStock", productVariantService.countStock(productId));
            request.setAttribute("totalSize", productVariantService.countSize(productId));
            request.setAttribute("totalColor", productVariantService.countColor(productId));

            request.setAttribute("page", "product");

            request.getRequestDispatcher("/WEB-INF/admin/variant-productAdmin.jsp").forward(request, response);
            return;
        }


        if ("add".equals(mode)) {

            request.setAttribute("mode", "add");
            request.setAttribute("productId", productId);
            request.setAttribute("sizes", productVariantService.getAllSizes());
            request.setAttribute("colors", productVariantService.getAllColors());
            request.setAttribute("page", "product");

            request.getRequestDispatcher("/WEB-INF/admin/form-productVariantAdmin.jsp").forward(request, response);
            return;
        }

        if ("edit".equals(mode)) {

            int id = Integer.parseInt(request.getParameter("id"));

            ProductVariant variant = productVariantService.getVariantById(id);


            request.setAttribute("variant", variant);
            request.setAttribute("productId", variant.getProductId());
            request.setAttribute("sizes", productVariantService.getAllSizes());
            request.setAttribute("colors", productVariantService.getAllColors());
            request.setAttribute("mode", "edit");
            request.setAttribute("page", "product");

            request.getRequestDispatcher("/WEB-INF/admin/form-productVariantAdmin.jsp").forward(request, response);
            return;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if ("create".equals(action)) {

            try {
                ProductVariant variant = new ProductVariant();

                String productIdParam = request.getParameter("productId");
                String sizeNameParam = request.getParameter("sizeName");
                String colorNameParam = request.getParameter("colorName");
                String stockParam = request.getParameter("stock");


                variant.setProductId(Integer.parseInt(productIdParam));
                service.SizeService sizeService = new service.SizeService();
                int sizeId = sizeService.findOrCreateSize(sizeNameParam);
                variant.setSizeId(sizeId);
                service.ColorService colorService = new service.ColorService();
                int colorId = colorService.findOrCreateColor(colorNameParam);
                variant.setColorId(colorId);
                variant.setStock(stockParam != null && !stockParam.isEmpty()
                    ? Integer.parseInt(stockParam) : 0);

                productVariantService.createVariant(variant);

                response.sendRedirect(
                        "productVariantAdmin?productId=" + variant.getProductId()
                );
            } catch (NumberFormatException e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, 
                    "Lỗi định dạng số: " + e.getMessage());
            }
            return;
        }


        if ("update".equals(action)) {

            ProductVariant variant = new ProductVariant();

            variant.setId(Integer.parseInt(request.getParameter("id")));
            variant.setProductId(Integer.parseInt(request.getParameter("productId")));
            
            String stockParam = request.getParameter("stock");
            variant.setStock(stockParam != null && !stockParam.isEmpty() 
                ? Integer.parseInt(stockParam) : 0);


            productVariantService.updateVariant(variant);

            response.sendRedirect("productVariantAdmin?productId=" + variant.getProductId()
            );
            return;
        }
        if ("delete".equals(action)) {

            int id = Integer.parseInt(request.getParameter("id"));
            int productId = Integer.parseInt(request.getParameter("productId"));

            productVariantService.deleteVariant(id);

            response.sendRedirect("productVariantAdmin?productId=" + productId
            );
        }
    }
}

