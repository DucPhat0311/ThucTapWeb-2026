package controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import service.DashboardService;
import service.OrderService;

import java.io.IOException;

@WebServlet(name = "DashboardAdminController", value = "/dashboard")
public class DashboardAdminController extends HttpServlet {
    private DashboardService service;
    private OrderService orderService;

    @Override
    public void init() {
        service = new DashboardService();
        orderService = new OrderService();
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("totalOrders", service.countOrders());
        request.setAttribute("totalRevenue", service.totalRevenue());
        request.setAttribute("totalProducts", service.countProducts());
        request.setAttribute("totalUsers", service.countUsers());
        request.setAttribute("latestOrders", service.latestOrders(10));

        request.setAttribute("page", "dashboard");
        request.getRequestDispatcher("/WEB-INF/admin/Dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}



