<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Biến Thể</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/sidebarAdmin.css">
</head>
<body>
<div class="admin">
    <jsp:include page="include/sidebarAdmin.jsp" />

    <section class="content">
        <main id="page">
            <section id="dashboard" class="page active">
 
                <div class="page-header">
                    <div style="display: flex; align-items: center; gap: 15px;">
                        <a href="productAdmin" class="back-to-product-btn" title="Quay về quản lý sản phẩm">
                            <i class="fa fa-arrow-left"></i>
                        </a>
                        <h1 id="pageTitle">Quản Lý Biến Thể</h1>
                    </div>
                    <div class="actions">
                        <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng xuất</a>
                    </div>
                </div>

                <div class="cards">
                    <div class="card">Tổng biến thể<span id="dashboard-total-variant">200</span></div>
                    <div class="card">Tổng tồn kho<span id="dashboard-total-variant-stock">500</span></div>
                    <div class="card">Số size<span id="dashboard-total-variant-size">10</span></div>
                    <div class="card">Số màu<span id="dashboard-total-variant-color">5</span></div>
                </div>

                <div class="user-toolbar" style="justify-content: flex-end; margin-bottom: 20px;">
                    <a href="#" class="btn-add">
                        <i class="fa fa-plus"></i> Thêm biến thể
                    </a>
                </div>

                <div class="user-table-wrapper">
                    <table class="user-table">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Size</th>
                            <th>Màu</th>
                            <th>Tồn kho</th>
                            <th>Hoạt động</th>
                        </tr>
                        </thead>
                        <tbody id="variantTableBody">
    <tr>
        <td>501</td>
        <td>Size L</td>
        <td>Màu Đen</td>
        <td>
            <span class="status active">45</span>
        </td>
        <td class="actions">
            <a href="#" class="icon-btn edit" title="Chỉnh sửa">
                <i class="fa fa-pen"></i>
            </a>
            <button type="button" class="icon-btn delete" onclick="openDeleteModal(501, 'Size L - Màu Đen')">
                <i class="fa fa-trash"></i>
            </button>
        </td>
    </tr>

    <tr>
        <td>502</td>
        <td>Size M</td>
        <td>Màu Trắng</td>
        <td>
            <span class="status processing">Sắp hết (5)</span>
        </td>
        <td class="actions">
            <a href="#" class="icon-btn edit" title="Chỉnh sửa">
                <i class="fa fa-pen"></i>
            </a>
            <button type="button" class="icon-btn delete" onclick="openDeleteModal(502, 'Size M - Màu Trắng')">
                <i class="fa fa-trash"></i>
            </button>
        </td>
    </tr>

    <tr>
        <td>503</td>
        <td>Size XL</td>
        <td>Màu Xanh Navy</td>
        <td>
            <span class="status blocked">Hết hàng</span>
        </td>
        <td class="actions">
            <a href="#" class="icon-btn edit" title="Chỉnh sửa">
                <i class="fa fa-pen"></i>
            </a>
            <button type="button" class="icon-btn delete" onclick="openDeleteModal(503, 'Size XL - Màu Xanh Navy')">
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
    <div class="modal-content modal-small">
        <div class="modal-header">
            <h3>Xác nhận xóa</h3>
        </div>

        <form method="post" action="#">
            <div class="modal-body">
                <p id="deleteMessage">Bạn có chắc muốn xóa biến thể <b>Size M - Màu Trắng</b> này không?</p>
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="id" id="deleteVariantId">
                <input type="hidden" name="productId" value="101">
            </div>

            <div class="modal-footer">
                <button type="button" class="btn-cancel" onclick="closeDeleteModal()">Hủy</button>
                <button type="submit" class="btn-delete">Xóa</button>
            </div>
        </form>
    </div>
</div>
</div>
<script src="${pageContext.request.contextPath}/js/admin/adminVariantProduct.js"></script>
</body>


</body>
</html>

