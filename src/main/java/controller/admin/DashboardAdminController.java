package controller.admin;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.constant.OrderStatusLabel;
import service.DashboardService;

import java.io.IOException;
import java.time.LocalDate;

@WebServlet(name = "DashboardAdminController", value = "/dashboardAdmin")
public class DashboardAdminController extends HttpServlet {
    private DashboardService service;
    private static final ObjectMapper mapper = new ObjectMapper();

    @Override
    public void init() {
        service = new DashboardService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("totalOrders",   service.countOrders());
        request.setAttribute("totalRevenue",  service.totalRevenue());
        request.setAttribute("totalProducts", service.countProducts());
        request.setAttribute("totalUsers",    service.countUsers());

        double[] monthlyRevenue = service.revenueByMonth();
        request.setAttribute("monthlyRevenueJson", mapper.writeValueAsString(monthlyRevenue));
        request.setAttribute("currentYear", LocalDate.now().getYear());
        request.setAttribute("totalUsers", service.countUsers());
        request.setAttribute("latestOrders", service.latestOrders(5));
        request.setAttribute("orderStatusLabels", OrderStatusLabel.adminLabels());

        request.setAttribute("page", "dashboard");
        request.getRequestDispatcher("/WEB-INF/admin/dashboardAdmin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }
}
