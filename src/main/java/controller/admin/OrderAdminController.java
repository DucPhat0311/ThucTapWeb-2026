package controller.admin;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.EmailService;
import service.OrderService;

@WebServlet(name = "OrderAdminController", value = "/orderAdmin")
public class OrderAdminController extends HttpServlet {

    private OrderService orderService;

    @Override
    public void init() {
        orderService = new OrderService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String mode = req.getParameter("mode");

        if (mode == null) {
   
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
            
            var allOrders = orderService.getAllOrders();
            int totalOrders = allOrders.size();
            int totalPages = (int) Math.ceil((double) totalOrders / pageSize);
            
            if (page < 1) page = 1;
            if (page > totalPages && totalPages > 0) page = totalPages;
            
            int start = (page - 1) * pageSize;
            int end = Math.min(start + pageSize, totalOrders);
            var orders = allOrders.subList(start, end);

            long pending = allOrders.stream()
                    .filter(o -> "PENDING".equals(o.getOrderStatus()))
                    .count();

            long completed = allOrders.stream()
                    .filter(o -> "COMPLETED".equals(o.getOrderStatus()))
                    .count();

            req.setAttribute("orders", orders);
            req.setAttribute("total", totalOrders);
            req.setAttribute("totalOrders", totalOrders);
            req.setAttribute("countPending", pending);
            req.setAttribute("countCompleted", completed);
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("pageSize", pageSize);

            req.setAttribute("page", "order");
        req.getRequestDispatcher("/WEB-INF/admin/orderAdmin.jsp").forward(req, resp);
            return;
        }


        if ("view".equals(mode)) {
            int id = Integer.parseInt(req.getParameter("id"));
            req.setAttribute("order", orderService.findById(id));
            req.setAttribute("items", orderService.getOrderItems(id));
            req.setAttribute("page", "order");
        req.getRequestDispatcher("/WEB-INF/admin/order-detailAdmin.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        String action = req.getParameter("action");
        if (!"update".equals(action)) return;

        int id = Integer.parseInt(req.getParameter("id"));
        String newStatus = req.getParameter("orderStatus");

  
        var order = orderService.findById(id);
        if (order == null) {
            resp.sendRedirect("orderAdmin");
            return;
        }

        String currentStatus = order.getOrderStatus();

        if ("COMPLETED".equals(currentStatus) || "CANCELLED".equals(currentStatus)) {
            resp.sendRedirect("orderAdmin?mode=view&id=" + id);
            return;
        }

        if ("PENDING".equals(currentStatus) && "COMPLETED".equals(newStatus)) {
            resp.sendRedirect("orderAdmin?mode=view&id=" + id);
            return;
        }


        orderService.updateStatus(id, newStatus);
        String userEmail = orderService.getUserEmailByOrderId(id);
        
        String statusInVietnamese;
        switch (newStatus) {
            case "PENDING":
                statusInVietnamese = "Chờ xử lý";
                break;
            case "SHIPPING":
                statusInVietnamese = "Đang giao";
                break;
            case "COMPLETED":
                statusInVietnamese = "Hoàn thành";
                break;
            case "CANCELLED":
                statusInVietnamese = "Đã hủy";
                break;
            default:
                statusInVietnamese = newStatus;
        }
        

        EmailService.sendEmail(
                userEmail,
                "Cập nhật trạng thái đơn hàng #" + id,
                "Đơn hàng của bạn đã chuyển sang trạng thái: " + statusInVietnamese
        );

        resp.sendRedirect("orderAdmin?mode=view&id=" + id);
    }

}

