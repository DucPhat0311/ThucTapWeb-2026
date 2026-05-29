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
                            <div class="topbar-title-wrap">
                                <a href="${pageContext.request.contextPath}/warehouseAdmin" class="back-to-product-btn">
                                    <i class="fa fa-arrow-left"></i>
                                </a>
                                <h1 class="topbar-title">Chi Tiết Phiếu Kho</h1>
                            </div>
                            <div class="actions">
                                <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng xuất</a>
                            </div>
                        </header>

                        <main id="page" class="page-main-padding">
                            <div class="cardHouse warehouse-card">
                                <c:if test="${not empty receipt and receipt.orderId > 0 and receipt.type == 'EXPORT'}">
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
                                <c:if test="${not empty receipt and receipt.orderId > 0 and receipt.type == 'RETURN'}">
                                    <div class="warehouse-order-banner warehouse-return-banner">
                                        <span class="warehouse-order-icon warehouse-return-icon"><i
                                                class="fa-solid fa-rotate-left"></i></span>
                                        <div>
                                            <span class="warehouse-order-label label-return">Hoàn kho từ Đơn
                                                trả hàng #${receipt.orderId}</span>
                                            <a href="${pageContext.request.contextPath}/returnAdmin?mode=view&id=${receipt.orderId}"
                                                class="warehouse-order-link link-return"><i
                                                    class="fa-solid fa-arrow-up-right-from-square icon-small"></i> Xem đơn trả hàng</a>
                                         </div>
                                    </div>
                                </c:if>
                                <div class="table-container detail-table-container">
                                    <table class="table">
                                        <thead>
                                            <tr>
                                                <th class="text-center">ID Biến thể</th>
                                                <th>Tên Sản Phẩm</th>
                                                <th class="text-center">Màu sắc</th>
                                                <th class="text-center">Size</th>
                                                <th class="text-center">Số lượng</th>
                                                <th class="text-right">Đơn giá</th>
                                                <th class="text-right">Thành tiền</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                             <c:forEach var="detail" items="${receiptDetails}">
                                                 <tr>
                                                     <td class="text-center">${detail.productVariantId}</td>
                                                     <td>${detail.productName}</td>
                                                     <td class="text-center">${detail.colorName}</td>
                                                     <td class="text-center">${detail.sizeName}</td>
                                                     <td class="text-center"><strong>${detail.quantity}</strong>
                                                     </td>
                                                     <td class="text-right">
                                                         <fmt:formatNumber value="${detail.price}" type="number"
                                                             maxFractionDigits="0" /> ₫
                                                     </td>
                                                     <td class="detail-total-price">
                                                         <fmt:formatNumber value="${detail.price * detail.quantity}"
                                                             type="number" maxFractionDigits="0" /> ₫
                                                     </td>
                                                 </tr>
                                             </c:forEach>
                                             <c:if test="${empty receiptDetails}">
                                                 <tr>
                                                     <td colspan="7" class="detail-empty-state">
                                                         <i class="fa-solid fa-inbox detail-empty-icon"></i>
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