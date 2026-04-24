<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Hồ Sơ Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/profileAdmin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/sidebarAdmin.css">
</head>
<body>
<div class="container">

    <jsp:include page="include/sidebarAdmin.jsp"/>

    <main class="main-content">
        <header class="topbar">
            <h1>Hồ Sơ Admin</h1>
            <a href="${pageContext.request.contextPath}/logout" id="logout">Đăng xuất</a>
        </header>

        <section class="content">
 
            <div class="profile-container">
                <div class="profile-left">
                    <div class="avatar-container">
                        <img src="https://vnn-imgs-a1.vgcloud.vn/znews-photo.zadn.vn/w660/Uploaded/wyhktpu/2021_11_15/250721_lisa_solo_mv_making_1_1.jpg" alt="Avatar" id="avatar-preview">
                        <input type="file" id="avatar-upload" accept="image/*" style="display: none;">
                        <button class="upload-btn" onclick="document.getElementById('avatar-upload').click();">Chọn ảnh</button>
                    </div>
                    <div class="user-info-left">
                        <h4>Admin</h4>
                        <p>admin@example.com</p>
                    </div>
                </div>
                <div class="profile-right">
                    <div class="info-section">
                        <h3>Thông tin cá nhân</h3>
                        <form action="" method="post">
                            <div class="form-row">
                                <div class="form-group">
                                    <label for="username">Tên đăng nhập</label>
                                    <input type="text" id="username" name="username" value="admin" readonly>
                                </div>
                                <div class="form-group">
                                    <label for="fullname">Họ và tên</label>
                                    <input type="text" id="fullname" name="fullname" value="Admin" required>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group">
                                    <label for="email">Email</label>
                                    <input type="email" id="email" name="email" value="admin@example.com" required>
                                </div>
                                <div class="form-group">
                                    <label for="phone">Số điện thoại</label>
                                    <input type="text" id="phone" name="phone" value="0123456789">
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="address">Địa chỉ</label>
                                <input type="text" id="address" name="address" value="123 Đường ABC, Quận 1, TP. HCM">
                            </div>
                            <div class="form-actions">
                                <button type="submit" class="btn-save">Lưu thay đổi</button>
                            </div>
                        </form>
                    </div>
                    <div class="password-section">
                        <h3>Đổi mật khẩu</h3>
                        <form action="" method="post">
                            <div class="form-group">
                                <label for="current-password">Mật khẩu hiện tại</label>
                                <input type="password" id="current-password" name="current-password" required>
                            </div>
                            <div class="form-group">
                                <label for="new-password">Mật khẩu mới</label>
                                <input type="password" id="new-password" name="new-password" required>
                            </div>
                            <div class="form-group">
                                <label for="confirm-password">Xác nhận mật khẩu mới</label>
                                <input type="password" id="confirm-password" name="confirm-password" required>
                            </div>
                            <div class="form-actions">
                                <button type="submit" class="btn-save">Đổi mật khẩu</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </section>
    </main>
</div>
</body>
</html>
