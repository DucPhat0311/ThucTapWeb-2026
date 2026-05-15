<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Form Nhập/Xuất Kho</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/formUser.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/sidebarAdmin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
</head>
<body>

<div class="container">
    <div class="form-header">
        <a href="${pageContext.request.contextPath}/warehouseAdmin" class="btn-back">← Quay lại</a>
        <h2>Tạo Phiếu Nhập/Xuất Kho</h2>
    </div>

    <form action="${pageContext.request.contextPath}/admin/warehouse/form" method="post">
        <div class="card">
            <h3>Thông tin phiếu</h3>
            <div class="row">
                <div class="col">
                    <label for="product">Sản phẩm</label>
                    <select id="product" name="productId">
                        <option value="1">Áo Thun Nam</option>
                        <option value="2">Quần Jean Nữ</option>
                    </select>
                </div>
                <div class="col">
                    <label for="type">Loại phiếu</label>
                    <select id="type" name="type">
                        <option value="import">Nhập kho</option>
                        <option value="export">Xuất kho</option>
                    </select>
                </div>
            </div>
            <div class="row">
                <div class="col">
                    <label for="quantity">Số lượng</label>
                    <input type="number" id="quantity" name="quantity" required>
                </div>
                <div class="col">
                    <label for="importPrice">Giá nhập</label>
                    <input type="number" id="importPrice" name="importPrice" step="0.01" required>
                </div>
            </div>
            <div class="row">
                <div class="col">
                    <label for="partner">Nhà cung cấp / Khách hàng</label>
                    <input type="text" id="partner" name="partner">
                </div>
                <div class="col">
                    <label for="date">Ngày</label>
                    <input type="date" id="date" name="date" required>
                </div>
            </div>
        </div>
        <div class="form-footer">
            <button type="button" class="btn-secondary" onclick="window.location.href='${pageContext.request.contextPath}/warehouseAdmin'">Hủy</button>
            <button type="submit" class="btn-primary">Lưu</button>
        </div>
    </form>
</div>
</body>
</html>
