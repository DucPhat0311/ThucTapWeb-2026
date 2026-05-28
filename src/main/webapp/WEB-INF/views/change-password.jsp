<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<%
    request.setAttribute("pageCss", "views/change-password.css");
    request.setAttribute("pageTitle" , "Đổi mật khẩu");
%>
<%@include file="../include/header.jsp"%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/views/change-password.css">

<section class="profile-container">
    <div class="profile-sidebar">
        <div class="user-info">
            <div class="avatar">
                <c:set var="avatarPath" value="${empty sessionScope.userlogin.avatarUrl ? 'img/avt.jpg' : sessionScope.userlogin.avatarUrl}" />
                <c:choose>
                    <c:when test="${fn:startsWith(avatarPath, 'http://') or fn:startsWith(avatarPath, 'https://')}">
                        <img src="${avatarPath}" alt="Avatar">
                    </c:when>
                    <c:otherwise>
                        <img src="${pageContext.request.contextPath}/${avatarPath}" alt="Avatar">
                    </c:otherwise>
                </c:choose>
                <form class="avatar-upload-form" method="post" action="profile" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="updateAvatar">
                    <input type="hidden" name="redirectTo" value="change-password">
                    <input type="file"
                           class="js-avatar-input"
                           name="avatarFile"
                           accept=".jpg,.jpeg,.png,.webp,image/jpeg,image/png,image/webp"
                           hidden>
                    <button type="button" class="change-avatar-btn js-avatar-trigger">Đổi ảnh</button>
                </form>
            </div>
            <h3>${empty sessionScope.userlogin.fullName ? sessionScope.userlogin.username : sessionScope.userlogin.fullName}</h3>
            <p>${sessionScope.userlogin.email}</p>
        </div>

        <nav class="profile-menu">
            <ul>
                <li><a href="profile"><i class="fas fa-user"></i> Thông tin cá nhân</a></li>
                <li><a href="address"><i class="fas fa-map-marker-alt"></i> Địa chỉ của tôi</a></li>
                <li><a href="order-user"><i class="fas fa-clipboard-list"></i> Đơn hàng của tôi</a></li>
                <li class="active"><a href="change-password"><i class="fas fa-lock"></i> Đổi mật khẩu</a></li>
                <li><a href="logout"><i class="fa fa-sign-out"></i> Đăng xuất</a></li>
            </ul>
        </nav>
    </div>

    <div class="profile-content" >
        <div class="profile-heading">
            <h2>Đổi mật khẩu</h2>
        </div>

        <form class="profile-form" method="post" action="change-password">
            <div class="form-row">
                <div class="form-group">
                    <label for="oldpass">Mật khẩu hiện tại</label>
                    <div class="password-input-wrap">
                        <input type="password" id="oldpass" name="oldpass" placeholder="Nhập mật khẩu cũ">
                        <button type="button" class="toggle-password-btn" data-target="oldpass" aria-label="Hiển thị mật khẩu">
                            <i class="fa-solid fa-eye"></i>
                        </button>
                    </div>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="newpass">Mật khẩu mới</label>
                    <div class="password-input-wrap">
                        <input type="password" id="newpass" name="newpass" placeholder="Nhập mật khẩu mới">
                        <button type="button" class="toggle-password-btn" data-target="newpass" aria-label="Hiển thị mật khẩu">
                            <i class="fa-solid fa-eye"></i>
                        </button>
                    </div>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="repass">Nhập lại mật khẩu mới</label>
                    <div class="password-input-wrap">
                        <input type="password" id="repass" name="repass" placeholder="Nhập lại mật khẩu mới">
                        <button type="button" class="toggle-password-btn" data-target="repass" aria-label="Hiển thị mật khẩu">
                            <i class="fa-solid fa-eye"></i>
                        </button>
                    </div>
                </div>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn-save">Lưu mật khẩu</button>
            </div>
        </form>

        <c:if test="${not empty error}">
            <p style="color:red">${error}</p>
        </c:if>

    </div>
</section>

<script src="${pageContext.request.contextPath}/js/views/avatar-upload.js"></script>
<script>
    document.querySelectorAll(".toggle-password-btn").forEach(button => {
        button.addEventListener("click", () => {
            const input = document.getElementById(button.dataset.target);
            const icon = button.querySelector("i");
            const showing = input.type === "text";
            input.type = showing ? "password" : "text";
            icon.classList.toggle("fa-eye", showing);
            icon.classList.toggle("fa-eye-slash", !showing);
            button.setAttribute("aria-label", showing ? "Hiển thị mật khẩu" : "Ẩn mật khẩu");
        });
    });
</script>
<%@ include file="../include/footer.jsp" %>
