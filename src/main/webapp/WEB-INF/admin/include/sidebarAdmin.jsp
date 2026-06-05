<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <aside class="sidebar">
            <div class="sidebar-header">
                <img src="${pageContext.request.contextPath}/img/logo.png" alt="Logo" class="sidebar-logo">
                <div class="admin-badge">Quản Trị Viên</div>
            </div>
            <div class="nav" id="menu">
                <a href="${pageContext.request.contextPath}/dashboardAdmin"
                    class="nav-item ${page == 'dashboard' ? 'active' : ''}">
                    <i class="fas fa-chart-line"></i> Thống Kê</a>
                <a href="${pageContext.request.contextPath}/userAdmin"
                    class="nav-item ${page == 'user' ? 'active' : ''}">
                    <i class="fas fa-users"></i> Người Dùng</a>
                <a href="${pageContext.request.contextPath}/categoryAdmin"
                    class="nav-item ${page == 'category' ? 'active' : ''}">
                    <i class="fas fa-tags"></i> Danh Mục</a>
                <a href="${pageContext.request.contextPath}/productAdmin"
                    class="nav-item ${page == 'product' ? 'active' : ''}">
                    <i class="fas fa-box"></i> Sản Phẩm</a>
                <a href="${pageContext.request.contextPath}/orderAdmin"
                    class="nav-item ${page == 'order' ? 'active' : ''}">
                    <i class="fas fa-shopping-cart"></i> Đơn Hàng</a>
                <a href="${pageContext.request.contextPath}/returnAdmin"
                    class="nav-item ${page == 'return' ? 'active' : ''}">
                    <i class="fas fa-rotate-left"></i> Trả Hàng</a>
                <a href="${pageContext.request.contextPath}/bannerAdmin"
                    class="nav-item ${page == 'banner' ? 'active' : ''}">
                    <i class="fas fa-image"></i> Banner</a>
                <a href="${pageContext.request.contextPath}/blogAdmin"
                    class="nav-item ${page == 'blog' ? 'active' : ''}">
                    <i class="fas fa-newspaper"></i> Bài Viết</a>
                <a href="${pageContext.request.contextPath}/contactAdmin"
                    class="nav-item ${page == 'contact' ? 'active' : ''}">
                    <i class="fas fa-envelope"></i> Liên hệ</a>
                <a href="${pageContext.request.contextPath}/warehouseAdmin"
                    class="nav-item ${page == 'warehouse' ? 'active' : ''}">
                    <i class="fas fa-warehouse"></i> Quản Lý Kho</a>
                <a href="${pageContext.request.contextPath}/roleAdmin"
                    class="nav-item ${page == 'role' ? 'active' : ''}">
                    <i class="fas fa-user-shield"></i> Phân Quyền</a>
                <a href="${pageContext.request.contextPath}/profileAdmin"
                    class="nav-item ${page == 'profile' ? 'active' : ''}">
                    <i class="fas fa-user-circle"></i> Hồ Sơ Admin</a>
            </div>
        </aside>

        <c:if test="${not empty sessionScope.access_denied}">
            <c:remove var="access_denied" scope="session" />
            <div id="accessDeniedToast" class="toast toast-error">
                <i class="fa-solid fa-circle-exclamation"></i> Không có quyền truy cập tính năng này!
            </div>
            <script>
                document.addEventListener('DOMContentLoaded', function () {
                    var toast = document.getElementById('accessDeniedToast');
                    if (toast) {
                        setTimeout(function () {
                            toast.classList.add('show');
                        }, 100);
                        setTimeout(function () {
                            toast.classList.remove('show');
                        }, 3000);
                    }
                });
            </script>
        </c:if>