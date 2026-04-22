<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    request.setAttribute("pageCss", "views/checkout.css");
    request.setAttribute("pageTitle", "Thanh toán");
%>

<%@include file="../include/header.jsp"%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/views/checkout.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/views/address-form.css">

<section class="checkout">
    <div class="checkout-container">
        <form action="place-order" method="post">
            <div class="checkout-left">
                <h2>Thông tin giao hàng</h2>

                <c:if test="${not empty addressError}">
                    <div class="checkout-alert checkout-alert-error">
                        ${addressError}
                    </div>
                </c:if>

                <c:choose>
                    <c:when test="${not empty selectedAddress}">
                        <div class="selected-address">
                            <div class="selected-address-header">
                                <h3>Địa chỉ giao hàng</h3>
                                <a href="${pageContext.request.contextPath}/address">Quản lý địa chỉ</a>
                            </div>
                            <div class="selected-address-body">
                                <p class="receiver-line">
                                    <strong>${selectedAddress.name}</strong>
                                    <span>${selectedAddress.phone}</span>
                                </p>
                                <p>${selectedAddress.detailAddress}, ${selectedAddress.ward}, ${selectedAddress.district}, ${selectedAddress.city}</p>
                                <c:if test="${selectedAddress.isDefault}">
                                    <span class="default-badge">Mặc định</span>
                                </c:if>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="checkout-address-empty">
                            <div>
                                <h3>Chưa có địa chỉ giao hàng</h3>
                                <p>Thêm địa chỉ ngay tại đây để dùng luôn cho đơn hàng. Địa chỉ mới sẽ được lưu vào sổ địa chỉ của bạn.</p>
                            </div>
                            <button type="button" class="btn-address-primary" id="btnOpenModal">
                                Thêm địa chỉ mới
                            </button>
                        </div>
                    </c:otherwise>
                </c:choose>

                <div class="form-group">
                    <label>Ghi chú</label>
                    <textarea name="note" placeholder="Giao giờ hành chính..."></textarea>
                </div>

                <h2>Phương thức thanh toán</h2>

                <div class="payment-method">
                    <label>
                        <input type="radio" name="paymentMethod" value="COD" checked>
                        Thanh toán khi nhận hàng (COD)
                    </label>

                    <label>
                        <input type="radio" name="paymentMethod" value="MOMO">
                        Ví điện tử MOMO
                    </label>

                    <label>
                        <input type="radio" name="paymentMethod" value="ONEPAY">
                        Thẻ ATM / Visa (OnePay)
                    </label>
                </div>
            </div>

            <div class="checkout-right">
                <h3>Đơn hàng của bạn</h3>
                <input type="hidden" name="cartId" value="${sessionScope.cartId}">
                <c:forEach var="item" items="${checkoutItems}">
                    <input type="hidden" name="variantIds" value="${item.variantId}">
                    <input type="hidden" name="quantities" value="${item.quantity}">
                </c:forEach>

                <div class="order-items">
                    <c:set var="total" value="0"/>
                    <c:forEach var="item" items="${checkoutItems}">
                        <div class="order-item">
                            <img src="${item.product.thumbnail}">
                            <div class="info">
                                <p class="name">${item.product.name}</p>
                                <p class="variant">Size ${item.size} · ${item.color}</p>
                                <p class="qty">SL: ${item.quantity}</p>
                            </div>
                            <div class="price">
                                <fmt:formatNumber value="${item.price * item.quantity}" type="number"/>₫
                            </div>
                        </div>

                        <c:set var="total" value="${total + item.price * item.quantity}"/>
                    </c:forEach>
                </div>

                <div class="order-summary">
                    <div>
                        <span>Tạm tính</span>
                        <span><fmt:formatNumber value="${total}" type="number"/>₫</span>
                    </div>

                    <div>
                        <span>Phí vận chuyển</span>
                        <span>Miễn phí</span>
                    </div>

                    <div class="total">
                        <span>Tổng cộng</span>
                        <span><fmt:formatNumber value="${total}" type="number"/>₫</span>
                    </div>
                </div>

                <button type="submit" class="btn-checkout" ${empty selectedAddress ? 'disabled' : ''}>
                    XÁC NHẬN THANH TOÁN
                </button>
                <c:if test="${empty selectedAddress}">
                    <p class="checkout-note">Bạn cần thêm địa chỉ giao hàng trước khi xác nhận thanh toán.</p>
                </c:if>
            </div>
        </form>
    </div>
</section>

<jsp:include page="address-modal.jsp">
    <jsp:param name="formAction" value="address" />
    <jsp:param name="redirectTo" value="checkout" />
    <jsp:param name="forceDefault" value="true" />
    <jsp:param name="hideDefaultOption" value="true" />
</jsp:include>

<script>
    window.APP_CONTEXT_PATH = "${pageContext.request.contextPath}";
</script>
<script src="${pageContext.request.contextPath}/js/views/address.js"></script>

<%@include file="../include/footer.jsp"%>
