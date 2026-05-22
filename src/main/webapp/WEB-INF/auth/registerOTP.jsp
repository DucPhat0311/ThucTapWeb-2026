<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    request.setAttribute("pageTitle", "Xác nhận OTP");
    request.setAttribute("pageCss", "auth/login.css");
%>

<%@ include file="../include/header.jsp" %>

<div class="forget-page">
    <div class="forget-image"></div>
<main class="forget-container">
    <div class="forget-box" >
        <a href="${pageContext.request.contextPath}/home" class="close-btn">
            <i class="fa-solid fa-arrow-left"></i>
        </a>
        <h2 class="quenMatKhau" style="font-size: 2rem;">Nhập mã OTP</h2>
        <form id="forgetForm" action="sendOTP" method="post">
            <% if(request.getAttribute("error") != null) { %>
                <div class="error-message">${error}</div>
            <% } %>
            <div class="input-group">
                <input type="hidden" name="email" value="${param.email}">
                <input type="hidden" name="type" value="register">
                <input type="text" name="otp" placeholder="Nhập OTP 6 số" maxlength="6" pattern="[0-9]{6}" required>
            </div>
            <div class="resend" style="font-size:14px; margin-bottom:25px;">
                <span id="resendText">
                    Bạn vẫn chưa nhận được?
                    <a href="#" id="resendLink">Gửi lại</a>
                </span>
                <span id="countdown" style="display:none; color:#999999;">
                    Vui lòng chờ <b id="time">60</b> giây để gửi lại
                </span>
            </div>
            <button type="submit" class="btn-primary">Xác nhận</button>
        </form>
        <div class="form-links">
            <a href="login">Quay lại đăng nhập</a>
        </div>
    </div>
</main>
</div>

<%@ include file="../include/footer.jsp" %>

<script src="${pageContext.request.contextPath}/js/auth/enterOTP.js"></script>
