<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Order</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/sidebarAdmin.css">
</head>
<body>
<div class="admin">

    <jsp:include page="include/sidebarAdmin.jsp" />

    <section class="content">
        <header class="topbar">
            <h1 id="pageTitle">Quản Lý Đơn Hàng</h1>
            <div class="actions">
                <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng xuất</a>
            </div>
        </header>


        <main id="page">
            <section id="dashboard" class="page active">
                <div class="cards">
                    <div class="card">Tổng đơn<br><span>${total}</span></div>
                    <div class="card">Đang xử lý<br><span>${countPending}</span></div>
                    <div class="card">Hoàn thành<br><span>${countCompleted}</span></div>
                </div>

                <div class="user-table-wrapper">
                    <table class="order-table">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Khách hàng</th>
                            <th>Tổng tiền</th>
                            <th>Trạng thái</th>
                            <th>Ngày tạo</th>
                            <th>Hành động</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:if test="${empty orders}">
                            <tr>
                                <td colspan="6" style="text-align:center">
                                    Chưa có đơn hàng.
                                </td>
                            </tr>
                        </c:if>

                        <c:forEach items="${orders}" var="o">
                            <tr>
                                <td>#${o.id}</td>
                                <td>${o.name}</td>
                                <td><fmt:formatNumber value="${o.finalAmount}" type="number"/> đ</td>
                                <td>
                                    <span class="order-status ${o.orderStatus}">
                                        <c:choose>
                                            <c:when test="${o.orderStatus == 'PENDING'}">Chờ xử lý</c:when>
                                            <c:when test="${o.orderStatus == 'SHIPPING'}">Đang giao</c:when>
                                            <c:when test="${o.orderStatus == 'COMPLETED'}">Hoàn thành</c:when>
                                            <c:when test="${o.orderStatus == 'CANCELLED'}">Đã hủy</c:when>
                                            <c:otherwise>${o.orderStatus}</c:otherwise>
                                        </c:choose>
                                    </span>
                                </td>

                                <td>
                                        ${o.createdAtFormatted}
                                </td>
                                <td>
                                    <a href="orderAdmin?mode=view&id=${o.id}" class="icon-btn view">
                                        <i class="fa fa-eye"></i>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>

                </div>

                <c:if test="${totalPages > 1}">
                    <div class="pagination">
                        <div class="pagination-info">
                            Hiển thị ${(currentPage - 1) * pageSize + 1} - ${currentPage * pageSize > totalOrders ? totalOrders : currentPage * pageSize} của ${totalOrders} đơn hàng
                        </div>
                        <div class="pagination-controls">
                            <c:if test="${currentPage > 1}">
                                <a href="orderAdmin?page=1" class="page-btn">« Đầu</a>
                                <a href="orderAdmin?page=${currentPage - 1}" class="page-btn">‹ Trước</a>
                            </c:if>

                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <c:choose>
                                    <c:when test="${i == currentPage}">
                                        <span class="page-btn active">${i}</span>
                                    </c:when>
                                    <c:when test="${i == 1 || i == totalPages || (i >= currentPage - 2 && i <= currentPage + 2)}">
                                        <a href="orderAdmin?page=${i}" class="page-btn">${i}</a>
                                    </c:when>
                                    <c:when test="${i == currentPage - 3 || i == currentPage + 3}">
                                        <span class="page-btn dots">...</span>
                                    </c:when>
                                </c:choose>
                            </c:forEach>

                            <c:if test="${currentPage < totalPages}">
                                <a href="orderAdmin?page=${currentPage + 1}" class="page-btn">Sau ›</a>
                                <a href="orderAdmin?page=${totalPages}" class="page-btn">Cuối »</a>
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

