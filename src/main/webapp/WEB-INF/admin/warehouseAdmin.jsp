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
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/sidebarAdmin.css?v=<%= System.currentTimeMillis() %>">
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
                                        <c:if test="${perms['add']}">
                                            <a href="${pageContext.request.contextPath}/admin/warehouseImportForm"
                                                class="btn-add">Thêm phiếu nhập</a>
                                        </c:if>
                                    </div>
                                    <c:if test="${not empty message}">
                                        <div class="alert-success">${message}</div>
                                        <c:remove var="message" scope="session" />
                                    </c:if>
                                    <c:if test="${not empty error}">
                                        <div class="alert-error">${error}</div>
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
                                                                <fmt:formatNumber value="${r.totalAmount}" type="number"
                                                                    maxFractionDigits="0" /> ₫
                                                            </td>
                                                            <td>${r.createdAtFormatted}</td>
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
                                                            <td><c:if test="${perms['view_detail']}"><a href="?action=view&id=${r.id}" class="icon-btn view"
                                                                    title="Xem chi tiết"><i class="fa fa-eye"></i></a></c:if>
                                                            </td>
                                                        </tr>
                                                    </c:if>
                                                </c:forEach>
                                                <c:if test="${empty receipts}">
                                                    <tr>
                                                        <td colspan="6" class="text-center">Chưa có phiếu nhập nào</td>
                                                    </tr>
                                                </c:if>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>

                                <div id="export" class="tab-content">
                                    <div class="tab-header">
                                        <h3>Lịch sử xuất kho</h3>
                                        <c:if test="${perms['add']}">
                                            <a href="${pageContext.request.contextPath}/admin/warehouseExportForm"
                                                class="btn-add">Thêm phiếu xuất</a>
                                        </c:if>
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
                                                                        <span
                                                                            class="warehouse-source-badge warehouse-source-order">
                                                                            <i class="fa-solid fa-cart-shopping"></i>
                                                                            Đơn #${r.orderId}
                                                                        </span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span
                                                                            class="warehouse-source-badge warehouse-source-manual">
                                                                            <i class="fa-solid fa-pen"></i>
                                                                            Thủ công
                                                                        </span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>${r.userName}</td>
                                                            <td>
                                                                <fmt:formatNumber value="${r.totalAmount}" type="number"
                                                                    maxFractionDigits="0" /> ₫
                                                            </td>
                                                            <td>${r.createdAtFormatted}</td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${r.status == 'COMPLETED'}">
                                                                        <span class="warehouse-status completed">Hoàn
                                                                            thành</span>
                                                                    </c:when>
                                                                    <c:when test="${r.status == 'PENDING'}">
                                                                        <span class="warehouse-status pending">Chờ xử
                                                                            lý</span>
                                                                    </c:when>
                                                                    <c:when test="${r.status == 'CANCELLED'}">
                                                                        <span class="warehouse-status cancelled">Đã
                                                                            hủy</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span
                                                                            class="warehouse-status">${r.status}</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td><c:if test="${perms['view_detail']}"><a href="?action=view&id=${r.id}" class="icon-btn view"
                                                                    title="Xem chi tiết"><i class="fa fa-eye"></i></a></c:if>
                                                            </td>
                                                        </tr>
                                                    </c:if>
                                                </c:forEach>
                                                <c:if test="${empty receipts}">
                                                    <tr>
                                                        <td colspan="7" class="text-center">Chưa có phiếu xuất
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
                                        <c:if test="${perms['add']}">
                                            <a href="${pageContext.request.contextPath}/admin/warehouseReturnForm"
                                                class="btn-add">Thêm phiếu hoàn kho</a>
                                        </c:if>
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
                                                                        <c:choose>
                                                                            <c:when test="${fn:contains(r.note, 'huỷ')}">
                                                                                <span class="warehouse-source-badge" style="background-color: #f8d7da; color: #721c24;">
                                                                                    <i class="fa-solid fa-ban"></i>
                                                                                    Đơn huỷ #${r.orderId}
                                                                                </span>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <span class="warehouse-source-badge warehouse-source-return">
                                                                                    <i class="fa-solid fa-rotate-left"></i>
                                                                                    Đơn hoàn #${r.orderId}
                                                                                </span>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span
                                                                            class="warehouse-source-badge warehouse-source-manual">
                                                                            <i class="fa-solid fa-pen"></i>
                                                                            Thủ công
                                                                        </span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>${r.userName}</td>
                                                            <td>
                                                                <fmt:formatNumber value="${r.totalAmount}" type="number"
                                                                    maxFractionDigits="0" /> ₫
                                                            </td>
                                                            <td>${r.createdAtFormatted}</td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${r.status == 'COMPLETED'}">
                                                                        <span class="warehouse-status completed">Hoàn
                                                                            thành</span>
                                                                    </c:when>
                                                                    <c:when test="${r.status == 'PENDING'}">
                                                                        <span class="warehouse-status pending">Chờ xử
                                                                            lý</span>
                                                                    </c:when>
                                                                    <c:when test="${r.status == 'CANCELLED'}">
                                                                        <span class="warehouse-status cancelled">Đã
                                                                            hủy</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span
                                                                            class="warehouse-status">${r.status}</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td><c:if test="${perms['view_detail']}"><a href="?action=view&id=${r.id}" class="icon-btn view"
                                                                    title="Xem chi tiết"><i class="fa fa-eye"></i></a></c:if>
                                                            </td>
                                                        </tr>
                                                    </c:if>
                                                </c:forEach>
                                                <c:if test="${!hasReturn}">
                                                    <tr>
                                                        <td colspan="7" class="text-center">Chưa có phiếu hoàn
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
                                        <div class="stock-search-wrapper">
                                            <input type="text" id="stockSearchInput" onkeyup="filterStockTable()"
                                                placeholder="Tìm kiếm sản phẩm, size, màu..."
                                                class="stock-search-input">
                                            <i class="fa fa-search stock-search-icon"></i>
                                        </div>
                                    </div>

                                    <div class="user-table-wrapper">
                                        <table class="user-table" id="stockTable">
                                            <thead>
                                                <tr>
                                                    <th>Sản Phẩm</th>
                                                    <th class="text-center">Màu Sắc</th>
                                                    <th class="text-center">Kích Cỡ</th>
                                                    <th class="text-center">Tổng Tồn Kho</th>
                                                    <th class="text-center">Trạng Thái</th>
                                                    <th class="text-center">Hành Động</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="s" items="${stocks}">
                                                    <tr>
                                                        <td class="font-weight-semibold">${s.productName}</td>
                                                        <td class="text-center"><span class="badge badge-color">${s.colorName}</span>
                                                        </td>
                                                        <td class="text-center"><span class="badge badge-size">${s.sizeName}</span>
                                                        </td>
                                                        <td class="text-center">
                                                            <strong class="stock-qty">${s.stock}</strong>
                                                        </td>
                                                        <td class="text-center">
                                                            <c:choose>
                                                                <c:when test="${s.stock == 0}">
                                                                    <span class="stock-status out-of-stock">Hết hàng</span>
                                                                </c:when>
                                                                <c:when test="${s.stock <= 5}">
                                                                    <span class="stock-status low-stock">Sắp hết</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="stock-status in-stock">Còn hàng</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="text-center">
                                                            <c:if test="${perms['view_detail']}">
                                                                <button type="button" class="icon-btn view"
                                                                    data-variant-id="${s.id}"
                                                                    data-variant-label="${fn:escapeXml(s.productName)} - Màu: ${s.colorName} - Size: ${s.sizeName}"
                                                                    onclick="showStockDetails(this)"
                                                                    title="Xem chi tiết các đợt nhập kho">
                                                                    <i class="fa fa-eye"></i>
                                                                </button>
                                                            </c:if>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                                <c:if test="${empty stocks}">
                                                    <tr>
                                                        <td colspan="6" class="text-center stock-loading-container">
                                                            Không tìm thấy sản phẩm nào trong kho</td>
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
                        <div class="modal stock-modal">
                            <div class="modal-header">
                                <h2 id="modalStockTitle" class="stock-modal-title">Chi tiết
                                    đợt nhập kho</h2>
                                <button class="modal-close stock-modal-close-btn" onclick="closeStockModal()">&times;</button>
                            </div>
                            <div class="modal-body stock-modal-body">
                                <div class="user-table-wrapper stock-modal-table-wrapper">
                                    <table class="user-table">
                                        <thead>
                                            <tr>
                                                <th>Mã Đợt Nhập</th>
                                                <th>Ngày Nhập</th>
                                                <th class="text-center">Số Lượng Nhập</th>
                                                <th class="text-right">Giá Nhập</th>
                                                <th class="text-center">Còn Lại</th>
                                            </tr>
                                        </thead>
                                        <tbody id="stockBatchTableBody">
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            <div class="modal-footer stock-modal-footer">
                                <button type="button" class="btn-back stock-modal-btn-close" onclick="closeStockModal()">Đóng</button>
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
                            if (evt) {
                                evt.currentTarget.className += " active";
                            } else {
                                for (i = 0; i < tablinks.length; i++) {
                                    if (tablinks[i].getAttribute("onclick") && tablinks[i].getAttribute("onclick").includes("'" + tabName + "'")) {
                                        tablinks[i].className += " active";
                                        break;
                                    }
                                }
                            }
                            sessionStorage.setItem("warehouseActiveTab", tabName);
                        }

                        document.addEventListener("DOMContentLoaded", function () {
                            const savedTab = sessionStorage.getItem("warehouseActiveTab");
                            if (savedTab) {
                                openTab(null, savedTab);
                            }
                        });

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

                        function showStockDetails(btn) {
                            const variantId = btn.getAttribute('data-variant-id');
                            const variantLabel = btn.getAttribute('data-variant-label');
                            document.getElementById("modalStockTitle").innerText = "Chi tiết đợt nhập: " + variantLabel;
                            const tableBody = document.getElementById("stockBatchTableBody");
                            tableBody.innerHTML = '<tr><td colspan="5" class="stock-loading-container"><i class="fa fa-spinner fa-spin stock-loading-icon"></i> Đang tải dữ liệu...</td></tr>';

                            document.getElementById("stockDetailModal").style.display = "flex";

                            fetch('${pageContext.request.contextPath}/admin/warehouseStockBatch?variantId=' + variantId)
                                .then(response => response.json())
                                .then(data => {
                                    tableBody.innerHTML = "";
                                    if (!data || data.length === 0) {
                                        tableBody.innerHTML = '<tr><td colspan="5" class="stock-modal-empty">Chưa có lịch sử nhập kho của sản phẩm này.</td></tr>';
                                        return;
                                    }
                                    data.forEach(batch => {
                                        const formattedPrice = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(batch.price);
                                        const row = document.createElement("tr");

                                        const badgeClass = batch.remainingQuantity > 0
                                            ? 'batch-badge-active'
                                            : 'batch-badge-empty';

                                        row.innerHTML =
                                            '<td class="font-weight-semibold">PN' + batch.id + '</td>' +
                                            '<td>' + batch.createdAtFormatted + '</td>' +
                                            '<td class="text-center"><strong>' + batch.quantity + '</strong></td>' +
                                            '<td class="text-right stock-price-highlight">' + formattedPrice + '</td>' +
                                            '<td class="text-center"><span class="badge batch-badge ' + badgeClass + '">' + batch.remainingQuantity + '</span></td>';
                                        tableBody.appendChild(row);
                                    });
                                })
                                .catch(error => {
                                    console.error("Error loading batches:", error);
                                    tableBody.innerHTML = '<tr><td colspan="5" class="stock-modal-error">Có lỗi xảy ra khi tải dữ liệu! Vui lòng thử lại sau.</td></tr>';
                                });
                        }

                        function closeStockModal() {
                            document.getElementById("stockDetailModal").style.display = "none";
                        }
                    </script>
                </body>

                </html>