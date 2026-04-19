<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<aside class="sidebar">
    <img src="${pageContext.request.contextPath}/img/logo.png" alt="Logo">
    <p>ADMIN</p>
    <div class="nav" id="menu">
        <a href="dashboardAdmin" class="nav-item ${page == 'dashboard' ? 'active' : ''}">
            <i class="fas fa-chart-line"></i> Thống Kê</a>
        <a href="userAdmin" class="nav-item ${page == 'user' ? 'active' : ''}">
            <i class="fas fa-users"></i> Người Dùng</a>
        <a href="categoryAdmin" class="nav-item ${page == 'category' ? 'active' : ''}">
            <i class="fas fa-tags"></i> Danh Mục</a>
        <a href="productAdmin" class="nav-item ${page == 'product' ? 'active' : ''}">
            <i class="fas fa-box"></i> Sản Phẩm</a>
        <a href="orderAdmin" class="nav-item ${page == 'order' ? 'active' : ''}">
            <i class="fas fa-shopping-cart"></i> Đơn Hàng</a>
        <a href="bannerAdmin" class="nav-item ${page == 'banner' ? 'active' : ''}">
            <i class="fas fa-image"></i> Banner</a>
        <a href="blogAdmin" class="nav-item ${page == 'blog' ? 'active' : ''}">
            <i class="fas fa-newspaper"></i> Bài Viết</a>
        <a href="contactAdmin" class="nav-item ${page == 'contact' ? 'active' : ''}">
            <i class="fas fa-envelope"></i> Liên hệ</a>
    </div>
</aside>