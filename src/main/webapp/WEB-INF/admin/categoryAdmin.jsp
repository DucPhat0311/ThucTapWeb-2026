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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/categoryAdmin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/sidebarAdmin.css">
</head>

<body>

<div class="admin">

    <jsp:include page="include/sidebarAdmin.jsp" />

    <section class="content">
        <header class="topbar">
            <h1 id="pageTitle">Quản Lý Danh Mục</h1>
            <div class="actions">
                <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng xuất</a>
            </div>
        </header>

        <main id="page">

            <section id="category" class="page active">

                <div class="cards">
                    <div class="card ${empty currentStatus ? 'active' : ''}" style="cursor: pointer;" onclick="window.location.href='categoryAdmin'">
                        Tổng danh mục
                        <span>${totalCategories}</span>
                    </div>
                    <div class="card ${currentStatus == 1 ? 'active' : ''}" style="cursor: pointer;" onclick="window.location.href='categoryAdmin?status=1'">
                        Đang hoạt động
                        <span>${activeCategories}</span>
                    </div>
                    <div class="card ${currentStatus == 0 ? 'active' : ''}" style="cursor: pointer;" onclick="window.location.href='categoryAdmin?status=0'">
                        Đã khóa
                        <span>${lockedCategories}</span>
                    </div>
                </div>

                <div class="category-header-row">
                    <h3>Danh sách danh mục</h3>
                    <div class="category-actions-wrap">
                        <div class="stock-search-wrapper">
                            <input type="text" id="categorySearchInput" onkeyup="filterCategoryTable()"
                                   placeholder="Tìm kiếm danh mục..."
                                   class="stock-search-input">
                            <i class="fa fa-search stock-search-icon"></i>
                        </div>
                        <a href="${pageContext.request.contextPath}/categoryAdmin?mode=add" class="btn-add">
                            <i class="fa fa-plus"></i> Thêm danh mục
                        </a>
                    </div>
                </div>


                <div class="user-table-wrapper" style="margin-top: 10px;">
                    <table class="user-table">
                        <thead>
                        <tr>
                            <th class="text-center" style="width: 80px;">ID</th>
                            <th>Tên danh mục</th>
                            <th class="text-center">Loại</th>
                            <th class="text-center">Thuộc danh mục cha</th>
                            <th class="text-center">Trạng thái</th>
                            <th class="text-center" style="width: 150px;">Hành động</th>
                        </tr>
                        </thead>

                        <tbody>
                        <c:if test="${empty parentCategoriesList and empty childCategoriesList}">
                            <tr>
                                <td colspan="6" class="text-center" style="padding: 20px;">Không có danh mục nào.</td>
                            </tr>
                        </c:if>

                        <c:forEach var="parent" items="${parentCategoriesList}">
                            <tr class="category-parent-row" data-parent-row-id="${parent.id}">
                                <td class="text-center font-weight-semibold">${parent.id}</td>
                                <td class="category-name-parent font-weight-semibold">
                                    <button type="button"
                                            class="collapse-btn"
                                            data-parent-id="${parent.id}"
                                            title="Thu gọn/Mở rộng danh mục con"
                                            onclick="toggleCategoryChildrenFromButton(this)">
                                        <i class="fa fa-chevron-down"></i>
                                    </button>
                                    ${parent.name}
                                </td>
                                <td class="text-center"><span class="type-chip parent">Danh mục cha</span></td>
                                <td class="text-center" style="color: #bbb;">-</td>
                                <td class="text-center">
                                    <span class="status ${parent.status == 1 ? 'active' : 'blocked'}">
                                        ${parent.status == 1 ? 'Đang hoạt động' : 'Đã khóa'}
                                    </span>
                                </td>
                                <td class="text-center action-buttons">
                                    <a href="${pageContext.request.contextPath}/categoryAdmin?mode=view&id=${parent.id}"
                                       class="icon-btn view"
                                       title="Xem chi tiết">
                                        <i class="fa fa-eye"></i>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/categoryAdmin?mode=edit&id=${parent.id}"
                                       class="icon-btn edit"
                                       title="Chỉnh sửa">
                                        <i class="fa fa-pen"></i>
                                    </a>
                                    <button class="icon-btn ${parent.status == 1 ? 'delete' : 'view'}"
                                            title="${parent.status == 1 ? 'Khóa danh mục' : 'Mở khóa'}"
                                            data-id="${parent.id}"
                                            data-name="${fn:escapeXml(parent.name)}"
                                            data-status="${parent.status}"
                                            onclick="toggleCategoryStatusFromButton(this)">
                                        <i class="fa fa-${parent.status == 1 ? 'lock' : 'unlock'}"></i>
                                    </button>
                                </td>
                            </tr>

                            <c:forEach var="child" items="${childCategoriesList}">
                                <c:if test="${child.parentId == parent.id}">
                                    <tr class="category-child-row" data-parent-id="${parent.id}">
                                        <td class="text-center" style="color: #666;">${child.id}</td>
                                        <td class="category-name-child">${child.name}</td>
                                        <td class="text-center"><span class="type-chip child">Danh mục con</span></td>
                                        <td class="text-center parent-name" style="font-weight: 500; color: #555;">${parent.name}</td>
                                        <td class="text-center">
                                            <span class="status ${child.status == 1 ? 'active' : 'blocked'}">
                                                ${child.status == 1 ? 'Đang hoạt động' : 'Đã khóa'}
                                            </span>
                                        </td>
                                        <td class="text-center action-buttons">
                                            <a href="${pageContext.request.contextPath}/categoryAdmin?mode=view&id=${child.id}"
                                               class="icon-btn view"
                                               title="Xem chi tiết">
                                                <i class="fa fa-eye"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/categoryAdmin?mode=edit&id=${child.id}"
                                               class="icon-btn edit"
                                               title="Chỉnh sửa">
                                                <i class="fa fa-pen"></i>
                                            </a>
                                            <button class="icon-btn ${child.status == 1 ? 'delete' : 'view'}"
                                                    title="${child.status == 1 ? 'Khóa danh mục' : 'Mở khóa'}"
                                                    data-id="${child.id}"
                                                    data-name="${fn:escapeXml(child.name)}"
                                                    data-status="${child.status}"
                                                    onclick="toggleCategoryStatusFromButton(this)">
                                                <i class="fa fa-${child.status == 1 ? 'lock' : 'unlock'}"></i>
                                            </button>
                                        </td>
                                    </tr>
                                </c:if>
                            </c:forEach>
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

<script src="${pageContext.request.contextPath}/js/admin/adminCategory.js"></script>

</body>
</html>