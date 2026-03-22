<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Tin tức</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css"><link rel="stylesheet" href="${pageContext.request.contextPath}/css/views/blog.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/sidebarAdmin.css">
</head>
<body>
<div class="admin">

    <jsp:include page="include/sidebarAdmin.jsp" />

    <section class="content">

        <header class="topbar">
            <h1 id="pageTitle">Bài viết</h1>
            <div class="actions">
                <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng xuất</a>
            </div>
        </header>

        <main id="page">

            <section id="dashboard" class="page active">
                <div class="cards">
                    <div class="card">Tổng bài viết<br><span>200</span></div>
                    <div class="card">Đang hiển thị<br><span>100</span></div>
                </div>

                <div class="toolbar">
                    <a href="#" class="btn-add">
                        <i class="fa fa-plus"></i> Thêm bài viết
                    </a>
                </div>

                <div class="table-container">
                    <table class="table">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Ảnh</th>
                            <th>Tiêu đề</th>
                            <th>Ngày tạo</th>
                            <th>Trạng thái</th>
                            <th>Hành động</th>
                        </tr>
                        </thead>
                        <tbody>
    <tr>
        <td>1</td>
        <td>
            <img src="#" alt="Trend 2026" style="object-fit: cover; border-radius: 4px;">
        </td>
        <td>Xu hướng màu sắc tối giản cho mùa Xuân 2026</td>
        <td>22/03/2026</td>
        <td>
            <span class="status active">Hiển thị</span>
        </td>
        <td class="actions">
            <a href="#" class="icon-btn view" title="Xem chi tiết">
                <i class="fa fa-eye"></i>
            </a>
            <a href="#" class="icon-btn edit" title="Chỉnh sửa">
                <i class="fa fa-pen"></i>
            </a>
            <button type="button" class="icon-btn delete" title="Xóa tin tức" onclick="openDeleteModal(1, 'Xu hướng màu sắc tối giản cho mùa Xuân 2026')">
                <i class="fa fa-trash"></i>
            </button>
        </td>
    </tr>

    <tr>
        <td>2</td>
        <td>
            <img src="#" alt="Mix & Match" style="object-fit: cover; border-radius: 4px;">
        </td>
        <td>5 cách phối đồ với áo thun Oversize cực chất</td>
        <td>20/03/2026</td>
        <td>
            <span class="status blocked">Ẩn</span>
        </td>
        <td class="actions">
            <a href="#" class="icon-btn view" title="Xem chi tiết">
                <i class="fa fa-eye"></i>
            </a>
            <a href="#" class="icon-btn edit" title="Chỉnh sửa">
                <i class="fa fa-pen"></i>
            </a>
            <button type="button" class="icon-btn delete" title="Xóa tin tức" onclick="openDeleteModal(2, '5 cách phối đồ với áo thun Oversize cực chất')">
                <i class="fa fa-trash"></i>
            </button>
        </td>
    </tr>

    <tr>
        <td>3</td>
        <td>
            <img src="#" alt="Aura Studio News" style="object-fit: cover; border-radius: 4px;">
        </td>
        <td>Khai trương cửa hàng Aura Studio chi nhánh Thủ Đức</td>
        <td>15/03/2026</td>
        <td>
            <span class="status active">Hiển thị</span>
        </td>
        <td class="actions">
            <a href="#" class="icon-btn view" title="Xem chi tiết">
                <i class="fa fa-eye"></i>
            </a>
            <a href="#" class="icon-btn edit" title="Chỉnh sửa">
                <i class="fa fa-pen"></i>
            </a>
            <button type="button" class="icon-btn delete" title="Xóa tin tức" onclick="openDeleteModal(3, 'Khai trương cửa hàng Aura Studio chi nhánh Thủ Đức')">
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

    <!-- MODAL XÓA -->
    <div id="deleteModal" class="modal-overlay">
        <div class="modal">
            <h3>Xác nhận xóa</h3>
            <p id="deleteMessage">Bạn có chắc muốn xóa tin tức này không?</p>

            <form id="deleteForm" method="post" action="blogAdmin">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="id" id="deleteBlogId">

                <div class="modal-actions">
                    <button type="button" class="btn-secondary" onclick="closeDeleteModal()">Hủy</button>
                    <button type="submit" class="btn-danger">Xóa</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/admin/adminBlog.js"></script>
</body>

</html>
