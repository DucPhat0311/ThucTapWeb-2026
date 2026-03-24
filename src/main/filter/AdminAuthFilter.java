package filter;

import java.io.IOException;

import model.User;
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
        "/userAdmin",
        "/categoryAdmin",
        "/productAdmin",
        "/orderAdmin",
        "/bannerAdmin",
        "/bannerAdmin",
})
public class AdminAuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
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
            // Nếu muốn xử lý khác, thêm logic ở đây
            return;
        }
        chain.doFilter(request, response);
    }

}
