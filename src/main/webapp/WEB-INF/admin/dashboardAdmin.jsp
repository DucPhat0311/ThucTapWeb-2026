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
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/sidebarAdmin.css?v=<%= System.currentTimeMillis() %>">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/dashboard.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/dashboardExport.css">
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
                                                Tổng doanh thu
                                                <span>
                                                                        <fmt:formatNumber value="${totalRevenue}" />đ
                                                                    </span>
                                            </div>

                                            <div class="card card--profit">
                                                Tổng lợi nhuận
                                                <span>
                                                                        <fmt:formatNumber value="${totalProfit}" />đ
                                                                    </span>
                                            </div>

                                            <div class="card card--import">
                                                Tổng chi phí nhập hàng
                                                <span>
                                                                        <fmt:formatNumber value="${totalImportCost}" />đ
                                                </span>
                                            </div>


                                            <div class="card">
                                                Tổng đơn hàng
                                                <span>${totalOrders}</span>
                                            </div>
                                        </div>
                                        <%-- Bộ lọc biểu đồ doanh thu --%>
                                        <div class="revenue-filters">
                                            <form method="GET" action="${pageContext.request.contextPath}/dashboardAdmin"
                                                  id="filterForm">
                                                <div class="rev-filter-group">
                                                    <label>Năm</label>
                                                    <select name="year" id="filterYear">
                                                        <c:forEach var="y" begin="2020" end="2030">
                                                            <option value="${y}" ${selectedYear==y ? 'selected' : '' }>
                                                                    ${y}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                                <div class="rev-filter-group">
                                                    <label>Tháng</label>
                                                    <select name="month" id="filterMonth">
                                                        <option value="all" ${empty selectedMonth ? 'selected' : '' }>Tất cả tháng</option>
                                                        <c:forEach var="m" begin="1" end="12">
                                                            <option value="${m}" ${selectedMonth==m ? 'selected' : '' }>
                                                                Tháng ${m}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                                <div class="rev-filter-group">
                                                    <label>Từ ngày</label>
                                                    <input type="date" name="startDate" id="filterStartDate"
                                                           value="${startDate}">
                                                </div>
                                                <div class="rev-filter-group">
                                                    <label>Đến ngày</label>
                                                    <input type="date" name="endDate" id="filterEndDate" value="${endDate}">
                                                </div>
                                                <div class="rev-btn-actions">
                                                    <button type="submit" class="btn-filter">Lọc dữ liệu</button>
                                                    <a href="${pageContext.request.contextPath}/dashboardAdmin"
                                                       class="btn-reset">Đặt lại</a>
                                                </div>
                                            </form>
                                        </div>
                                        <%-- Biểu đồ --%>
                                        <div class="chart-card" id="revenueChartSection">
                                            <div class="chart-card-header">
                                                <c:choose>
                                                    <c:when test="${filterType == 'range'}">
                                                        <h2 id="chartTitle">Doanh thu từ ${startDate} đến ${endDate}
                                                        </h2>
                                                        <span class="year-badge">Lọc khoảng ngày</span>
                                                    </c:when>
                                                    <c:when test="${filterType == 'month'}">
                                                        <h2 id="chartTitle">Doanh thu theo ngày (Tháng
                                                                ${selectedMonth}/${selectedYear})</h2>
                                                        <span class="year-badge">Tháng
                                                                                        ${selectedMonth}/${selectedYear}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <h2 id="chartTitle">Doanh thu theo tháng</h2>
                                                        <span class="year-badge">Năm ${selectedYear}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="chart-tabs">
                                                <button class="chart-tab active" id="tabRevenue" onclick="switchTab('revenue')">
                                                    <i class="fa-solid fa-chart-column"></i> Doanh thu
                                                </button>
                                                <button class="chart-tab" id="tabProfit" onclick="switchTab('profit')">
                                                    <i class="fa-solid fa-chart-line"></i> Lợi nhuận
                                                </button>
                                                <button class="chart-tab" id="tabImportCost" onclick="switchTab('importCost')">
                                                    <i class="fa-solid fa-box"></i> Chi phí nhập hàng
                                                </button>
                                                <button class="chart-tab" id="tabOrders" onclick="switchTab('orders')">
                                                    <i class="fa-solid fa-shopping-cart"></i> Đơn hàng
                                                </button>
                                            </div>
                                            <div class="chart-wrapper" id="wrapChart">
                                                <canvas id="mainChart"></canvas>
                                            </div>
                                        </div>

                <%-- section thống kế sp --%>
                <div class="stat-tables-section">
                    <div class="stat-tables-grid">

                        <%-- bảng sp bán chạy --%>
                            <div class="stat-table-card stat-table-card--hot">
                                <div class="stat-table-header">
                                    <h3><i class="fa-solid fa-fire"></i> Thống kê sản phẩm bán chạy</h3>
                                    <div class="stat-header-actions">
                                    <form class="inline-filter-form" method="GET" action="${pageContext.request.contextPath}/dashboardAdmin">
                                        <div class="inline-filter-group">
                                            <label>Tháng</label>
                                            <select name="hotMonth">
                                                <option value="" ${empty hotMonth ? 'selected' : ''}>Tất cả</option>
                                                <c:forEach var="m" begin="1" end="12">
                                                    <option value="${m}" ${hotMonth==m ? 'selected' : ''}>${m}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="inline-filter-group">
                                            <label>Từ</label>
                                            <input type="date" name="hotStartDate" value="${hotStartDate}">
                                        </div>
                                        <div class="inline-filter-group">
                                            <label>Đến</label>
                                            <input type="date" name="hotEndDate" value="${hotEndDate}">
                                        </div>
                                        <input type="hidden" name="coldMonth" value="${coldMonth}">
                                        <input type="hidden" name="coldStartDate" value="${coldStartDate}">
                                        <input type="hidden" name="coldEndDate" value="${coldEndDate}">
                                        <button type="submit" class="btn-inline-filter">Lọc</button>
                                        <a href="${pageContext.request.contextPath}/dashboardAdmin?coldMonth=${coldMonth}&coldStartDate=${coldStartDate}&coldEndDate=${coldEndDate}" class="btn-inline-reset">Đặt lại</a>
                                    </form>
                                        <form method="GET" action="${pageContext.request.contextPath}/dashboardAdmin" class="dashboard-export-form">
                                            <input type="hidden" name="action" value="exportExcel">
                                            <input type="hidden" name="exportTarget" value="sold">
                                            <input type="hidden" name="year" value="${selectedYear}">
                                            <input type="hidden" name="month" value="${param.month}">
                                            <input type="hidden" name="startDate" value="${startDate}">
                                            <input type="hidden" name="endDate" value="${endDate}">
                                            <input type="hidden" name="hotMonth" value="${hotMonth}">
                                            <input type="hidden" name="hotStartDate" value="${hotStartDate}">
                                            <input type="hidden" name="hotEndDate" value="${hotEndDate}">
                                            <button type="submit" class="btn-export-excel">
                                                <i class="fa-solid fa-file-excel"></i> Excel
                                            </button>
                                        </form>
                                    </div>
                                </div>
                                <div class="stat-search-bar">
                                    <input type="text" id="hotSearchInput"
                                           onkeyup="filterTable('hotTable','hotSearchInput')"
                                           placeholder="Tìm kiếm sản phẩm...">
                                    <i class="fa-solid fa-magnifying-glass"></i>
                                </div>
                                <div class="stat-table-wrapper">
                                    <table class="stat-table" id="hotTable">
                                        <thead>
                                        <tr>
                                            <th>STT</th>
                                            <th>Mã sản phẩm</th>
                                            <th>Tên sản phẩm</th>
                                            <th>Danh mục</th>
                                            <th>Giá</th>
                                            <th>Đã bán</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <c:choose>
                                            <c:when test="${not empty topSellingProducts}">
                                                <c:forEach var="p" items="${topSellingProducts}" varStatus="st">
                                                    <tr>
                                                        <td>${st.index + 1}</td>
                                                        <td><span class="product-code-badge">${p.productCode}</span></td>
                                                        <td class="product-name-cell">${p.productName}</td>
                                                        <td>${p.categoryName}</td>
                                                        <td><fmt:formatNumber value="${p.price}" maxFractionDigits="0" /></td>
                                                        <td><span class="sold-badge sold-badge--hot">${p.totalSold}</span></td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td colspan="7" class="stat-empty">Không có dữ liệu</td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <%-- bảng sp ko baán đc --%>
                            <div class="stat-table-card stat-table-card--cold">
                                <div class="stat-table-header">
                                    <h3><i class="fa-solid fa-box-open"></i> Thống kê sản phẩm không bán được</h3>
                                    <div class="stat-header-actions">
                                    <form class="inline-filter-form" method="GET" action="${pageContext.request.contextPath}/dashboardAdmin">
                                        <input type="hidden" name="hotMonth" value="${hotMonth}">
                                        <input type="hidden" name="hotStartDate" value="${hotStartDate}">
                                        <input type="hidden" name="hotEndDate" value="${hotEndDate}">
                                        <div class="inline-filter-group">
                                            <label>Tháng</label>
                                            <select name="coldMonth">
                                                <option value="" ${empty coldMonth ? 'selected' : ''}>Tất cả</option>
                                                <c:forEach var="m" begin="1" end="12">
                                                    <option value="${m}" ${coldMonth==m ? 'selected' : ''}>${m}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="inline-filter-group">
                                            <label>Từ</label>
                                            <input type="date" name="coldStartDate" value="${coldStartDate}">
                                        </div>
                                        <div class="inline-filter-group">
                                            <label>Đến</label>
                                            <input type="date" name="coldEndDate" value="${coldEndDate}">
                                        </div>
                                        <button type="submit" class="btn-inline-filter">Lọc</button>
                                        <a href="${pageContext.request.contextPath}/dashboardAdmin?hotMonth=${hotMonth}&hotStartDate=${hotStartDate}&hotEndDate=${hotEndDate}" class="btn-inline-reset">Đặt lại</a>
                                    </form>
                                        <form method="GET" action="${pageContext.request.contextPath}/dashboardAdmin" class="dashboard-export-form">
                                            <input type="hidden" name="action" value="exportExcel">
                                            <input type="hidden" name="exportTarget" value="unsold">
                                            <input type="hidden" name="year" value="${selectedYear}">
                                            <input type="hidden" name="month" value="${param.month}">
                                            <input type="hidden" name="startDate" value="${startDate}">
                                            <input type="hidden" name="endDate" value="${endDate}">
                                            <input type="hidden" name="coldMonth" value="${coldMonth}">
                                            <input type="hidden" name="coldStartDate" value="${coldStartDate}">
                                            <input type="hidden" name="coldEndDate" value="${coldEndDate}">
                                            <button type="submit" class="btn-export-excel">
                                                <i class="fa-solid fa-file-excel"></i> Excel
                                            </button>
                                        </form>
                                    </div>
                                </div>
                                <div class="stat-search-bar">
                                    <input type="text" id="coldSearchInput"
                                           onkeyup="filterTable('coldTable','coldSearchInput')"
                                           placeholder="Tìm kiếm sản phẩm...">
                                    <i class="fa-solid fa-magnifying-glass"></i>
                                </div>
                                <div class="stat-table-wrapper">
                                    <table class="stat-table" id="coldTable">
                                        <thead>
                                        <tr>
                                            <th>STT</th>
                                            <th>Mã sản phẩm</th>
                                            <th>Tên sản phẩm</th>
                                            <th>Danh mục</th>
                                            <th>Giá</th>
                                            <th>Đã bán</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <c:choose>
                                            <c:when
                                                    test="${not empty unsoldProducts}">
                                                <c:forEach var="p"
                                                           items="${unsoldProducts}"
                                                           varStatus="st">
                                                    <tr>
                                                        <td>${st.index + 1}
                                                        </td>
                                                        <td><span
                                                                class="product-code-badge">${p.productCode}</span>
                                                        </td>
                                                        <td
                                                                class="product-name-cell">
                                                                ${p.productName}
                                                        </td>
                                                        <td>${p.categoryName}
                                                        </td>
                                                        <td>
                                                            <fmt:formatNumber
                                                                    value="${p.price}"
                                                                    maxFractionDigits="0" />
                                                        </td>
                                                        <td><span
                                                                class="sold-badge sold-badge--zero">0</span>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td colspan="7"
                                                        class="stat-empty">
                                                        Không có dữ liệu
                                                    </td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                    </div>
                    </div>

                    </div>
            </section>
        </main>
    </section>
</div>
                    <script>
                        const chartLabels = ${ chartLabelsJson != null ? chartLabelsJson : "[]" };
                        const revData = ${ chartDataJson   != null ? chartDataJson : "[]" };
                        const profData = ${ profitDataJson  != null ? profitDataJson : "[]" };
                        const importCostData = ${ importCostDataJson != null ? importCostDataJson : "[]" };
                        const ordersData = ${ ordersDataJson != null ? ordersDataJson : "[]" };

                        const fmtVND = v => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(v);
                        const fmtCompact = v => new Intl.NumberFormat('vi-VN', { notation: 'compact', compactDisplay: 'short' }).format(v) + '₫';
                        const ctx = document.getElementById('mainChart').getContext('2d');
                        function makeGradient(r, g, b) {
                            const g1 = ctx.createLinearGradient(0, 0, 0, 380);
                            g1.addColorStop(0, 'rgba(' + r + ',' + g + ',' + b + ',0.85)');
                            g1.addColorStop(1, 'rgba(' + r + ',' + g + ',' + b + ',0.15)');
                            return g1;
                        }
                        const revGradient = makeGradient(163, 121, 82);
                        const profGradient = makeGradient(34, 197, 94);
                        const importGradient = makeGradient(239, 68, 68);
                        const ordersGradient = makeGradient(59, 130, 246);
                        let myChart = new Chart(ctx, {
                            type: 'bar',
                            data: {
                                labels: chartLabels,
                                datasets: [{
                                    label: 'Doanh thu',
                                    data: revData,
                                    backgroundColor: revGradient,
                                    hoverBackgroundColor: '#8F6641',
                                    borderRadius: 7,
                                    borderWidth: 0
                                }]
                            },
                            options: {
                                responsive: true,
                                maintainAspectRatio: false,
                                interaction: { mode: 'index', intersect: false },
                                scales: {
                                    x: { grid: { color: 'rgba(0,0,0,0.04)' }, ticks: { color: '#6b5040', font: { size: 12 } } },
                                    y: {
                                        beginAtZero: true,
                                        grid: { color: 'rgba(0,0,0,0.05)' },
                                        ticks: { color: '#6b5040', font: { size: 11 }, callback: fmtCompact }
                                    }
                                },
                                plugins: {
                                    legend: { display: false },
                                    tooltip: {
                                        backgroundColor: '#2d2d2d',
                                        titleColor: '#f5e6d3',
                                        bodyColor: '#e8d5c0',
                                        padding: 14,
                                        callbacks: { label: c => {
                                            if (c.dataset.label === 'Đơn hàng') return ' ' + c.dataset.label + ': ' + c.parsed.y;
                                            return ' ' + c.dataset.label + ': ' + fmtVND(c.parsed.y);
                                        } }
                                    }
                                }
                            }
                        });

    const titleEl = document.getElementById('chartTitle');
    const baseTitle = titleEl ? titleEl.textContent : '';

    function switchTab(tab) {
        document.getElementById('tabRevenue').classList.toggle('active', tab === 'revenue');
        document.getElementById('tabProfit').classList.toggle('active', tab === 'profit');
        document.getElementById('tabImportCost').classList.toggle('active', tab === 'importCost');
        document.getElementById('tabOrders').classList.toggle('active', tab === 'orders');

        let labelStr = 'Doanh thu';
        let dataArr = revData;
        let bgGradient = revGradient;
        let hoverBg = '#8F6641';

        if (tab === 'profit') {
            labelStr = 'Lợi nhuận';
            dataArr = profData;
            bgGradient = profGradient;
            hoverBg = '#16a34a';
        } else if (tab === 'importCost') {
            labelStr = 'Chi phí nhập hàng';
            dataArr = importCostData;
            bgGradient = importGradient;
            hoverBg = '#dc2626';
        } else if (tab === 'orders') {
            labelStr = 'Đơn hàng';
            dataArr = ordersData;
            bgGradient = ordersGradient;
            hoverBg = '#2563eb';
        }

        if (titleEl) {
            titleEl.textContent = baseTitle.replace(/^(Doanh thu|Lợi nhuận|Chi phí nhập hàng|Đơn hàng)/, labelStr);
        }

        myChart.data.datasets[0].label = labelStr;
        myChart.data.datasets[0].data = dataArr;
        myChart.data.datasets[0].backgroundColor = bgGradient;
        myChart.data.datasets[0].hoverBackgroundColor = hoverBg;

        if (tab === 'orders') {
            myChart.options.scales.y.ticks.callback = function(value) { return value; };
        } else {
            myChart.options.scales.y.ticks.callback = fmtCompact;
        }

        myChart.update();
    }
                        document.getElementById('statMonthSelect').addEventListener('change', function () {
                            if (this.value) {
                                document.getElementById('statStartDate').value = '';
                                document.getElementById('statEndDate').value = '';
                            }
                        });
                        document.getElementById('statStartDate').addEventListener('change', function () {
                            if (this.value) document.getElementById('statMonthSelect').value = '';
                        });
                        document.getElementById('statEndDate').addEventListener('change', function () {
                            if (this.value) document.getElementById('statMonthSelect').value = '';
                        });

                        function filterTable(tableId, inputId) {
                            const filter = document.getElementById(inputId).value.toLowerCase();
                            const rows = document.getElementById(tableId).getElementsByTagName('tr');
                            for (let i = 1; i < rows.length; i++) {
                                const text = rows[i].textContent || rows[i].innerText;
                                rows[i].style.display = text.toLowerCase().includes(filter) ? '' : 'none';
                            }
                        }
                    </script>
</body>

</html>
