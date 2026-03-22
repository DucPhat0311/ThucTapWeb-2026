<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/user.css">
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
        <!-- PHẦN HEADER -->
        <header class="topbar">
            <h1 id="pageTitle">Dashboard</h1>
            <div class="actions">
                <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng xuất</a>
            </div>
        </header>

        <main id="page">
            <section id="dashboard" class="page active">
                
                <!-- THỐNG KÊ TỔNG QUAN -->
                <div class="cards">
                    <div class="card" onclick="window.location.href='${pageContext.request.contextPath}/order-admin'" style="cursor: pointer; transition: transform 0.2s;" onmouseover="this.style.transform='translateY(-5px)'" onmouseout="this.style.transform='translateY(0)'" title="Nhấn để xem quản lý đơn hàng">
                        Tổng đơn hàng
                        <span>200</span>
                    </div>

                    <div class="card" onclick="window.location.href='${pageContext.request.contextPath}/revenue-admin'" style="cursor: pointer; transition: transform 0.2s;" onmouseover="this.style.transform='translateY(-5px)'" onmouseout="this.style.transform='translateY(0)'" title="Nhấn để xem chi tiết doanh thu">
                        Tổng doanh thu
                        <span>
                            <span id="dashboard-total-revenue">189000đ</span>
                        </span>
                    </div>

                    <div class="card" onclick="window.location.href='${pageContext.request.contextPath}/product-admin'" style="cursor: pointer; transition: transform 0.2s;" onmouseover="this.style.transform='translateY(-5px)'" onmouseout="this.style.transform='translateY(0)'" title="Nhấn để xem quản lý sản phẩm">
                        Sản phẩm
                        <span>200</span>
                    </div>

                    <div class="card" onclick="window.location.href='${pageContext.request.contextPath}/user-admin'" style="cursor: pointer; transition: transform 0.2s;" onmouseover="this.style.transform='translateY(-5px)'" onmouseout="this.style.transform='translateY(0)'" title="Nhấn để xem quản lý người dùng">
                        Người dùng
                        <span>150</span>
                    </div>
                </div>

                <h2 style="margin-bottom: 12px; margin-top: 30px;">Đơn hàng mới nhất</h2>

                <div class="user-table-wrapper">
                    <table class="order-table">
                        <tr>
                      <tr>
                                <th>Mã</th>
                                <th>Người nhận</th>
                                <th>Tổng tiền</th>
                                <th>Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>#1001</td>
                                <td>Nguyễn Văn A</td>
                                <td>1,200,000đ</td>
                                <td><span class="order-status COMPLETED">Hoàn thành</span></td>
                            </tr>
                            <tr>
                                <td>#1002</td>
                                <td>Trần Thị B</td>
                                <td>850,000đ</td>
                                <td><span class="order-status PENDING">Chờ xử lý</span></td>
                            </tr>
                            <tr>
                                <td>#1003</td>
                                <td>Lê Văn C</td>
                                <td>2,400,000đ</td>
                                <td><span class="order-status SHIPPING">Đang giao</span></td>
                            </tr>
                            <tr>
                                <td>#1004</td>
                                <td>Phạm Minh D</td>
                                <td>500,000đ</td>
                                <td><span class="order-status CANCELLED">Đã hủy</span></td>
                            </tr>
                        </tbody>
                    </table>
                    <div style="margin-top: 15px; text-align: right;">
                        <a href="${pageContext.request.contextPath}/orderAdmin" 
                        style="color: #8d5e33; text-decoration: none;">Xem tất cả đơn hàng &rarr;</a>
                    </div>
                </div>

            </section>
        </main>
    </section>
</div> 

<script src="${pageContext.request.contextPath}/js/admin/adminDashboard.js"></script>

</body>
</html>
