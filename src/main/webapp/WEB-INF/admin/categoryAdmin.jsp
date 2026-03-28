<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Admin Category</title>
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
                        <span>${totalCategories}</span>
                    </div>
                    <div class="card">
                        Đang dùng
                        <span>${activeCategories}</span>
                    </div>
                    <div class="card">
                        Đã khóa
                        <span>${lockedCategories}</span>
                    </div>
                </div>

                <div class="user-toolbar">
                    <form method="post"
                          action="${pageContext.request.contextPath}/categoryAdmin"
                          class="user-toolbar">
                        <input type="hidden" name="action" value="search">
                        <input type="text" name="keyword" value="${param.keyword}"
                               placeholder="Tìm theo tên danh mục...">
                        <button type="submit" class="btn-search">
                            <i class="fa fa-search"></i> Tìm
                        </button>
                    </form>

                    <a href="${pageContext.request.contextPath}/categoryAdmin?mode=add" class="btn-add">
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
                        <c:forEach var="c" items="${parentCategoriesList}" varStatus="status">
                            <tr>
                                <td>${status.index + 1}</td>
                                <td>${c.id}</td>
                                <td>${c.name}</td>
                                <td>

                                    <span class="status ${c.status == 1 ? 'active' : 'inactive'}">
                                        ${c.status == 1 ? 'Đang dùng' : 'Đã khóa'}
                                    </span>
                                </td>
                                <td class="action-buttons">
     

                                    <a href="${pageContext.request.contextPath}/categoryAdmin?mode=view&id=${c.id}"
                                       class="icon-btn view"
                                       title="Xem chi tiết">
                                        <i class="fa fa-eye"></i>
                                    </a>


                                    <a href="${pageContext.request.contextPath}/categoryAdmin?mode=edit&id=${c.id}"
                                       class="icon-btn edit"
                                       title="Chỉnh sửa">
                                        <i class="fa fa-pen"></i>
                                    </a>


                                    <button class="icon-btn ${c.status == 1 ? 'delete' : 'view'}"
                                            title="${c.status == 1 ? 'Khóa danh mục' : 'Mở khóa'}"
                                            onclick="toggleCategoryStatus(${c.id}, '${c.name}', ${c.status})">
                                        <i class="fa fa-${c.status == 1 ? 'lock' : 'unlock'}"></i>
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
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
                        <c:forEach var="c" items="${childCategoriesList}" varStatus="status">
                            <tr>
                                <td>${status.index + 1}</td>
                                <td>${c.id}</td>
                                <td>${c.name}</td>
                                <td>${parentNameMap[c.parentId]}</td>
                                <td>

                                    <span class="status ${c.status == 1 ? 'active' : 'inactive'}">
                                        ${c.status == 1 ? 'Đang dùng' : 'Đã khóa'}
                                    </span>
                                </td>
                                <td class="action-buttons">

                                    <a href="${pageContext.request.contextPath}/categoryAdmin?mode=view&id=${c.id}"
                                       class="icon-btn view"
                                       title="Xem chi tiết">
                                        <i class="fa fa-eye"></i>
                                    </a>


                                    <a href="${pageContext.request.contextPath}/categoryAdmin?mode=edit&id=${c.id}"
                                       class="icon-btn edit"
                                       title="Chỉnh sửa">
                                        <i class="fa fa-pen"></i>
                                    </a>


                                    <button class="icon-btn ${c.status == 1 ? 'delete' : 'view'}"
                                            title="${c.status == 1 ? 'Khóa danh mục' : 'Mở khóa'}"
                                            onclick="toggleCategoryStatus(${c.id}, '${c.name}', ${c.status})">
                                        <i class="fa fa-${c.status == 1 ? 'lock' : 'unlock'}"></i>
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

<script src="${pageContext.request.contextPath}/javaScript/admin/adminCategory.js"></script>

</body>
</html>