<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>Form Tin tức</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/banner-form.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/sidebarAdmin.css">
</head>
<body>

<div class="container">

    <div class="form-header">
        <a href="blogAdmin" class="btn-back">← Quay lại</a>
        <h2>
            <c:if test="${mode == 'add'}">Thêm tin tức</c:if>
            <c:if test="${mode == 'edit'}">Chỉnh sửa tin tức</c:if>
            <c:if test="${mode == 'view'}">Chi tiết tin tức</c:if>
        </h2>
    </div>

    <form action="blogAdmin" method="post" enctype="multipart/form-data">

        <div class="card">
            <h3>Thông tin bài viết </h3>

            <div class="row">
                <div class="col">
                    <label>Tiêu đề</label>
                    <input type="text" name="title" value="${blog.title}" required <c:if test="${mode == 'view'}">readonly</c:if>>
                </div>

                <div class="col">
                    <label>Mô tả ngắn</label>
                    <textarea name="description" <c:if test="${mode == 'view'}">readonly</c:if>>${blog.description}</textarea>
                </div>
            </div>
        </div>

        <div class="card">
            <h3>Nội dung</h3>

            <div class="row">
                <div class="col">
                    <label>Nội dung</label>
                    <textarea name="content" <c:if test="${mode == 'view'}">readonly</c:if>>${blog.content}</textarea>
                </div>
            </div>
        </div>

        <div class="card">
            <h3>Thiết lập hiển thị</h3>

            <div class="row">
                <div class="col">
                    <label>Ảnh đại diện</label>
                    <c:if test="${mode != 'view'}">
                        <input type="file" name="imageFile" accept="image/*">
                    </c:if>

                    <c:if test="${mode == 'edit' || mode == 'view'}">
                        <div class="preview">
                            <img src="${blog.img}" style="max-width:300px;">
                        </div>
                    </c:if>
                </div>

                <div class="col">
                    <label>Trạng thái</label>
                    <select name="status" <c:if test="${mode == 'view'}">disabled</c:if>>
                        <option value="1" ${blog.status == 1 ? "selected" : ""}>Hiển thị</option>
                        <option value="0" ${blog.status == 0 ? "selected" : ""}>Ẩn</option>
                    </select>
                </div>
            </div>
        </div>

        <div class="form-footer">
            <c:if test="${mode != 'view'}">
                <button type="submit" class="btn-primary">Lưu</button>
            </c:if>
            <a href="blogAdmin" class="btn-secondary">Hủy</a>
        </div>

        <input type="hidden" name="id" value="${blog.id}">
        <input type="hidden" name="action" value="${mode == 'add' ? 'create' : 'update'}">
    </form>



</div>

</body>
</html>

