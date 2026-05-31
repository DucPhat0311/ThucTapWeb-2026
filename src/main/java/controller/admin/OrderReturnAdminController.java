package controller.admin;

import dao.admin.OrderReturnDaoAdmin;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.OrderReturn;
import model.constant.OrderReturnStatus;
import model.constant.PaymentMethod;
import model.constant.PaymentStatus;
import service.OrderService;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

@WebServlet(name = "OrderReturnAdminController", value = "/returnAdmin")
public class OrderReturnAdminController extends HttpServlet {
    private static final int PAGE_SIZE = 8;
    private static final Set<String> FILTER_STATUSES = Set.of(
            OrderReturnStatus.REQUESTED,
            OrderReturnStatus.APPROVED,
            OrderReturnStatus.REJECTED,
            OrderReturnStatus.RETURNING,
            OrderReturnStatus.RETURNED
    );

    private OrderReturnDaoAdmin orderReturnDao;
    private OrderService orderService;

    @Override
    public void init() {
        orderReturnDao = new OrderReturnDaoAdmin();
        orderService = new OrderService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAdminLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        setCommonAttributes(request);
        if ("view".equals(request.getParameter("mode"))) {
            showDetail(request, response);
            return;
        }
        showList(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        if (!isAdminLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.setCharacterEncoding("UTF-8");
        int id;
        try {
            id = Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/returnAdmin");
            return;
        }

        String action = request.getParameter("action");
        String adminNote = trimToEmpty(request.getParameter("adminNote"));
        boolean updated;
        String result;

        if ("approve".equals(action)) {
            updated = orderReturnDao.approve(id, adminNote);
            result = "approved";
        } else if ("reject".equals(action)) {
            if (adminNote.isBlank()) {
                redirectDetail(response, request, id, "error=reject_note_required");
                return;
            }
            updated = orderReturnDao.reject(id, adminNote);
            result = "rejected";
        } else if ("startReturning".equals(action)) {
            updated = orderReturnDao.startReturning(id, adminNote);
            result = "returning";
        } else if ("completeReturn".equals(action)) {
            updated = orderReturnDao.completeReturnAndRestoreStock(id, adminNote);
            result = "returned";
        } else if ("confirmRefund".equals(action)) {
            updated = orderReturnDao.confirmRefund(id, adminNote);
            result = "refunded";
        } else {
            redirectDetail(response, request, id, "error=invalid_action");
            return;
        }

        redirectDetail(response, request, id,
                updated ? "success=" + result : "error=invalid_transition");
    }

    private void showList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<OrderReturn> allRequests = orderReturnDao.getAll();
        String status = trimToEmpty(request.getParameter("status"));
        List<OrderReturn> filteredRequests = allRequests;
        if (FILTER_STATUSES.contains(status)) {
            filteredRequests = allRequests.stream()
                    .filter(item -> status.equals(item.getReturnStatus()))
                    .collect(Collectors.toList());
            request.setAttribute("currentStatus", status);
        }

        int currentPage = parsePositiveInt(request.getParameter("page"), 1);
        int totalPages = (int) Math.ceil((double) filteredRequests.size() / PAGE_SIZE);
        if (totalPages > 0 && currentPage > totalPages) {
            currentPage = totalPages;
        }
        int start = Math.min((currentPage - 1) * PAGE_SIZE, filteredRequests.size());
        int end = Math.min(start + PAGE_SIZE, filteredRequests.size());

        request.setAttribute("returns", filteredRequests.subList(start, end));
        request.setAttribute("total", allRequests.size());
        request.setAttribute("totalFiltered", filteredRequests.size());
        request.setAttribute("countRequested", countStatus(allRequests, OrderReturnStatus.REQUESTED));
        request.setAttribute("countApproved", countStatus(allRequests, OrderReturnStatus.APPROVED));
        request.setAttribute("countRejected", countStatus(allRequests, OrderReturnStatus.REJECTED));
        request.setAttribute("countReturning", countStatus(allRequests, OrderReturnStatus.RETURNING));
        request.setAttribute("countReturned", countStatus(allRequests, OrderReturnStatus.RETURNED));
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("pageSize", PAGE_SIZE);
        request.getRequestDispatcher("/WEB-INF/admin/returnAdmin.jsp").forward(request, response);
    }

    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id;
        try {
            id = Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/returnAdmin");
            return;
        }

        OrderReturn orderReturn = orderReturnDao.findById(id).orElse(null);
        if (orderReturn == null) {
            response.sendRedirect(request.getContextPath() + "/returnAdmin");
            return;
        }

        request.setAttribute("orderReturn", orderReturn);
        request.setAttribute("order", orderService.findById(orderReturn.getOrderId()));
        request.setAttribute("items", orderService.getOrderItems(orderReturn.getOrderId()));
        request.getRequestDispatcher("/WEB-INF/admin/return-detailAdmin.jsp").forward(request, response);
    }

    private void setCommonAttributes(HttpServletRequest request) {
        request.setAttribute("page", "return");
        request.setAttribute("paymentMethodLabels", Map.of(
                PaymentMethod.COD, "Thanh toán khi nhận hàng",
                PaymentMethod.VNPAY, "VNPay"
        ));
        request.setAttribute("paymentStatusLabels", Map.of(
                PaymentStatus.UNPAID, "Chưa thanh toán",
                PaymentStatus.PENDING, "Đang chờ thanh toán",
                PaymentStatus.PAID, "Đã thanh toán",
                PaymentStatus.FAILED, "Thanh toán thất bại",
                PaymentStatus.REFUND_PENDING, "Chờ hoàn tiền",
                PaymentStatus.REFUNDED, "Đã hoàn tiền"
        ));
    }

    private long countStatus(List<OrderReturn> requests, String status) {
        return requests.stream().filter(item -> status.equals(item.getReturnStatus())).count();
    }

    private boolean isAdminLoggedIn(HttpServletRequest request) {
        return request.getSession(false) != null
                && request.getSession(false).getAttribute("admin") != null;
    }

    private int parsePositiveInt(String value, int fallback) {
        try {
            int parsed = Integer.parseInt(value);
            return parsed > 0 ? parsed : fallback;
        } catch (NumberFormatException e) {
            return fallback;
        }
    }

    private String trimToEmpty(String value) {
        return value == null ? "" : value.trim();
    }

    private void redirectDetail(HttpServletResponse response, HttpServletRequest request,
                                int id, String result) throws IOException {
        response.sendRedirect(request.getContextPath() + "/returnAdmin?mode=view&id=" + id + "&" + result);
    }
}
