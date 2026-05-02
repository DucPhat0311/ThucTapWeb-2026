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
            <c:if test="${not empty success}">
                <div class="alert alert-success">${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <div class="profile-container">
                <div class="profile-left">
                    <div class="avatar-container">
                        <img src="${pageContext.request.contextPath}/img/avatars/${adminInfo.avatarUrl}" alt="Avatar" id="avatar-preview">
                        <input type="file" id="avatar-upload" accept="image/*" style="display: none;">
                        <button class="upload-btn" onclick="document.getElementById('avatar-upload').click();">Chọn ảnh</button>
                    </div>
                    <div class="user-info-left">
                        <h4>${adminInfo.fullName}</h4>
                        <p>${adminInfo.email}</p>
                    </div>
                </div>
                <div class="profile-right">
                    <div class="info-section">
                        <h3>Thông tin cá nhân</h3>
                        <form action="${pageContext.request.contextPath}/profileAdmin" method="post">
                            <input type="hidden" name="action" value="updateProfile">
                            <div class="form-row">
                                <div class="form-group">
                                    <label for="username">Tên đăng nhập</label>
                                    <input type="text" id="username" name="username" value="${adminInfo.username}" readonly>
                                </div>
                                <div class="form-group">
                                    <label for="fullname">Họ và tên</label>
                                    <input type="text" id="fullname" name="fullName" value="${adminInfo.fullName}" required>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group">
                                    <label for="email">Email</label>
                                    <input type="email" id="email" name="email" value="${adminInfo.email}" required>
                                </div>
                                <div class="form-group">
                                    <label for="phone">Số điện thoại</label>
                                    <input type="text" id="phone" name="phone" value="${adminInfo.phone}">
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="address">Địa chỉ</label>
                                <input type="text" id="address" name="address" value="${adminInfo.address}">
                            </div>
                             <div class="form-row">
                                <div class="form-group">
                                    <label for="birthday">Ngày sinh</label>
                                    <input type="date" id="birthday" name="birthday" value="<fmt:formatDate value="${adminInfo.birthday}" pattern="yyyy-MM-dd" />">
                                </div>
                                <div class="form-group">
                                    <label for="gender">Giới tính</label>
                                    <select id="gender" name="gender">
                                        <option value="Nam" ${adminInfo.gender == 'Nam' ? 'selected' : ''}>Nam</option>
                                        <option value="Nữ" ${adminInfo.gender == 'Nữ' ? 'selected' : ''}>Nữ</option>
                                        <option value="Khác" ${adminInfo.gender == 'Khác' ? 'selected' : ''}>Khác</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-actions">
                                <button type="submit" class="btn-save">Lưu thay đổi</button>
                            </div>
                        </form>
                    </div>
                    <div class="password-section">
                        <h3>Đổi mật khẩu</h3>
                        <form action="${pageContext.request.contextPath}/profileAdmin" method="post">
                            <input type="hidden" name="action" value="changePassword">
                            <div class="form-group password-group">
                                <label for="current-password">Mật khẩu hiện tại</label>
                                <input type="password" id="current-password" name="currentPassword" required>
                                <i class="fas fa-eye" id="toggle-current-password" onclick="togglePassword('current-password', 'toggle-current-password')"></i>
                            </div>
                            <div class="form-group password-group">
                                <label for="new-password">Mật khẩu mới</label>
                                <input type="password" id="new-password" name="newPassword" required>
                                <i class="fas fa-eye" id="toggle-new-password" onclick="togglePassword('new-password', 'toggle-new-password')"></i>
                            </div>
                            <div class="form-group password-group">
                                <label for="confirm-password">Xác nhận mật khẩu mới</label>
                                <input type="password" id="confirm-password" name="confirmPassword" required>
                                <i class="fas fa-eye" id="toggle-confirm-password" onclick="togglePassword('confirm-password', 'toggle-confirm-password')"></i>
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
<script src="${pageContext.request.contextPath}/js/auth/register.js"></script>
</body>
</html>
