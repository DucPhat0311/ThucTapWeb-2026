<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Phân Quyền Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/sidebarAdmin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/roleAdmin.css">
</head>

<body>
<div class="admin">
    <jsp:include page="include/sidebarAdmin.jsp" />

    <section class="content">
        <header class="topbar">
            <h1 id="pageTitle">Phân Quyền</h1>
            <div class="actions">
                <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng xuất</a>
            </div>
        </header>

        <main id="page">
            <section id="role" class="page active">

                <div class="role-layout">
                    <%-- ====== PANEL TRÁI: Danh sách roles ====== --%>
                    <div class="role-list-panel">
                        <div class="role-list-header">
                            <h3>Vai trò</h3>
                            <button type="button" class="btn-add-role" onclick="openCreateModal()">
                                <i class="fa fa-plus"></i> Thêm
                            </button>
                        </div>

                        <div class="role-list">
                            <c:forEach items="${roles}" var="r">
                                <a href="roleAdmin?roleId=${r.id}"
                                   class="role-item ${selectedRole.id == r.id ? 'active' : ''}">
                                    <div class="role-item-info">
                                        <span class="role-name">${r.name}</span>
                                        <c:if test="${r.isSystem == 1}">
                                            <span class="badge-system">Hệ thống</span>
                                        </c:if>
                                    </div>
                                    <span class="role-desc">${r.description}</span>
                                </a>
                            </c:forEach>
                        </div>
                    </div>

                    <%-- ====== PANEL PHẢI: Bảng quyền ====== --%>
                    <div class="role-detail-panel">
                        <c:if test="${selectedRole != null}">
                            <div class="role-detail-header">
                                <div class="role-detail-title">
                                    <h3>${selectedRole.name}</h3>
                                    <c:if test="${selectedRole.isSystem == 1}">
                                        <span class="badge-system">Hệ thống - Toàn quyền</span>
                                    </c:if>
                                </div>

                                <c:if test="${selectedRole.isSystem == 0}">
                                    <div class="role-detail-actions">
                                        <button type="button" class="btn-edit-role"
                                                onclick="openEditModal('${selectedRole.id}', '${selectedRole.name}', '${selectedRole.description}')">
                                            <i class="fa fa-pen"></i> Sửa
                                        </button>
                                        <button type="button" class="btn-delete-role"
                                                onclick="openDeleteModal('${selectedRole.id}', '${selectedRole.name}')">
                                            <i class="fa fa-trash"></i> Xoá
                                        </button>
                                    </div>
                                </c:if>
                            </div>

                            <form method="post" action="roleAdmin" id="permissionForm">
                                <input type="hidden" name="action" value="savePermissions">
                                <input type="hidden" name="roleId" value="${selectedRole.id}">

                                <div class="permission-table-wrapper">
                                    <table class="permission-table">
                                        <thead>
                                        <tr>
                                            <th class="module-col">Module</th>
                                            <th class="action-col">
                                                <div class="th-content">
                                                    <span>Xem DS</span>
                                                    <c:if test="${selectedRole.isSystem == 0}">
                                                        <label class="check-all-col" title="Chọn tất cả cột">
                                                            <input type="checkbox" onchange="toggleColumn('view_list', this.checked)">
                                                        </label>
                                                    </c:if>
                                                </div>
                                            </th>
                                            <th class="action-col">
                                                <div class="th-content">
                                                    <span>Chi tiết</span>
                                                    <c:if test="${selectedRole.isSystem == 0}">
                                                        <label class="check-all-col" title="Chọn tất cả cột">
                                                            <input type="checkbox" onchange="toggleColumn('view_detail', this.checked)">
                                                        </label>
                                                    </c:if>
                                                </div>
                                            </th>
                                            <th class="action-col">
                                                <div class="th-content">
                                                    <span>Thêm</span>
                                                    <c:if test="${selectedRole.isSystem == 0}">
                                                        <label class="check-all-col" title="Chọn tất cả cột">
                                                            <input type="checkbox" onchange="toggleColumn('add', this.checked)">
                                                        </label>
                                                    </c:if>
                                                </div>
                                            </th>
                                            <th class="action-col">
                                                <div class="th-content">
                                                    <span>Sửa</span>
                                                    <c:if test="${selectedRole.isSystem == 0}">
                                                        <label class="check-all-col" title="Chọn tất cả cột">
                                                            <input type="checkbox" onchange="toggleColumn('edit', this.checked)">
                                                        </label>
                                                    </c:if>
                                                </div>
                                            </th>
                                            <th class="action-col">
                                                <div class="th-content">
                                                    <span>Xoá</span>
                                                    <c:if test="${selectedRole.isSystem == 0}">
                                                        <label class="check-all-col" title="Chọn tất cả cột">
                                                            <input type="checkbox" onchange="toggleColumn('delete', this.checked)">
                                                        </label>
                                                    </c:if>
                                                </div>
                                            </th>
                                            <th class="action-col">
                                                <div class="th-content">
                                                    <span>Khoá</span>
                                                    <c:if test="${selectedRole.isSystem == 0}">
                                                        <label class="check-all-col" title="Chọn tất cả cột">
                                                            <input type="checkbox" onchange="toggleColumn('lock', this.checked)">
                                                        </label>
                                                    </c:if>
                                                </div>
                                            </th>
                                            <c:if test="${selectedRole.isSystem == 0}">
                                                <th class="toggle-col">Tất cả</th>
                                            </c:if>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <c:set var="moduleNames" value="user,category,product,order,return,banner,blog,contact,warehouse,role" />
                                        <c:set var="moduleLabels" value="Người dùng,Danh mục,Sản phẩm,Đơn hàng,Trả hàng,Banner,Bài viết,Liên hệ,Kho,Phân quyền" />
                                        <c:set var="actionNames" value="view_list,view_detail,add,edit,delete,lock" />

                                        <c:forTokens items="${moduleNames}" delims="," var="mod" varStatus="modIdx">
                                            <tr>
                                                <td class="module-name">
                                                    <c:forTokens items="${moduleLabels}" delims="," var="label" varStatus="labelIdx">
                                                        <c:if test="${labelIdx.index == modIdx.index}">${label}</c:if>
                                                    </c:forTokens>
                                                </td>
                                                <c:forTokens items="${actionNames}" delims="," var="act">
                                                    <td class="perm-cell">
                                                        <c:set var="isChecked" value="false" />
                                                        <c:forEach items="${permissions}" var="p">
                                                            <c:if test="${p.module == mod && p.action == act && p.allowed == 1}">
                                                                <c:set var="isChecked" value="true" />
                                                            </c:if>
                                                        </c:forEach>

                                                        <label class="perm-checkbox">
                                                            <input type="checkbox"
                                                                   name="perm_${mod}_${act}"
                                                                   value="1"
                                                                   data-module="${mod}"
                                                                   data-action="${act}"
                                                                   ${isChecked == 'true' ? 'checked' : ''}
                                                                   ${selectedRole.isSystem == 1 ? 'checked disabled' : ''}>
                                                            <span class="checkmark"></span>
                                                        </label>
                                                    </td>
                                                </c:forTokens>
                                                <c:if test="${selectedRole.isSystem == 0}">
                                                    <td class="toggle-cell">
                                                        <label class="perm-checkbox toggle-row-checkbox">
                                                            <input type="checkbox" onchange="toggleRow('${mod}', this.checked)">
                                                            <span class="checkmark"></span>
                                                        </label>
                                                    </td>
                                                </c:if>
                                            </tr>
                                        </c:forTokens>
                                        </tbody>
                                    </table>
                                </div>

                                <c:if test="${selectedRole.isSystem == 0}">
                                    <div class="permission-footer">
                                        <button type="submit" class="btn-save-perm">
                                            <i class="fa fa-save"></i> Lưu quyền
                                        </button>
                                    </div>
                                </c:if>
                            </form>
                        </c:if>

                        <c:if test="${selectedRole == null}">
                            <div class="empty-state">
                                <i class="fa fa-shield-alt"></i>
                                <p>Chưa có vai trò nào. Hãy tạo vai trò mới!</p>
                            </div>
                        </c:if>
                    </div>
                </div>

            </section>
        </main>
    </section>
</div>

<%-- ====== MODAL: Tạo / Sửa Role ====== --%>
<div id="roleModal" class="modal-overlay">
    <div class="modal">
        <h3 id="roleModalTitle">Thêm vai trò</h3>
        <form method="post" action="roleAdmin" id="roleForm">
            <input type="hidden" name="action" id="roleFormAction" value="create">
            <input type="hidden" name="roleId" id="roleFormId">

            <div class="form-group">
                <label>Tên vai trò <span class="required">*</span></label>
                <input type="text" name="roleName" id="roleFormName" required
                       placeholder="VD: NV Quản lý sản phẩm">
            </div>

            <div class="form-group">
                <label>Mô tả</label>
                <textarea name="roleDescription" id="roleFormDesc" rows="3"
                          placeholder="Mô tả vai trò..."></textarea>
            </div>

            <div class="modal-actions">
                <button type="button" class="btn-secondary" onclick="closeRoleModal()">Huỷ</button>
                <button type="submit" class="btn-primary" id="roleFormSubmitBtn">Tạo</button>
            </div>
        </form>
    </div>
</div>

<%-- ====== MODAL: Xoá Role ====== --%>
<div id="deleteModal" class="modal-overlay">
    <div class="modal">
        <h3>Xác nhận xoá</h3>
        <p>Bạn có chắc muốn xoá vai trò <b id="deleteRoleName"></b>?</p>
        <p class="delete-warning">Những người dùng đang gán vai trò này sẽ bị chuyển về role mặc định.</p>
        <form method="post" action="roleAdmin">
            <input type="hidden" name="action" value="delete">
            <input type="hidden" name="roleId" id="deleteRoleId">
            <div class="modal-actions">
                <button type="button" class="btn-secondary" onclick="closeDeleteModal()">Huỷ</button>
                <button type="submit" class="btn-danger">Xoá</button>
            </div>
        </form>
    </div>
</div>

</body>
<script src="${pageContext.request.contextPath}/js/admin/adminRole.js"></script>
</html>
