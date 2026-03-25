<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi Tiết Đơn Hàng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/formUser.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/sidebarAdmin.css">
</head>
<body>

<div class="container">

    <div class="form-header">
        <a href="orderAdmin" class="btn-back">← Quay lại danh sách</a>
        <h2>Chi tiết đơn hàng #10245</h2>
    </div>

    <div class="card">
        <h3>Thông tin người nhận</h3>
        <p><b>Người nhận:</b> Nguyễn Văn An</p>
        <p><b>SĐT:</b> 0901234567</p>
        <p><b>Địa chỉ:</b> Số 123, Đường Kha Vạn Cân, Linh Trung, Thủ Đức, TP. HCM</p>
    </div>

    <div class="card">
        <h3>Trạng thái đơn hàng</h3>

        <form method="post" action="#" class="status-form">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" value="10245">

            <label>Trạng thái</label>
            <select name="orderStatus">
                <option value="PENDING">Chờ xử lý</option>
                <option value="SHIPPING" selected>Đang giao</option>
                <option value="COMPLETED">Hoàn thành</option>
                <option value="CANCELLED">Đã hủy</option>
            </select>

            <button type="submit" class="btn-primary">Cập nhật</button>
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
                <tr>
                    <td>
                        <img src="https://via.placeholder.com/50" class="product-thumb">
                    </td>
                    <td>Áo thun Oversize Aura Studio</td>
                    <td>L</td>
                    <td>Đen</td>
                    <td>2</td>
                    <td>250,000 đ</td>
                </tr>
                <tr>
                    <td>
                        <img src="https://via.placeholder.com/50" class="product-thumb">
                    </td>
                    <td>Quần Jean Slimfit Blue</td>
                    <td>32</td>
                    <td>Xanh</td>
                    <td>1</td>
                    <td>450,000 đ</td>
                </tr>
            </tbody>
        </table>
    </div>
</div>

<c:if test="${mode == 'view'}">
    <style>
        input, select, textarea, button {
            pointer-events: none;
            background: #f2f2f2;
        }
        .btn-secondary {
            pointer-events: auto;
        }
    </style>
</c:if>

</body>
</html>


