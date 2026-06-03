<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
        <%@ taglib prefix="aura" uri="/WEB-INF/tlds/aura.tld" %>

            <% request.setAttribute("pageCss", "views/checkout-success.css" );
                request.setAttribute("pageTitle", "Đặt hàng thành công" ); %>

                <%@include file="../include/header.jsp" %>
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/views/checkout-success.css">

                    <div class="order-success-wrapper">
                        <div class="success-top-banner">
                            <div class="success-icon-wrapper">
                                <i class="fa-solid fa-check"></i>
                            </div>
                            <h2>${successMessage}</h2>
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
                                        <li><i class="fa-solid fa-money-bill-wave"></i> Phương thức:
                                            ${paymentMethodLabel}</li>
                                        <li><i class="fa-solid fa-circle-check"></i> Trạng thái thanh toán:
                                            ${paymentStatusLabel}</li>
                                        <li><i class="fa-solid fa-phone-volume"></i> Nhân viên giao hàng sẽ liên hệ
                                            trước khi giao</li>
                                        <li><i class="fa-solid fa-truck-fast"></i> Thời gian dự kiến: Giao hàng tiêu
                                            chuẩn (3-5 ngày)</li>
                                    </ul>
                                </div>

                                <div class="action-buttons">
                                    <a href="${pageContext.request.contextPath}/order-user" class="btn-secondary">Đơn hàng của tôi</a>
                                    <a href="${pageContext.request.contextPath}/home" class="btn-main">Tiếp tục mua sắm</a>
                                </div>
                            </div>

                            <div class="order-right">
                                <h3><i class="fa-solid fa-bag-shopping"></i> Tóm tắt đơn hàng</h3>
                                <div class="product-list">
                                    <c:forEach var="item" items="${orderItems}">
                                        <div class="product-item">
                                            <div class="product-img">
                                                <c:set var="itemThumb"
                                                    value="${empty item.thumbnail ? 'img/aox.webp' : item.thumbnail}" />
                                                <img src="${aura:resolve(pageContext.request.contextPath, '/img/products', itemThumb, 'img/aox.webp')}"
                                                    alt="${item.productName}" />
                                                <span class="qty-badge">${item.quantity}</span>
                                            </div>
                                            <div class="product-info">
                                                <b>${item.productName}</b>
                                                <p>Size: ${item.size} | Màu: ${item.color}</p>
                                            </div>
                                            <div class="product-price">
                                                <fmt:formatNumber value="${item.total}" type="number" />₫
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>

                                <div class="summary-box">
                                    <div class="summary-row">
                                        <span>Tạm tính</span>
                                        <span>
                                            <fmt:formatNumber value="${order.totalPrice}" type="number" />₫
                                        </span>
                                    </div>

                                    <div class="summary-row">
                                        <span>Phí vận chuyển</span>
                                        <c:choose>
                                            <c:when test="${order.shippingFee > 0}">
                                                <span>
                                                    <fmt:formatNumber value="${order.shippingFee}" type="number" />₫
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: #28a745; font-weight: bold;">MIỄN PHÍ</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <hr class="divider">

                                    <div class="summary-total">
                                        <span>Tổng cộng</span>
                                        <span class="total-price">
                                            <fmt:formatNumber value="${order.finalAmount}" type="number" />₫
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <%@include file="../include/footer.jsp" %>
