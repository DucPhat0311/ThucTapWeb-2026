<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/formProductVariant.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/sidebarAdmin.css">
    
    <title>
        <c:choose>
            <c:when test="${mode == 'add'}">Thêm Ảnh</c:when>
            <c:when test="${mode == 'edit'}">Sửa Ảnh</c:when>
            <c:otherwise>Xem Ảnh</c:otherwise>
        </c:choose>
    </title>
    
</head>
<body>
<div class="container">
    <div class="form-header">
        <a href="img-productAdmin" class="btn-back">
            <i class="fa fa-arrow-left"></i> Quay lại
        </a>

        <h2>
            <c:choose>
                <c:when test="${mode == 'add'}">Thêm Ảnh Mới</c:when>
                <c:when test="${mode == 'edit'}">Sửa Ảnh</c:when>
                <c:otherwise>Chi Tiết Ảnh</c:otherwise>
            </c:choose>
        </h2>
    </div>


    <div class="card">
        <form action="productImgAdmin" method="post" enctype="multipart/form-data">
            <input type="hidden" name="productId" value="${productId}">
            <c:if test="${mode == 'edit'}">
                <input type="hidden" name="id" value="${image.id}">
            </c:if>
            <input type="hidden" name="action" value="${mode == 'add' ? 'create' : 'update'}">


            <div class="col">
                <label>
                    Hình Ảnh
                    <c:if test="${mode == 'add'}"><span style="color: red;">*</span></c:if>
                </label>


                <c:if test="${mode != 'add' && image.imageUrl != null}">
                    <div class="image-preview">
                        <img src="${image.imageUrl}" alt="Current Image" id="currentImage">
                    </div>
                </c:if>


                <c:if test="${mode != 'view'}">
                    <div class="file-input-wrapper">
                        <input type="file"
                               id="imageFile"
                               name="imageFile"
                               accept="image/*"
                               onchange="previewImage(event)"
                                ${mode == 'add' ? 'required' : ''}>
                        <label for="imageFile" class="file-input-label">
                            <i class="fa fa-upload"></i> Chọn Ảnh
                        </label>
                        <span class="file-name" id="fileName">
                            ${mode == 'add' ? 'Chưa chọn file' : 'Chọn để thay đổi'}
                        </span>
                    </div>


                    <div class="image-preview" id="newImagePreview" style="display: none; margin-top: 15px;">
                        <img src="" alt="Preview" id="previewImg">
                    </div>
                </c:if>
            </div>


            <div class="col" style="margin-top: 15px;">
                <label>Đặt làm ảnh chính</label>
                <div class="checkbox-wrapper">
                    <input type="checkbox"
                           id="isMain"
                           name="isMain"
                           value="true"
                           ${mode == 'edit' && image.main ? 'checked' : ''}
                           ${mode == 'view' ? 'disabled' : ''}>
                    <small class="form-text">Ảnh chính sẽ được hiển thị đầu tiên</small>
                </div>
            </div>


            <c:if test="${mode != 'view'}">
                <div class="form-footer" style="margin-top: 25px;">
                    <a href="productImgAdmin?productId=${productId}" class="btn-secondary">
                        <i class="fa fa-times"></i> Hủy
                    </a>
                    <button type="submit" class="btn-primary">
                        <i class="fa fa-save"></i>
                        ${mode == 'add' ? 'Thêm Ảnh' : 'Cập Nhật'}
                    </button>
                </div>
            </c:if>
            <c:if test="${mode == 'view'}">
                <div class="form-footer" style="margin-top: 25px;">
                    <a href="productImgAdmin?productId=${productId}" class="btn-secondary">
                        <i class="fa fa-arrow-left"></i> Quay lại
                    </a>
                </div>
            </c:if>
        </form>
    </div>
</div>



<script src="${pageContext.request.contextPath}/js/admin/adminProductImg.js"></script>
<input type="hidden" id="formMode" value="${mode}">
</body>
</html>


