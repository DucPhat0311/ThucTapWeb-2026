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

    public double[] revenueByMonth() {
        int currentYear = LocalDate.now().getYear();
        return dao.revenueByMonth(currentYear);
    }

    public double[] revenueByMonth(int year) {
        return dao.revenueByMonth(year);
    }

    public double[] revenueByDaysInMonth(int year, int month) {
        return dao.revenueByDaysInMonth(year, month);
    }

    public java.util.Map<String, Double> revenueByDateRange(String startDateStr, String endDateStr) {
        return dao.revenueByDateRange(startDateStr, endDateStr);
    }

    public double totalProfit() {
        return dao.totalProfit();
    }

    public double[] profitByMonth(int year) {
        return dao.profitByMonth(year);
    }

    public double[] profitByDaysInMonth(int year, int month) {
        return dao.profitByDaysInMonth(year, month);
    }

    public java.util.Map<String, Double> profitByDateRange(String startDateStr, String endDateStr) {
        return dao.profitByDateRange(startDateStr, endDateStr);
    }
}
