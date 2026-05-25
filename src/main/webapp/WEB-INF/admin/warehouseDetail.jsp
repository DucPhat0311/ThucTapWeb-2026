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
                            <h1>Chi Tiết Phiếu Kho</h1>
                            <div class="actions">
                                <a href="${pageContext.request.contextPath}/warehouseAdmin" class="btn-back">
                                    <i class="fa fa-arrow-left"></i> Quay Lại
                                </a>
                            </div>
                        </header>

                        <main id="page" style="padding: 20px;">
                            <div class="card" style="background: #fff; padding: 20px; border-radius: 8px;">
                                <c:if test="${not empty receipt and receipt.orderId > 0}">
                                    <div class="warehouse-order-banner">
                                        <span class="warehouse-order-icon"><i class="fa-solid fa-cart-shopping"></i></span>
                                        <div>
                                            <strong class="warehouse-order-title">Xuất kho tự động theo đơn hàng</strong>
                                            <span class="warehouse-order-id">Đơn hàng #${receipt.orderId}</span>
                                            <a href="${pageContext.request.contextPath}/orderAdmin?mode=view&id=${receipt.orderId}"
                                               class="warehouse-order-link">Xem đơn hàng →</a>
                                        </div>
                                    </div>
                                </c:if>
                                <table style="width: 100%; border-collapse: collapse; margin-top: 20px;" border="1">
                                    <thead>
                                        <tr style="background-color: #f4f4f4;">
                                            <th style="padding: 10px;">ID Biến thể</th>
                                            <th style="padding: 10px;">Tên Sản Phẩm</th>
                                            <th style="padding: 10px;">Màu sắc</th>
                                            <th style="padding: 10px;">Size</th>
                                            <th style="padding: 10px;">Số lượng</th>
                                            <th style="padding: 10px;">Đơn giá</th>
                                            <th style="padding: 10px;">Thành tiền</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="detail" items="${receiptDetails}">
                                            <tr style="cursor: default;">
                                                <td style="padding: 10px; text-align: center;">
                                                    ${detail.productVariantId}</td>
                                                <td style="padding: 10px;">${detail.productName}</td>
                                                <td style="padding: 10px; text-align: center;">${detail.colorName}</td>
                                                <td style="padding: 10px; text-align: center;">${detail.sizeName}</td>
                                                <td style="padding: 10px; text-align: center;">${detail.quantity}</td>
                                                <td style="padding: 10px; text-align: right; white-space: nowrap;"><fmt:formatNumber value="${detail.price}" type="number" maxFractionDigits="0" /> ₫</td>
                                                <td style="padding: 10px; text-align: right; white-space: nowrap;"><fmt:formatNumber value="${detail.price * detail.quantity}" type="number" maxFractionDigits="0" /> ₫</td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty receiptDetails}">
                                            <tr>
                                                <td colspan="7" style="padding: 10px; text-align: center;">Không có chi
                                                    tiết nào.</td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </main>
                    </section>
                </div>
            </body>

            </html>