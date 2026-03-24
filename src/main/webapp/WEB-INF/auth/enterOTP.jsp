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
            <div class="input-group">
                <input type="hidden" name="email" value="${param.email}">
                <input type="text" name="otp" placeholder="Nhập OTP 6 số" maxlength="6" pattern="[0-9]{6}" required>
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

