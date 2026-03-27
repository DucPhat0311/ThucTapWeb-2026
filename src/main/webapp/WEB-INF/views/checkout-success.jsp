<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    request.setAttribute("pageCss", "views/checkout-success.css");
    request.setAttribute("pageTitle", "Đặt hàng thành công");
%>

<%@include file="../include/header.jsp"%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/views/checkout-success.css">

<div class="order-success-wrapper">
    <div class="success-top-banner">
        <div class="success-icon-wrapper">
            <i class="fa-solid fa-check"></i>
        </div>
        <h2>Cảm ơn <b>${order.name}</b>, đơn hàng đã được đặt thành công!</h2>
        <p class="order-code">Mã đơn hàng của bạn: <b>#${order.id}</b></p>
    </div>

    <div class="order-success-content">
        <div class="order-left">
            <div class="info-card">
                <h3><i class="fa-solid fa-location-dot"></i> Địa chỉ nhận hàng</h3>
                <div class="address-details">
                    <p class="name">${order.name}</p>
                    <p class="phone">${order.phone}</p>
                    <p class="address-text">${order.shippingAddress}</p>
                    <c:if test="${not empty order.note}">
                        <p class="note"><b>Ghi chú:</b> ${order.note}</p>
                    </c:if>
                </div>
            </div>

            <div class="info-card">
                <h3><i class="fa-solid fa-circle-info"></i> Thông tin đơn hàng</h3>
                <ul class="order-updates">
                    <li><i class="fa-solid fa-money-bill-wave"></i> Phương thức: Thanh toán khi nhận hàng (COD)</li>
                    <li><i class="fa-solid fa-phone-volume"></i> Nhân viên giao hàng sẽ liên hệ trước khi giao</li>
                    <li><i class="fa-solid fa-truck-fast"></i> Thời gian dự kiến: Giao hàng tiêu chuẩn (3–5 ngày)</li>
                </ul>
            </div>

            <div class="action-buttons">
                <a href="order-user" class="btn-secondary">Đơn hàng của tôi</a>
                <a href="home" class="btn-main">Tiếp tục mua sắm</a>
            </div>
        </div>

        <div class="order-right">
            <h3><i class="fa-solid fa-bag-shopping"></i> Tóm tắt đơn hàng</h3>
            <div class="product-list">
                <c:forEach var="item" items="${orderItems}">
                    <div class="product-item">
                        <div class="product-img">
                            <img src="${not empty item.thumbnail ? item.thumbnail : './img/aox.webp'}" alt="${item.productName}" />
                            <span class="qty-badge">${item.quantity}</span>
                        </div>
                        <div class="product-info">
                            <b>${item.productName}</b>
                            <p>Size: ${item.size} | Màu: ${item.color}</p>
                        </div>
                        <div class="product-price">
                            <fmt:formatNumber value="${item.total}" type="number"/>₫
                        </div>
                    </div>
                </c:forEach>
            </div>

            <div class="summary-box">
                <div class="summary-row">
                    <span>Tạm tính</span>
                    <span><fmt:formatNumber value="${order.totalPrice}" type="number"/>₫</span>
                </div>
                <div class="summary-row">
                    <span>Phí vận chuyển</span>
                    <span>MIỄN PHÍ</span>
                </div>
                <hr class="divider">
                <div class="summary-total">
                    <span>Tổng cộng</span>
                    <span class="total-price"><fmt:formatNumber value="${order.finalAmount}" type="number"/>₫</span>
                </div>
            </div>
        </div>
    </div>
</div>

<%@include file="../include/footer.jsp"%>
