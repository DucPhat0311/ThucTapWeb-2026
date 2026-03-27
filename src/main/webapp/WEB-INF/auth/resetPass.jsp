<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    request.setAttribute("pageTitle", "Đặt lại mật khẩu");
    request.setAttribute("pageCss", "auth/forget.css");
%>

<%@ include file="../include/header.jsp" %>


<div class="forget-page">
    <div class="forget-image"></div>

<main class="forget-container">
    <div class="forget-box">

        <a href="sendOTP">
            <button class="close-btn"><i class="fa-solid fa-arrow-left"></i></button>
        </a>


        <h2 class="quenMatKhau">Thiết Lập Mật Khẩu</h2>
        <div class="reset-email">Tạo mật khẩu mới cho <span style="color:#4a332a; font-size:1.15rem; font-weight:700;">${param.email}</span></div>

        <form action="resetPass" method="post">
            <input type="hidden" name="email" value="${param.email}">
            <input type="hidden" name="otp" value="${param.otp}">


            <label class="reset-label" for="password">Mật khẩu mới</label>
            <div class="input-group password-group">
                <input type="password" id="password" name="password" placeholder="Mật khẩu mới">
                <span class="toggle-password" data-target="password">
                    <i class="fa-solid fa-eye"></i>
                </span>
            </div>

            <label class="reset-label" for="confirmPassword">Xác nhận mật khẩu</label>
            <div class="input-group password-group">
                <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Nhập lại mật khẩu mới">
                <span class="toggle-password" data-target="confirmPassword">
                    <i class="fa-solid fa-eye"></i>
                </span>
            </div>
            <div id="match-error">Mật khẩu xác nhận không khớp!</div>

            <ul class="rules">
                <li id="rule-lower">Ít nhất một kí tự viết thường.</li>
                <li id="rule-upper">Ít nhất một kí tự viết hoa.</li>
                <li id="rule-length">8–16 kí tự.</li>
                <li id="rule-digit">Có số.</li>
                <li id="rule-special">Ký tự đặc biệt.</li>
            </ul>

            <button type="submit" class="btn-primary" id="submitBtn" disabled>TIẾP THEO</button>
        </form>

    </div>
</main>
</div>

<%@ include file="../include/footer.jsp" %>

<script src="${pageContext.request.contextPath}/js/auth/resetPass.js"></script>
