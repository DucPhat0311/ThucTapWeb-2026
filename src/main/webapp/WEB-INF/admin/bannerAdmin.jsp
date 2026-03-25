<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Banner</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css"><link rel="stylesheet" href="${pageContext.request.contextPath}/css/include/banner.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/sidebarAdmin.css">
</head>
<body>
<div class="admin">
    <jsp:include page="include/sidebarAdmin.jsp" />

    <section class="content">
        <header class="topbar">
            <h1 id="pageTitle">Quản Lý Banner</h1>
            <div class="actions">
                <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng xuất</a>
            </div>
        </header>

        <main id="page">
            <section id="dashboard" class="page active">
                <div class="cards">
                    <div class="card">Tổng banner<br><span id="dashboard-total-banner">4</span></div>
                    <div class="card">Đang hoạt động<br><span id="dashboard-total-banner-active">2</span></div>
                </div>

                <div class="banner-toolbar">
                    <a href="#" class="btn-add">
                        <i class="fa fa-plus"></i> Thêm banner
                    </a>
                </div>


                <div class="banner-table-wrapper">
                    <table class="banner-table">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Ảnh</th>
                            <th>Liên kết đến</th>
                            <th>Tiêu đề</th>
                            <th>Trạng thái</th>
                            <th>Hành động</th>
                        </tr>
                        </thead>
                        <tbody id="bannerTableBody">
    <tr>
        <td>1</td>
        <td><img src="https://via.placeholder.com/150x60" alt="Summer Sale" class="banner-thumb"></td>
        <td>/category/summer-collection</td>
        <td>Banner Khuyến mãi Mùa Hè - Giảm 50%</td>
        <td>
            <span class="status active">Hoạt động</span>
        </td>
        <td class="actions">
            <a href="banner-admin?mode=view&id=1" class="icon-btn view" title="Xem chi tiết">
                <i class="fa fa-eye"></i>
            </a>
            <a href="banner-admin?mode=edit&id=1" class="icon-btn edit" title="Chỉnh sửa">
                <i class="fa fa-pen"></i>
            </a>
            <button type="button" class="icon-btn delete" title="Xóa banner" onclick="openDeleteModal(1, 'Banner Khuyến mãi Mùa Hè - Giảm 50%')">
                <i class="fa fa-trash"></i>
            </button>
        </td>
    </tr>

    <tr>
        <td>2</td>
        <td><img src="https://via.placeholder.com/150x60" alt="Winter Collection" class="banner-thumb"></td>
        <td>/category/winter-2025</td>
        <td>Bộ sưu tập Thu Đông cũ</td>
        <td>
            <span class="status blocked">Bị khóa</span>
        </td>
        <td class="actions">
            <a href="banner-admin?mode=view&id=2" class="icon-btn view" title="Xem chi tiết">
                <i class="fa fa-eye"></i>
            </a>
            <a href="banner-admin?mode=edit&id=2" class="icon-btn edit" title="Chỉnh sửa">
                <i class="fa fa-pen"></i>
            </a>
            <button type="button" class="icon-btn delete" title="Xóa banner" onclick="openDeleteModal(2, 'Bộ sưu tập Thu Đông cũ')">
                <i class="fa fa-trash"></i>
            </button>
        </td>
    </tr>
</tbody>
</table>
</div>
</section>
</main>
</section>

<div id="deleteModal" class="modal-overlay" style="display: none;">
    <div class="modal">
        <h3>Xác nhận xóa</h3>
        <p id="deleteMessage">Bạn có chắc muốn xóa banner này không?</p>

        <form id="deleteForm" method="post" action="#">
            <input type="hidden" name="action" value="delete">
            <input type="hidden" name="id" id="deleteBannerId">

            <div class="modal-actions">
                <button type="button" class="btn-secondary" onclick="closeDeleteModal()">Hủy</button>
                <button type="submit" class="btn-danger">Xóa</button>
            </div>
        </form>
    </div>
</div>
</div>

<script src="${pageContext.request.contextPath}/js/admin/adminBanner.js"></script>
</body>

</html>

