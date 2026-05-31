package service;

import dao.admin.DashboardDao;

import java.time.LocalDate;

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

    /** Doanh thu theo từng tháng trong năm hiện tại. */
    public double[] revenueByMonth() {
        int currentYear = LocalDate.now().getYear();
        return dao.revenueByMonth(currentYear);
    }
}
