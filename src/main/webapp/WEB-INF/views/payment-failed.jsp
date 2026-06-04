<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="aura" uri="/WEB-INF/tlds/aura.tld" %>

            <% request.setAttribute("pageCss", "views/payment-failed.css" );
                request.setAttribute("pageTitle", "Thanh toán thất bại" ); %>

                <%@include file="../include/header.jsp" %>

                    <div class="payment-failed-wrapper">
                        <div class="failed-top-banner">
                            <div class="failed-icon-wrapper">
                                <i class="fa-solid fa-xmark"></i>
                            </div>
                            <h2>
                                <c:choose>
                                    <c:when test="${not empty failedTitle}">${failedTitle}</c:when>
                                    <c:otherwise>Thanh toán không thành công</c:otherwise>
                                </c:choose>
                            </h2>
                            <p class="failed-message">
                                <c:choose>
                                    <c:when test="${not empty failedMessage}">${failedMessage}</c:when>
                                    <c:otherwise>Đơn hàng của bạn đã được ghi nhận nhưng chưa hoàn tất thanh toán.
                                    </c:otherwise>
                                </c:choose>
                            </p>
                            <c:if test="${not empty order}">
                                <p class="order-code">Mã đơn hàng: <b>#${order.id}</b></p>
                            </c:if>
                        </div>

                        <div class="payment-failed-content">
                            <div class="failed-left">
                                <div class="failed-info-card">
                                    <h3><i class="fa-solid fa-circle-info"></i> Thông tin thanh toán</h3>
                                    <ul class="failed-updates">
                                        <li><i class="fa-solid fa-triangle-exclamation"></i> Trạng thái: ${not empty
                                            paymentStatusLabel ? paymentStatusLabel : "Thanh toán thất bại"}</li>
                                        <li><i class="fa-solid fa-credit-card"></i> Phương thức: ${not empty
                                            paymentMethodLabel ? paymentMethodLabel : "VNPay"}</li>
                                        <li><i class="fa-solid fa-clock-rotate-left"></i> Bạn có thể thử thanh toán lại
                                            hoặc kiểm tra đơn hàng trong tài khoản.</li>
                                    </ul>
                                </div>

                                <c:if test="${not empty order}">
                                    <div class="failed-info-card">
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
                                </c:if>

                                <div class="failed-actions">
                                    <c:if
                                        test="${not empty order && order.paymentMethods == 'VNPAY' && order.paymentStatuses != 'PAID'}">
                                        <form action="${pageContext.request.contextPath}/payment-failed" method="post" class="retry-payment-form">
                                            <input type="hidden" name="orderId" value="${order.id}">
                                            <button type="submit" class="btn-main">Thử thanh toán lại</button>
                                        </form>
                                    </c:if>
                                    <a href="${pageContext.request.contextPath}/order-user" class="btn-secondary">Đơn hàng của tôi</a>
                                    <a href="${pageContext.request.contextPath}/home" class="btn-light">Tiếp tục mua sắm</a>
                                </div>
                            </div>

                            <c:if test="${not empty order}">
                                <div class="failed-right">
                                    <h3><i class="fa-solid fa-bag-shopping"></i> Tóm tắt đơn hàng</h3>

                                    <c:if test="${not empty orderItems}">
                                        <div class="product-list">
                                            <c:forEach var="item" items="${orderItems}">
                                                <div class="product-item">
                                                    <div class="product-img">
                                                        <c:set var="itemThumb"
                                                            value="${empty item.thumbnail ? 'img/logo.png' : item.thumbnail}" />
                                                        <img src="${aura:resolve(pageContext.request.contextPath, '/img/products', itemThumb, 'img/logo.png')}"
                                                            alt="${item.productName}">
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
                                    </c:if>

                                    <div class="summary-box">
                                        <div class="summary-row">
                                            <span>Tạm tính</span>
                                            <span>
                                                <fmt:formatNumber value="${order.totalPrice}" type="number" />₫
                                            </span>
                                        </div>
                                        <div class="summary-row">
                                            <span>Phí vận chuyển</span>
                                            <span>
                                                <fmt:formatNumber value="${order.shippingFee}" type="number" />₫
                                            </span>
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
                            </c:if>
                        </div>
                    </div>

                    <%@include file="../include/footer.jsp" %>
