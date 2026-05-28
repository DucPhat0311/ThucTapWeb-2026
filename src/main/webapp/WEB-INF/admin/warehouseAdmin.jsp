<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Quản Lý Kho</title>
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/warehouse.css">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/sidebarAdmin.css">
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
                </head>

                <body>
                    <div class="admin">

                        <jsp:include page="include/sidebarAdmin.jsp" />

                        <section class="content">
                            <header class="topbar">
                                <h1 id="pageTitle">Quản Lý Kho</h1>
                                <div class="actions">
                                    <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng xuất</a>
                                </div>
                            </header>

                            <main id="page">
                                <div class="tab-container">
                                    <div class="tab-link active" onclick="openTab(event, 'import')">
                                        Nhập Kho
                                    </div>
                                    <div class="tab-link" onclick="openTab(event, 'export')">
                                        Xuất Kho
                                    </div>
                                    <div class="tab-link" onclick="openTab(event, 'return')">
                                        Hoàn Kho
                                    </div>
                                    <div class="tab-link" onclick="openTab(event, 'stock')">
                                        Tồn Kho
                                    </div>
                                </div>

                                <div id="import" class="tab-content active">
                                    <div class="tab-header">
                                        <h3>Lịch sử nhập kho</h3>
                                        <a href="${pageContext.request.contextPath}/admin/warehouseImportForm"
                                            class="btn-add">Thêm phiếu nhập</a>
                                    </div>
                                    <c:if test="${not empty message}">
                                        <div style="color: green; margin-bottom: 10px;">${message}</div>
                                        <c:remove var="message" scope="session" />
                                    </c:if>
                                    <c:if test="${not empty error}">
                                        <div style="color: red; margin-bottom: 10px;">${error}</div>
                                        <c:remove var="error" scope="session" />
                                    </c:if>

                                    <div class="user-table-wrapper">
                                        <table class="user-table">
                                            <thead>
                                                <tr>
                                                    <th>Mã Phiếu Nhập</th>
                                                    <th>Người Nhập</th>
                                                    <th>Tổng Tiền</th>
                                                    <th>Ngày Nhập</th>
                                                    <th>Trạng Thái</th>
                                                    <th>Hành Động</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="r" items="${receipts}">
                                                    <c:if test="${r.type == 'IMPORT'}">
                                                        <tr>
                                                            <td>PN${r.id}</td>
                                                            <td>${r.userName}</td>
                                                            <td>
                                                                <fmt:formatNumber value="${r.totalAmount}"
                                                                    type="number" maxFractionDigits="0" /> ₫
                                                            </td>
                                                            <td>${r.createdAt}</td>
                                                            <td><span style="color: green; font-weight: bold;">
                                                                    <c:choose>
                                                                        <c:when test="${r.status == 'COMPLETED'}">Hoàn
                                                                            thành</c:when>
                                                                        <c:when test="${r.status == 'PENDING'}">Chờ xử
                                                                            lý</c:when>
                                                                        <c:when test="${r.status == 'CANCELLED'}">Đã hủy
                                                                        </c:when>
                                                                        <c:otherwise>${r.status}</c:otherwise>
                                                                    </c:choose>
                                                                </span>
                                                            </td>
                                                            <td><a href="?action=view&id=${r.id}" class="icon-btn view" title="Xem chi tiết"><i class="fa fa-eye"></i></a></td>
                                                        </tr>
                                                    </c:if>
                                                </c:forEach>
                                                <c:if test="${empty receipts}">
                                                    <tr>
                                                        <td colspan="6" style="text-align: center;">Chưa có phiếu nhập
                                                            nào</td>
                                                    </tr>
                                                </c:if>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>

                                <div id="export" class="tab-content">
                                    <div class="tab-header">
                                        <h3>Lịch sử xuất kho</h3>
                                        <a href="${pageContext.request.contextPath}/admin/warehouseExportForm"
                                            class="btn-add">Thêm phiếu xuất</a>
                                    </div>
                                    <div class="user-table-wrapper">
                                        <table class="user-table">
                                            <thead>
                                                <tr>
                                                    <th>Mã Phiếu Xuất</th>
                                                    <th>Nguồn</th>
                                                    <th>Người Xuất</th>
                                                    <th>Tổng Tiền</th>
                                                    <th>Ngày Xuất</th>
                                                    <th>Trạng Thái</th>
                                                    <th>Hành Động</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="r" items="${receipts}">
                                                    <c:if test="${r.type == 'EXPORT'}">
                                                        <tr>
                                                            <td>PX${r.id}</td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${r.orderId > 0}">
                                                                        <span class="warehouse-source-badge warehouse-source-order">
                                                                            <i class="fa-solid fa-cart-shopping"></i>
                                                                            Đơn #${r.orderId}
                                                                        </span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="warehouse-source-badge warehouse-source-manual">
                                                                            <i class="fa-solid fa-pen"></i>
                                                                            Thủ công
                                                                        </span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>${r.userName}</td>
                                                            <td>
                                                                <fmt:formatNumber value="${r.totalAmount}"
                                                                    type="number" maxFractionDigits="0" /> ₫
                                                            </td>
                                                            <td>${r.createdAt}</td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${r.status == 'COMPLETED'}">
                                                                        <span class="warehouse-status completed">Hoàn thành</span>
                                                                    </c:when>
                                                                    <c:when test="${r.status == 'PENDING'}">
                                                                        <span class="warehouse-status pending">Chờ xử lý</span>
                                                                    </c:when>
                                                                    <c:when test="${r.status == 'CANCELLED'}">
                                                                        <span class="warehouse-status cancelled">Đã hủy</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="warehouse-status">${r.status}</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td><a href="?action=view&id=${r.id}" class="icon-btn view" title="Xem chi tiết"><i class="fa fa-eye"></i></a></td>
                                                        </tr>
                                                    </c:if>
                                                </c:forEach>
                                                <c:if test="${empty receipts}">
                                                    <tr>
                                                        <td colspan="7" style="text-align: center;">Chưa có phiếu xuất
                                                            nào</td>
                                                    </tr>
                                                </c:if>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>

                                <div id="return" class="tab-content">
                                    <div class="tab-header">
                                        <h3>Lịch sử hoàn kho</h3>
                                        <a href="${pageContext.request.contextPath}/admin/warehouseReturnForm"
                                            class="btn-add">Thêm phiếu hoàn kho</a>
                                    </div>
                                    <div class="user-table-wrapper">
                                        <table class="user-table">
                                            <thead>
                                                <tr>
                                                    <th>Mã Phiếu Hoàn</th>
                                                    <th>Nguồn</th>
                                                    <th>Người Hoàn</th>
                                                    <th>Tổng Tiền</th>
                                                    <th>Ngày Hoàn Kho</th>
                                                    <th>Trạng Thái</th>
                                                    <th>Hành Động</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:set var="hasReturn" value="false" />
                                                <c:forEach var="r" items="${receipts}">
                                                    <c:if test="${r.type == 'RETURN'}">
                                                        <c:set var="hasReturn" value="true" />
                                                        <tr>
                                                            <td>PH${r.id}</td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${r.orderId > 0}">
                                                                        <span class="warehouse-source-badge warehouse-source-return">
                                                                            <i class="fa-solid fa-rotate-left"></i>
                                                                            Đơn trả #${r.orderId}
                                                                        </span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="warehouse-source-badge warehouse-source-manual">
                                                                            <i class="fa-solid fa-pen"></i>
                                                                            Thủ công
                                                                        </span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>${r.userName}</td>
                                                            <td>
                                                                <fmt:formatNumber value="${r.totalAmount}"
                                                                    type="number" maxFractionDigits="0" /> ₫
                                                            </td>
                                                            <td>${r.createdAt}</td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${r.status == 'COMPLETED'}">
                                                                        <span class="warehouse-status completed">Hoàn thành</span>
                                                                    </c:when>
                                                                    <c:when test="${r.status == 'PENDING'}">
                                                                        <span class="warehouse-status pending">Chờ xử lý</span>
                                                                    </c:when>
                                                                    <c:when test="${r.status == 'CANCELLED'}">
                                                                        <span class="warehouse-status cancelled">Đã hủy</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="warehouse-status">${r.status}</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td><a href="?action=view&id=${r.id}" class="icon-btn view" title="Xem chi tiết"><i class="fa fa-eye"></i></a></td>
                                                        </tr>
                                                    </c:if>
                                                </c:forEach>
                                                <c:if test="${!hasReturn}">
                                                    <tr>
                                                        <td colspan="7" style="text-align: center;">Chưa có phiếu hoàn
                                                            kho nào</td>
                                                    </tr>
                                                </c:if>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>

                                <div id="stock" class="tab-content">
                                    <div class="tab-header" style="margin-bottom: 15px;">
                                        <h3>Tồn kho sản phẩm</h3>
                                        <div style="position: relative; width: 300px;">
                                            <input type="text" id="stockSearchInput" onkeyup="filterStockTable()" 
                                                placeholder="Tìm kiếm sản phẩm, size, màu..." 
                                                style="width: 100%; padding: 8px 12px 8px 35px; border: 1px solid #e0d0c1; border-radius: 8px; font-size: 13px; background: #fff;">
                                            <i class="fa fa-search" style="position: absolute; left: 12px; top: 50%; transform: translateY(-50%); color: #8c7060; font-size: 13px;"></i>
                                        </div>
                                    </div>

                                    <div class="user-table-wrapper">
                                        <table class="user-table" id="stockTable">
                                            <thead>
                                                <tr>
                                                    <th>Sản Phẩm</th>
                                                    <th style="text-align: center;">Màu Sắc</th>
                                                    <th style="text-align: center;">Kích Cỡ</th>
                                                    <th style="text-align: center;">Tổng Tồn Kho</th>
                                                    <th style="text-align: center;">Trạng Thái</th>
                                                    <th style="text-align: center;">Hành Động</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="s" items="${stocks}">
                                                    <tr>
                                                        <td style="font-weight: 600;">${s.productName}</td>
                                                        <td style="text-align: center;"><span class="badge" style="background: #fdf6e2; color: #8c7060; padding: 4px 10px; border-radius: 6px; font-size: 12px; font-weight: 600; border: 1px solid #f3e5d8;">${s.colorName}</span></td>
                                                        <td style="text-align: center;"><span class="badge" style="background: #f0f8ff; color: #1e90ff; padding: 4px 10px; border-radius: 6px; font-size: 12px; font-weight: 600; border: 1px solid #e1f0ff;">${s.sizeName}</span></td>
                                                        <td style="text-align: center;">
                                                            <strong style="font-size: 15px;">${s.stock}</strong>
                                                        </td>
                                                        <td style="text-align: center;">
                                                            <c:choose>
                                                                <c:when test="${s.stock == 0}">
                                                                    <span class="status-badge out-of-stock" style="padding: 4px 10px; font-size: 11px;">Hết hàng</span>
                                                                </c:when>
                                                                <c:when test="${s.stock <= 5}">
                                                                    <span class="status-badge status-pending" style="padding: 4px 10px; font-size: 11px;">Sắp hết</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="status-badge status-active" style="padding: 4px 10px; font-size: 11px; background: rgba(47, 158, 68, 0.12); color: #2f9e44;">Còn hàng</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td style="text-align: center;">
                                                            <button type="button" class="icon-btn view" 
                                                                onclick="showStockDetails(${s.id}, '${fn:escapeXml(s.productName)} - Màu: ${s.colorName} - Size: ${s.sizeName}')" 
                                                                title="Xem chi tiết các đợt nhập kho">
                                                                <i class="fa fa-eye"></i>
                                                            </button>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                                <c:if test="${empty stocks}">
                                                    <tr>
                                                        <td colspan="6" style="text-align: center; padding: 20px; color: #8c7060;">Không tìm thấy sản phẩm nào trong kho</td>
                                                    </tr>
                                                </c:if>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </main>
                        </section>
                    </div>

                    <!-- MODAL CHI TIẾT ĐỢT NHẬP KHO -->
                    <div id="stockDetailModal" class="modal-overlay">
                        <div class="modal" style="max-width: 700px; width: 90%;">
                            <div class="modal-header">
                                <h2 id="modalStockTitle" style="margin: 0; font-size: 18px; color: #8F6641;">Chi tiết đợt nhập kho</h2>
                                <button class="modal-close" onclick="closeStockModal()" style="background: none; border: none; font-size: 24px; cursor: pointer; color: #8c7060;">&times;</button>
                            </div>
                            <div class="modal-body" style="padding: 20px; overflow-y: auto; max-height: 60vh;">
                                <div class="user-table-wrapper" style="margin-top: 0; box-shadow: none; border: 1px solid #f0e6db;">
                                    <table class="user-table">
                                        <thead>
                                            <tr>
                                                <th>Mã Đợt Nhập</th>
                                                <th>Ngày Nhập</th>
                                                <th style="text-align: center;">Số Lượng Nhập</th>
                                                <th style="text-align: right;">Giá Nhập</th>
                                                <th style="text-align: center;">Còn Lại</th>
                                            </tr>
                                        </thead>
                                        <tbody id="stockBatchTableBody">
                                            <!-- JS will dynamically populate here -->
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            <div class="modal-footer" style="padding: 15px 25px; border-top: 2px solid #f0f0f0; display: flex; justify-content: flex-end; background: #faf8f5;">
                                <button type="button" class="btn-back" onclick="closeStockModal()" style="padding: 9px 20px; font-weight: 600; cursor: pointer; border-radius: 8px; font-size: 13px; transform: none; min-width: 90px; text-align: center;">Đóng</button>
                            </div>
                        </div>
                    </div>

                    <script>
                        function openTab(evt, tabName) {
                            var i, tabcontent, tablinks;
                            tabcontent = document.getElementsByClassName("tab-content");
                            for (i = 0; i < tabcontent.length; i++) {
                                tabcontent[i].style.display = "none";
                            }
                            tablinks = document.getElementsByClassName("tab-link");
                            for (i = 0; i < tablinks.length; i++) {
                                tablinks[i].className = tablinks[i].className.replace(" active", "");
                            }
                            document.getElementById(tabName).style.display = "block";
                            evt.currentTarget.className += " active";
                        }

                        function filterStockTable() {
                            const input = document.getElementById("stockSearchInput");
                            const filter = input.value.toLowerCase();
                            const table = document.getElementById("stockTable");
                            const trs = table.getElementsByTagName("tr");

                            for (let i = 1; i < trs.length; i++) {
                                let rowText = trs[i].textContent || trs[i].innerText;
                                if (rowText.toLowerCase().indexOf(filter) > -1) {
                                    trs[i].style.display = "";
                                } else {
                                    trs[i].style.display = "none";
                                }
                            }
                        }

                        function showStockDetails(variantId, variantLabel) {
                            document.getElementById("modalStockTitle").innerText = "Chi tiết đợt nhập: " + variantLabel;
                            const tableBody = document.getElementById("stockBatchTableBody");
                            tableBody.innerHTML = '<tr><td colspan="5" style="text-align: center; padding: 20px; color: #8c7060;"><i class="fa fa-spinner fa-spin" style="font-size: 20px; color: #8F6641; margin-right: 8px;"></i> Đang tải dữ liệu...</td></tr>';
                            
                            document.getElementById("stockDetailModal").style.display = "flex";

                            fetch('${pageContext.request.contextPath}/admin/warehouseStockBatch?variantId=' + variantId)
                                .then(response => response.json())
                                .then(data => {
                                    tableBody.innerHTML = "";
                                    if (!data || data.length === 0) {
                                        tableBody.innerHTML = '<tr><td colspan="5" style="text-align: center; padding: 20px; color: #8c7060; font-style: italic;">Chưa có lịch sử nhập kho của sản phẩm này.</td></tr>';
                                        return;
                                    }
                                    data.forEach(batch => {
                                        const formattedPrice = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(batch.price);
                                        const row = document.createElement("tr");
                                        
                                        const badgeStyle = batch.remainingQuantity > 0 
                                            ? 'background: rgba(47, 158, 68, 0.12); color: #2f9e44; border: 1px solid rgba(47, 158, 68, 0.2);' 
                                            : 'background: rgba(220, 53, 69, 0.12); color: #dc3545; border: 1px solid rgba(220, 53, 69, 0.2);';
                                        
                                        row.innerHTML = 
                                            '<td style="font-weight: 600;">PN' + batch.id + '</td>' +
                                            '<td>' + batch.createdAtFormatted + '</td>' +
                                            '<td style="text-align: center;"><strong>' + batch.quantity + '</strong></td>' +
                                            '<td style="text-align: right; font-weight: 600; color: #8F6641;">' + formattedPrice + '</td>' +
                                            '<td style="text-align: center;"><span class="badge" style="padding: 4px 10px; border-radius: 6px; font-size: 12px; font-weight: 600; ' + badgeStyle + '">' + batch.remainingQuantity + '</span></td>';
                                        tableBody.appendChild(row);
                                    });
                                })
                                .catch(error => {
                                    console.error("Error loading batches:", error);
                                    tableBody.innerHTML = '<tr><td colspan="5" style="text-align: center; padding: 20px; color: #dc3545; font-weight: 600;">Có lỗi xảy ra khi tải dữ liệu! Vui lòng thử lại sau.</td></tr>';
                                });
                        }

                        function closeStockModal() {
                            document.getElementById("stockDetailModal").style.display = "none";
                        }
                    </script>
                </body>

                </html>