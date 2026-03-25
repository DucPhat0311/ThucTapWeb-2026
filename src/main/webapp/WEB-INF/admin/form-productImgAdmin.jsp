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
    
    <title>Thêm Ảnh</title>
</head>
<body>
<div class="container">
    <div class="form-header">
        <a href="img-productAdmin" class="btn-back">
            <i class="fa fa-arrow-left"></i> Quay lại
        </a>
        <h2>Thêm Ảnh Mới</h2>
    </div>

    <div class="card">
        <form action="#" method="post" enctype="multipart/form-data">
            <input type="hidden" name="productId" value="101">
            <input type="hidden" name="action" value="create">

            <div class="col">
                <label>
                    Hình Ảnh <span style="color: red;">*</span>
                </label>

                <div class="file-input-wrapper">
                    <input type="file"
                           id="imageFile"
                           name="imageFile"
                           accept="image/*"
                           required>
                    <label for="imageFile" class="file-input-label" style="cursor: pointer; display: inline-block; padding: 8px 15px; background: #eee; border-radius: 4px; border: 1px solid #ccc;">
                        <i class="fa fa-upload"></i> Chọn Ảnh
                    </label>
                    <span class="file-name" id="fileName" style="margin-left: 10px; color: #666;">
                        Chưa chọn file
                    </span>
                </div>

                <div class="image-preview" id="newImagePreview" style="display: none; margin-top: 15px;">
                    <img src="" alt="Preview" id="previewImg" style="max-width: 300px; border-radius: 8px; border: 1px solid #ddd;">
                </div>
            </div>

            <div class="col" style="margin-top: 15px;">
                <label for="isMain">Đặt làm ảnh chính</label>
                <div class="checkbox-wrapper" style="display: flex; align-items: center; gap: 10px; margin-top: 5px;">
                    <input type="checkbox" id="isMain" name="isMain" value="true">
                    <small class="form-text" style="color: #888;">Ảnh chính sẽ được hiển thị đầu tiên</small>
                </div>
            </div>

            <div class="form-footer" style="margin-top: 25px; display: flex; gap: 10px;">
                <a href="img-productAdmin" class="btn-secondary" style="padding: 10px 20px; text-decoration: none; background: #f4f4f4; color: #333; border-radius: 4px;">
                    <i class="fa fa-times"></i> Hủy
                </a>
                <button type="submit" class="btn-primary" style="padding: 10px 20px; cursor: pointer; background: #8d5e33; color: white; border: none; border-radius: 4px;">
                    <i class="fa fa-save"></i> Thêm Ảnh
                </button>
            </div>
        </form>
    </div>
</div>

<input type="hidden" id="formMode" value="add">

</body>
</html>


