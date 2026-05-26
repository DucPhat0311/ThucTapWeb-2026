<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
            <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

                <% request.setAttribute("pageCss", "views/order-detail.css" );
                    request.setAttribute("pageTitle", "Chi tiết đơn hàng" ); %>

                    <%@ include file="../include/header.jsp" %>

                        <section class="profile-container">
                            <div class="profile-sidebar">
                                <div class="user-info">
                                    <div class="avatar">
                                        <c:set var="avatarPath"
                                            value="${empty sessionScope.userlogin.avatarUrl ? 'img/avt.jpg' : sessionScope.userlogin.avatarUrl}" />
                                        <c:choose>
                                            <c:when
                                                test="${fn:startsWith(avatarPath, 'http://') or fn:startsWith(avatarPath, 'https://')}">
                                                <img src="${avatarPath}" alt="Avatar">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="${pageContext.request.contextPath}/${avatarPath}"
                                                    alt="Avatar">
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <nav class="profile-menu">
                                    <ul>
                                        <li><a href="profile"><i class="fas fa-user"></i> Thông tin cá nhân</a></li>
                                        <li><a href="address"><i class="fas fa-map-marker-alt"></i> Địa chỉ của tôi</a>
                                        </li>
                                        <li class="active"><a href="order-user"><i class="fas fa-clipboard-list"></i>
                                                Đơn hàng của tôi</a></li>
                                        <li><a href="change-password"><i class="fas fa-lock"></i> Đổi mật khẩu</a></li>
                                        <li><a href="logout"><i class="fa fa-sign-out"></i> Đăng xuất</a></li>
                                    </ul>
                                </nav>
                            </div>

                            <div class="profile-content order-detail-page">
                                <div class="detail-header">
                                    <div>
                                        <h2>Chi tiết đơn hàng</h2>
                                        <p class="order-code">Mã đơn hàng: <strong>#${order.id}</strong></p>
                                    </div>

                                    <div class="detail-status">
                                        <span class="status-badge ${orderStatusClass}">${orderStatusLabel}</span>
                                    </div>
                                </div>

                                <div class="detail-section">
                                    <h3>Thông tin đơn hàng</h3>

                                    <div class="summary-grid">
                                        <div class="summary-item">
                                            <span class="label">Ngày đặt hàng</span>
                                            <span class="value">${order.createdAtFormatted}</span>
                                        </div>
                                        <div class="summary-item">
                                            <span class="label">Phương thức thanh toán</span>
                                            <span class="value">${paymentMethodLabel}</span>
                                        </div>
                                        <div class="summary-item">
                                            <span class="label">Trạng thái thanh toán</span>
                                            <span class="value">${paymentStatusLabel}</span>
                                        </div>
                                        <div class="summary-item">
                                            <span class="label">Dự kiến giao</span>
                                            <span class="value">
                                                <c:choose>
                                                    <c:when test="${not empty order.ghnExpectedDeliveryTimeFormatted}">
                                                        ${order.ghnExpectedDeliveryTimeFormatted}
                                                    </c:when>
                                                    <c:otherwise>Chưa có thông tin</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                    </div>
                                </div>

                                <div class="detail-section">
                                    <h3>Theo dõi vận chuyển</h3>

                                    <c:choose>
                                        <c:when test="${empty order.ghnOrderCode}">
                                            <div class="tracking-empty">Đơn hàng chưa có mã vận đơn GHN.</div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="tracking-summary">
                                                <div>
                                                    <span class="label">Mã vận đơn GHN</span>
                                                    <strong>${order.ghnOrderCode}</strong>
                                                </div>
                                                <div>
                                                    <span class="label">Trạng thái GHN</span>
                                                    <strong>${not empty order.ghnStatusName ? order.ghnStatusName :
                                                        "Chưa có trạng thái"}</strong>
                                                </div>
                                                <div>
                                                    <span class="label">Cập nhật gần nhất</span>
                                                    <strong>${not empty order.ghnLastUpdatedAtFormatted ?
                                                        order.ghnLastUpdatedAtFormatted : "Chưa có thông tin"}</strong>
                                                </div>
                                            </div>

                                            <c:if test="${not empty trackingError}">
                                                <div class="tracking-error">${trackingError}</div>
                                            </c:if>

                                            <c:choose>
                                                <c:when test="${empty trackingLogs}">
                                                    <div class="tracking-empty">Chưa có lịch sử vận chuyển.</div>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="tracking-timeline">
                                                        <c:forEach var="log" items="${trackingLogs}">
                                                            <div class="tracking-item">
                                                                <div class="tracking-dot"></div>
                                                                <div class="tracking-content">
                                                                    <div>
                                                                        <h4>${log.statusName}</h4>
                                                                        <c:if test="${not empty log.description}">
                                                                            <p>${log.description}</p>
                                                                        </c:if>
                                                                    </div>
                                                                    <span>${log.eventTimeFormatted}</span>
                                                                </div>
                                                            </div>
                                                        </c:forEach>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="detail-section">
                                    <h3>Sản phẩm đã đặt</h3>

                                    <div class="detail-product-list">
                                        <c:forEach var="item" items="${orderItems}">
                                            <div class="detail-product-item">
                                                <div class="product-left">
                                                    <img src="${(not empty item.thumbnail and fn:startsWith(item.thumbnail, 'http')) ? '' : pageContext.request.contextPath.concat('/')}${empty item.thumbnail ? 'img/aox.webp' : item.thumbnail}"
                                                        alt="${item.productName}">
                                                    <div class="product-info">
                                                        <h4>${item.productName}</h4>
                                                        <p>Màu sắc: ${item.color}</p>
                                                        <p>Size: ${item.size}</p>
                                                        <p>Số lượng: ${item.quantity}</p>
                                                    </div>
                                                </div>
                                                <div class="product-right">
                                                    <span class="price">
                                                        <fmt:formatNumber value="${item.total}" type="number" />₫
                                                    </span>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>

                                <div class="detail-section">
                                    <h3>Thông tin nhận hàng</h3>

                                    <div class="info-box">
                                        <p><strong>Người nhận:</strong> ${order.name}</p>
                                        <p><strong>Số điện thoại:</strong> ${order.phone}</p>
                                        <p><strong>Địa chỉ:</strong> ${order.shippingAddress}</p>
                                        <c:if test="${not empty order.note}">
                                            <p><strong>Ghi chú:</strong> ${order.note}</p>
                                        </c:if>
                                    </div>
                                </div>

                                <div class="detail-section">
                                    <h3>Tổng thanh toán</h3>

                                    <div class="payment-summary">
                                        <div class="payment-row">
                                            <span>Tạm tính</span>
                                            <span>
                                                <fmt:formatNumber value="${order.totalPrice}" type="number" />₫
                                            </span>
                                        </div>
                                        <div class="payment-row">
                                            <span>Phí vận chuyển</span>
                                            <span>
                                                <fmt:formatNumber value="${order.shippingFee}" type="number" />₫
                                            </span>
                                        </div>
                                        <div class="payment-row total">
                                            <span>Tổng cộng</span>
                                            <span>
                                                <fmt:formatNumber value="${order.finalAmount}" type="number" />₫
                                            </span>
                                        </div>
                                    </div>
                                </div>

                                <div class="detail-actions">
                                    <a href="order-user" class="btn-back">Quay lại đơn hàng</a>
                                </div>
                            </div>
                        </section>

                        <%@ include file="../include/footer.jsp" %>