<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%
    request.setAttribute("pageCss", "views/profile.css");
    request.setAttribute("pageTitle" , "Profile");
%>

<%@include file="../include/header.jsp"%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/views/profile.css">

<!-- ========== PROFILE ========== -->
<section class="profile-container">
    <div class="profile-sidebar">
        <div class="user-info">
            <div class="avatar">
                <c:set var="avatarPath" value="${empty user.avatarUrl ? 'img/avt.jpg' : user.avatarUrl}" />
                <c:choose>
                    <c:when test="${fn:startsWith(avatarPath, 'http://') or fn:startsWith(avatarPath, 'https://')}">
                        <img src="${avatarPath}" alt="Avatar">
                    </c:when>
                    <c:otherwise>
                        <img src="${pageContext.request.contextPath}/${avatarPath}" alt="Avatar">
                    </c:otherwise>
                </c:choose>

                <form id="avatar-form" class="avatar-upload-form" method="post" action="profile" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="updateAvatar">
                    <input type="hidden" name="redirectTo" value="profile">
                    <input type="file"
                           id="avatarFileInput"
                           class="js-avatar-input"
                           name="avatarFile"
                           accept=".jpg,.jpeg,.png,.webp,image/jpeg,image/png,image/webp"
                           hidden>
                    <button type="button" class="change-avatar-btn js-avatar-trigger" id="btn-change-avatar">Đổi ảnh</button>
                </form>
            </div>
            <c:if test="${param.avatarUpdated == '1'}">
                <p class="avatar-message success">Đổi ảnh đại diện thành công.</p>
            </c:if>
            <c:if test="${param.avatarError == 'empty'}">
                <p class="avatar-message error">Vui lòng chọn ảnh trước khi tải lên.</p>
            </c:if>
            <c:if test="${param.avatarError == 'size'}">
                <p class="avatar-message error">Ảnh quá dung lượng (tối đa 5MB).</p>
            </c:if>
            <c:if test="${param.avatarError == 'type'}">
                <p class="avatar-message error">Chỉ hỗ trợ ảnh JPG, PNG hoặc WEBP.</p>
            </c:if>
            <c:if test="${param.avatarError == 'upload'}">
                <p class="avatar-message error">Không thể tải ảnh lên, vui lòng thử lại.</p>
            </c:if>
        </div>

        <nav class="profile-menu">
            <ul>
                <li class="active"><a href="profile"><i class="fas fa-user"></i> Thông tin cá nhân</a></li>
                <li><a href="address"><i class="fas fa-map-marker-alt"></i> Địa chỉ của tôi</a></li>
                <li><a href="order-user"><i class="fas fa-clipboard-list"></i> Đơn hàng của tôi</a></li>
                <li><a href="change-password"><i class="fas fa-lock"></i> Đổi mật khẩu</a></li>
                <li><a href="logout"><i class="fa fa-sign-out"></i> Đăng xuất</a></li>
            </ul>
        </nav>
    </div>

    <div class="profile-content">
        <h2>Thông tin cá nhân</h2>

        <form class="profile-form" method="post" action="profile" onsubmit="syncBirthday()">
            <input type="hidden" name="action" value="updateProfile">
            <div class="form-row">
                <div class="form-group">
                    <label for="fullname">Họ và tên</label>
                    <input type="text" id="fullname" name="fullname" value="${user.fullName}" disabled>
                </div>
                <div class="form-group">
                    <label for="phone">Số điện thoại</label>
                    <input type="tel" id="phone" name="phone" value="${user.phone}" disabled>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" value="${user.email}" disabled>
                </div>
                <div class="form-group">
                    <label for="birthday">Ngày sinh</label>
                    <input type="text" id="birthdayDisplay"
                           value="<fmt:formatDate value='${birthdayDate}' pattern='dd-MM-yyyy'/>" disabled>


                    <input type="hidden"
                           id="birthday"
                           name="birthday"
                           value="<fmt:formatDate value='${birthdayDate}' pattern='yyyy-MM-dd'/>">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="address">Địa chỉ</label>
                    <input type="text" id="address" name="address" value="${user.address}" disabled>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Giới tính</label>
                    <div class="radio-group">
                        <label>
                            <input type="radio" name="gender" value="male"
                            ${user.gender == 'male' ? 'checked' : ''} disabled>
                            Nam
                        </label>

                        <label>
                            <input type="radio" name="gender" value="female"
                            ${user.gender == 'female' ? 'checked' : ''} disabled>
                            Nữ
                        </label>

                        <label>
                            <input type="radio" name="gender" value="other"
                            ${user.gender == 'other' ? 'checked' : ''} disabled>
                            Khác
                        </label>

                    </div>
                </div>
            </div>

            <div class="form-actions">
                <button type="button" class="btn-edit" id="btn-edit-profile">Sửa</button>
                <button type="button" class="btn-cancel" id="btn-cancel-profile" style="display: none;">Hủy</button>
                <button type="submit" class="btn-save" id="btn-save-profile" style="display: none;">Lưu thay đổi</button>
            </div>
        </form>
    </div>
</section>
<script src="${pageContext.request.contextPath}/js/views/profile.js"></script>
<!-- ========== FOOTER ========== -->
<%@ include file="../include/footer.jsp" %>
