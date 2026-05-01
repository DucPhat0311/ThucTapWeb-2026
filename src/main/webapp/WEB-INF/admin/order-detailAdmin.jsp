<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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

    <c:set var="unpaidOnlineOrder" value="${order.paymentMethods == 'VNPAY' && order.paymentStatuses != 'PAID'}"/>

    <div class="form-header">
        <a href="orderAdmin" class="btn-back">← Quay lại danh sách</a>
        <h2>Chi tiết đơn hàng #${order.id}</h2>
    </div>

    <c:if test="${param.error == 'unpaid_online_order'}">
        <div class="card" style="border-left: 4px solid #dc3545;">
            <p>Đơn hàng thanh toán online chưa hoàn tất. Admin chỉ nên hủy đơn hoặc chờ khách thanh toán thành công.</p>
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
        <p><b>Tổng thanh toán:</b> <fmt:formatNumber value="${order.finalAmount}" type="number"/> đ</p>
    </div>

    <div class="card">
        <h3>Cập nhật trạng thái đơn hàng</h3>

        <form method="post" action="orderAdmin" class="status-form">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" value="${order.id}">

            <label for="orderStatus">Trạng thái</label>
            <select id="orderStatus" name="orderStatus">
                <c:choose>
                    <c:when test="${unpaidOnlineOrder}">
                        <option value="PENDING_PAYMENT" ${order.orderStatus == 'PENDING_PAYMENT' ? 'selected' : ''}>Chờ thanh toán</option>
                        <option value="CANCELLED" ${order.orderStatus == 'CANCELLED' ? 'selected' : ''}>Đã hủy</option>
                    </c:when>
                    <c:otherwise>
                        <c:if test="${order.orderStatus == 'PENDING_PAYMENT'}">
                            <option value="PENDING_PAYMENT" selected>Chờ thanh toán</option>
                        </c:if>
                        <option value="PENDING" ${order.orderStatus == 'PENDING' ? 'selected' : ''}>Chờ xử lý</option>
                        <option value="SHIPPING" ${order.orderStatus == 'SHIPPING' ? 'selected' : ''}>Đang giao</option>
                        <option value="COMPLETED" ${order.orderStatus == 'COMPLETED' ? 'selected' : ''}>Hoàn thành</option>
                        <option value="CANCELLED" ${order.orderStatus == 'CANCELLED' ? 'selected' : ''}>Đã hủy</option>
                    </c:otherwise>
                </c:choose>
            </select>

            <c:if test="${unpaidOnlineOrder}">
                <p style="margin-top: 10px; color: #dc3545;">
                    Đơn VNPay chưa thanh toán thành công nên không thể chuyển sang trạng thái xử lý hoặc giao hàng.
                </p>
            </c:if>

            <button class="btn-primary">Cập nhật</button>
        </form>
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
                        <img src="${i.thumbnail}" class="product-thumb"
                             onerror="this.src='${pageContext.request.contextPath}/img/no-image.png'">
                    </td>
                    <td>${i.productName}</td>
                    <td>${i.size}</td>
                    <td>${i.color}</td>
                    <td>${i.quantity}</td>
                    <td><fmt:formatNumber value="${i.price}" type="number"/> đ</td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

</div>

</body>
</html>
