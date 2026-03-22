<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    request.setAttribute("pageTitle", "Đăng nhập");
    request.setAttribute("pageCss", "auth/login.css");
%>

<%@ include file="../include/header.jsp" %>

<div class="login-page">
    <div class="login-image"></div>
   <section class="login-container">
    <div class="login-box">
      <a href="${pageContext.request.contextPath}/home">
        <button class="close-btn"><i class="fa-solid fa-xmark"></i></button>
      </a>
      <h2 class="dangNhap" >Đăng nhập</h2>
      <form id="loginForm" action="login" method="post">
        <div class="input-group">
          <label for="username">Email/Tên đăng nhập</label>
          <input type="text" id="username" name="username" placeholder="Nhập email/Tên tài khoản" required value="">
        </div>

        <div class="input-group">
          <label for="password">Mật khẩu</label>
          <input type="password" id="password" name="password" placeholder="Nhập mật khẩu" required>
        </div>


        <div class="remember-forgot">
            <a href="forget-password">Quên mật khẩu?</a>
        </div>
          <button type="submit" class="btn-primary">Đăng nhập</button>


        <div class="form-links">

          <p class="notAccount">Chưa có tài khoản? <a href="register">Đăng ký ngay</a></p>
        </div>
      </form>
    </div>
  </section>
</div>

<%@ include file="../include/footer.jsp" %>

