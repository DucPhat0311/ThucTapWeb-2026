<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin User</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/sidebarAdmin.css">
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
                    <div class="card">Tổng người dùng<br><span id="dashboard-total-user">${total}</span></div>
                    <div class="card">Hoạt động<br><span id="dashboard-total-user-active">${countActive}</span></div>
                    <div class="card">Bị khóa<br><span id="dashboard-total-user-block">${countBlock}</span></div>
                </div>

                <div class="user-toolbar">
                    <form method="get" action="userAdmin" class="user-toolbar">
                        <input
                                type="text"
                                name="keyword"
                                value="${param.keyword}"
                                placeholder="Tìm theo username, email..."
                        >

                        <button type="submit" class="btn-search">
                            <i class="fa fa-search"></i> Tìm
                        </button>
                    </form>

                    <a href="userAdmin?mode=add" class="btn-add">
                        <i class="fa fa-plus"></i> Thêm người dùng
                    </a>
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
                            <th>Trạng thái</th>
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
                                        <c:when test="${u.role == 'admin'}">
                                            Quản trị
                                        </c:when>
                                        <c:otherwise>
                                            Khách hàng
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <td>
                                    <c:choose>
                                        <c:when test="${u.status == 'ACTIVE'}">
                                            <span class="status active">Hoạt động</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status blocked">Bị khóa</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="actions">
                                    <a href="userAdmin?mode=view&id=${u.id}"
                                       class="icon-btn view" title="Xem chi tiết">
                                        <i class="fa fa-eye"></i>
                                    </a>

                                    <a href="userAdmin?mode=edit&id=${u.id}"
                                       class="icon-btn edit" title="Chỉnh sửa">
                                        <i class="fa fa-pen"></i>
                                    </a>


                                    <c:choose>
                                        <c:when test="${u.status == 'ACTIVE'}">
                                            <button type="button"
                                                    class="icon-btn lock"
                                                    title="Khóa người dùng"
                                                    onclick="openConfirmModal('${u.id}', 'bị khóa', 'khóa')">
                                                <i class="fa fa-lock" style="color: #e74c3c;"></i>
                                            </button>
                                        </c:when>

                                        <c:otherwise>
                                            <button type="button"
                                                    class="icon-btn unlock"
                                                    title="Mở khóa người dùng"
                                                    onclick="openConfirmModal('${u.id}', 'được hoạt động lại', 'mở khóa')">
                                                <i class="fa fa-unlock" style="color: #27ae60;"></i>
                                            </button>
                                        </c:otherwise>
                                    </c:choose>

                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>

            </section>

        </main>
    </section>


    <div id="confirmModal" class="modal-overlay">
        <div class="modal">
            <h3>Xác nhận</h3>
            <p>Bạn có chắc muốn <b id="modalActionText">khóa người dùng</b> này không?</p>
            <form id="confirmForm" method="post" action="userAdmin">
                <input type="hidden" name="action" id="formActionField" value="block">
                <input type="hidden" name="id" id="confirmUserId">

                <div class="modal-actions">
                    <button type="button" class="btn-secondary" onclick="closeModal()">Hủy</button>
                    <button type="submit" id="btnConfirmSubmit" class="btn-danger">Khóa</button>
                </div>
            </form>
        </div>
    </div>
</div>

</body>
<script src="${pageContext.request.contextPath}/js/admin/adminUser.js"></script>

</html>


