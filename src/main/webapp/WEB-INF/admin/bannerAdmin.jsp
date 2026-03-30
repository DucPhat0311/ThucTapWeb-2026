<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
                    <div class="card">Tổng banner<br><span id="dashboard-total-banner">${total}</span></div>
                    <div class="card">Đang hoạt động<br><span id="dashboard-total-banner-active">${totalActive}</span></div>
                </div>

                <div class="banner-toolbar">
                    <a href="bannerAdmin?mode=add" class="btn-add">
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
                                <td><img src="${pageContext.request.contextPath}/${b.imageUrl}" alt="" class="banner-thumb"></td>
                                <td>${b.navigateTo}</td>
                                <td>${b.title}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${b.status}">
                                            <span class="status active">Hoạt động</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status blocked">Bị khóa</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="actions">
                                    <!-- XEM -->
                                    <a href="bannerAdmin?mode=view&id=${b.id}"
                                       class="icon-btn view" title="Xem chi tiết">
                                        <i class="fa fa-eye"></i>
                                    </a>

                                    <!-- SỬA -->
                                    <a href="bannerAdmin?mode=edit&id=${b.id}"
                                       class="icon-btn edit" title="Chỉnh sửa">
                                        <i class="fa fa-pen"></i>
                                    </a>

                                    <!-- KHÓA/MỞ KHÓA -->
                                    <c:choose>
                                        <c:when test="${b.status}">
                                            <button type="button"
                                                    class="icon-btn lock"
                                                    title="Khóa banner"
                                                    onclick="openLockModal(${b.id}, '${b.title}', 'lock')">
                                                <i class="fa fa-lock"></i>
                                            </button>
                                        </c:when>
                                        <c:otherwise>                                 
                                            <button type="button"
                                                    class="icon-btn unlock"
                                                    title="Mở khóa banner"
                                                    onclick="openLockModal(${b.id}, '${b.title}', 'unlock')">
                                                <i class="fa fa-unlock"></i>
                                            </button>
                                        </c:otherwise>
                                    </c:choose>

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
            </section>
        </main>
    </section>

    
    <div id="deleteModal" class="modal-overlay" style="display:none;">
        <div class="modal">
            <h3>Xác nhận xóa</h3>
            <p id="deleteMessage">Bạn có chắc muốn xóa banner này không?</p>
            <form id="deleteForm" method="post" action="bannerAdmin">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="id" id="deleteBannerId">
                <div class="modal-actions">
                    <button type="button" class="btn-secondary" onclick="closeDeleteModal()">Hủy</button>
                    <button type="submit" class="btn-danger">Xóa</button>
                </div>
            </form>
        </div>
    </div>

    
    <div id="lockModal" class="modal-overlay" style="display:none;">
        <div class="modal">
            <h3 id="lockModalTitle">Xác nhận</h3>
            <p id="lockMessage">Bạn có chắc muốn thực hiện thao tác này?</p>
            <form id="lockForm" method="post" action="bannerAdmin">
                <input type="hidden" name="action" id="lockAction" value="">
                <input type="hidden" name="id" id="lockBannerId">
                <div class="modal-actions">
                    <button type="button" class="btn-secondary" onclick="closeLockModal()">Hủy</button>
                    <button type="submit" class="btn-danger" id="lockSubmitBtn">Xác nhận</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/admin/adminBanner.js"></script>

</body>

</html>

