<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="aura" uri="/WEB-INF/tlds/aura.tld" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Form Product Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/formUser.css?v=<%= System.currentTimeMillis() %>">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/sidebarAdmin.css?v=<%= System.currentTimeMillis() %>">
</head>
<body>

<div class="container">


    <div class="form-header">
        <a href="${pageContext.request.contextPath}/productAdmin" class="btn-back">← Quay lại</a>
        <h2>
            <c:choose>
                <c:when test="${mode == 'add'}">Thêm sản phẩm</c:when>
                <c:when test="${mode == 'edit'}">Chỉnh sửa sản phẩm</c:when>
                <c:otherwise>Xem chi tiết sản phẩm</c:otherwise>
            </c:choose>
        </h2>
    </div>


    <form method="post" action="${pageContext.request.contextPath}/productAdmin" enctype="multipart/form-data">


        <div class="card">
            <h3>Thông tin sản phẩm</h3>

            <c:if test="${mode != 'add'}">
                <div class="row">
                    <div class="col">
                        <label>ID</label>
                        <input type="text" name="id" value="${product.id}">
                    </div>
                </div>
            </c:if>

            <div class="row">
                <div class="col">
                    <label>Tên sản phẩm</label>
                    <input type="text" name="name" value="${product.name}" required>
                </div>
            </div>

            <div class="row">
                <div class="col">
                    <label>Giá gốc</label>
                    <input type="number" name="price" value="${product.price}" required>
                </div>

                <div class="col">
                    <label>Giá sale (nếu có)</label>
                    <input type="number" name="sale_price" value="${product.sale_price}" min="0">
                </div>
            </div>

            <div class="row">
                <div class="col">
                    <label>Danh mục</label>
                    <select name="category_id" required>
                        <option value="">-- Chọn danh mục --</option>
                        <c:forEach var="c" items="${categories}">
                            <option value="${c.id}" 
                                    ${product.category_id == c.id ? 'selected' : ''}>
                                ${c.name}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="col">
                    <label>Trạng thái</label>
                    <select name="status" required>
                        <option value="Đang hoạt động" ${product.status == 'Đang hoạt động' ? 'selected' : ''}>
                            Đang hoạt động
                        </option>
                        <option value="Đã ẩn" ${product.status == 'Đã ẩn' ? 'selected' : ''}>
                            Đã ẩn
                        </option>
                    </select>
                </div>
            </div>

            <div class="row">
                <div class="col">
                    <label>Mô tả sản phẩm</label>
                    <textarea name="description" rows="5">${product.description}</textarea>
                </div>
            </div>

            <div class="row">
                <div class="col">
                    <label>Hình ảnh sản phẩm</label>
                    <input type="file" name="imageFiles" accept="image/*" multiple
                           onchange="previewProductImages(event)"
                           ${mode == 'view' ? 'disabled' : ''}>
                    <small style="color: #666; display: block; margin-top: 5px;">
                        Chọn ảnh sản phẩm (có thể chọn nhiều ảnh cùng lúc)
                    </small>
                </div>
            </div>


            <div class="row">
                <div class="col">
                    <label>Xem trước ảnh</label>
                    <div id="product-image-preview-container" style="margin-top: 10px; display: flex; flex-wrap: wrap; gap: 15px;">
                        <c:if test="${not empty product.thumbnail && mode != 'add'}">
                            <div style="position: relative; display: inline-block; border: 1px solid #ddd; padding: 5px; border-radius: 8px;">
                                <img id="product-image-preview" src="${aura:resolve(pageContext.request.contextPath, '/img/products', product.thumbnail, 'img/logo.png')}" 
                                     alt="Product image"
                                     style="width: 120px; height: 120px; object-fit: cover; border-radius: 4px; display: block;">
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>

            <c:if test="${mode == 'add'}">
                <style>
                    .variant-row { flex-wrap: wrap !important; gap: 15px !important; }
                    .variant-row .col { min-width: 180px; flex: 1; }
                </style>
                <div style="margin-top: 32px; border-top: 1px dashed #ccc; padding-top: 24px;">
                    <h3>Thêm biến thể</h3>
                    <div id="variant-list">
                        <div class="row variant-row" style="align-items: flex-end; margin-bottom: 15px;">
                            <div class="col">
                                <label>Size</label>
                                <input type="text" name="variant_size[]" placeholder="Nhập kích cỡ..." required>
                            </div>
                            <div class="col">
                                <label>Màu sắc</label>
                                <input type="text" name="variant_color[]" placeholder="Nhập màu..." required>
                            </div>
                            <div class="col">
                                <label>Giá riêng</label>
                                <input type="number" name="variant_price[]" placeholder="Giá..." value="0" min="0">
                            </div>
                            <div class="col">
                                <label>Giá sale riêng</label>
                                <input type="number" name="variant_sale_price[]" placeholder="Sale..." value="0" min="0">
                            </div>
                            <input type="hidden" name="variant_stock[]" value="0">
                            <div class="col" style="flex: 0 0 auto; min-width: 60px;">
                                <button type="button" style="padding: 12px; background: #dc3545; color: white; border: none; cursor: pointer; border-radius: 8px; font-weight: 600; height: 46px; display: inline-flex; align-items: center; justify-content: center;" onclick="removeVariantRow(this)">Xóa</button>
                            </div>
                        </div>
                    </div>
                    <button type="button" style="margin-top: 10px; padding: 10px 20px; background: #28a745; color: white; border: none; cursor: pointer; border-radius: 8px; font-size: 14px; font-weight: 600; display: inline-flex; align-items: center; gap: 6px;" onclick="addVariantRow()">
                        <i class="fa fa-plus"></i> Thêm dòng biến thể
                    </button>
                </div>

                <script>
                    function addVariantRow() {
                        const container = document.getElementById('variant-list');
                        const row = document.createElement('div');
                        row.className = 'row variant-row';
                        row.style.alignItems = 'flex-end';
                        row.style.marginBottom = '15px';
                        
                        row.innerHTML = `
                            <div class="col">
                                <label>Size</label>
                                <input type="text" name="variant_size[]" placeholder="Nhập kích cỡ..." required style="width: 100%; padding: 12px 16px; border-radius: 8px; border: 1.5px solid #dcd3cb; background-color: #fcfbf9; font-size: 15px;">
                            </div>
                            <div class="col">
                                <label>Màu sắc</label>
                                <input type="text" name="variant_color[]" placeholder="Nhập màu..." required style="width: 100%; padding: 12px 16px; border-radius: 8px; border: 1.5px solid #dcd3cb; background-color: #fcfbf9; font-size: 15px;">
                            </div>
                            <div class="col">
                                <label>Giá riêng</label>
                                <input type="number" name="variant_price[]" placeholder="Giá..." value="0" min="0" style="width: 100%; padding: 12px 16px; border-radius: 8px; border: 1.5px solid #dcd3cb; background-color: #fcfbf9; font-size: 15px;">
                            </div>
                            <div class="col">
                                <label>Giá sale riêng</label>
                                <input type="number" name="variant_sale_price[]" placeholder="Sale..." value="0" min="0" style="width: 100%; padding: 12px 16px; border-radius: 8px; border: 1.5px solid #dcd3cb; background-color: #fcfbf9; font-size: 15px;">
                            </div>
                            <input type="hidden" name="variant_stock[]" value="0">
                            <div class="col" style="flex: 0 0 auto; min-width: 60px;">
                                <button type="button" style="padding: 12px; background: #dc3545; color: white; border: none; cursor: pointer; border-radius: 8px; font-weight: 600; height: 46px; display: inline-flex; align-items: center; justify-content: center;" onclick="removeVariantRow(this)">Xóa</button>
                            </div>
                        `;
                        container.appendChild(row);
                    }
                    
                    function removeVariantRow(btn) {
                        const rows = document.querySelectorAll('.variant-row');
                        if (rows.length > 1) {
                            btn.closest('.variant-row').remove();
                        } else {
                            alert('Sản phẩm phải có ít nhất 1 biến thể!');
                        }
                    }
                </script>
            </c:if>
        </div>


        <div class="form-footer">
            <c:if test="${mode != 'view'}">
                <button type="submit" name="action"
                        value="${mode == 'add' ? 'add' : 'update'}"
                        class="btn-primary">
                    Lưu
                </button>
            </c:if>
            <a href="${pageContext.request.contextPath}/productAdmin" class="btn-secondary">Hủy</a>
        </div>


        <input type="hidden" name="id" value="${product.id}">
        <input type="hidden" name="mode" value="${mode}">

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

<script src="${pageContext.request.contextPath}/js/admin/adminProductForm.js?v=<%= System.currentTimeMillis() %>"></script>
</body>
</html>

