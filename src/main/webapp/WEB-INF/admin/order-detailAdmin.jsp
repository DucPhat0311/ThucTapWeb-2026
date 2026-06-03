<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
    <%@ taglib prefix="aura" uri="/WEB-INF/tlds/aura.tld" %>
        <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <title>Chi tiết đơn hàng</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/formUser.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/sidebarAdmin.css">
            </head>

            <body>

                <div class="container">

                    <c:set var="unpaidOnlineOrder"
                        value="${order.paymentMethods == 'VNPAY' && order.paymentStatuses != 'PAID' && order.paymentStatuses != 'REFUND_PENDING' && order.paymentStatuses != 'REFUNDED'}" />

                    <div class="form-header">
                        <a href="${pageContext.request.contextPath}/orderAdmin" class="btn-back">← Quay lại danh sách</a>
                        <h2>Chi tiết đơn hàng #${order.id}</h2>
                    </div>

                    <c:if test="${param.error == 'unpaid_online_order'}">
                        <div class="card" style="border-left: 4px solid #dc3545;">
                            <p>Đơn hàng thanh toán online chưa hoàn tất. Admin chỉ nên hủy đơn hoặc chờ khách thanh toán
                                thành công.</p>
                        </div>
                    </c:if>

                    <c:if test="${param.error == 'ghn_not_allowed'}">
                        <div class="card" style="border-left: 4px solid #dc3545;">
                            <p>Đơn hàng này không thể tạo vận đơn GHN hoặc đã có mã vận đơn.</p>
                        </div>
                    </c:if>

                    <c:if test="${param.error == 'ghn_create_failed'}">
                        <div class="card" style="border-left: 4px solid #dc3545;">
                            <p>Không thể tạo vận đơn GHN. ${param.message}</p>
                        </div>
                    </c:if>

                    <c:if test="${param.error == 'cancel_not_allowed'}">
                        <div class="card" style="border-left: 4px solid #dc3545;">
                            <p>Không thể hủy đơn hàng. ${param.message}</p>
                        </div>
                    </c:if>

                    <c:if test="${param.error == 'invalid_order_action'}">
                        <div class="card" style="border-left: 4px solid #dc3545;">
                            <p>Thao tác cập nhật đơn hàng không hợp lệ với trạng thái hiện tại.</p>
                        </div>
                    </c:if>

                    <c:if test="${param.success == 'ghn_created'}">
                        <div class="card" style="border-left: 4px solid #28a745;">
                            <p>Tạo vận đơn GHN thành công.</p>
                        </div>
                    </c:if>
                    <c:if test="${param.error == 'ghn_disabled'}">
                        <div class="card" style="border-left: 4px solid #dc3545;">
                            <p>Chế độ kiểm thử chỉ tạo hành trình mô phỏng, không tạo vận đơn thật trên GHN.</p>
                        </div>
                    </c:if>

                    <c:if test="${param.error == 'demo_not_allowed'}">
                        <div class="card" style="border-left: 4px solid #dc3545;">
                            <p>Đơn hàng này không thể tạo hành trình mô phỏng hoặc đã có mã theo dõi.</p>
                        </div>
                    </c:if>

                    <c:if test="${param.error == 'demo_create_failed'}">
                        <div class="card" style="border-left: 4px solid #dc3545;">
                            <p>Không thể tạo hành trình mô phỏng. ${param.message}</p>
                        </div>
                    </c:if>

                    <c:if test="${param.success == 'demo_created'}">
                        <div class="card" style="border-left: 4px solid #28a745;">
                            <p>Đã tạo hành trình mô phỏng. Thao tác này không tạo vận đơn GHN thật.</p>
                        </div>
                    </c:if>

                    <c:if test="${param.error == 'demo_update_failed'}">
                        <div class="card" style="border-left: 4px solid #dc3545;">
                            <p>Không thể cập nhật hành trình mô phỏng. ${param.message}</p>
                        </div>
                    </c:if>

                    <c:if test="${param.success == 'demo_updated'}">
                        <div class="card" style="border-left: 4px solid #28a745;">
                            <p>Cập nhật hành trình mô phỏng thành công.</p>
                        </div>
                    </c:if>

                    <c:if test="${param.success == 'refund_confirmed'}">
                        <div class="card" style="border-left: 4px solid #28a745;">
                            <p>Đã xác nhận hoàn tiền cho đơn hàng.</p>
                        </div>
                    </c:if>

                    <div class="card">
                        <h3>Thông tin người nhận</h3>
                        <p><b>Người nhận:</b> ${order.name}</p>
                        <p><b>SĐT:</b> ${order.phone}</p>
                        <p><b>Địa chỉ:</b> ${order.shippingAddress}</p>
                        <c:if test="${not empty order.note}">
                            <p><b>Ghi chú:</b> ${order.note}</p>
                        </c:if>
                    </div>

                    <div class="card">
                        <h3>Thông tin thanh toán</h3>
                        <p><b>Phương thức:</b> ${paymentMethodLabels[order.paymentMethods]}</p>
                        <p><b>Trạng thái thanh toán:</b> ${paymentStatusLabels[order.paymentStatuses]}</p>
                        <p><b>Trạng thái đơn hàng:</b> ${orderStatusLabels[order.orderStatus]}</p>
                        <p><b>Ngày tạo:</b> ${order.createdAtFormatted}</p>
                        <p><b>Tổng thanh toán:</b>
                            <fmt:formatNumber value="${order.finalAmount}" type="number" /> đ
                        </p>
                    </div>

                    <div class="card">
                        <h3>Theo dõi vận chuyển</h3>
                        <c:choose>
                            <c:when test="${not empty order.ghnOrderCode}">
                                <c:choose>
                                    <c:when test="${fn:startsWith(order.ghnOrderCode, 'DEMO-')}">
                                        <p><b>Loại theo dõi:</b> Mô phỏng kiểm thử</p>
                                        <p><b>Mã theo dõi:</b> ${order.ghnOrderCode}</p>
                                        <p><b>Trạng thái:</b> ${not empty order.ghnStatusName ? order.ghnStatusName : 'Chưa có trạng thái'}</p>
                                    </c:when>
                                    <c:otherwise>
                                        <p><b>Mã vận đơn GHN:</b> ${order.ghnOrderCode}</p>
                                        <p><b>Trạng thái GHN:</b> ${not empty order.ghnStatusName ? order.ghnStatusName : 'Chưa có trạng thái'}</p>
                                    </c:otherwise>
                                </c:choose>
                                <c:if test="${not empty order.ghnExpectedDeliveryTimeFormatted}">
                                    <p><b>Dự kiến giao:</b> ${order.ghnExpectedDeliveryTimeFormatted}</p>
                                </c:if>
                                <c:if test="${not empty order.ghnLastUpdatedAtFormatted}">
                                    <p><b>Cập nhật lúc:</b> ${order.ghnLastUpdatedAtFormatted}</p>
                                </c:if>

                                <c:if test="${demoTracking && order.orderStatus != 'COMPLETED' && order.orderStatus != 'CANCELLED'}">
                                    <hr style="margin: 20px 0; border: 0; border-top: 1px solid #eee;">
                                    <h3>Cập nhật chặng mô phỏng</h3>
                                    <form method="post" action="${pageContext.request.contextPath}/orderAdmin" class="status-form">
                                        <input type="hidden" name="action" value="updateDemoTracking">
                                        <input type="hidden" name="id" value="${order.id}">

                                        <label for="trackingStatus">Chặng vận chuyển</label>
                                        <select id="trackingStatus" name="trackingStatus" required>
                                            <c:forEach var="status" items="${demoTrackingStatuses}">
                                                <option value="${status.key}" ${status.key == order.ghnStatus ? 'selected' : ''}>${status.value}</option>
                                            </c:forEach>
                                        </select>

                                        <label for="trackingLocation">Vị trí hiện tại hoặc ghi chú</label>
                                        <input type="text" id="trackingLocation" name="trackingLocation"
                                               placeholder="Ví dụ: Kho phân loại Thủ Đức, TP.HCM"
                                               value="<c:out value='${demoTrackingLocation}'/>"
                                               maxlength="255">

                                        <button class="btn-primary">Lưu chặng vận chuyển</button>
                                    </form>
                                </c:if>
                            </c:when>
                            <c:otherwise>
                                <p>Đơn hàng chưa có hành trình theo dõi.</p>
                                <p>Chế độ mô phỏng phục vụ kiểm thử, không gửi yêu cầu tạo vận đơn đến GHN.</p>
                                <c:choose>
                                    <c:when test="${order.orderStatus == 'PROCESSING'}">
                                        <form method="post" action="${pageContext.request.contextPath}/orderAdmin" class="status-form">
                                            <input type="hidden" name="action" value="createDemoTracking">
                                            <input type="hidden" name="id" value="${order.id}">
                                            <button class="btn-primary">Tạo hành trình mô phỏng</button>
                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                        <p style="margin-top: 10px; color: #8a6238;">
                                            Cần xác nhận đơn trước khi tạo hành trình vận chuyển.
                                        </p>
                                    </c:otherwise>
                                </c:choose>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <c:if test="${demoTracking}">
                        <div class="card">
                            <h3>Lịch sử hành trình mô phỏng</h3>
                            <c:choose>
                                <c:when test="${empty trackingLogs}">
                                    <p>Chưa có lịch sử vận chuyển.</p>
                                </c:when>
                                <c:otherwise>
                                    <table class="order-table">
                                        <thead>
                                            <tr>
                                                <th>Thời gian</th>
                                                <th>Trạng thái</th>
                                                <th>Mô tả</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="log" items="${trackingLogs}">
                                                <tr>
                                                    <td>${log.eventTimeFormatted}</td>
                                                    <td>${log.statusName}</td>
                                                    <td>${log.description}</td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>

                    <div class="card">
                        <h3>Thao tác xử lý đơn hàng</h3>

                        <div class="admin-order-actions">
                            <c:choose>
                                <c:when test="${order.orderStatus == 'PENDING'}">
                                    <c:if test="${!unpaidOnlineOrder}">
                                        <form method="post" action="${pageContext.request.contextPath}/orderAdmin" class="status-form">
                                            <input type="hidden" name="action" value="update">
                                            <input type="hidden" name="orderAction" value="confirm">
                                            <input type="hidden" name="id" value="${order.id}">
                                            <button class="btn-primary">Xác nhận đơn</button>
                                        </form>
                                    </c:if>
                                    <form method="post" action="${pageContext.request.contextPath}/orderAdmin" class="status-form">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="orderAction" value="cancel">
                                        <input type="hidden" name="id" value="${order.id}">
                                        <button class="btn-warning">Hủy đơn</button>
                                    </form>
                                </c:when>

                                <c:when test="${order.orderStatus == 'PENDING_PAYMENT'}">
                                    <p class="order-action-note">
                                        Đơn đang chờ thanh toán. Admin chỉ nên hủy đơn hoặc chờ khách thanh toán thành công.
                                    </p>
                                    <form method="post" action="${pageContext.request.contextPath}/orderAdmin" class="status-form">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="orderAction" value="cancel">
                                        <input type="hidden" name="id" value="${order.id}">
                                        <button class="btn-warning">Hủy đơn</button>
                                    </form>
                                </c:when>

                                <c:when test="${order.orderStatus == 'PROCESSING'}">
                                    <p class="order-action-note">
                                        Đơn đã được xác nhận. Tạo hành trình vận chuyển ở khối theo dõi phía trên hoặc chuyển trực tiếp sang đang giao khi cần kiểm thử nhanh.
                                    </p>
                                    <form method="post" action="${pageContext.request.contextPath}/orderAdmin" class="status-form">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="orderAction" value="markShipping">
                                        <input type="hidden" name="id" value="${order.id}">
                                        <button class="btn-primary">Chuyển sang đang giao</button>
                                    </form>
                                    <form method="post" action="${pageContext.request.contextPath}/orderAdmin" class="status-form">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="orderAction" value="cancel">
                                        <input type="hidden" name="id" value="${order.id}">
                                        <button class="btn-warning">Hủy đơn</button>
                                    </form>
                                </c:when>

                                <c:when test="${order.orderStatus == 'SHIPPING'}">
                                    <form method="post" action="${pageContext.request.contextPath}/orderAdmin" class="status-form">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="orderAction" value="markCompleted">
                                        <input type="hidden" name="id" value="${order.id}">
                                        <button class="btn-primary">Giao thành công</button>
                                    </form>
                                    <form method="post" action="${pageContext.request.contextPath}/orderAdmin" class="status-form">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="orderAction" value="cancel">
                                        <input type="hidden" name="id" value="${order.id}">
                                        <button class="btn-warning">Hủy vận đơn</button>
                                    </form>
                                </c:when>

                                <c:when test="${order.orderStatus == 'CANCELLED' && order.paymentStatuses == 'REFUND_PENDING'}">
                                    <p class="order-action-note">
                                        Đơn VNPay đã hủy và đang chờ shop xác nhận hoàn tiền cho khách.
                                    </p>
                                    <form method="post" action="${pageContext.request.contextPath}/orderAdmin" class="status-form">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="orderAction" value="confirmRefund">
                                        <input type="hidden" name="id" value="${order.id}">
                                        <button class="btn-primary">Xác nhận đã hoàn tiền</button>
                                    </form>
                                </c:when>

                                <c:otherwise>
                                    <p class="order-action-note">
                                        Đơn hàng đã ở trạng thái kết thúc, không thể cập nhật trạng thái chính.
                                    </p>
                                </c:otherwise>
                            </c:choose>

                            <c:if test="${unpaidOnlineOrder && order.orderStatus != 'PENDING_PAYMENT'}">
                                <p class="order-action-note danger">
                                    Đơn VNPay chưa thanh toán thành công nên không thể chuyển sang trạng thái xử lý hoặc giao hàng.
                                </p>
                            </c:if>
                        </div>
                    </div>

                    <div class="card">
                        <h3>Sản phẩm</h3>

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
                                <c:forEach items="${items}" var="i">
                                    <tr>
                                        <td>
                                            <img src="${aura:resolve(pageContext.request.contextPath, '/img/products', i.thumbnail, 'img/aox.webp')}" class="product-thumb"
                                                onerror="this.onerror=null; this.style.display='none';">
                                        </td>
                                        <td>${i.productName}</td>
                                        <td>${i.size}</td>
                                        <td>${i.color}</td>
                                        <td>${i.quantity}</td>
                                        <td>
                                            <fmt:formatNumber value="${i.price}" type="number" /> đ
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                </div>

            </body>

            </html>
