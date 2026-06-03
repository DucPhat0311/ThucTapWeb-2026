<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
            <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ taglib prefix="aura" uri="/WEB-INF/tlds/aura.tld" %>

                <% request.setAttribute("pageCss", "views/order-detail.css" );
                    request.setAttribute("pageTitle", "Chi tiết đơn hàng" ); %>

                    <%@ include file="../include/header.jsp" %>

                        <section class="profile-container">
                            <div class="profile-sidebar">
                                <div class="user-info">
                                    <div class="avatar">
                                        <c:set var="avatarPath"
                                            value="${empty sessionScope.userlogin.avatarUrl ? 'img/avt.jpg' : sessionScope.userlogin.avatarUrl}" />
                                        <img src="${aura:resolve(pageContext.request.contextPath, '', avatarPath, 'img/avt.jpg')}" alt="Avatar">
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

                            <div class="profile-content order-detail-page order-status-${orderStatusClass}">
                                <div class="detail-header">
                                    <div>
                                        <span class="detail-eyebrow">Theo dõi đơn hàng</span>
                                        <h2>Chi tiết đơn hàng</h2>
                                        <p class="order-code">Mã đơn hàng: <strong>#${order.id}</strong></p>
                                    </div>

                                    <div class="detail-status">
                                        <span class="status-badge ${orderStatusClass}">${orderStatusLabel}</span>
                                    </div>
                                </div>

                                <div class="order-progress-card">
                                    <div class="order-progress-step ${order.orderStatus == 'PENDING' || order.orderStatus == 'PENDING_PAYMENT' || order.orderStatus == 'PROCESSING' || order.orderStatus == 'SHIPPING' || order.orderStatus == 'COMPLETED' ? 'active' : ''}">
                                        <span><i class="fa-solid fa-receipt"></i></span>
                                        <div>
                                            <strong>Đặt hàng</strong>
                                            <small>${order.createdAtFormatted}</small>
                                        </div>
                                    </div>
                                    <div class="order-progress-step ${order.orderStatus == 'PENDING_PAYMENT' || order.orderStatus == 'PROCESSING' || order.orderStatus == 'SHIPPING' || order.orderStatus == 'COMPLETED' ? 'active' : ''}">
                                        <span><i class="fa-solid fa-credit-card"></i></span>
                                        <div>
                                            <strong>Thanh toán</strong>
                                            <small>${paymentStatusLabel}</small>
                                        </div>
                                    </div>
                                    <div class="order-progress-step ${order.orderStatus == 'PROCESSING' || order.orderStatus == 'SHIPPING' || order.orderStatus == 'COMPLETED' ? 'active' : ''}">
                                        <span><i class="fa-solid fa-truck-fast"></i></span>
                                        <div>
                                            <strong>Vận chuyển</strong>
                                            <small>${order.orderStatus == 'PROCESSING' ? 'Shop đang chuẩn bị hàng' : (not empty order.ghnStatusName ? order.ghnStatusName : orderStatusLabel)}</small>
                                        </div>
                                    </div>
                                    <div class="order-progress-step ${order.orderStatus == 'COMPLETED' ? 'active' : ''} ${order.orderStatus == 'CANCELLED' ? 'cancelled' : ''}">
                                        <span><i class="fa-solid ${order.orderStatus == 'CANCELLED' ? 'fa-xmark' : 'fa-check'}"></i></span>
                                        <div>
                                            <strong>${order.orderStatus == 'CANCELLED' ? 'Đã hủy' : 'Hoàn tất'}</strong>
                                            <small>${order.orderStatus == 'COMPLETED' ? 'Đơn hàng hoàn thành' : orderStatusLabel}</small>
                                        </div>
                                    </div>
                                </div>

                                <div class="detail-section">
                                    <h3>Thông tin đơn hàng</h3>

                                    <div class="summary-grid">
                                        <div class="summary-item">
                                            <i class="fa-regular fa-calendar"></i>
                                            <span class="label">Ngày đặt hàng</span>
                                            <span class="value">${order.createdAtFormatted}</span>
                                        </div>
                                        <div class="summary-item">
                                            <i class="fa-regular fa-credit-card"></i>
                                            <span class="label">Phương thức thanh toán</span>
                                            <span class="value">${paymentMethodLabel}</span>
                                        </div>
                                        <div class="summary-item payment-state payment-${fn:toLowerCase(order.paymentStatuses)}">
                                            <i class="fa-solid fa-wallet"></i>
                                            <span class="label">Trạng thái thanh toán</span>
                                            <span class="value">${paymentStatusLabel}</span>
                                        </div>
                                        <div class="summary-item">
                                            <i class="fa-solid fa-calendar-check"></i>
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

                                <div class="detail-section tracking-section">
                                    <h3>Theo dõi vận chuyển</h3>

                                    <c:choose>
                                        <c:when test="${empty order.ghnOrderCode}">
                                            <div class="tracking-empty">Đơn hàng chưa có thông tin theo dõi vận chuyển.</div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="tracking-summary">
                                                <c:choose>
                                                    <c:when test="${demoTracking}">
                                                        <div class="tracking-summary-card">
                                                            <i class="fa-solid fa-route"></i>
                                                            <span class="label">Hình thức theo dõi</span>
                                                            <strong>Mô phỏng kiểm thử</strong>
                                                        </div>
                                                        <div class="tracking-summary-card">
                                                            <i class="fa-solid fa-barcode"></i>
                                                            <span class="label">Mã theo dõi</span>
                                                            <strong>${order.ghnOrderCode}</strong>
                                                        </div>
                                                        <div class="tracking-summary-card tracking-current">
                                                            <i class="fa-solid fa-truck-fast"></i>
                                                            <span class="label">Trạng thái hiện tại</span>
                                                            <strong>${not empty order.ghnStatusName ? order.ghnStatusName :
                                                                "Chưa có trạng thái"}</strong>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="tracking-summary-card">
                                                            <i class="fa-solid fa-barcode"></i>
                                                            <span class="label">Mã vận đơn GHN</span>
                                                            <strong>${order.ghnOrderCode}</strong>
                                                        </div>
                                                        <div class="tracking-summary-card tracking-current">
                                                            <i class="fa-solid fa-truck-fast"></i>
                                                            <span class="label">Trạng thái GHN</span>
                                                            <strong>${not empty order.ghnStatusName ? order.ghnStatusName :
                                                                "Chưa có trạng thái"}</strong>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                                <div class="tracking-summary-card">
                                                    <i class="fa-regular fa-clock"></i>
                                                    <span class="label">Cập nhật gần nhất</span>
                                                    <strong>${not empty order.ghnLastUpdatedAtFormatted ?
                                                        order.ghnLastUpdatedAtFormatted : "Chưa có thông tin"}</strong>
                                                </div>
                                            </div>

                                            <c:if test="${demoTracking}">
                                                <div class="tracking-empty">Hành trình này được mô phỏng phục vụ kiểm thử.</div>
                                            </c:if>

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
                                                    <c:set var="itemThumb"
                                                        value="${empty item.thumbnail ? 'img/aox.webp' : item.thumbnail}" />
                                                    <img src="${aura:resolve(pageContext.request.contextPath, '/img/products', itemThumb, 'img/aox.webp')}"
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

                                <c:if test="${order.orderStatus == 'COMPLETED'}">
                                    <div class="detail-section return-request-section">
                                        <h3>Đổi trả và hoàn hàng</h3>

                                        <c:if test="${param.returnRequest == 'success'}">
                                            <div class="return-message success">
                                                Yêu cầu trả hàng đã được gửi. AURA Studio sẽ kiểm tra và phản hồi trong thời gian sớm nhất.
                                            </div>
                                        </c:if>
                                        <c:if test="${param.returnError == 'duplicate'}">
                                            <div class="return-message error">Đơn hàng này đã có yêu cầu trả hàng.</div>
                                        </c:if>
                                        <c:if test="${param.returnError == 'expired'}">
                                            <div class="return-message error">Đơn hàng đã quá thời hạn yêu cầu trả hàng 07 ngày.</div>
                                        </c:if>
                                        <c:if test="${param.returnError == 'invalid'}">
                                            <div class="return-message error">Vui lòng chọn lý do và nhập mô tả hợp lệ.</div>
                                        </c:if>

                                        <c:choose>
                                            <c:when test="${returnRequestExists}">
                                                <div class="return-overview">
                                                    <div class="return-overview-head">
                                                        <div>
                                                            <span class="return-caption">Trạng thái yêu cầu</span>
                                                            <strong class="return-status ${orderReturn.returnStatus}">${returnStatusLabel}</strong>
                                                        </div>
                                                        <div>
                                                            <span class="return-caption">Ngày gửi</span>
                                                            <strong>${orderReturn.requestedAtFormatted}</strong>
                                                        </div>
                                                    </div>
                                                    <div class="return-request-details">
                                                        <p><strong>Lý do:</strong> ${returnReasonLabel}</p>
                                                        <p><strong>Mô tả:</strong> <c:out value="${orderReturn.description}" /></p>
                                                        <c:if test="${not empty orderReturn.adminNote}">
                                                            <p><strong>Phản hồi từ shop:</strong> <c:out value="${orderReturn.adminNote}" /></p>
                                                        </c:if>
                                                        <p><strong>Hoàn tiền:</strong> ${refundStatusLabel}</p>
                                                        <c:if test="${orderReturn.refundStatus == 'REFUNDED'}">
                                                            <p><strong>Thời gian hoàn tiền:</strong> ${orderReturn.refundedAtFormatted}</p>
                                                        </c:if>
                                                    </div>
                                                </div>

                                                <div class="return-progress">
                                                    <div class="return-progress-item active">
                                                        <span><i class="fa-solid fa-check"></i></span>
                                                        <div>
                                                            <strong>Đã gửi yêu cầu</strong>
                                                            <small>${orderReturn.requestedAtFormatted}</small>
                                                        </div>
                                                    </div>
                                                    <div class="return-progress-item ${orderReturn.returnStatus == 'APPROVED' || orderReturn.returnStatus == 'RETURNING' || orderReturn.returnStatus == 'RETURNED' ? 'active' : ''} ${orderReturn.returnStatus == 'REJECTED' ? 'rejected' : ''}">
                                                        <span><i class="fa-solid ${orderReturn.returnStatus == 'REJECTED' ? 'fa-xmark' : 'fa-check'}"></i></span>
                                                        <div>
                                                            <strong>${orderReturn.returnStatus == 'REJECTED' ? 'Đã từ chối' : 'Đã chấp nhận'}</strong>
                                                            <small>${orderReturn.processedAtFormatted}</small>
                                                        </div>
                                                    </div>
                                                    <div class="return-progress-item ${orderReturn.returnStatus == 'RETURNING' || orderReturn.returnStatus == 'RETURNED' ? 'active' : ''}">
                                                        <span><i class="fa-solid fa-box"></i></span>
                                                        <div>
                                                            <strong>Đang hoàn hàng</strong>
                                                            <small>${orderReturn.returningAtFormatted}</small>
                                                        </div>
                                                    </div>
                                                    <div class="return-progress-item ${orderReturn.returnStatus == 'RETURNED' ? 'active' : ''}">
                                                        <span><i class="fa-solid fa-warehouse"></i></span>
                                                        <div>
                                                            <strong>Shop đã nhận hàng</strong>
                                                            <small>${orderReturn.returnedAtFormatted}</small>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:when>
                                            <c:when test="${returnRequestEligible}">
                                                <p class="return-intro">
                                                    Bạn có thể gửi yêu cầu trả hàng đến <strong>${returnDeadline}</strong>
                                                    theo chính sách 07 ngày của AURA Studio.
                                                </p>
                                                <form method="post" action="${pageContext.request.contextPath}/order-return"
                                                      class="return-request-form">
                                                    <input type="hidden" name="orderId" value="${order.id}">

                                                    <label for="reasonCode">Lý do trả hàng</label>
                                                    <select id="reasonCode" name="reasonCode" required>
                                                        <option value="">Chọn lý do</option>
                                                        <c:forEach var="reason" items="${returnReasons}">
                                                            <option value="${reason.key}">${reason.value}</option>
                                                        </c:forEach>
                                                    </select>

                                                    <label for="returnDescription">Mô tả chi tiết</label>
                                                    <textarea id="returnDescription" name="description" maxlength="1000" rows="4"
                                                              placeholder="Mô tả tình trạng sản phẩm hoặc lý do bạn muốn trả hàng..."
                                                              required></textarea>

                                                    <button type="submit" class="btn-return-request">
                                                        Gửi yêu cầu trả hàng
                                                    </button>
                                                </form>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="return-unavailable">
                                                    Thời hạn gửi yêu cầu trả hàng cho đơn này đã kết thúc hoặc chưa có xác nhận giao thành công.
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </c:if>

                                <div class="detail-actions">
                                    <a href="order-user" class="btn-back">Quay lại đơn hàng</a>
                                </div>
                            </div>
                        </section>

                        <%@ include file="../include/footer.jsp" %>
