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
}