package filter;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import model.Role;
import model.User;
import service.RoleService;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebFilter(urlPatterns = {
        "/dashboardAdmin",
        "/profileAdmin",
        "/userAdmin",
        "/categoryAdmin",
        "/productAdmin",
        "/productImgAdmin",
        "/productVariantAdmin",
        "/orderAdmin",
        "/returnAdmin",
        "/bannerAdmin",
        "/blogAdmin",
        "/contactAdmin",
        "/warehouseAdmin",
        "/admin/warehouseForm",
        "/admin/warehouseImportForm",
        "/admin/warehouseExportForm",
        "/admin/warehouseReturnForm",
        "/admin/warehouseStockBatch",
        "/roleAdmin"
})
public class AdminAuthFilter implements Filter {

    private static final Map<String, String> URL_MODULE_MAP = new HashMap<>();

    static {
        URL_MODULE_MAP.put("/dashboardAdmin", null);
        URL_MODULE_MAP.put("/profileAdmin", null);
        URL_MODULE_MAP.put("/userAdmin", "user");
        URL_MODULE_MAP.put("/categoryAdmin", "category");
        URL_MODULE_MAP.put("/productAdmin", "product");
        URL_MODULE_MAP.put("/productImgAdmin", "product");
        URL_MODULE_MAP.put("/productVariantAdmin", "product");
        URL_MODULE_MAP.put("/orderAdmin", "order");
        URL_MODULE_MAP.put("/returnAdmin", "return");
        URL_MODULE_MAP.put("/bannerAdmin", "banner");
        URL_MODULE_MAP.put("/blogAdmin", "blog");
        URL_MODULE_MAP.put("/contactAdmin", "contact");
        URL_MODULE_MAP.put("/warehouseAdmin", "warehouse");
        URL_MODULE_MAP.put("/admin/warehouseForm", "warehouse");
        URL_MODULE_MAP.put("/admin/warehouseImportForm", "warehouse");
        URL_MODULE_MAP.put("/admin/warehouseExportForm", "warehouse");
        URL_MODULE_MAP.put("/admin/warehouseReturnForm", "warehouse");
        URL_MODULE_MAP.put("/admin/warehouseStockBatch", "warehouse");
        URL_MODULE_MAP.put("/roleAdmin", "role");
    }

    private RoleService roleService;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        roleService = new RoleService();
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("userlogin") == null) {
            resp.sendRedirect(req.getContextPath() + "/login?error=loginError&redirect=admin");
            return;
        }

        User user = (User) session.getAttribute("userlogin");

        if (!"admin".equalsIgnoreCase(user.getRole())) {
            req.getRequestDispatcher("/WEB-INF/auth/error403.jsp").forward(req, resp);
            return;
        }

        if (user.getRoleId() == null) {
            chain.doFilter(request, response);
            return;
        }

        Role role = roleService.getRoleById(user.getRoleId());
        if (role == null || role.getIsSystem() == 1) {
            chain.doFilter(request, response);
            return;
        }

        String servletPath = req.getServletPath();
        String module = URL_MODULE_MAP.get(servletPath);

        if (module == null) {
            chain.doFilter(request, response);
            return;
        }

        String requiredAction = resolveAction(req.getMethod(), req.getParameter("action"));

        if (roleService.hasPermission(user.getRoleId(), module, requiredAction)) {
            chain.doFilter(request, response);
        } else {
            req.getRequestDispatcher("/WEB-INF/auth/error403.jsp").forward(req, resp);
        }
    }

    private String resolveAction(String httpMethod, String actionParam) {
        if ("GET".equalsIgnoreCase(httpMethod)) {
            return "view_list";
        }
        if (actionParam == null) {
            return "view_list";
        }
        return switch (actionParam.toLowerCase()) {
            case "create", "add" -> "add";
            case "update", "edit", "save", "savepermissions" -> "edit";
            case "delete" -> "delete";
            case "block", "unblock", "lock", "unlock", "active", "inactive", "deactivate", "activate" -> "lock";
            case "detail", "view" -> "view_detail";
            default -> "view_list";
        };
    }
}
