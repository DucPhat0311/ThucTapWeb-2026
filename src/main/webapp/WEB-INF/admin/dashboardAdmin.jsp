<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/sidebarAdmin.css">
    <style>
        .revenue-link-card {
            text-decoration: none;
            color: inherit;
            display: block;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .revenue-link-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2) !important;
        }
    </style>
</head>
<body>
<div class="admin">
    <jsp:include page="include/sidebarAdmin.jsp" />

    <section class="content">
        <header class="topbar">
            <h1 id="pageTitle">Thống Kê</h1>
            <div class="actions">
                <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng xuất</a>
            </div>
        </header>

        <main id="page">
            <section id="dashboard" class="page active">
                
                <div class="cards">
                    <div class="card" onclick="window.location.href='${pageContext.request.contextPath}/orderAdmin'" style="cursor: pointer; transition: transform 0.2s;" onmouseover="this.style.transform='translateY(-5px)'" onmouseout="this.style.transform='translateY(0)'" title="Nhấn để xem quản lý đơn hàng">
                        Tổng đơn hàng
                        <span>${totalOrders}</span>
                    </div>

                    <div class="card" onclick="window.location.href='${pageContext.request.contextPath}/revenueAdmin'" style="cursor: pointer; transition: transform 0.2s;" onmouseover="this.style.transform='translateY(-5px)'" onmouseout="this.style.transform='translateY(0)'" title="Nhấn để xem chi tiết doanh thu">
                        Tổng doanh thu
                        <span>
                            <span id="dashboard-total-revenue"><fmt:formatNumber value="${totalRevenue}"/>đ</span>
                        </span>
                    </div>

                    <div class="card" onclick="window.location.href='${pageContext.request.contextPath}/productAdmin'" style="cursor: pointer; transition: transform 0.2s;" onmouseover="this.style.transform='translateY(-5px)'" onmouseout="this.style.transform='translateY(0)'" title="Nhấn để xem quản lý sản phẩm">
                        Sản phẩm
                        <span>${totalProducts}</span>
                    </div>

                    <div class="card" onclick="window.location.href='${pageContext.request.contextPath}/userAdmin'" style="cursor: pointer; transition: transform 0.2s;" onmouseover="this.style.transform='translateY(-5px)'" onmouseout="this.style.transform='translateY(0)'" title="Nhấn để xem quản lý người dùng">
                        Người dùng
                        <span>${totalUsers}</span>
                    </div>
                </div>

                <h2 style="margin-bottom: 12px; margin-top: 30px;">Đơn hàng mới nhất</h2>

                <div class="user-table-wrapper">
                    <table class="order-table">
                        <tr>
                            <th>Mã</th>
                            <th>Người nhận</th>
                            <th>Tổng tiền</th>
                            <th>Trạng thái</th>
                        </tr>

                        <c:forEach items="${latestOrders}" var="o">
                            <tr>
                                <td>#${o.id}</td>
                                <td>${o.name}</td>
                                <td>
                                    <fmt:formatNumber value="${o.totalPrice}"/>đ
                                </td>
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
                            </tr>
                        </c:forEach>
                    </table>
                    <div style="margin-top: 15px; text-align: right;">
                        <a href="${pageContext.request.contextPath}/orderAdmin" style="color: #8d5e33; text-decoration: none;">Xem tất cả đơn hàng &rarr;</a>
                    </div>
                </div>

            </section>
        </main>
    </section>
</div>

</body>
</html>
