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

                    <%-- Bộ lọc doanh thu --%>
                    <div class="revenue-filters">
                        <form method="GET" action="${pageContext.request.contextPath}/dashboardAdmin" id="filterForm">
                            
                            <!-- Lọc theo năm -->
                            <div class="rev-filter-group">
                                <label>Năm</label>
                                <select name="year" id="filterYear">
                                    <c:forEach var="y" begin="2020" end="2030">
                                        <option value="${y}" ${selectedYear == y ? 'selected' : ''}>${y}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Lọc theo tháng -->
                            <div class="rev-filter-group">
                                <label>Tháng</label>
                                <select name="month" id="filterMonth">
                                    <option value="all" ${selectedMonth == null || selectedMonth == 'all' ? 'selected' : ''}>Tất cả tháng</option>
                                    <c:forEach var="m" begin="1" end="12">
                                        <option value="${m}" ${selectedMonth == m ? 'selected' : ''}>Tháng ${m}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Từ ngày -->
                            <div class="rev-filter-group">
                                <label>Từ ngày</label>
                                <input type="date" name="startDate" id="filterStartDate" value="${startDate}">
                            </div>

                            <!-- Đến ngày -->
                            <div class="rev-filter-group">
                                <label>Đến ngày</label>
                                <input type="date" name="endDate" id="filterEndDate" value="${endDate}">
                            </div>

                            <!-- Nút hành động -->
                            <div class="rev-btn-actions">
                                <button type="submit" class="btn-filter">
                                    Lọc dữ liệu
                                </button>
                                <a href="${pageContext.request.contextPath}/dashboardAdmin" class="btn-reset">
                                    Đặt lại
                                </a>
                            </div>
                        </form>
                    </div>

                    <%-- Biểu đồ doanh thu --%>
                    <div class="chart-card" id="revenueChartSection">
                        <div class="chart-card-header">
                            <c:choose>
                                <c:when test="${filterType == 'range'}">
                                    <h2>Doanh thu từ ${startDate} đến ${endDate}</h2>
                                    <span class="year-badge">Lọc khoảng ngày</span>
                                </c:when>
                                <c:when test="${filterType == 'month'}">
                                    <h2>Doanh thu theo ngày (Tháng ${selectedMonth}/${selectedYear})</h2>
                                    <span class="year-badge">Tháng ${selectedMonth}/${selectedYear}</span>
                                </c:when>
                                <c:otherwise>
                                    <h2>Doanh thu theo tháng</h2>
                                    <span class="year-badge">Năm ${selectedYear}</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="chart-wrapper">
                            <canvas id="revenueChart"></canvas>
                        </div>
                    </div>

                </section>
            </main>
        </section>

        <script>
            const chartLabels = ${chartLabelsJson != null ? chartLabelsJson : '[]'};
            const chartData = ${chartDataJson != null ? chartDataJson : '[]'};

            const ctx = document.getElementById('revenueChart').getContext('2d');

            const gradient = ctx.createLinearGradient(0, 0, 0, 360);
            gradient.addColorStop(0, '#A37952');
            gradient.addColorStop(1, 'rgba(163, 121, 82, 0.4)');

            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: chartLabels,
                    datasets: [{
                        label: 'Doanh thu',
                        data: chartData,
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