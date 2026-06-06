<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="aura" uri="/WEB-INF/tlds/aura.tld" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Banner</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css"><link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/banner.css">
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
                    <div class="card" style="cursor: pointer;" onclick="window.location.href='${pageContext.request.contextPath}/bannerAdmin'">
                        Tổng banner<br><span id="dashboard-total-banner">${total}</span></div>
                    <div class="card" style="cursor: pointer;" onclick="window.location.href='${pageContext.request.contextPath}/bannerAdmin?status=1'">
                        Đang hoạt động<br><span id="dashboard-total-banner-active">${totalActive}</span></div>
                    <div class="card" style="cursor: pointer;" onclick="window.location.href='${pageContext.request.contextPath}/bannerAdmin?status=0'">
                        Đã ẩn<br><span id="dashboard-total-banner-block">${totalBlocked}</span></div>
                </div>

                <div class="banner-toolbar">
                    <a href="${pageContext.request.contextPath}/bannerAdmin?mode=add" class="btn-add">
                        <i class="fa fa-plus"></i> Thêm banner
                    </a>
                </div>


                <div class="banner-table-wrapper">
                    <!-- TABLE USER -->
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
                        <!-- demo data -->
                        <c:forEach items="${banners}" var="b">
                            <tr>
                                <td>${b.id}</td>
                                <td><img src="${aura:resolve(pageContext.request.contextPath, '/img', b.imageUrl, '')}" alt="" class="banner-thumb"></td>
                                <td>${b.navigateTo}</td>
                                <td>${b.title}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${b.status}">
                                            <span class="stock-badge in-stock">Hoạt động</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="stock-badge out-of-stock">Đã ẩn</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="actions">
                                    <!-- XEM -->
                                    <a href="${pageContext.request.contextPath}/bannerAdmin?mode=view&id=${b.id}"
                                       class="icon-btn view" title="Xem chi tiết">
                                        <i class="fa fa-eye"></i>
                                    </a>

                                    <!-- SỬA -->
                                    <a href="${pageContext.request.contextPath}/bannerAdmin?mode=edit&id=${b.id}"
                                       class="icon-btn edit" title="Chỉnh sửa">
                                        <i class="fa fa-pen"></i>
                                    </a>

                                    <!-- XÓA -->
                                    <button type="button"
                                            class="icon-btn delete"
                                            title="Xóa banner"
                                            onclick="openDeleteModal(${b.id}, '${b.title}')">
                                        <i class="fa fa-trash"></i>
                                    </button>
                                </td>

                            </tr>
                        </c:forEach>

                        </tbody>
                    </table>
                </div>
                
                <c:if test="${totalPages > 1}">
                    <div class="pagination">
                        <div class="pagination-info">
                            Hiển thị ${(currentPage - 1) * pageSize + 1} - ${currentPage * pageSize >
                            totalItems ? totalItems : currentPage * pageSize} của ${totalItems} banner
                        </div>

                        <div class="pagination-controls">
                            <c:if test="${currentPage > 1}">
                                <a href="${pageContext.request.contextPath}/bannerAdmin?page=1${qs}"
                                   class="page-btn">Đầu</a>
                                <a href="${pageContext.request.contextPath}/bannerAdmin?page=${currentPage - 1}${qs}"
                                   class="page-btn">Trước</a>
                            </c:if>

                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <c:choose>
                                    <c:when test="${i == currentPage}">
                                        <span class="page-btn active">${i}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/bannerAdmin?page=${i}${qs}"
                                           class="page-btn">${i}</a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>

                            <c:if test="${currentPage < totalPages}">
                                <a href="${pageContext.request.contextPath}/bannerAdmin?page=${currentPage + 1}${qs}"
                                   class="page-btn">Sau</a>
                                <a href="${pageContext.request.contextPath}/bannerAdmin?page=${totalPages}${qs}"
                                   class="page-btn">Cuối</a>
                            </c:if>
                        </div>
                    </div>
                </c:if>
            </section>
        </main>
    </section>

    
    <div id="deleteModal" class="modal-overlay" style="display:none;">
        <div class="modal">
            <h3>Xác nhận xóa</h3>
            <p id="deleteMessage">Bạn có chắc muốn xóa banner này không?</p>
            <form id="deleteForm" method="post" action="${pageContext.request.contextPath}/bannerAdmin">
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

