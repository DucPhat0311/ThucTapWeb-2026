<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Form Product Variant</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/formProductVariant.css?v=<%= System.currentTimeMillis() %>">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/sidebarAdmin.css?v=<%= System.currentTimeMillis() %>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
</head>
<body>

<div class="container">

    <div class="form-header">
        <a href="${pageContext.request.contextPath}/productVariantAdmin?productId=${productId}" class="btn-back">
            ← Quay lại
        </a>
        <h2>
            <c:choose>
                <c:when test="${mode == 'add'}">Thêm biến thể</c:when>
                <c:when test="${mode == 'edit'}">Chỉnh sửa biến thể</c:when>
            </c:choose>
        </h2>
    </div>


    <form method="post" action="${pageContext.request.contextPath}/productVariantAdmin">

        <div class="card">
            <h3>Thông tin biến thể</h3>


            <c:if test="${mode == 'edit'}">
                <div class="row">
                    <div class="col">
                        <label>ID</label>
                        <input type="text" value="${variant.id}" readonly>
                    </div>
                </div>
            </c:if>


            <div class="row">
                <div class="col">
                    <label>Size</label>
                    <input type="text" name="sizeName" required placeholder="Nhập kích cỡ..." 
                           value="${mode == 'edit' ? variant.sizeName : ''}"
                           style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
                </div>

                <div class="col">
                    <label>Màu sắc</label>
                    <input type="text" name="colorName" required placeholder="Nhập màu..." 
                           value="${mode == 'edit' ? variant.colorName : ''}"
                           style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
                </div>
            </div>

            <div class="row">
                <div class="col">
                    <label>Giá riêng</label>
                    <input type="number" name="price" value="${mode == 'edit' ? variant.price : '0'}" min="0" style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
                </div>
                <div class="col">
                    <label>Giá sale riêng</label>
                    <input type="number" name="salePrice" value="${mode == 'edit' ? variant.salePrice : '0'}" min="0" style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
                </div>
            </div>
            
            <div class="row">
                <c:choose>
                    <c:when test="${mode == 'edit'}">
                        <div class="col">
                            <label>Tồn kho</label>
                            <input type="number" name="stock" value="${variant.stock}" readonly>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <input type="hidden" name="stock" value="0">
                    </c:otherwise>
                </c:choose>
            </div>

        </div>

        <div class="form-footer">
            <button type="submit"
                    name="action"
                    value="${mode == 'add' ? 'create' : 'update'}"
                    class="btn-primary">
                Lưu
            </button>

            <a href="${pageContext.request.contextPath}/productVariantAdmin?productId=${productId}"
               class="btn-secondary">
                Hủy
            </a>
        </div>

        <input type="hidden" name="productId" value="${productId}">
        <c:if test="${mode == 'edit'}">
            <input type="hidden" name="id" value="${variant.id}">
        </c:if>

    </form>

</div>

</body>
</html>


