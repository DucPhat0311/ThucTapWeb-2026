<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý sản phẩm</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/sidebarAdmin.css">
</head>
<body>

<div class="admin">

    <jsp:include page="include/sidebarAdmin.jsp" />

    <section class="content">
        <header class="topbar">
            <h1 id="pageTitle">Quản Lý Sản Phẩm</h1>
            <div class="actions">
                <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng xuất</a>
            </div>
        </header>

        <main id="page">
            <section id="product" class="page active">
                
                <div class="cards">
                    <div class="card">
                        Tổng sản phẩm
                        <span>450</span>
                    </div>
                    <div class="card">
                        Đang bán
                        <span>300</span>
                    </div>
                    <div class="card">
                        Ngừng bán
                        <span>150</span>
                    </div>
                </div>

                <div class="user-toolbar">
                    <form method="post"
                          action="${pageContext.request.contextPath}/productAdmin"
                          class="user-toolbar">
                        <input type="hidden" name="action" value="#">
                        <input type="text" name="keyword" value="#"
                               placeholder="Tìm theo tên sản phẩm...">
                        <button type="submit" class="btn-search">
                            <i class="fa fa-search"></i> Tìm
                        </button>
                    </form>

                    <a href="#" class="btn-add">
                        <i class="fa fa-plus"></i> Thêm sản phẩm
                    </a>
                </div>

                <div class="user-table-wrapper">
                    <table class="user-table">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Ảnh</th>
                            <th>Tên sản phẩm</th>
                            <th>Giá</th>
                            <th>Giá sale</th>
                            <th>Danh mục</th>
                            <th>Trạng thái</th>
                            <th>Hành động</th>
                        </tr>
                        </thead>
                        <tbody>
    <tr>
        <td>SP001</td>

        <td>
            <img src="#" alt="Áo thun Oversize" style="width: 50px; height: 50px; object-fit: cover; border-radius: 5px;">
        </td>

        <td>Áo thun Oversize Cotton 100% Aura Premium</td>

        <td>250,000 đ</td>

        <td>199,000 đ</td>

        <td>Áo thun nam</td>

        <td>
            <span class="status active">Đang bán</span>
        </td>

        <td class="action-buttons">
            <a href="#" class="icon-btn view" title="Xem chi tiết">
                <i class="fa fa-eye"></i>
            </a>

            <a href="#" class="icon-btn edit" title="Chỉnh sửa">
                <i class="fa fa-pen"></i>
            </a>

            <a href="#" class="icon-btn variant" title="Quản lý biến thể">
                <i class="fa fa-layer-group"></i>
            </a>

            <a href="#" class="icon-btn image" title="Quản lý ảnh">
                <i class="fa fa-images"></i>
            </a>

            <button class="icon-btn delete" title="Đặt hết hàng" onclick="openToggleProductModal(1, 'Áo thun Oversize', 'Đang bán')">
                <i class="fa fa-trash"></i>
            </button>
        </td>
    </tr>

    <tr>
        <td>SP002</td>

        <td>
            <img src="#" alt="Quần Jean" style="width: 50px; height: 50px; object-fit: cover; border-radius: 5px;">
        </td>

        <td>Quần Jean Slimfit Wash Xanh Aura Studio Edition 2026...</td>

        <td>550,000 đ</td>

        <td>Không có</td>

        <td>Quần nam</td>

        <td>
            <span class="status active">Hết hàng</span>
        </td>

        <td class="action-buttons">
            <a href="#" class="icon-btn view" title="Xem chi tiết">
                <i class="fa fa-eye"></i>
            </a>

            <a href="#" class="icon-btn edit" title="Chỉnh sửa">
                <i class="fa fa-pen"></i>
            </a>

            <a href="#" class="icon-btn variant" title="Quản lý biến thể">
                <i class="fa fa-layer-group"></i>
            </a>

            <a href="#" class="icon-btn image" title="Quản lý ảnh">
                <i class="fa fa-images"></i>
            </a>

            <button class="icon-btn delete" title="Mở bán lại" onclick="openToggleProductModal(2, 'Quần Jean Slimfit', 'Hết hàng')">
                <i class="fa fa-trash"></i>
            </button>
        </td>
    </tr>
</tbody>
</table>
</div>
<!-- Phân trang -->
                <c:if test="${totalPages > 1}">
                    <div class="pagination">
                        <div class="pagination-info">
                            Hiển thị ${(currentPage - 1) * pageSize + 1} - ${currentPage * pageSize > totalProducts ? totalProducts : currentPage * pageSize} của ${totalProducts} sản phẩm
                        </div>
                        <div class="pagination-controls">
                            <c:if test="${currentPage > 1}">
                                <a href="product-admin?page=1" class="page-btn">« Đầu</a>
                                <a href="product-admin?page=${currentPage - 1}" class="page-btn">‹ Trước</a>
                            </c:if>

                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <c:choose>
                                    <c:when test="${i == currentPage}">
                                        <span class="page-btn active">${i}</span>
                                    </c:when>
                                    <c:when test="${i == 1 || i == totalPages || (i >= currentPage - 2 && i <= currentPage + 2)}">
                                        <a href="product-admin?page=${i}" class="page-btn">${i}</a>
                                    </c:when>
                                    <c:when test="${i == currentPage - 3 || i == currentPage + 3}">
                                        <span class="page-btn dots">...</span>
                                    </c:when>
                                </c:choose>
                            </c:forEach>

                            <c:if test="${currentPage < totalPages}">
                                <a href="product-admin?page=${currentPage + 1}" class="page-btn">Sau ›</a>
                                <a href="product-admin?page=${totalPages}" class="page-btn">Cuối »</a>
                            </c:if>
                        </div>
                    </div>
                </c:if>
            </section>

        </main>
    </section>
</div>
</body>
</html>