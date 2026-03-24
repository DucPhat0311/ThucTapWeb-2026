package controller.web;

import dao.user.OrderDao;
import dao.user.OrderItemDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "OrderSuccessController", value = "/order-success")
public class OrderSuccessController extends HttpServlet {
    private OrderDao orderDao;
    private OrderItemDao orderItemDao;


    @Override
    public void init() {
        orderDao = new OrderDao();
        orderItemDao = new OrderItemDao();
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userlogin") == null) {
            response.sendRedirect("login");
            return;
        }

        Integer orderId = (Integer) session.getAttribute("lastOrderId");
        if (orderId == null) {
            response.sendRedirect("home");
            return;
        }

        //Lấy order
        var order = orderDao.getById(orderId);
        if (order == null) {
            response.sendRedirect("home");
            return;
        }

        var orderItems = orderItemDao.getByOrderId(orderId);

        request.setAttribute("order", order);
        request.setAttribute("orderItems", orderItems);

        session.removeAttribute("lastOrderId");

        request.getRequestDispatcher("/WEB-INF/views/checkout-success.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}


