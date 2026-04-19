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
        <a href="productVariantAdmin?productId=${productId}" class="btn-back">
            ← Quay lại
        </a>
        <h2>
            <c:choose>
                <c:when test="${mode == 'add'}">Thêm biến thể</c:when>
                <c:when test="${mode == 'edit'}">Chỉnh sửa biến thể</c:when>
            </c:choose>
        </h2>
    </div>


    <form method="post" action="productVariantAdmin">

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
                    <c:choose>
                        <c:when test="${mode == 'edit'}">
                            <input type="text" value="${variant.sizeName}" readonly disabled style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; background: #eee;">
                        </c:when>
                        <c:otherwise>
                            <input type="text" name="sizeName" required placeholder="Tự ghi ra size..." style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="col">
                    <label>Màu sắc</label>
                    <c:choose>
                        <c:when test="${mode == 'edit'}">
                            <input type="text" value="${variant.colorName}" readonly disabled style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; background: #eee;">
                        </c:when>
                        <c:otherwise>
                            <input type="text" name="colorName" required placeholder="Tự ghi ra màu..." style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="row">
                <div class="col">
                    <label>Tồn kho</label>
                    <input type="number" name="stock" min="0" required
                           value="${mode == 'edit' ? variant.stock : 0}">
                </div>
            </div>

        </div>

        <div class="form-footer">
            <button type="submit"
                    name="action"
                    value="${mode == 'add' ? 'create' : 'update'}"
                    class="btn-primary">
                Lưu
            </button>

            <a href="productVariantAdmin?productId=${productId}"
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


