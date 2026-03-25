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

Bản tĩnh sạch cho danh sách Ảnh sản phẩm, giữ nguyên cấu trúc, class và các icon Font Awesome của bạn:

HTML
<main id="page">
    <section class="page active">

        <div class="cards">
            <div class="card">Tổng Ảnh<span>3</span></div>
        </div>

        <div class="user-toolbar" style="justify-content: flex-end; margin-bottom: 20px;">
            <a href="#" class="btn-add">
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
                <tr>
                    <td>1</td>
                    <td>IMG01</td>
                    <td>
                        <img src="https://via.placeholder.com/100x100" alt="Product Image" class="product-thumbnail">
                    </td>
                    <td>
                        <span class="status active">
                            <i class="fa fa-check-circle"></i> Có
                        </span>
                    </td>
                    <td>
                        <div class="actions">
                            <a href="#" class="icon-btn view" title="Xem">
                                <i class="fa fa-eye"></i>
                            </a>
                            <a href="#" class="icon-btn edit" title="Sửa">
                                <i class="fa fa-pen"></i>
                            </a>
                            <button class="icon-btn delete" title="Xóa">
                                <i class="fa fa-trash"></i>
                            </button>
                        </div>
                    </td>
                </tr>

                <tr>
                    <td>2</td>
                    <td>IMG02</td>
                    <td>
                        <img src="https://via.placeholder.com/100x100" alt="Product Image" class="product-thumbnail">
                    </td>
                    <td>
                        <span class="status inactive">
                            <i class="fa fa-times-circle"></i> Không
                        </span>
                    </td>
                    <td>
                        <div class="actions">
                            <a href="#" class="icon-btn view" title="Xem">
                                <i class="fa fa-eye"></i>
                            </a>
                            <a href="#" class="icon-btn edit" title="Sửa">
                                <i class="fa fa-pen"></i>
                            </a>
                            <button class="icon-btn delete" title="Xóa">
                                <i class="fa fa-trash"></i>
                            </button>
                        </div>
                    </td>
                </tr>
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

<script src="${pageContext.request.contextPath}/javaScript/admin/adminProductImg.js"></script>
<input type="hidden" id="globalProductId" value="#">

</body>
</html>


