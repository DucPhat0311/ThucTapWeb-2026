package controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import service.BannerService;
import model.Banner;
import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.util.List;

@WebServlet(name = "BannerAdminController", value = "/bannerAdmin")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 25,      // 25MB 
        maxRequestSize = 1024 * 1024 * 50    // 50MB 
)
public class BannerAdminController extends HttpServlet {
    private BannerService bannerService;

    @Override
    public void init(){
        bannerService = new BannerService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String mode = request.getParameter("mode");

        if (mode == null){
            List<Banner> banners = bannerService.getAllBanner();

            int total = banners.size();

            int totalActive = bannerService.getActiveBanners().size();

            request.setAttribute("banners", banners);
            request.setAttribute("total", total);
            request.setAttribute("totalActive", totalActive);

            request.setAttribute("page", "banner");
        request.getRequestDispatcher("/WEB-INF/admin/bannerAdmin.jsp").forward(request,response);
            return;
        }

        if ("edit".equals(mode) || "view".equals(mode)){
            int id = Integer.parseInt(request.getParameter("id"));
            Banner banner = bannerService.getBannerById(id);

            request.setAttribute("banner", banner);
            request.setAttribute("mode", mode);

            request.setAttribute("page", "banner");
        request.getRequestDispatcher("/WEB-INF/admin/form-bannerAdmin.jsp").forward(request,response);
            return;
        }

        if ("add".equals(mode)){
            request.setAttribute("mode", mode);

            request.setAttribute("page", "banner");
        request.getRequestDispatcher("/WEB-INF/admin/form-bannerAdmin.jsp").forward(request,response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            bannerService.deleteBanner(id);
            response.sendRedirect("bannerAdmin");
            return;
        }


        if ("lock".equals(action) || "unlock".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean status = "unlock".equals(action); 
            bannerService.lockOrUnlockBanner(id, status);
            response.sendRedirect("bannerAdmin");
            return;
        }



        String uploadDir = getServletContext().getRealPath("/img");
        File dir = new File(uploadDir);
        if (!dir.exists()){
            dir.mkdirs();
        }

        Part filePart = request.getPart("imageFile");
        String fileName = "";

        if (filePart != null && filePart.getSubmittedFileName() != null) {
            fileName = Path.of(filePart.getSubmittedFileName())
                    .getFileName().toString();
        }

        if ("create".equals(action)){
            String imageUrl = null;
            if (!fileName.isEmpty()) {
                filePart.write(uploadDir + fileName);
                imageUrl = "./img/" + fileName;
            }

            Banner banner = new Banner();

            banner.setImageUrl(imageUrl);
            banner.setTitle(request.getParameter("title"));
            banner.setNavigateTo(request.getParameter("navigateTo"));

            int status = Integer.parseInt(request.getParameter("status"));

            banner.setStatus(status == 1);

            bannerService.createBanner(banner);

            response.sendRedirect("bannerAdmin");
            return;
        }

        if ("update".equals(action)){
            int id = Integer.parseInt(request.getParameter("id"));

            Banner oldBanner = bannerService.getBannerById(id);
            String imageUrl = oldBanner.getImageUrl();

            if (!fileName.isEmpty()) {
                filePart.write(uploadDir + fileName);
                imageUrl = "./img/" + fileName;
            }

            Banner banner = new Banner();

            banner.setId(id);
            banner.setImageUrl(imageUrl);
            banner.setTitle(request.getParameter("title"));
            banner.setNavigateTo(request.getParameter("navigateTo"));

            int status = Integer.parseInt(request.getParameter("status"));

            banner.setStatus(status == 1);

            bannerService.updateBanner(banner);

            response.sendRedirect("bannerAdmin");
            return;
        }


    }
}


