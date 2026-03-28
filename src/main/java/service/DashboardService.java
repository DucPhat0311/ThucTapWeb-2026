package service;

import dao.admin.DashboardDao;
import model.Order;

import java.util.List;

public class DashboardService {

    private DashboardDao dao = new DashboardDao();

    public int countOrders() {
        return dao.countOrders();
    }

    public double totalRevenue() {
        return dao.totalRevenue();
    }

    public int countProducts() {
        return dao.countProducts();
    }

    public int countUsers() {
        return dao.countUsers();
    }

    public List<Order> latestOrders(int limit) {
        return dao.latestOrders(limit);
    }
}
