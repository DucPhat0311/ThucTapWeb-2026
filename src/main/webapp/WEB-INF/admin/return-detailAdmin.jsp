<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="aura" uri="/WEB-INF/tlds/aura.tld" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xử lý yêu cầu trả hàng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/formUser.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/returnAdmin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
</head>
<body>
<div class="container return-detail">
    <div class="form-header return-detail-header">
        <a href="${pageContext.request.contextPath}/returnAdmin" class="btn-back">
            <i class="fa-solid fa-arrow-left"></i> Danh sách yêu cầu
        </a>
        <div>
            <h2>Yêu cầu trả hàng #${orderReturn.id}</h2>
            <p class="detail-subtitle">Đơn hàng #${orderReturn.orderId}</p>
        </div>
        <span class="return-status ${orderReturn.returnStatus}">
            <c:out value="${orderReturn.returnStatusLabel}"/>
        </span>
    </div>

    <c:if test="${param.success == 'approved'}">
        <div class="notice success">Đã chấp nhận yêu cầu trả hàng. Khách hàng có thể gửi sản phẩm hoàn về shop.</div>
    </c:if>
    <c:if test="${param.success == 'rejected'}">
        <div class="notice success">Đã từ chối yêu cầu trả hàng.</div>
    </c:if>
    <c:if test="${param.success == 'returning'}">
        <div class="notice success">Đã chuyển yêu cầu sang trạng thái đang hoàn hàng.</div>
    </c:if>
    <c:if test="${param.success == 'returned'}">
        <div class="notice success">Đã xác nhận nhận lại sản phẩm và cộng lại số lượng vào kho. Nếu đơn đã thanh toán, yêu cầu được chuyển sang chờ hoàn tiền.</div>
    </c:if>
    <c:if test="${param.success == 'refunded'}">
        <div class="notice success">Đã ghi nhận hoàn tiền thành công cho khách hàng.</div>
    </c:if>
    <c:if test="${param.error == 'reject_note_required'}">
        <div class="notice error">Vui lòng nhập lý do từ chối để khách hàng biết kết quả xử lý.</div>
    </c:if>
    <c:if test="${param.error == 'invalid_transition'}">
        <div class="notice error">Không thể thực hiện thao tác vì trạng thái yêu cầu đã thay đổi.</div>
    </c:if>

    <div class="return-detail-grid">
        <section class="card">
            <h3>Thông tin yêu cầu</h3>
            <div class="detail-line"><span>Ngày gửi</span><strong>${orderReturn.requestedAtFormatted}</strong></div>
            <div class="detail-line"><span>Lý do</span><strong><c:out value="${orderReturn.reasonLabel}"/></strong></div>
            <div class="detail-line"><span>Hoàn tiền</span><strong><c:out value="${orderReturn.refundStatusLabel}"/></strong></div>
            <c:if test="${orderReturn.returnStatus == 'RETURNED'}">
                <div class="detail-line"><span>Ngày shop nhận lại</span><strong>${orderReturn.returnedAtFormatted}</strong></div>
                <div class="detail-line"><span>Tồn kho</span><strong>${orderReturn.stockRestored ? 'Đã cộng lại kho' : 'Chưa cập nhật'}</strong></div>
                <c:if test="${orderReturn.refundStatus == 'REFUNDED'}">
                    <div class="detail-line"><span>Ngày hoàn tiền</span><strong>${orderReturn.refundedAtFormatted}</strong></div>
                </c:if>
            </c:if>
            <div class="detail-content">
                <span>Mô tả của khách hàng</span>
                <p><c:out value="${orderReturn.description}"/></p>
            </div>
            <c:if test="${not empty orderReturn.adminNote}">
                <div class="detail-content admin-note">
                    <span>Phản hồi của admin</span>
                    <p><c:out value="${orderReturn.adminNote}"/></p>
                </div>
            </c:if>
        </section>

        <section class="card">
            <h3>Thông tin đơn hàng</h3>
            <div class="detail-line"><span>Khách hàng</span><strong><c:out value="${order.name}"/></strong></div>
            <div class="detail-line"><span>Số điện thoại</span><strong><c:out value="${order.phone}"/></strong></div>
            <div class="detail-line"><span>Thanh toán</span><strong>${paymentMethodLabels[order.paymentMethods]}</strong></div>
            <div class="detail-line"><span>Trạng thái thanh toán</span><strong>${paymentStatusLabels[order.paymentStatuses]}</strong></div>
            <div class="detail-line"><span>Tổng tiền</span><strong><fmt:formatNumber value="${order.finalAmount}" type="number"/> đ</strong></div>
            <a href="${pageContext.request.contextPath}/orderAdmin?mode=view&amp;id=${orderReturn.orderId}" class="order-link">
                Xem chi tiết đơn hàng <i class="fa-solid fa-arrow-right"></i>
            </a>
        </section>
    </div>

    <c:choose>
        <c:when test="${orderReturn.returnStatus == 'REQUESTED'}">
            <section class="card action-card">
                <h3>Xét duyệt yêu cầu</h3>
                <div class="action-grid">
                    <form method="post" action="${pageContext.request.contextPath}/returnAdmin" class="decision-form">
                        <input type="hidden" name="id" value="${orderReturn.id}">
                        <input type="hidden" name="action" value="approve">
                        <label for="approveNote">Ghi chú khi chấp nhận (không bắt buộc)</label>
                        <textarea id="approveNote" name="adminNote" maxlength="1000" placeholder="Ví dụ: Vui lòng đóng gói sản phẩm và gửi lại shop."></textarea>
                        <button type="submit" class="btn-primary"><i class="fa-solid fa-check"></i> Chấp nhận</button>
                    </form>
                    <form method="post" action="${pageContext.request.contextPath}/returnAdmin" class="decision-form reject-form">
                        <input type="hidden" name="id" value="${orderReturn.id}">
                        <input type="hidden" name="action" value="reject">
                        <label for="rejectNote">Lý do từ chối <span class="required">*</span></label>
                        <textarea id="rejectNote" name="adminNote" maxlength="1000" required placeholder="Nêu rõ lý do yêu cầu không đủ điều kiện."></textarea>
                        <button type="submit" class="btn-reject"><i class="fa-solid fa-xmark"></i> Từ chối</button>
                    </form>
                </div>
            </section>
        </c:when>
        <c:when test="${orderReturn.returnStatus == 'APPROVED'}">
            <section class="card action-card">
                <h3>Cập nhật tiến trình hoàn hàng</h3>
                <form method="post" action="${pageContext.request.contextPath}/returnAdmin" class="returning-form">
                    <input type="hidden" name="id" value="${orderReturn.id}">
                    <input type="hidden" name="action" value="startReturning">
                    <label for="returningNote">Ghi chú vận chuyển hoàn (không bắt buộc)</label>
                    <textarea id="returningNote" name="adminNote" maxlength="1000" placeholder="Ví dụ: Khách hàng đã bàn giao gói hàng cho đơn vị vận chuyển."></textarea>
                    <button type="submit" class="btn-primary"><i class="fa-solid fa-truck-arrow-right"></i> Xác nhận đang hoàn hàng</button>
                </form>
            </section>
        </c:when>
        <c:when test="${orderReturn.returnStatus == 'RETURNING'}">
            <section class="card action-card">
                <h3>Xác nhận nhận lại sản phẩm</h3>
                <p class="action-description">Chỉ xác nhận sau khi shop đã kiểm tra và nhận lại đầy đủ sản phẩm. Thao tác này sẽ cộng số lượng sản phẩm trở lại kho và không thể thực hiện lần hai.</p>
                <form method="post" action="${pageContext.request.contextPath}/returnAdmin" class="returning-form">
                    <input type="hidden" name="id" value="${orderReturn.id}">
                    <input type="hidden" name="action" value="completeReturn">
                    <label for="returnedNote">Ghi chú nhận hàng (không bắt buộc)</label>
                    <textarea id="returnedNote" name="adminNote" maxlength="1000" placeholder="Ví dụ: Shop đã nhận đủ sản phẩm, tình trạng nguyên vẹn."></textarea>
                    <button type="submit" class="btn-primary"><i class="fa-solid fa-box-open"></i> Xác nhận đã nhận và hoàn kho</button>
                </form>
            </section>
        </c:when>
        <c:when test="${orderReturn.returnStatus == 'RETURNED'}">
            <c:choose>
                <c:when test="${orderReturn.refundStatus == 'PENDING'}">
                    <section class="card action-card">
                        <h3>Xử lý hoàn tiền</h3>
                        <p class="action-description">
                            Đơn hàng đã thanh toán và đã được nhận lại. Sau khi thực hiện hoàn tiền
                            cho khách qua phương thức phù hợp, hãy xác nhận kết quả tại đây.
                        </p>
                        <form method="post" action="${pageContext.request.contextPath}/returnAdmin" class="returning-form">
                            <input type="hidden" name="id" value="${orderReturn.id}">
                            <input type="hidden" name="action" value="confirmRefund">
                            <label for="refundNote">Ghi chú hoàn tiền (không bắt buộc)</label>
                            <textarea id="refundNote" name="adminNote" maxlength="1000"
                                      placeholder="Ví dụ: Đã hoàn tiền theo giao dịch VNPay hoặc chuyển khoản cho khách."></textarea>
                            <button type="submit" class="btn-primary"><i class="fa-solid fa-money-check-dollar"></i> Xác nhận đã hoàn tiền</button>
                        </form>
                    </section>
                </c:when>
                <c:when test="${orderReturn.refundStatus == 'REFUNDED'}">
                    <div class="notice info">Shop đã nhận lại sản phẩm, cập nhật tồn kho và hoàn tiền cho khách hàng.</div>
                </c:when>
                <c:otherwise>
                    <div class="notice info">Shop đã nhận lại sản phẩm và cập nhật tồn kho. Đơn hàng không phát sinh khoản tiền cần hoàn.</div>
                </c:otherwise>
            </c:choose>
        </c:when>
    </c:choose>

    <section class="card">
        <h3>Sản phẩm trong đơn</h3>
        <table class="order-table">
            <thead>
            <tr>
                <th>Ảnh</th>
                <th>Sản phẩm</th>
                <th>Size</th>
                <th>Màu</th>
                <th>SL</th>
                <th>Giá</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${items}" var="item">
                <tr>
                    <td>
                        <img src="${aura:resolve(pageContext.request.contextPath, '/img/products', item.thumbnail, 'img/aox.webp')}"
                             class="product-thumb" alt="" onerror="this.style.display='none'">
                    </td>
                    <td><c:out value="${item.productName}"/></td>
                    <td><c:out value="${item.size}"/></td>
                    <td><c:out value="${item.color}"/></td>
                    <td>${item.quantity}</td>
                    <td><fmt:formatNumber value="${item.price}" type="number"/> đ</td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </section>
</div>
</body>
</html>
