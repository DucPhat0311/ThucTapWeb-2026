<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Blog Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/blog.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/sidebarAdmin.css">
</head>
<body>
<div class="admin">
    <jsp:include page="include/sidebarAdmin.jsp" />

    <section class="content">

        <header class="topbar">
            <h1 id="pageTitle">Quản Lý Bài Viết</h1>
            <div class="actions">
                <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng xuất</a>
            </div>
        </header>


        <main id="page">

            <section id="dashboard" class="page active">
                <div class="cards">
                    <div class="card" style="cursor: pointer;" onclick="window.location.href='blogAdmin'">
                        Tổng bài viết<br><span>${total}</span></div>
                    <div class="card" style="cursor: pointer;" onclick="window.location.href='blogAdmin?status=1'">
                        Đang hiển thị<br><span>${totalActive}</span></div>
                    <div class="card" style="cursor: pointer;" onclick="window.location.href='blogAdmin?status=0'">
                        Đang ẩn<br><span>${totalHidden}</span></div>
                </div>

                <div class="toolbar">
                    <a href="blogAdmin?mode=add" class="btn-add">
                        <i class="fa fa-plus"></i> Thêm bài viết
                    </a>
                </div>


                <div class="table-container">

                    <table class="table">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Ảnh</th>
                            <th>Tiêu đề</th>
                            <th>Ngày tạo</th>
                            <th>Trạng thái</th>
                            <th>Hành động</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${blogList}" var="n">
                            <tr>
                                <td>${n.id}</td>
                                <td>
                                    <img src="${n.img}">
                                </td>
                                <td>${n.title}</td>
                                <td>${n.createdAt}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${n.status == 1}">
                                            <span class="status active">Hiển thị</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status blocked">Ẩn</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="actions">
                                    <!-- XEM -->
                                    <a href="blogAdmin?mode=view&id=${n.id}"
                                       class="icon-btn view" title="Xem chi tiết">
                                        <i class="fa fa-eye"></i>
                                    </a>

                                    <!-- SỬA -->
                                    <a href="blogAdmin?mode=edit&id=${n.id}"
                                       class="icon-btn edit" title="Chỉnh sửa">
                                        <i class="fa fa-pen"></i>
                                    </a>

                                    <!-- XÓA MỀM -->
                                    <button type="button"
                                            class="icon-btn delete"
                                            title="Xóa tin tức"
                                            onclick="openDeleteModal(${n.id}, '${n.title}')">
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

    <!-- MODAL XÓA -->
    <div id="deleteModal" class="modal-overlay">
        <div class="modal">
            <h3>Xác nhận xóa</h3>
            <p id="deleteMessage">Bạn có chắc muốn xóa bài viết này không?</p>

            <form id="deleteForm" method="post" action="blogAdmin">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="id" id="deleteBlogId">

                <div class="modal-actions">
                    <button type="button" class="btn-secondary" onclick="closeDeleteModal()">Hủy</button>
                    <button type="submit" class="btn-danger">Xóa</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/admin/adminBlog.js"></script>
</body>


</html>


