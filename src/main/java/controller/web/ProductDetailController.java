package controller.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.*;
import service.*;

import java.io.IOException;
import java.util.List;


@WebServlet("/detail-product")
public class ProductDetailController extends HttpServlet {
    private ProductService productService;
    private ColorService colorService;
    private SizeService sizeService;
    private ProductImageService productImageService;
    private ProductVariantService productVariantService;

    @Override
    public void init()  {
        productService = new ProductService();
        productImageService = new ProductImageService();
        colorService = new ColorService();
        sizeService = new SizeService();
        productVariantService = new ProductVariantService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idRaw = request.getParameter("id"); // id: type string

        int id = Integer.parseInt(idRaw);
        Product product = productService.getProductById(id);

        List<Product> ralatedProducts = productService.ralatedProduct(id, 4);


        List<ProductImage> listImage = productImageService.getImageByProduct(id);

        List<Color> listColor = colorService.getColorByProductId(id);

        List<Size> listSize = sizeService.getSizeByProductId(id);

        List<ProductVariant> listVariant = productVariantService.getVariantByProductId(id);


        request.setAttribute("variants", listVariant);
        request.setAttribute("sizes", listSize);
        request.setAttribute("colors", listColor);
        request.setAttribute("images", listImage);
        request.setAttribute("product", product);
        request.setAttribute("ralatedProducts",ralatedProducts);
        request.getRequestDispatcher("/WEB-INF/views/detail-product.jsp").forward(request, response);
    }

}
