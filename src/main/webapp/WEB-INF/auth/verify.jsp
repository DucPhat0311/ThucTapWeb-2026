<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    request.setAttribute("pageTitle", "Xác minh OTP");
    request.setAttribute("pageCss", "auth/forget.css");
%>

<%@ include file="../include/header.jsp" %>

<div class="forget-page">
    <div class="forget-image"></div>
    <main class="forget-container">
        <div class="forget-box">
            <a href="fpcl">
                <button class="close-btn"><i class="fa-solid fa-arrow-left"></i></button>
            </a>
            <h2 class="quenMatKhau">Nhập mã xác nhận</h2>
            <p style="color:#5c4033; margin-bottom:1.5rem; text-align:center;">
                Mã xác minh đã được gửi đến Email<br>
                <strong>meomeo@gmail.com</strong>
            </p>
            <form action="enterOTP" method="post" onsubmit="return joinOtp()">
                <input type="hidden" name="email" value="">
                <input type="hidden" name="otp" id="otp">
                <input type="hidden" name="type" value="">
                <div class="otp-line">
                    <input type="text" maxlength="1" class="o" inputmode="numeric">
                    <input type="text" maxlength="1" class="o" inputmode="numeric">
                    <input type="text" maxlength="1" class="o" inputmode="numeric">
                    <input type="text" maxlength="1" class="o" inputmode="numeric">
                    <input type="text" maxlength="1" class="o" inputmode="numeric">
                    <input type="text" maxlength="1" class="o" inputmode="numeric">
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
                <button type="submit" class="btn-primary" id="submitBtn">TIẾP THEO</button>
            </form>
        </div>
    </main>
</div>
<%@ include file="../include/footer.jsp" %>
</html>
