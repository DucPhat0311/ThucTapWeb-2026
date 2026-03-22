<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    request.setAttribute("pageTitle", "Quên mật khẩu");
    request.setAttribute("pageCss", "auth/forget.css");
%>

<%@ include file="../include/header.jsp" %>

<div class="forget-page">
    <div class="forget-image"></div>
    <main class="forget-container">
        <div class="forget-box">
            <a href="${pageContext.request.contextPath}/home">
                <button class="close-btn"><i class="fa-solid fa-arrow-left"></i></button>
            </a>

            <h2 class="quenMatKhau">Quên mật khẩu</h2>
            <form id="forgetForm" action="forgetPass" method="post">
                <div class="input-group">
                    <label for="email">Email đã đăng ký</label>
                    <input type="email" id="email" name="email" placeholder="Nhập email" required>
                </div>

                <button type="submit" class="btn-primary">Tiếp theo</button>
            </form>
                <div class="links">
                    <a href="login">Quay lại đăng nhập</a>
                    </div>
        </div>
    </main>
</div>

<%@ include file="../include/footer.jsp" %>

