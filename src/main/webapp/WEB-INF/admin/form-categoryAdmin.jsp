<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Admin Category Form</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/formUser.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/sidebarAdmin.css">
</head>
<body>

<div class="container">

    <div class="form-header">
        <a href="categoryAdmin" class="btn-back">← Quay lại</a>
        <h2>
            <c:choose>
                <c:when test="${mode == 'add'}">Thêm danh mục</c:when>
                <c:when test="${mode == 'edit'}">Chỉnh sửa danh mục</c:when>
                <c:otherwise>Xem chi tiết danh mục</c:otherwise>
            </c:choose>
        </h2>
    </div>


    <form method="post" action="categoryAdmin">


        <div class="card">
            <h3>Thông tin danh mục</h3>

            <c:if test="${mode != 'add'}">
                <div class="row">
                    <div class="col">
                        <label>ID</label>
                        <input type="text" value="${category.id}" readonly>
                    </div>
                </div>
            </c:if>

            <div class="row">
                <div class="col">
                    <label>Tên danh mục</label>
                    <input type="text" name="name" value="${category.name}" required>
                </div>

                <div class="col">
                    <label>Danh mục cha</label>
                    <select name="parentId">
                        <option value="0">Không có (Danh mục Cha)</option>
                        <c:forEach var="parent" items="${parentCategories}">
                            <option value="${parent.id}" ${category.parentId == parent.id ? 'selected' : ''}>
                                ${parent.name}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="col">
                    <label>Trạng thái</label>
                    <select name="status">
                        <option value="1" ${category.status == 1 ? 'selected' : ''}>
                            Đang dùng
                        </option>
                        <option value="0" ${category.status == 0 ? 'selected' : ''}>
                            Đã khóa
                        </option>
                    </select>
                </div>
            </div>

        </div>


        <div class="form-footer">
            <c:if test="${mode != 'view'}">
                <button type="submit" name="action"
                        value="${mode == 'add' ? 'create' : 'update'}"
                        class="btn-primary">
                    Lưu
                </button>
            </c:if>
            <a href="categoryAdmin" class="btn-secondary">Hủy</a>
        </div>


        <input type="hidden" name="id" value="${category.id}">
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


