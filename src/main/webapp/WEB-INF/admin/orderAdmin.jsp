<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Đơn Hàng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/sidebarAdmin.css">
</head>
<body>
<div class="admin">
    <jsp:include page="include/sidebarAdmin.jsp" />

    <section class="content">
        <header class="topbar">
            <h1 id="pageTitle">Quản lý Đơn Hàng</h1>
            <div class="actions">
                <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng xuất</a>
            </div>
        </header>

        <main id="page">
            <section id="dashboard" class="page active">
                <div class="cards">
                    <div class="card">Tổng đơn<br><span>35</span></div>
                    <div class="card">Đang xử lý<br><span>15</span></div>
                    <div class="card">Hoàn thành<br><span>20</span></div>
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
    <tr>
        <td>#1001</td>
        <td>Nguyễn Văn A</td>
        <td>450,000 đ</td>
        <td>
            <span class="order-status PENDING">Chờ xử lý</span>
        </td>
        <td>25/03/2026 10:30</td>
        <td>
            <a href="#" class="icon-btn view">
                <i class="fa fa-eye"></i>
            </a>
        </td>
    </tr>

    <tr>
        <td>#1002</td>
        <td>Trần Thị B</td>
        <td>1,200,000 đ</td>
        <td>
            <span class="order-status SHIPPING">Đang giao</span>
        </td>
        <td>24/03/2026 15:20</td>
        <td>
            <a href="#" class="icon-btn view">
                <i class="fa fa-eye"></i>
            </a>
        </td>
    </tr>

    <tr>
        <td>#1003</td>
        <td>Lê Văn C</td>
        <td>890,000 đ</td>
        <td>
            <span class="order-status COMPLETED">Hoàn thành</span>
        </td>
        <td>23/03/2026 09:15</td>
        <td>
            <a href="#" class="icon-btn view">
                <i class="fa fa-eye"></i>
            </a>
        </td>
    </tr>

    <tr>
        <td>#1004</td>
        <td>Phạm Minh D</td>
        <td>250,000 đ</td>
        <td>
            <span class="order-status CANCELLED">Đã hủy</span>
        </td>
        <td>22/03/2026 18:00</td>
        <td>
            <a href="#" class="icon-btn view">
                <i class="fa fa-eye"></i>
            </a>
        </td>
    </tr>
</tbody>
                    </table>

                </div>

            </section>

        </main>
    </section>

</div>


<script src="${pageContext.request.contextPath}/js/admin/adminOrder.js"></script>
</body>


</html>

