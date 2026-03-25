<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Form Product Variant</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/formProductVariant.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/sidebarAdmin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
</head>
<body>

<div class="container">

<div class="form-header">
    <a href="variant-productAdmin" class="btn-back">
        ← Quay lại
    </a>
    <h2>Chỉnh sửa biến thể</h2>
</div>

<form method="post" action="variant-productAdmin">

    <div class="card">
        <h3>Thông tin biến thể</h3>

        <div class="row">
            <div class="col">
                <label>ID</label>
                <input type="text" value="501" readonly>
            </div>
        </div>

        <div class="row">
            <div class="col">
                <label>Size</label>
                <input type="text" value="Size L" readonly disabled style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; background: #eee;">
            </div>

            <div class="col">
                <label>Màu sắc</label>
                <input type="text" value="Màu Đen" readonly disabled style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; background: #eee;">
            </div>
        </div>

        <div class="row">
            <div class="col">
                <label>Giá</label>
                <input type="number" name="price" step="0.01" min="0" required value="250000">
            </div>

            <div class="col">
                <label>Giá sale</label>
                <input type="number" name="salePrice" step="0.01" min="0" required value="199000">
            </div>
        </div>

        <div class="row">
            <div class="col">
                <label>Tồn kho</label>
                <input type="number" name="stock" min="0" required value="45">
            </div>
        </div>

    </div>

    <div class="form-footer">
        <button type="submit" name="action" value="update" class="btn-primary">
            Lưu
        </button>

        <a href="variant-productAdmin" class="btn-secondary">
            Hủy
        </a>
    </div>

    <input type="hidden" name="productId" value="101">
    <input type="hidden" name="id" value="501">

</form>
</div>

</body>
</html>


