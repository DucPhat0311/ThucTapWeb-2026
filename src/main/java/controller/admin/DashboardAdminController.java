package controller.admin;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.ProductSaleStatDto;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import model.constant.OrderStatusLabel;
import service.DashboardService;
import java.io.IOException;
import java.io.OutputStream;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

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

        String action = request.getParameter("action");
        if ("exportExcel".equalsIgnoreCase(action)) {
            exportDashboardExcel(request, response);
            return;
        }

        request.setAttribute("totalOrders", service.countOrders());
        request.setAttribute("totalRevenue", service.totalRevenue());
        request.setAttribute("totalProfit", service.totalProfit());
        request.setAttribute("totalImportCost", service.totalImportCost());

        String yearParam = request.getParameter("year");
        String monthParam = request.getParameter("month");
        String startDateParam = request.getParameter("startDate");
        String endDateParam = request.getParameter("endDate");

        String hotMonthParam = request.getParameter("hotMonth");
        String hotStartDate = request.getParameter("hotStartDate");
        String hotEndDate = request.getParameter("hotEndDate");

        String coldMonthParam = request.getParameter("coldMonth");
        String coldStartDate = request.getParameter("coldStartDate");
        String coldEndDate = request.getParameter("coldEndDate");

        Integer statYear = LocalDate.now().getYear();

        Integer hotMonth = null;
        if (hotMonthParam != null && !hotMonthParam.trim().isEmpty()) {
            try { hotMonth = Integer.parseInt(hotMonthParam); } catch (NumberFormatException ignored) {}
        }

        Integer coldMonth = null;
        if (coldMonthParam != null && !coldMonthParam.trim().isEmpty()) {
            try { coldMonth = Integer.parseInt(coldMonthParam); } catch (NumberFormatException ignored) {}
        }

        List<ProductSaleStatDto> topSelling = service.getTopSellingProducts(
                statYear, hotMonth, hotStartDate, hotEndDate, 20);

        List<ProductSaleStatDto> unsold = service.getUnsoldProducts(
                statYear, coldMonth, coldStartDate, coldEndDate);

        request.setAttribute("topSellingProducts", topSelling);
        request.setAttribute("unsoldProducts", unsold);

        request.setAttribute("hotMonth", hotMonthParam);
        request.setAttribute("hotStartDate", hotStartDate);
        request.setAttribute("hotEndDate", hotEndDate);

        request.setAttribute("coldMonth", coldMonthParam);
        request.setAttribute("coldStartDate", coldStartDate);
        request.setAttribute("coldEndDate", coldEndDate);

        Object chartData = null;
        Object chartLabels = null;
        Object profitData = null;
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

            java.util.Map<String, Double> rangeProfitData = service.profitByDateRange(startDateParam, endDateParam);
            profitData = new java.util.ArrayList<>(rangeProfitData.values());

        } else if (monthParam != null && !monthParam.trim().isEmpty() && !monthParam.equals("all")) {
            // Filter by specific month in year
            try {
                int selectedMonth = Integer.parseInt(monthParam);
                filterType = "month";
                double[] dailyRev = service.revenueByDaysInMonth(selectedYear, selectedMonth);
                double[] dailyProfit = service.profitByDaysInMonth(selectedYear, selectedMonth);

                // Labels from "Ngày 1" to "Ngày N"
                java.util.List<String> labels = new java.util.ArrayList<>();
                java.util.List<Double> dataList = new java.util.ArrayList<>();
                java.util.List<Double> profitList = new java.util.ArrayList<>();
                for (int i = 0; i < dailyRev.length; i++) {
                    labels.add("Ngày " + (i + 1));
                    dataList.add(dailyRev[i]);
                    profitList.add(dailyProfit[i]);
                }
                chartLabels = labels;
                chartData = dataList;
                profitData = profitList;
                request.setAttribute("selectedMonth", selectedMonth);
            } catch (NumberFormatException e) {
                // fallback to year
                filterType = "year";
            }
        }

        // Default: Filter by Year
        if (filterType.equals("year")) {
            double[] monthlyRevenue = service.revenueByMonth(selectedYear);
            double[] monthlyProfit = service.profitByMonth(selectedYear);
            java.util.List<String> labels = java.util.Arrays.asList(
                    "Tháng 1", "Tháng 2", "Tháng 3", "Tháng 4", "Tháng 5", "Tháng 6",
                    "Tháng 7", "Tháng 8", "Tháng 9", "Tháng 10", "Tháng 11", "Tháng 12");
            java.util.List<Double> dataList = new java.util.ArrayList<>();
            java.util.List<Double> profitList = new java.util.ArrayList<>();
            for (int i = 0; i < monthlyRevenue.length; i++) {
                dataList.add(monthlyRevenue[i]);
                profitList.add(monthlyProfit[i]);
            }
            chartLabels = labels;
            chartData = dataList;
            profitData = profitList;
        }

        request.setAttribute("chartLabelsJson", mapper.writeValueAsString(chartLabels));
        request.setAttribute("chartDataJson", mapper.writeValueAsString(chartData));
        request.setAttribute("profitDataJson", mapper.writeValueAsString(profitData));
        request.setAttribute("selectedYear", selectedYear);
        request.setAttribute("startDate", startDateParam);
        request.setAttribute("endDate", endDateParam);
        request.setAttribute("filterType", filterType);

        request.setAttribute("page", "dashboard");
        request.getRequestDispatcher("/WEB-INF/admin/dashboardAdmin.jsp").forward(request, response);
    }

    private void exportDashboardExcel(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Integer selectedYear = parseInteger(request.getParameter("year"), LocalDate.now().getYear());
        String monthParam = request.getParameter("month");
        Integer selectedMonth = (monthParam != null && !"all".equalsIgnoreCase(monthParam))
                ? parseInteger(monthParam, null)
                : null;
        String startDate = trimToNull(request.getParameter("startDate"));
        String endDate = trimToNull(request.getParameter("endDate"));

        String hotMonthParam = trimToNull(request.getParameter("hotMonth"));
        Integer hotMonth = parseInteger(hotMonthParam, null);
        String hotStartDate = trimToNull(request.getParameter("hotStartDate"));
        String hotEndDate = trimToNull(request.getParameter("hotEndDate"));

        String coldMonthParam = trimToNull(request.getParameter("coldMonth"));
        Integer coldMonth = parseInteger(coldMonthParam, null);
        String coldStartDate = trimToNull(request.getParameter("coldStartDate"));
        String coldEndDate = trimToNull(request.getParameter("coldEndDate"));

        List<ProductSaleStatDto> topSelling = service.getTopSellingProducts(
                selectedYear, hotMonth, hotStartDate, hotEndDate, 20);
        List<ProductSaleStatDto> unsold = service.getUnsoldProducts(
                selectedYear, coldMonth, coldStartDate, coldEndDate);

        String fileName = buildDashboardExportFileName(selectedYear, selectedMonth, startDate, endDate);
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");

        try (Workbook workbook = new XSSFWorkbook()) {
            createSoldSheet(workbook, topSelling, selectedYear, selectedMonth, startDate, endDate, hotMonth, hotStartDate, hotEndDate);
            createUnsoldSheet(workbook, unsold, selectedYear, selectedMonth, startDate, endDate, coldMonth, coldStartDate, coldEndDate);
            try (OutputStream out = response.getOutputStream()) {
                workbook.write(out);
                out.flush();
            }
        }
    }

    private void createSoldSheet(Workbook workbook,
                                 List<ProductSaleStatDto> rows,
                                 Integer selectedYear,
                                 Integer selectedMonth,
                                 String startDate,
                                 String endDate,
                                 Integer hotMonth,
                                 String hotStartDate,
                                 String hotEndDate) {
        Sheet sheet = workbook.createSheet("San pham ban duoc");
        writeSheetTitle(sheet, workbook, "THONG KE SAN PHAM BAN DUOC");
        writeFilterInfo(sheet, 1, "Bo loc dashboard",
                buildFilterSummary(selectedYear, selectedMonth, startDate, endDate, hotMonth, hotStartDate, hotEndDate));
        writeProductTable(sheet, workbook, 3, rows, false);
    }

    private void createUnsoldSheet(Workbook workbook,
                                   List<ProductSaleStatDto> rows,
                                   Integer selectedYear,
                                   Integer selectedMonth,
                                   String startDate,
                                   String endDate,
                                   Integer coldMonth,
                                   String coldStartDate,
                                   String coldEndDate) {
        Sheet sheet = workbook.createSheet("San pham khong ban");
        writeSheetTitle(sheet, workbook, "THONG KE SAN PHAM KHONG BAN DUOC");
        writeFilterInfo(sheet, 1, "Bo loc dashboard",
                buildFilterSummary(selectedYear, selectedMonth, startDate, endDate, coldMonth, coldStartDate, coldEndDate));
        writeProductTable(sheet, workbook, 3, rows, true);
    }

    private void writeSheetTitle(Sheet sheet, Workbook workbook, String title) {
        Row row = sheet.createRow(0);
        Cell cell = row.createCell(0);
        cell.setCellValue(title);
        CellStyle style = workbook.createCellStyle();
        Font font = workbook.createFont();
        font.setBold(true);
        font.setFontHeightInPoints((short) 14);
        style.setFont(font);
        cell.setCellStyle(style);
        sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 5));
    }

    private void writeFilterInfo(Sheet sheet, int rowIndex, String label, String value) {
        Row row = sheet.createRow(rowIndex);
        row.createCell(0).setCellValue(label);
        row.createCell(1).setCellValue(value);
        sheet.addMergedRegion(new CellRangeAddress(rowIndex, rowIndex, 1, 5));
    }

    private void writeProductTable(Sheet sheet, Workbook workbook, int startRow, List<ProductSaleStatDto> rows, boolean unsoldSheet) {
        String[] headers = {"STT", "Mã sản phẩm", "Tên sản phẩm", "Danh mục", "Giá", "Đã bán"};
        Row headerRow = sheet.createRow(startRow);
        CellStyle headerStyle = createHeaderStyle(workbook);
        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerStyle);
        }

        CellStyle moneyStyle = workbook.createCellStyle();
        DataFormat dataFormat = workbook.createDataFormat();
        moneyStyle.setDataFormat(dataFormat.getFormat("#,##0"));

        int rowIndex = startRow + 1;
        for (int i = 0; i < rows.size(); i++) {
            ProductSaleStatDto p = rows.get(i);
            Row row = sheet.createRow(rowIndex++);
            row.createCell(0).setCellValue(i + 1);
            row.createCell(1).setCellValue(p.getProductCode());
            row.createCell(2).setCellValue(p.getProductName());
            row.createCell(3).setCellValue(p.getCategoryName());
            Cell priceCell = row.createCell(4);
            priceCell.setCellValue(p.getPrice());
            priceCell.setCellStyle(moneyStyle);
            row.createCell(5).setCellValue(unsoldSheet ? 0 : p.getTotalSold());
        }

        for (int i = 0; i < headers.length; i++) {
            sheet.autoSizeColumn(i);
        }
    }

    private CellStyle createHeaderStyle(Workbook workbook) {
        CellStyle style = workbook.createCellStyle();
        Font font = workbook.createFont();
        font.setBold(true);
        style.setFont(font);
        style.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
        style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        style.setBorderBottom(BorderStyle.THIN);
        style.setBorderTop(BorderStyle.THIN);
        style.setBorderLeft(BorderStyle.THIN);
        style.setBorderRight(BorderStyle.THIN);
        return style;
    }

    private String buildDashboardExportFileName(Integer year, Integer month, String startDate, String endDate) {
        String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss"));
        String suffix;
        if (startDate != null && endDate != null) {
            suffix = "range_" + startDate + "_" + endDate;
        } else if (month != null) {
            suffix = "month_" + year + "_" + month;
        } else {
            suffix = "year_" + year;
        }
        return ("bangthongke_banduoc_kobandc_" + suffix + "_" + timestamp + ".xlsx").replaceAll("[^a-zA-Z0-9._-]", "_");
    }

    private String buildFilterSummary(Integer selectedYear,
                                      Integer selectedMonth,
                                      String startDate,
                                      String endDate,
                                      Integer extraMonth,
                                      String extraStartDate,
                                      String extraEndDate) {
        StringBuilder sb = new StringBuilder();
        if (startDate != null && endDate != null) {
            sb.append("Khoang ngay: ").append(startDate).append(" -> ").append(endDate);
        } else if (selectedMonth != null) {
            sb.append("Thang: ").append(selectedMonth).append("/").append(selectedYear);
        } else {
            sb.append("Nam: ").append(selectedYear);
        }
        if (extraMonth != null) {
            sb.append(" | Lọc bảng: thang ").append(extraMonth);
        }
        if (extraStartDate != null && extraEndDate != null) {
            sb.append(" | Lọc bảng: ").append(extraStartDate).append(" -> ").append(extraEndDate);
        }
        return sb.toString();
    }

    private Integer parseInteger(String value, Integer defaultValue) {
        if (value == null || value.trim().isEmpty()) {
            return defaultValue;
        }
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    private String trimToNull(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }
}
