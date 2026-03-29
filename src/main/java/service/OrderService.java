package service;

import dao.admin.OrderDaoAdmin;
import dao.user.OrderDao;
import model.*;

import java.util.List;

public class OrderService {
    
    private OrderDaoAdmin dao = new OrderDaoAdmin();

    public List<Order> getAllOrders() {
        return dao.getAll();
}

    public Order findById(int id) {
        return dao.findById(id);
    }

    public List<OrderItem> getOrderItems(int orderId) {
        return dao.getItems(orderId);
    }

    public void updateStatus(int id, String status) {
        dao.updateStatus(id, status);
    }
    public String getUserEmailByOrderId(int orderId) {
        return dao.getUserEmailByOrderId(orderId);
    }

}