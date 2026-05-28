<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <title>Chi Tiết Phiếu Kho</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/sidebarAdmin.css">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
            </head>

            <body>
                <div class="admin">
                    <jsp:include page="include/sidebarAdmin.jsp" />

                    <section class="content">
                        <header class="topbar">
                            <div style="display: flex; align-items: center; gap: 15px;">
                                <a href="${pageContext.request.contextPath}/warehouseAdmin" class="back-to-product-btn">
                                    <i class="fa fa-arrow-left"></i>
                                </a>
                                <h1 style="margin: 0;">Chi Tiết Phiếu Kho</h1>
                            </div>
                            <div class="actions">
                                <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng xuất</a>
                            </div>
                        </header>

                        <main id="page" style="padding: 20px;">
                            <div class="cardHouse" style="background: #fff; padding: 24px; border-radius: 12px;">
                                <c:if test="${not empty receipt and receipt.orderId > 0}">
                                    <div class="warehouse-order-banner">
                                        <span class="warehouse-order-icon"><i
                                                class="fa-solid fa-cart-shopping"></i></span>
                                        <div>
                                            <span class="warehouse-order-label">Xuất kho tự động Đơn hàng
                                                #${receipt.orderId}</span>
                                            <a href="${pageContext.request.contextPath}/orderAdmin?mode=view&id=${receipt.orderId}"
                                                class="warehouse-order-link"><i
                                                    class="fa-solid fa-arrow-up-right-from-square"
                                                    style="font-size:10px;"></i> Xem đơn hàng</a>
                                        </div>
                                    </div>
                                </c:if>
                                <div class="table-container" style="margin-top: 4px;">
                                    <table class="table">
                                        <thead>
                                            <tr>
                                                <th style="text-align:center;">ID Biến thể</th>
                                                <th>Tên Sản Phẩm</th>
                                                <th style="text-align:center;">Màu sắc</th>
                                                <th style="text-align:center;">Size</th>
                                                <th style="text-align:center;">Số lượng</th>
                                                <th style="text-align:right;">Đơn giá</th>
                                                <th style="text-align:right;">Thành tiền</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="detail" items="${receiptDetails}">
                                                <tr>
                                                    <td style="text-align: center;">${detail.productVariantId}</td>
                                                    <td>${detail.productName}</td>
                                                    <td style="text-align: center;">${detail.colorName}</td>
                                                    <td style="text-align: center;">${detail.sizeName}</td>
                                                    <td style="text-align: center;"><strong>${detail.quantity}</strong>
                                                    </td>
                                                    <td style="text-align: right; white-space: nowrap;">
                                                        <fmt:formatNumber value="${detail.price}" type="number"
                                                            maxFractionDigits="0" /> ₫
                                                    </td>
                                                    <td
                                                        style="text-align: right; white-space: nowrap; font-weight: 600; color: var(--primary-color);">
                                                        <fmt:formatNumber value="${detail.price * detail.quantity}"
                                                            type="number" maxFractionDigits="0" /> ₫
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${empty receiptDetails}">
                                                <tr>
                                                    <td colspan="7"
                                                        style="text-align: center; padding: 30px; color: var(--text-muted);">
                                                        <i class="fa-solid fa-inbox"
                                                            style="font-size:24px; display:block; margin-bottom:8px;"></i>
                                                        Không có chi tiết nào.
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </main>
                    </section>
                </div>
            </body>

            </html>