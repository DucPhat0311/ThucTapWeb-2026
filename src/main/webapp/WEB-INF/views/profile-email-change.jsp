<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    request.setAttribute("pageCss", "views/profile.css");
    request.setAttribute("pageTitle", "Xác minh email");
%>

<%@ include file="../include/header.jsp" %>

<section class="profile-email-change-page">
    <div class="profile-email-change-box">
        <a href="profile" class="profile-email-back">
            <i class="fa-solid fa-arrow-left"></i>
            Quay lại hồ sơ
        </a>

        <c:choose>
            <c:when test="${step == 'new'}">
                <h2>Xác minh email mới</h2>
                <p class="profile-email-note">
                    Mã OTP đã được gửi đến email mới <strong>${newEmail}</strong>.
                    Vui lòng kiểm tra email để tiếp tục xác minh.
                </p>
                <p class="profile-email-note muted">
                    Bước cập nhật email sẽ được hoàn tất sau khi xác minh mã OTP từ email mới.
                </p>
            </c:when>
            <c:otherwise>
                <h2>Xác minh email hiện tại</h2>
                <p class="profile-email-note">
                    Mã OTP đã được gửi đến email hiện tại của bạn. Nhập mã này để tiếp tục gửi OTP đến email mới
                    <strong>${newEmail}</strong>.
                </p>

                <c:if test="${not empty error}">
                    <div class="profile-email-error">${error}</div>
                </c:if>

                <form method="post" action="profile-email-change" class="profile-email-form">
                    <input type="hidden" name="step" value="old">
                    <label for="otp">Mã OTP email hiện tại</label>
                    <input type="text" id="otp" name="otp" inputmode="numeric" maxlength="6" pattern="[0-9]{6}" required>
                    <button type="submit">Xác nhận</button>
                </form>
            </c:otherwise>
        </c:choose>
    </div>
</section>

<%@ include file="../include/footer.jsp" %>
