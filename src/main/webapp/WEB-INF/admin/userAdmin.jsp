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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/sidebarAdmin.css">
</head>

<body>
<div class="admin">

    <jsp:include page="include/sidebarAdmin.jsp" />

    <section class="content">
        <!-- PHẦN HEADER -->
        <header class="topbar">
            <h1 id="pageTitle">Người dùng</h1>
            <div class="actions">
                <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng xuất</a>
            </div>
        </header>

        <main id="page">
            <!-- DASHBROAD -->
            <section id="dashboard" class="page active">
                <div class="cards">
                    <div class="card">Tổng người dùng<br><span id="dashboard-total-user">300</span></div>
                    <div class="card">Người dùng mới trong tuần<br><span id="dashboard-total-user-in-week">50</span></div>
                    <div class="card">Hoạt động<br><span id="dashboard-total-user-active">250</span></div>
                    <div class="card">Bị khóa<br><span id="dashboard-total-user-block">50</span></div>
                </div>

                <div class="user-toolbar">
                    <form method="get" action="userAdmin" class="user-toolbar">
                        <input
                                type="text"
                                name="keyword"
                                value=""
                                placeholder="Tìm theo tên username, email người dùng"
                        >
                        <button type="submit" class="btn-search">
                            <i class="fa fa-search"></i> Tìm
                        </button>
                    </form>

                    <a href="#" class="btn-add">
                        <i class="fa fa-plus"></i> Thêm người dùng
                    </a>
                </div>


                <div class="user-table-wrapper">
                    <!-- TABLE USER -->
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
                        <tr>
                            <td>1</td>
                            <td>admin_nlu</td>
                            <td>Nguyễn Văn Admin</td>
                            <td>admin@st.hcmuaf.edu.vn</td>
                            <td>Quản trị</td>
                            <td>
                                <span class="status active">Hoạt động</span>
                            </td>
                            <td class="actions">
                                <a href="#" class="icon-btn view" title="Xem chi tiết">
                                    <i class="fa fa-eye"></i>
                                </a>
                                <a href="#" class="icon-btn edit" title="Chỉnh sửa">
                                    <i class="fa fa-pen"></i>
                                </a>
                                <button type="button" class="icon-btn lock" title="Khóa người dùng">
                                    <i class="fa fa-lock"></i>
                                </button>
                            </td>
                        </tr>

                        <tr>
                            <td>2</td>
                            <td>khachhang_test</td>
                            <td>Trần Thị Khách</td>
                            <td>test@gmail.com</td>
                            <td>Khách hàng</td>
                            <td>
                                <span class="status blocked">Bị khóa</span>
                            </td>
                            <td class="actions">
                                <a href="#" class="icon-btn view" title="Xem chi tiết">
                                    <i class="fa fa-eye"></i>
                                </a>
                                <a href="#" class="icon-btn edit" title="Chỉnh sửa">
                                    <i class="fa fa-pen"></i>
                                </a>
                                <button type="button" class="icon-btn unlock" title="Mở khóa người dùng">
                                    <i class="fa fa-unlock"></i>
                                </button>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>

                <div id="confirmModal" class="modal-overlay">
                    <div class="modal">
                        <h3>Xác nhận</h3>
                        <p>Bạn có chắc muốn <b id="modalActionText">khóa</b> người dùng này không?</p>

                        <form id="confirmForm" method="post" action="userAdmin">
                            <input type="hidden" name="action" id="formActionField" value="block">
                            <input type="hidden" name="id" id="confirmUserId" value="">

                            <div class="modal-actions">
                                <button type="button" class="btn-secondary">Hủy</button>
                                <button type="submit" id="btnConfirmSubmit" class="btn-danger">Khóa</button>
                            </div>
                        </form>
                    </div>
                </div>

</div>


</body>

<script src="${pageContext.request.contextPath}/js/admin/adminUser.js"></script>

</html>


