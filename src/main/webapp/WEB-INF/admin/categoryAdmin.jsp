<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Danh Mục</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/sidebarAdmin.css">
</head>
<body>

<div class="admin">

    <jsp:include page="include/sidebarAdmin.jsp" />

    <section class="content">

        <header class="topbar">
            <h1 id="pageTitle">Quản lý danh mục</h1>
            <div class="actions">
                <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng xuất</a>
            </div>
        </header>

        <main id="page">

            <section id="category" class="page active">

                <div class="cards">
                    <div class="card">
                        Tổng danh mục
                        <span>40</span>
                    </div>
                    <div class="card">
                        Đang dùng
                        <span>30</span>
                    </div>
                    <div class="card">
                        Đã khóa
                        <span>10</span>
                    </div>
                </div>

                <div class="user-toolbar">
                    <form method="post"
                          action="${pageContext.request.contextPath}/category-admin"
                          class="user-toolbar">
                        <input type="hidden" name="action" value="#">
                        <input type="text" name="keyword" value="#"
                               placeholder="Tìm theo tên danh mục...">
                        <button type="submit" class="btn-search">
                            <i class="fa fa-search"></i> Tìm
                        </button>
                    </form>

                    <a href="#" class="btn-add">
                        <i class="fa fa-plus"></i> Thêm danh mục
                    </a>
                </div>

                <div style="margin-top: 20px; margin-bottom: 10px;">
                    <h3>Danh mục cha</h3>
                </div>
                <div class="user-table-wrapper">
                    <table class="user-table">
                        <thead>
                        <tr>
                            <th>STT</th>
                            <th>ID</th>
                            <th>Tên danh mục cha</th>
                            <th>Trạng thái</th>
                            <th>Hành động</th>
                        </tr>
                        </thead>
                        <tbody>
            <tr>
                <td>1</td>
                <td>CAT01</td>
                <td>Áo Nam</td>
                <td>
                    <span class="status active">Đang dùng</span>
                </td>
                <td class="action-buttons">
                    <a href="#" class="icon-btn view" title="Xem chi tiết">
                        <i class="fa fa-eye"></i>
                    </a>
                    <a href="#" class="icon-btn edit" title="Chỉnh sửa">
                        <i class="fa fa-pen"></i>
                    </a>
                    <button class="icon-btn delete" title="Khóa danh mục" onclick="toggleCategoryStatus(1, 'Áo Nam', 1)">
                        <i class="fa fa-lock"></i>
                    </button>
                </td>
            </tr>
            <tr>
                <td>2</td>
                <td>CAT02</td>
                <td>Quần Nam</td>
                <td>
                    <span class="status active">Đang dùng</span>
                </td>
                <td class="action-buttons">
                    <a href="#" class="icon-btn view" title="Xem chi tiết">
                        <i class="fa fa-eye"></i>
                    </a>
                    <a href="#" class="icon-btn edit" title="Chỉnh sửa">
                        <i class="fa fa-pen"></i>
                    </a>
                    <button class="icon-btn delete" title="Khóa danh mục" onclick="toggleCategoryStatus(2, 'Quần Nam', 1)">
                        <i class="fa fa-lock"></i>
                    </button>
                </td>
            </tr>
        </tbody>
    </table>
</div>

<div style="margin-top: 30px; margin-bottom: 10px;">
    <h3>Danh mục con</h3>
</div>
<div class="user-table-wrapper">
    <table class="user-table">
        <thead>
            <tr>
                <th>STT</th>
                <th>ID</th>
                <th>Tên danh mục con</th>
                <th>Thuộc danh mục cha</th>
                <th>Trạng thái</th>
                <th>Hành động</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>1</td>
                <td>SUB01</td>
                <td>Áo thun</td>
                <td>Áo Nam</td>
                <td>
                    <span class="status active">Đang dùng</span>
                </td>
                <td class="action-buttons">
                    <a href="#" class="icon-btn view" title="Xem chi tiết">
                        <i class="fa fa-eye"></i>
                    </a>
                    <a href="#" class="icon-btn edit" title="Chỉnh sửa">
                        <i class="fa fa-pen"></i>
                    </a>
                    <button class="icon-btn delete" title="Khóa danh mục" onclick="toggleCategoryStatus(101, 'Áo thun', 1)">
                        <i class="fa fa-lock"></i>
                    </button>
                </td>
            </tr>
            <tr>
                <td>2</td>
                <td>SUB02</td>
                <td>Áo sơ mi</td>
                <td>Áo Nam</td>
                <td>
                    <span class="status active">Đang dùng</span>
                </td>
                <td class="action-buttons">
                    <a href="#" class="icon-btn view" title="Xem chi tiết">
                        <i class="fa fa-eye"></i>
                    </a>
                    <a href="#" class="icon-btn edit" title="Chỉnh sửa">
                        <i class="fa fa-pen"></i>
                    </a>
                    <button class="icon-btn delete" title="Khóa danh mục" onclick="toggleCategoryStatus(102, 'Áo sơ mi', 1)">
                        <i class="fa fa-lock"></i>
                    </button>
                </td>
            </tr>
            <tr>
                <td>3</td>
                <td>SUB03</td>
                <td>Quần Short mẫu cũ</td>
                <td>Quần Nam</td>
                <td>
                    <span class="status inactive">Đã khóa</span>
                </td>
                <td class="action-buttons">
                    <a href="#" class="icon-btn view" title="Xem chi tiết">
                        <i class="fa fa-eye"></i>
                    </a>
                    <a href="#" class="icon-btn edit" title="Chỉnh sửa">
                        <i class="fa fa-pen"></i>
                    </a>
                    <button class="icon-btn view" title="Mở khóa" onclick="toggleCategoryStatus(103, 'Quần Short mẫu cũ', 0)">
                        <i class="fa fa-unlock"></i>
                    </button>
                </td>
            </tr>
        </tbody>
    </table>
</div>

            </section>

        </main>
    </section>
</div>

<div class="modal-overlay" id="toggle-status-modal">
    <div class="modal-content modal-small">
        <div class="modal-header">
            <h2 id="toggle-status-title">Xác nhận</h2>
        </div>
        <div class="modal-body">
            <p id="toggle-status-message"></p>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn-cancel" onclick="closeToggleStatusModal()">Hủy</button>
            <button type="button" class="btn-delete" onclick="confirmToggleStatus()">Xác nhận</button>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/admin/adminCategory.js"></script>

</body>
</html>