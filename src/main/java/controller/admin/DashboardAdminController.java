package controller.admin;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.constant.OrderStatusLabel;
import service.DashboardService;

import java.io.IOException;
import java.time.LocalDate;

@WebServlet(name = "DashboardAdminController", value = "/dashboardAdmin")
public class DashboardAdminController extends HttpServlet {
    private DashboardService service;
    private static final ObjectMapper mapper = new ObjectMapper();

    @Override
    public void init() {
        service = new DashboardService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("totalOrders",   service.countOrders());
        request.setAttribute("totalRevenue",  service.totalRevenue());
        request.setAttribute("totalProducts", service.countProducts());
        request.setAttribute("totalUsers",    service.countUsers());

        // Get filter parameters
        String yearParam = request.getParameter("year");
        String monthParam = request.getParameter("month");
        String startDateParam = request.getParameter("startDate");
        String endDateParam = request.getParameter("endDate");

        Object chartData = null;
        Object chartLabels = null;
        String filterType = "year"; // "year", "month", "range"

        int currentYear = LocalDate.now().getYear();
        int selectedYear = currentYear;
        if (yearParam != null && !yearParam.trim().isEmpty()) {
            try {
                selectedYear = Integer.parseInt(yearParam);
            } catch (NumberFormatException e) {
                // Keep default
            }
        }

        if (startDateParam != null && !startDateParam.trim().isEmpty() &&
            endDateParam != null && !endDateParam.trim().isEmpty()) {
            
            // Filter by date range
            filterType = "range";
            java.util.Map<String, Double> rangeData = service.revenueByDateRange(startDateParam, endDateParam);
            chartLabels = new java.util.ArrayList<>(rangeData.keySet());
            chartData = new java.util.ArrayList<>(rangeData.values());
            
        } else if (monthParam != null && !monthParam.trim().isEmpty() && !monthParam.equals("all")) {
            // Filter by specific month in year
            try {
                int selectedMonth = Integer.parseInt(monthParam);
                filterType = "month";
                double[] dailyRev = service.revenueByDaysInMonth(selectedYear, selectedMonth);
                
                // Labels from "Ngày 1" to "Ngày N"
                java.util.List<String> labels = new java.util.ArrayList<>();
                java.util.List<Double> dataList = new java.util.ArrayList<>();
                for (int i = 0; i < dailyRev.length; i++) {
                    labels.add("Ngày " + (i + 1));
                    dataList.add(dailyRev[i]);
                }
                chartLabels = labels;
                chartData = dataList;
                request.setAttribute("selectedMonth", selectedMonth);
            } catch (NumberFormatException e) {
                // fallback to year
                filterType = "year";
            }
        }

        // Default: Filter by Year
        if (filterType.equals("year")) {
            double[] monthlyRevenue = service.revenueByMonth(selectedYear);
            java.util.List<String> labels = java.util.Arrays.asList(
                "Tháng 1", "Tháng 2", "Tháng 3", "Tháng 4", "Tháng 5", "Tháng 6",
                "Tháng 7", "Tháng 8", "Tháng 9", "Tháng 10", "Tháng 11", "Tháng 12"
            );
            java.util.List<Double> dataList = new java.util.ArrayList<>();
            for (double v : monthlyRevenue) {
                dataList.add(v);
            }
            chartLabels = labels;
            chartData = dataList;
        }

        request.setAttribute("chartLabelsJson", mapper.writeValueAsString(chartLabels));
        request.setAttribute("chartDataJson", mapper.writeValueAsString(chartData));
        request.setAttribute("selectedYear", selectedYear);
        request.setAttribute("startDate", startDateParam);
        request.setAttribute("endDate", endDateParam);
        request.setAttribute("filterType", filterType);

        request.setAttribute("page", "dashboard");
        request.getRequestDispatcher("/WEB-INF/admin/dashboardAdmin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }
}
