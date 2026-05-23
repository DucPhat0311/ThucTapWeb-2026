<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Ảnh Sản Phẩm</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/sidebarAdmin.css">
</head>
<body>
<div class="admin">

    <jsp:include page="include/sidebarAdmin.jsp" />

 
    <section class="content">
        <div class="page-header">
            <div style="display: flex; align-items: center; gap: 15px;">
                <a href="productAdmin" class="back-to-product-btn" title="Quay về quản lý sản phẩm">
                    <i class="fa fa-arrow-left"></i>
                </a>
                <h1>Quản Lý Ảnh Sản Phẩm</h1>
            </div>
            <div class="actions">
                <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng xuất</a>
            </div>
        </div>

<main id="page">
    <section class="page active">

            <div class="cards">
                <div class="card">Tổng Ảnh<span>${totalImages}</span></div>
            </div>


            <div class="user-toolbar" style="justify-content: flex-end; margin-bottom: 20px;">
                <a href="productImgAdmin?productId=${productId}&mode=add" class="btn-add">
                    <i class="fa fa-plus"></i> Thêm Ảnh
                </a>
            </div>

       
            <div class="user-table-wrapper">
                <table class="user-table">
                    <thead>
                    <tr>
                        <th width="5%">STT</th>
                        <th width="8%">ID</th>
                        <th width="40%">Hình Ảnh</th>
                        <th width="12%">Ảnh Chính</th>
                        <th width="20%">Hành Động</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${empty images}">
                            <tr>
                                <td colspan="5" class="text-center">Chưa có ảnh nào</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="img" items="${images}" varStatus="status">
                                <tr>
                                    <td>${status.index + 1}</td>
                                    <td>${img.id}</td>
                                    <td>
                                        <img src="${pageContext.request.contextPath}/${img.imageUrl}"
                                            alt="Product Image"
                                            class="product-thumbnail">
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${img.main}">
                                                <span class="status active">
                                                    <i class="fa fa-check-circle"></i> Có
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status inactive">
                                                    <i class="fa fa-times-circle"></i> Không
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="actions">
                                            <a href="productImgAdmin?productId=${productId}&mode=view&id=${img.id}"
                                               class="icon-btn view"
                                               title="Xem">
                                                <i class="fa fa-eye"></i>
                                            </a>
                                            <a href="productImgAdmin?productId=${productId}&mode=edit&id=${img.id}"
                                               class="icon-btn edit"
                                               title="Sửa">
                                                <i class="fa fa-pen"></i>
                                            </a>
                                            <button onclick="deleteImage(${img.id})"
                                                    class="icon-btn delete"
                                                    title="Xóa">
                                                <i class="fa fa-trash"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
            </section>
        </main>
    </section>
</div>


<div id="delete-modal" class="modal-overlay">
    <div class="modal-content modal-small">
        <div class="modal-header">
            <h3>Xác Nhận Xóa</h3>
            <button class="modal-close" onclick="closeDeleteModal()">&times;</button>
        </div>
        <div class="modal-body">
            <p id="delete-message">Bạn có chắc chắn muốn xóa ảnh này?</p>
        </div>
        <div class="modal-footer">
            <button class="btn-cancel" onclick="closeDeleteModal()">Hủy</button>
            <button class="btn-delete" onclick="confirmDelete()">Xóa</button>
        </div>
    </div>
</div>


<script src="${pageContext.request.contextPath}/js/admin/adminProductImg.js"></script>
<input type="hidden" id="globalProductId" value="${productId}">
</body>
</html>


