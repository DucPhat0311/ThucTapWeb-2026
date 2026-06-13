<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="aura" uri="/WEB-INF/tlds/aura.tld" %>
<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Blog</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/sidebarAdmin.css?v=<%= System.currentTimeMillis() %>">
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
                    <div class="card" style="cursor: pointer;" onclick="window.location.href='${pageContext.request.contextPath}/blogAdmin'">
                        Tổng bài viết<br><span>${total}</span></div>
                    <div class="card" style="cursor: pointer;" onclick="window.location.href='${pageContext.request.contextPath}/blogAdmin?status=1'">
                        Đang hiển thị<br><span>${totalActive}</span></div>
                    <div class="card" style="cursor: pointer;" onclick="window.location.href='${pageContext.request.contextPath}/blogAdmin?status=0'">
                        Đang ẩn<br><span>${totalHidden}</span></div>
                </div>

                <div class="toolbar">
                    <c:if test="${perms[\'add\']}">
<a href="${pageContext.request.contextPath}/blogAdmin?mode=add" class="btn-add">
                        <i class="fa fa-plus"></i> Thêm bài viết
                    </a>
</c:if>
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
                                    <img src="${aura:resolve(pageContext.request.contextPath, '', n.img, '')}">
                                </td>
                                <td>${n.title}</td>
                                <td>${n.createdAt}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${n.status == 1}">
                                            <span class="stock-badge in-stock">Hiển thị</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="stock-badge out-of-stock">Ẩn</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="actions">
                                    <!-- XEM -->
                                    <c:if test="${perms[\'view_detail\']}">
<a href="${pageContext.request.contextPath}/blogAdmin?mode=view&id=${n.id}"
                                       class="icon-btn view" title="Xem chi tiết">
                                        <i class="fa fa-eye"></i>
                                    </a>
</c:if>

                                    <!-- SỬA -->
                                    <c:if test="${perms[\'edit\']}">
<a href="${pageContext.request.contextPath}/blogAdmin?mode=edit&id=${n.id}"
                                       class="icon-btn edit" title="Chỉnh sửa">
                                        <i class="fa fa-pen"></i>
                                    </a>
</c:if>

                                    <!-- XÓA MỀM -->
                                    <c:if test="${perms[\'delete\']}">
<button type="button"
                                            class="icon-btn delete"
                                            title="Xóa tin tức"
                                            onclick="openDeleteModal(${n.id}, '${n.title}')">
                                        <i class="fa fa-trash"></i>
                                    </button>
</c:if>
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
                            totalItems ? totalItems : currentPage * pageSize} của ${totalItems} bài viết
                        </div>

                        <div class="pagination-controls">
                            <c:if test="${currentPage > 1}">
                                <a href="${pageContext.request.contextPath}/blogAdmin?page=1${qs}"
                                   class="page-btn">Đầu</a>
                                <a href="${pageContext.request.contextPath}/blogAdmin?page=${currentPage - 1}${qs}"
                                   class="page-btn">Trước</a>
                            </c:if>

                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <c:choose>
                                    <c:when test="${i == currentPage}">
                                        <span class="page-btn active">${i}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/blogAdmin?page=${i}${qs}"
                                           class="page-btn">${i}</a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>

                            <c:if test="${currentPage < totalPages}">
                                <a href="${pageContext.request.contextPath}/blogAdmin?page=${currentPage + 1}${qs}"
                                   class="page-btn">Sau</a>
                                <a href="${pageContext.request.contextPath}/blogAdmin?page=${totalPages}${qs}"
                                   class="page-btn">Cuối</a>
                            </c:if>
                        </div>
                    </div>
                </c:if>
            </section>
        </main>
    </section>

    <!-- MODAL XÓA -->
    <div id="deleteModal" class="modal-overlay">
        <div class="modal">
            <h3>Xác nhận xóa</h3>
            <p id="deleteMessage">Bạn có chắc muốn xóa bài viết này không?</p>

            <form id="deleteForm" method="post" action="${pageContext.request.contextPath}/blogAdmin">
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


