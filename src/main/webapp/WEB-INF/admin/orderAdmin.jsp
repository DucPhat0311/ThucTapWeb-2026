<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
        <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Quản lý đơn hàng</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/sidebarAdmin.css?v=<%= System.currentTimeMillis() %>">
            </head>

            <body>
                <div class="admin">

                    <jsp:include page="include/sidebarAdmin.jsp" />

                    <section class="content">
                        <header class="topbar">
                            <h1 id="pageTitle">Quản lý đơn hàng</h1>
                            <div class="actions">
                                <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng xuất</a>
                            </div>
                        </header>

                        <main id="page">
                            <section id="dashboard" class="page active">
                                <div class="cards order-cards">
                                    <div class="card ${empty currentStatus ? 'active' : ''}" style="cursor: pointer;"
                                        onclick="window.location.href='${pageContext.request.contextPath}/orderAdmin'">
                                        Tổng đơn<br><span>${total}</span></div>
                                    <div class="card ${currentStatus == 'PENDING' ? 'active' : ''}"
                                        style="cursor: pointer;"
                                        onclick="window.location.href='${pageContext.request.contextPath}/orderAdmin?status=PENDING'">
                                        Cần xác nhận<br><span>${countPending}</span></div>
                                    <div class="card ${currentStatus == 'PENDING_PAYMENT' ? 'active' : ''}"
                                        style="cursor: pointer;"
                                        onclick="window.location.href='${pageContext.request.contextPath}/orderAdmin?status=PENDING_PAYMENT'">
                                        Chờ thanh toán<br><span>${countPendingPayment}</span></div>
                                    <div class="card ${currentStatus == 'PROCESSING' ? 'active' : ''}"
                                        style="cursor: pointer;"
                                        onclick="window.location.href='${pageContext.request.contextPath}/orderAdmin?status=PROCESSING'">
                                        Đang chuẩn bị hàng<br><span>${countProcessing}</span></div>
                                    <div class="card ${currentStatus == 'SHIPPING' ? 'active' : ''}"
                                        style="cursor: pointer;"
                                        onclick="window.location.href='${pageContext.request.contextPath}/orderAdmin?status=SHIPPING'">
                                        Đang giao hàng<br><span>${countShipping}</span></div>
                                    <div class="card ${currentStatus == 'COMPLETED' ? 'active' : ''}"
                                        style="cursor: pointer;"
                                        onclick="window.location.href='${pageContext.request.contextPath}/orderAdmin?status=COMPLETED'">
                                        Đã hoàn thành<br><span>${countCompleted}</span></div>
                                    <div class="card ${currentStatus == 'CANCELLED' ? 'active' : ''}"
                                        style="cursor: pointer;"
                                        onclick="window.location.href='${pageContext.request.contextPath}/orderAdmin?status=CANCELLED'">
                                        Đã hủy<br><span>${countCancelled}</span></div>
                                </div>

                                <div class="user-table-wrapper">
                                    <table class="order-table">
                                        <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>Khách hàng</th>
                                                <th>Tổng tiền</th>
                                                <th>Phương thức</th>
                                                <th>Thanh toán</th>
                                                <th>Trạng thái đơn</th>
                                                <th>Ngày tạo</th>
                                                <th>Hành động</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:if test="${empty orders}">
                                                <tr>
                                                    <td colspan="8" style="text-align:center">
                                                        Chưa có đơn hàng.
                                                    </td>
                                                </tr>
                                            </c:if>

                                            <c:forEach items="${orders}" var="o">
                                                <tr>
                                                    <td>#${o.id}</td>
                                                    <td>${o.name}</td>
                                                    <td>
                                                        <fmt:formatNumber value="${o.finalAmount}" type="number" /> đ
                                                    </td>
                                                    <td>${paymentMethodLabels[o.paymentMethods]}</td>
                                                    <td>
                                                        <span class="pay-status ${o.paymentStatuses}">
                                                            ${paymentStatusLabels[o.paymentStatuses]}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <span class="order-status ${o.orderStatus}">
                                                            ${orderStatusLabels[o.orderStatus]}
                                                        </span>
                                                    </td>
                                                    <td>${o.createdAtFormatted}</td>
                                                    <td>
                                                        <c:if test="${perms[\'view_detail\']}">
<a href="${pageContext.request.contextPath}/orderAdmin?mode=view&id=${o.id}"
                                                            class="icon-btn view">
                                                            <i class="fa fa-eye"></i>
                                                        </a>
</c:if>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>

                                <c:if test="${totalPages > 1}">
                                    <c:choose>
                                        <c:when test="${not empty currentStatus}">
                                            <c:set var="statusParam" value="&amp;status=${currentStatus}" />
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="statusParam" value="" />
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="pagination">
                                        <div class="pagination-info">
                                            Hiển thị ${(currentPage - 1) * pageSize + 1}
                                            - ${currentPage * pageSize > totalOrders ? totalOrders : currentPage *
                                            pageSize}
                                            của ${totalOrders} đơn hàng
                                        </div>
                                        <div class="pagination-controls">
                                            <c:if test="${currentPage > 1}">
                                                <a href="${pageContext.request.contextPath}/orderAdmin?page=1${statusParam}"
                                                    class="page-btn">« Đầu</a>
                                                <a href="${pageContext.request.contextPath}/orderAdmin?page=${currentPage - 1}${statusParam}"
                                                    class="page-btn">‹ Trước</a>
                                            </c:if>

                                            <c:forEach begin="1" end="${totalPages}" var="i">
                                                <c:choose>
                                                    <c:when test="${i == currentPage}">
                                                        <span class="page-btn active">${i}</span>
                                                    </c:when>
                                                    <c:when
                                                        test="${i == 1 || i == totalPages || (i >= currentPage - 2 && i <= currentPage + 2)}">
                                                        <a href="${pageContext.request.contextPath}/orderAdmin?page=${i}${statusParam}"
                                                            class="page-btn">${i}</a>
                                                    </c:when>
                                                    <c:when test="${i == currentPage - 3 || i == currentPage + 3}">
                                                        <span class="page-btn dots">...</span>
                                                    </c:when>
                                                </c:choose>
                                            </c:forEach>

                                            <c:if test="${currentPage < totalPages}">
                                                <a href="${pageContext.request.contextPath}/orderAdmin?page=${currentPage + 1}${statusParam}"
                                                    class="page-btn">Sau ›</a>
                                                <a href="${pageContext.request.contextPath}/orderAdmin?page=${totalPages}${statusParam}"
                                                    class="page-btn">Cuối »</a>
                                            </c:if>
                                        </div>
                                    </div>
                                </c:if>
                            </section>
                        </main>
                    </section>

                </div>

                <script src="${pageContext.request.contextPath}/js/admin/adminOrder.js"></script>
            </body>

            </html>