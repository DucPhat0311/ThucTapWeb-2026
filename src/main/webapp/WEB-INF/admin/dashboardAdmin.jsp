<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
        <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Admin Dashboard</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/sidebarAdmin.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/dashboard.css">
                <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.4/dist/chart.umd.min.js"></script>
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
                                    <div class="card">
                                        Tổng đơn hàng
                                        <span>${totalOrders}</span>
                                    </div>

                                    <div class="card">
                                        Tổng doanh thu
                                        <span>
                                            <fmt:formatNumber value="${totalRevenue}" />đ
                                        </span>
                                    </div>

                                    <div class="card">
                                        Sản phẩm
                                        <span>${totalProducts}</span>
                                    </div>

                                    <div class="card">
                                        Người dùng
                                        <span>${totalUsers}</span>
                                    </div>
                                </div>

                                <%-- Biểu đồ doanh thu --%>
                                    <div class="chart-card" id="revenueChartSection" style="margin-top: 28px;">
                                        <div class="chart-card-header">
                                            <h2>Doanh thu theo tháng</h2>
                                            <span class="year-badge">Năm ${currentYear}</span>
                                        </div>
                                        <div class="chart-wrapper">
                                            <canvas id="revenueChart"></canvas>
                                        </div>
                                    </div>
                                </div>

                            </section>
                        </main>
                    </section>
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
                                        ${orderStatusLabels[o.orderStatus]}
                                    </span>
                                </td>
                            </tr>
                        </c:forEach>
                    </table>
                    <div style="margin-top: 15px; text-align: right;">
                        <a href="${pageContext.request.contextPath}/orderAdmin" style="color: #8d5e33; text-decoration: none;">Xem tất cả đơn hàng &rarr;</a>
                    </div>
                </div>

                <script>
                    const monthlyData = ${ monthlyRevenueJson != null ? monthlyRevenueJson : '[]'};

                    const ctx = document.getElementById('revenueChart').getContext('2d');

                    const gradient = ctx.createLinearGradient(0, 0, 0, 360);
                    gradient.addColorStop(0, '#A37952');
                    gradient.addColorStop(1, 'rgba(163, 121, 82, 0.4)');

                    new Chart(ctx, {
                        type: 'bar',
                        data: {
                            labels: ['Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6',
                                'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12'],
                            datasets: [{
                                label: 'Doanh thu',
                                data: monthlyData,
                                backgroundColor: gradient,
                                hoverBackgroundColor: '#8F6641',
                                borderRadius: 6,
                                borderWidth: 0
                            }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            interaction: { mode: 'index', intersect: false },
                            scales: {
                                x: {
                                    grid: { color: 'rgba(0,0,0,0.05)' },
                                    ticks: { color: '#6b5040', font: { size: 12 } }
                                },
                                y: {
                                    beginAtZero: true,
                                    grid: { color: 'rgba(0,0,0,0.06)' },
                                    ticks: {
                                        color: '#6b5040',
                                        font: { size: 11 },
                                        callback: v => new Intl.NumberFormat('vi-VN', {
                                            notation: 'compact', compactDisplay: 'short'
                                        }).format(v) + '₫'
                                    }
                                }
                            },
                            plugins: {
                                legend: { display: false },
                                tooltip: {
                                    backgroundColor: '#4a3728',
                                    titleColor: '#f5e6d3',
                                    bodyColor: '#e8d5c0',
                                    padding: 12,
                                    callbacks: {
                                        label: ctx => ' ' + new Intl.NumberFormat('vi-VN', {
                                            style: 'currency', currency: 'VND'
                                        }).format(ctx.parsed.y)
                                    }
                                }
                            }
                        }
                    });
                </script>
            </body>

            </html>