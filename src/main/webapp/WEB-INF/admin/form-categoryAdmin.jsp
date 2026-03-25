<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Form Danh mục</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/formUser.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/sidebarAdmin.css">
</head>
<body>

<div class="container">

<div class="form-header">
    <a href="categoryAdmin" class="btn-back">← Quay lại</a>
    <h2>Chỉnh sửa danh mục</h2>
</div>

<form method="post" action="categoryAdmin">

    <div class="card">
        <h3>Thông tin danh mục</h3>

        <div class="row">
            <div class="col">
                <label>ID</label>
                <input type="text" value="10" readonly>
            </div>
        </div>

        <div class="row">
            <div class="col">
                <label>Tên danh mục</label>
                <input type="text" name="name" value="Áo thun nam" required>
            </div>

            <div class="col">
                <label>Danh mục cha</label>
                <select name="parentId">
                    <option value="0">Không có (Danh mục Cha)</option>
                    <option value="1" selected>Áo Nam</option>
                    <option value="2">Quần Nam</option>
                    <option value="3">Phụ kiện</option>
                </select>
            </div>

            <div class="col">
                <label>Trạng thái</label>
                <select name="status">
                    <option value="1" selected>Đang dùng</option>
                    <option value="0">Đã khóa</option>
                </select>
            </div>
        </div>
    </div>

    <div class="form-footer">
        <button type="submit" name="action" value="update" class="btn-primary">
            Lưu
        </button>
        <a href="categoryAdmin" class="btn-secondary">Hủy</a>
    </div>

    <input type="hidden" name="id" value="10">
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

</body>
</html>

