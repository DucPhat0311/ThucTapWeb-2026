<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
        <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Admin User</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/sidebarAdmin.css?v=<%= System.currentTimeMillis() %>">
            </head>

            <body>
                <div class="admin">
                    <jsp:include page="include/sidebarAdmin.jsp" />

                    <section class="content">
                        <header class="topbar">
                            <h1 id="pageTitle">Quản Lý Khách Hàng</h1>
                            <div class="actions">
                                <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng xuất</a>
                            </div>
                        </header>

                        <main id="page">
                            <section id="dashboard" class="page active">
                                <div class="cards">
                                    <div class="card" style="cursor: pointer;"
                                        onclick="window.location.href='${pageContext.request.contextPath}/userAdmin<c:if test="
                                        ${not empty currentKeyword}">?keyword=${currentKeyword}</c:if>'">
                                        Tổng người dùng<br><span id="dashboard-total-user">${total}</span></div>
                                    <div class="card" style="cursor: pointer;"
                                        onclick="window.location.href='${pageContext.request.contextPath}/userAdmin?status=ACTIVE<c:if test="
                                        ${not empty currentKeyword}">&keyword=${currentKeyword}</c:if>'">
                                        Hoạt động<br><span id="dashboard-total-user-active">${countActive}</span></div>
                                    <div class="card" style="cursor: pointer;"
                                        onclick="window.location.href='${pageContext.request.contextPath}/userAdmin?status=BLOCKED<c:if test="
                                        ${not empty currentKeyword}">&keyword=${currentKeyword}</c:if>'">
                                        Bị khóa<br><span id="dashboard-total-user-block">${countBlock}</span></div>
                                </div>

                                <div class="user-toolbar">
                                    <form method="get" action="${pageContext.request.contextPath}/userAdmin"
                                        class="user-toolbar">

                                        <c:if test="${not empty currentStatus}">
                                            <input type="hidden" name="status" value="${currentStatus}">
                                        </c:if>

                                        <input type="text" name="keyword" value="${param.keyword}"
                                            placeholder="Tìm theo username, email...">

                                        <button type="submit" class="btn-search">
                                            <i class="fa fa-search"></i> Tìm
                                        </button>
                                    </form>

                                    <c:if test="${perms['add']}">
                                        <a href="${pageContext.request.contextPath}/userAdmin?mode=add" class="btn-add">
                                            <i class="fa fa-plus"></i> Thêm người dùng
                                        </a>
                                    </c:if>
                                </div>


                                <div class="user-table-wrapper">
                                    <table class="user-table">
                                        <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>Username</th>
                                                <th>Họ tên</th>
                                                <th>Email</th>
                                                <th>Vai trò</th>
                                                <th class="text-center">Trạng thái</th>
                                                <th>Hành động</th>
                                            </tr>
                                        </thead>
                                        <tbody id="userTableBody">
                                            <c:forEach items="${users}" var="u">
                                                <tr>
                                                    <td>${u.id}</td>
                                                    <td>${u.username}</td>
                                                    <td>${u.fullName}</td>
                                                    <td>${u.email}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when
                                                                test="${u.role == 'admin' or u.role == 'Admin' or u.role == 'ADMIN'}">
                                                                Quản trị
                                                            </c:when>
                                                            <c:otherwise>
                                                                Khách hàng
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>

                                                    <td class="text-center">
                                                        <c:choose>
                                                            <c:when test="${u.status == 'ACTIVE'}">
                                                                <span class="stock-badge in-stock">Hoạt động</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="stock-badge out-of-stock">Bị khóa</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="actions">
                                                        <c:if test="${perms['view_detail']}">
                                                            <a href="${pageContext.request.contextPath}/userAdmin?mode=view&id=${u.id}"
                                                                class="icon-btn view" title="Xem chi tiết">
                                                                <i class="fa fa-eye"></i>
                                                            </a>
                                                        </c:if>

                                                        <c:if test="${perms['edit']}">
                                                            <a href="${pageContext.request.contextPath}/userAdmin?mode=edit&id=${u.id}"
                                                                class="icon-btn edit" title="Chỉnh sửa">
                                                                <i class="fa fa-pen"></i>
                                                            </a>
                                                        </c:if>


                                                        <c:if test="${perms['lock']}">
                                                            <c:choose>
                                                                <c:when test="${u.status == 'ACTIVE'}">
                                                                    <button type="button" class="icon-btn lock"
                                                                        title="Khóa người dùng"
                                                                        onclick="openConfirmModal('${u.id}', 'bị khóa', 'khóa', ${u.id == sessionScope.userlogin.id})">
                                                                        <i class="fa fa-lock" style="color: #e74c3c;"></i>
                                                                    </button>
                                                                </c:when>

                                                                <c:otherwise>
                                                                    <button type="button" class="icon-btn unlock"
                                                                        title="Mở khóa người dùng"
                                                                        onclick="openConfirmModal('${u.id}', 'được hoạt động lại', 'mở khóa', ${u.id == sessionScope.userlogin.id})">
                                                                        <i class="fa fa-unlock" style="color: #27ae60;"></i>
                                                                    </button>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:if>

                                                        <c:if test="${perms['change_pass']}">
                                                            <button type="button" class="icon-btn key" title="Đổi mật khẩu"
                                                                onclick="openChangePassModal('${u.id}', '${u.username}')">
                                                                <i class="fa fa-key" style="color: #f39c12;"></i>
                                                            </button>
                                                        </c:if>

                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>

                                <c:if test="${totalPages > 1}">

                                    <c:set var="qs" value="" />
                                    <c:if test="${not empty currentStatus}">
                                        <c:set var="qs" value="${qs}&status=${currentStatus}" />
                                    </c:if>
                                    <c:if test="${not empty currentKeyword}">
                                        <c:set var="qs" value="${qs}&keyword=${currentKeyword}" />
                                    </c:if>

                                    <div class="pagination">
                                        <div class="pagination-info">
                                            Hiển thị ${(currentPage - 1) * pageSize + 1} - ${currentPage * pageSize >
                                            totalUsers ? totalUsers : currentPage * pageSize} của ${totalUsers} người
                                            dùng
                                        </div>

                                        <div class="pagination-controls">
                                            <c:if test="${currentPage > 1}">
                                                <a href="${pageContext.request.contextPath}/userAdmin?page=1${qs}"
                                                    class="page-btn">« Đầu</a>
                                                <a href="${pageContext.request.contextPath}/userAdmin?page=${currentPage - 1}${qs}"
                                                    class="page-btn">‹ Trước</a>
                                            </c:if>

                                            <c:forEach begin="1" end="${totalPages}" var="i">
                                                <c:choose>
                                                    <c:when test="${i == currentPage}">
                                                        <span class="page-btn active">${i}</span>
                                                    </c:when>
                                                    <c:when
                                                        test="${i == 1 || i == totalPages || (i >= currentPage - 2 && i <= currentPage + 2)}">
                                                        <a href="${pageContext.request.contextPath}/userAdmin?page=${i}${qs}"
                                                            class="page-btn">${i}</a>
                                                    </c:when>
                                                    <c:when test="${i == currentPage - 3 || i == currentPage + 3}">
                                                        <span class="page-btn dots">...</span>
                                                    </c:when>
                                                </c:choose>
                                            </c:forEach>

                                            <c:if test="${currentPage < totalPages}">
                                                <a href="${pageContext.request.contextPath}/userAdmin?page=${currentPage + 1}${qs}"
                                                    class="page-btn">Sau ›</a>
                                                <a href="${pageContext.request.contextPath}/userAdmin?page=${totalPages}${qs}"
                                                    class="page-btn">Cuối »</a>
                                            </c:if>
                                        </div>
                                    </div>
                                </c:if>

                        </main>
                    </section>


                    <div id="confirmModal" class="modal-overlay">
                        <div class="modal">
                            <h3>Xác nhận</h3>
                            <p>Bạn có chắc muốn <b id="modalActionText">khóa người dùng</b> này không?</p>
                            <p id="selfLockWarning" style="color: #e74c3c; font-weight: bold; display: none; margin-bottom: 20px; font-size: 14px;">
                                <i class="fa fa-exclamation-triangle"></i> CẢNH BÁO: Bạn đang thao tác khóa TÀI KHOẢN CỦA CHÍNH MÌNH. Nếu tiếp tục, bạn sẽ bị đăng xuất ngay lập tức và không thể tự đăng nhập lại!
                            </p>
                            <form id="confirmForm" method="post" action="${pageContext.request.contextPath}/userAdmin">
                                <input type="hidden" name="action" id="formActionField" value="block">
                                <input type="hidden" name="id" id="confirmUserId">

                                <div class="modal-actions">
                                    <button type="button" class="btn-secondary" onclick="closeModal()">Hủy</button>
                                    <button type="submit" id="btnConfirmSubmit" class="btn-danger">Khóa</button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <div id="changePassModal" class="modal-overlay">
                        <div class="modal">
                            <h3><i class="fa fa-key" style="color:#a87c53;margin-right:8px"></i>Đổi mật khẩu</h3>
                            <p>Tài khoản: <b id="changePassUsername"></b></p>
                            <form id="changePassForm" method="post"
                                action="${pageContext.request.contextPath}/userAdmin"
                                onsubmit="return validateChangePass()">
                                <input type="hidden" name="action" value="changePassword">
                                <input type="hidden" name="id" id="changePassUserId">

                                <div class="modal-field">
                                    <label for="newPassword">Mật khẩu mới</label>
                                    <div class="pass-wrapper">
                                        <input type="password" id="newPassword" name="newPassword"
                                            placeholder="Nhập mật khẩu mới">
                                        <span class="toggle-password" onclick="togglePassword('newPassword','eyeNew')">
                                            <i class="fa fa-eye" id="eyeNew"></i>
                                        </span>
                                    </div>
                                    <small id="newPasswordError" class="modal-field-error"></small>
                                </div>

                                <div class="modal-field">
                                    <label for="confirmNewPassword">Nhập lại mật khẩu mới</label>
                                    <div class="pass-wrapper">
                                        <input type="password" id="confirmNewPassword" name="confirmNewPassword"
                                            placeholder="Nhập lại mật khẩu mới">
                                        <span class="toggle-password"
                                            onclick="togglePassword('confirmNewPassword','eyeConfirm')">
                                            <i class="fa fa-eye" id="eyeConfirm"></i>
                                        </span>
                                    </div>
                                    <small id="confirmNewPasswordError" class="modal-field-error"></small>
                                </div>

                                <div class="modal-actions">
                                    <button type="button" class="btn-secondary"
                                        onclick="closeChangePassModal()">Hủy</button>
                                    <button type="submit" class="btn-primary-modal">Xác nhận đổi</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <script src="${pageContext.request.contextPath}/js/auth/register.js"></script>
                <script src="${pageContext.request.contextPath}/js/admin/adminUser.js"></script>
            </body>

            </html>