<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Product Form</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/formUser.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/sidebarAdmin.css">
</head>
<body>

<div class="container">

<div class="form-header">
    <a href="productAdmin" class="btn-back">← Quay lại</a>
    <h2>Chỉnh sửa sản phẩm</h2>
</div>

<form method="post" action="productAdmin" enctype="multipart/form-data">

    <div class="card">
        <h3>Thông tin sản phẩm</h3>

        <div class="row">
            <div class="col">
                <label>ID</label>
                <input type="text" name="id" value="SP-2026-001" readonly>
            </div>
        </div>

        <div class="row">
            <div class="col">
                <label>Tên sản phẩm</label>
                <input type="text" name="name" value="Áo Khoác Bomber Varsity Aura Limited" required>
            </div>
        </div>

        <div class="row">
            <div class="col">
                <label>Giá gốc</label>
                <input type="number" name="price" value="850000" required>
            </div>

            <div class="col">
                <label>Giá sale (nếu có)</label>
                <input type="number" name="sale_price" value="690000" min="0">
            </div>
        </div>

        <div class="row">
            <div class="col">
                <label>Danh mục</label>
                <select name="category_id" required>
                    <option value="">-- Chọn danh mục --</option>
                    <option value="1" selected>Áo khoác nam</option>
                    <option value="2">Quần Jean</option>
                    <option value="3">Phụ kiện</option>
                </select>
            </div>

            <div class="col">
                <label>Trạng thái</label>
                <select name="status" required>
                    <option value="Đang bán" selected>Đang bán</option>
                    <option value="Hết hàng">Hết hàng</option>
                </select>
            </div>
        </div>

        <div class="row">
            <div class="col">
                <label>Mô tả sản phẩm</label>
                <textarea name="description" rows="5">Chất liệu dạ phối tay da cao cấp, lót chần bông giữ ấm cực tốt cho mùa đông 2026. Họa tiết thêu tỉ mỉ.</textarea>
            </div>
        </div>

        <div class="row">
            <div class="col">
                <label>Hình ảnh sản phẩm</label>
                <input type="file" name="imageFile" accept="image/*">
                <small style="color: #666; display: block; margin-top: 5px;">
                    Chọn ảnh sản phẩm
                </small>
            </div>
        </div>

        <div class="row">
            <div class="col">
                <div id="product-image-preview-container" style="margin-top: 10px;">
                    <label>Xem trước ảnh</label>
                    <img id="product-image-preview" src="https://via.placeholder.com/300" 
                         alt="Product image"
                         style="max-width: 300px; max-height: 300px; border-radius: 8px; border: 1px solid #ddd; display: block; margin-top: 10px;">
                </div>
            </div>
        </div>

        </div>

    <div class="form-footer">
        <button type="submit" name="action" value="update" class="btn-primary">
            Lưu
        </button>
        <a href="productAdmin" class="btn-secondary">Hủy</a>
    </div>

    <input type="hidden" name="id" value="SP-2026-001">
    <input type="hidden" name="mode" value="edit">

</form>
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

<script src="${pageContext.request.contextPath}/js/admin/adminProductForm.js"></script>
</body>
</html>

