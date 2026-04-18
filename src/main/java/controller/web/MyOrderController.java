package controller.web;

import dao.user.OrderDao;
import dao.user.OrderItemDao;
import model.Order;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/order-user")
public class MyOrderController extends HttpServlet {

    private final OrderDao orderDao = new OrderDao();
    private final OrderItemDao orderItemDao = new OrderItemDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userlogin") == null) {
            resp.sendRedirect("login");
            return;
        }

        User user = (User) session.getAttribute("userlogin");

        String status = req.getParameter("status");

        List<Order> orders;
        if (status != null && !status.isEmpty() && !status.equals("all")) {
            orders = orderDao.getByUserIdAndStatus(user.getId(), status);
        } else {
            orders = orderDao.getByUserId(user.getId());
        }

        // Gắn item cho từng order
        for (Order o : orders) {
            List<model.OrderItem> items = orderItemDao.getByOrderId(o.getId());
            System.out.println("Order ID: " + o.getId() + " has " + items.size() + " items");
            for (model.OrderItem item : items) {
                System.out.println("  - Product: " + item.getProductId() + ", Thumbnail: " + item.getThumbnail());
            }
            o.setItems(items);
        }

        req.setAttribute("orders", orders);
        req.setAttribute("currentStatus", status != null ? status : "all");
        req.getRequestDispatcher("/WEB-INF/views/order-user.jsp").forward(req, resp);
    }
}

