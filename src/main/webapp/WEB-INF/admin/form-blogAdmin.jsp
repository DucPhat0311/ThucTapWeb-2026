<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>Form Blog</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/formBanner.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/sidebarAdmin.css">
</head>
Đây là bản tĩnh sạch cho trang Chi tiết/Chỉnh sửa bài viết (Blog), giữ nguyên 100% các class và cấu trúc thẻ của bạn, chỉ thay nội dung mẫu về chủ đề thời trang.

HTML
<body>

<div class="container">

    <div class="form-header">
        <a href="blogAdmin" class="btn-back">← Quay lại</a>
        <h2>Chỉnh sửa bài viết</h2>
    </div>

    <form action="#" method="post" enctype="multipart/form-data">

        <div class="card">
            <h3>Thông tin bài viết </h3>

            <div class="row">
                <div class="col">
                    <label>Tiêu đề</label>
                    <input type="text" name="title" value="Xu hướng phối đồ Streetwear 2026" required>
                </div>

                <div class="col">
                    <label>Mô tả ngắn</label>
                    <textarea name="description">Khám phá những phong cách phối đồ đường phố đang dẫn đầu xu hướng năm nay tại Aura Studio.</textarea>
                </div>
            </div>
        </div>

        <div class="card">
            <h3>Nội dung</h3>

            <div class="row">
                <div class="col">
                    <label>Nội dung</label>
                    <textarea name="content" rows="10">Nội dung chi tiết về các bộ phối đồ, chất liệu vải và cách kết hợp phụ kiện cho phong cách Streetwear...</textarea>
                </div>
            </div>
        </div>

        <div class="card">
            <h3>Thiết lập hiển thị</h3>

            <div class="row">
                <div class="col">
                    <label>Ảnh đại diện</label>
                    <input type="file" name="imageFile" accept="image/*">

                    <div class="preview">
                        <img src="https://via.placeholder.com/300x200" style="max-width:300px;">
                    </div>
                </div>

                <div class="col">
                    <label>Trạng thái</label>
                    <select name="status">
                        <option value="1" selected>Hiển thị</option>
                        <option value="0">Ẩn</option>
                    </select>
                </div>
            </div>
        </div>

        <div class="form-footer">
            <button type="submit" class="btn-primary">Lưu</button>
            <a href="blogAdmin" class="btn-secondary">Hủy</a>
        </div>

        <input type="hidden" name="id" value="101">
        <input type="hidden" name="action" value="update">
    </form>

</div>

</body>
</html>

