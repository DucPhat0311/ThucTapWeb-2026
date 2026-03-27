<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Form Banner</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/formBanner.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/sidebarAdmin.css">
</head>
<body>
<div class="container">

    <div class="form-header">
    <a href="bannerAdmin" class="btn-back">← Quay lại</a>
    <h2>Chỉnh sửa banner</h2>
</div>

<form method="post" action="bannerAdmin" enctype="multipart/form-data">

    <div class="card">
        <h3>Thông tin banner</h3>

        <div class="row">
            <div class="col">
                <label>Tiêu đề</label>
                <input type="text"
                       name="title"
                       value="Bộ sưu tập Xuân Hè 2026">
            </div>

            <div class="col">
                <label>Liên kết đến</label>
                <input type="text"
                       name="navigateTo"
                       value="collections/summer-2026"
                       placeholder="san-pham">
            </div>
        </div>

        <div class="row">
            <div class="col">
                <label>Trạng thái</label>
                <select name="status">
                    <option value="1" selected>Hoạt động</option>
                    <option value="0">Không hoạt động</option>
                </select>
            </div>
        </div>

        <div class="row">
            <div class="col">
                <label>Ảnh banner</label>
                <input type="file"
                       name="imageFile"
                       accept="image/*">

                <div class="preview">
                    <img id="previewImg"
                         src="https://via.placeholder.com/600x200"
                         alt="Preview"
                         style="display:block; max-width:300px;">
                </div>
            </div>
        </div>
    </div>

    <div class="form-footer">
        <button type="submit"
                name="action"
                value="update"
                class="btn-primary">
            Lưu
        </button>
        <a href="bannerAdmin" class="btn-secondary">Hủy</a>
    </div>

    <input type="hidden" name="id" value="1">
    <input type="hidden" name="mode" value="edit">
</form>


</div>
</body>
</html>

