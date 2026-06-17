package service;

import dao.admin.DashboardDao;
import model.ProductSaleStatDto;

import java.time.LocalDate;
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

    public double totalImportCost() {
        return dao.totalImportCost();
    }

    public double[] importCostByMonth(int year) {
        return dao.importCostByMonth(year);
    }

    public double[] importCostByDaysInMonth(int year, int month) {
        return dao.importCostByDaysInMonth(year, month);
    }

    public java.util.Map<String, Double> importCostByDateRange(String startDateStr, String endDateStr) {
        return dao.importCostByDateRange(startDateStr, endDateStr);
    }

    public double[] ordersByMonth(int year) {
        return dao.ordersByMonth(year);
    }

    public double[] ordersByDaysInMonth(int year, int month) {
        return dao.ordersByDaysInMonth(year, month);
    }

    public java.util.Map<String, Double> ordersByDateRange(String startDateStr, String endDateStr) {
        return dao.ordersByDateRange(startDateStr, endDateStr);
    }

    public List<ProductSaleStatDto> getTopSellingProducts(
            Integer year, Integer month, String startDate, String endDate, int limit) {
        return dao.getTopSellingProducts(year, month, startDate, endDate, limit);
    }

    public List<ProductSaleStatDto> getUnsoldProducts(
            Integer year, Integer month, String startDate, String endDate) {
        return dao.getUnsoldProducts(year, month, startDate, endDate);
    }
}
