package controller.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import service.OrderService;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/cancel-order")
public class CancelOrderController extends HttpServlet {
    private OrderService orderService;

    @Override
    public void init() {
        orderService = new OrderService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userlogin") == null) {
            response.sendRedirect("login");
            return;
        }

        Integer orderId = parseOrderId(request.getParameter("id"));
        if (orderId == null) {
            response.sendRedirect("order-user?cancel=invalid");
            return;
        }

        User user = (User) session.getAttribute("userlogin");
        var cancellationCheck = orderService.cancelUserOrder(orderId, user.getId());
        if (!cancellationCheck.cancellable()) {
            response.sendRedirect("order-user?cancel=failed&message=" + URLEncoder.encode(cancellationCheck.message(), StandardCharsets.UTF_8));
            return;
        }

        response.sendRedirect("order-user?status=CANCELLED&cancel=success");
    }

    private Integer parseOrderId(String rawOrderId) {
        if (rawOrderId == null || rawOrderId.isBlank()) {
            return null;
        }
        try {
            return Integer.parseInt(rawOrderId.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
