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
    <style>
#category .user-table-wrapper {
    border: 1px solid #e0d5c5;
    border-radius: 12px;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
    background: #fff;
}

#category .category-parent-row {
    background: #ffffff;
    transition: background 0.2s;
}

#category .category-parent-row td {
    border-top: 1px solid #f0e6da;
    font-weight: 600;
    color: #2c1e11;
    padding: 12px 15px;
}

#category .category-child-row td {
    background: #fafafa; 
    border-top: 1px dashed #eee;
}

#category .category-child-row {
    display: none;
}

#category .category-name-child {
    position: relative;
    padding-left: 50px !important; 
    color: #666;
    font-size: 0.95em;
}

#category .collapse-btn {
    width: 26px;
    height: 26px;
    border: 1px solid #d6c0a2;
    border-radius: 6px;
    background: #fff;
    color: #8a6646;
    cursor: pointer;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    margin-right: 8px;
    transition: all 0.3s ease;
}

#category .collapse-btn:hover {
    background: #8a6646;
    color: #fff;
}

#category .collapse-btn i {
    font-size: 10px;
    transition: transform 0.3s ease;
}

#category .collapse-btn.collapsed i {
    transform: rotate(-90deg); 
}

#category .type-chip {
    padding: 3px 12px;
    border-radius: 20px;
    font-size: 11px;
    font-weight: 600;
}

#category .type-chip.parent {
    background: #fdf2e9;
    color: #a0522d;
    border: 1px solid #f5deb3;
}

#category .type-chip.child {
    background: #f0f0f0;
    color: #777;
    border: 1px solid #ddd;
}
</style>

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


                <div class="user-table-wrapper" style="margin-top: 20px;">
                    <table class="user-table">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Tên danh mục</th>
                            <th>Loại</th>
                            <th>Thuộc danh mục cha</th>
                            <th>Trạng thái</th>
                            <th>Hành động</th>
                        </tr>
                        </thead>

                        <tbody>
                        <c:if test="${empty parentCategoriesList and empty childCategoriesList}">
                            <tr>
                                <td colspan="6" style="text-align:center">Không có danh mục nào.</td>
                            </tr>
                        </c:if>

                        <c:forEach var="parent" items="${parentCategoriesList}">
                            <tr class="category-parent-row" data-parent-row-id="${parent.id}">
                                <td>${parent.id}</td>
                                <td class="category-name-parent">
                                    <button type="button"
                                            class="collapse-btn collapsed"
                                            data-parent-id="${parent.id}"
                                            title="Thu gọn/Mở rộng danh mục con"
                                            onclick="toggleCategoryChildrenFromButton(this)">
                                        <i class="fa fa-chevron-down"></i>
                                    </button>
                                    ${parent.name}
                                </td>
                                <td><span class="type-chip parent">Danh mục cha</span></td>
                                <td>-</td>
                                <td>
                                    <span class="status ${parent.status == 1 ? 'active' : 'inactive'}">
                                        ${parent.status == 1 ? 'Đang dùng' : 'Đã khóa'}
                                    </span>
                                </td>
                                <td class="action-buttons">
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
                                        <td>${child.id}</td>
                                        <td class="category-name-child">${child.name}</td>
                                        <td><span class="type-chip child">Danh mục con</span></td>
                                        <td class="parent-name">${parent.name}</td>
                                        <td>
                                            <span class="status ${child.status == 1 ? 'active' : 'inactive'}">
                                                ${child.status == 1 ? 'Đang dùng' : 'Đã khóa'}
                                            </span>
                                        </td>
                                        <td class="action-buttons">
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

<script>
    function toggleCategoryStatusFromButton(button) {
        const id = parseInt(button.getAttribute('data-id'), 10);
        const name = button.getAttribute('data-name') || '';
        const status = parseInt(button.getAttribute('data-status'), 10);
        toggleCategoryStatus(id, name, status);
    }

    function toggleCategoryChildrenFromButton(button) {
        const parentId = parseInt(button.getAttribute('data-parent-id'), 10);
        toggleCategoryChildren(parentId, button);
    }

    function toggleCategoryChildren(parentId, button) {
        const childRows = document.querySelectorAll('tr.category-child-row[data-parent-id="' + parentId + '"]');
        if (!childRows.length) {
            return;
        }

        const shouldCollapse = !button.classList.contains('collapsed');
        childRows.forEach((row) => {
            row.style.display = shouldCollapse ? 'none' : 'table-row';
        });

        button.classList.toggle('collapsed', shouldCollapse);
    }
</script>

<script src="${pageContext.request.contextPath}/js/admin/adminCategory.js"></script>

</body>
</html>