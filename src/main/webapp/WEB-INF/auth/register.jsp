<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    request.setAttribute("pageTitle", "Đăng ký");
    request.setAttribute("pageCss", "auth/register.css");
%>

<%@ include file="../include/header.jsp" %>

<div class="register-page">
    <main class="register-container">
        <div class="register-box wide-box">
            <h2 class="dangKy">Đăng ký tài khoản</h2>
            <form class="registerForm" action="register" method="post">
                <div class="form-row">

                    <div class="input-group">
                        <label for="full_name">Họ và tên</label>
                        <input type="text" name="full_name" id="full_name" placeholder="Nhập họ và tên..." required>
                    </div>
                </div>

                <div class="form-row two-cols">
   
                    <div class="input-group">
                        <label for="username">Tên đăng nhập</label>
                        <input type="text" name="username" id="username" placeholder="Nhập tên đăng nhập..." required>
                    </div>

                    <div class="input-group">
                        <label for="email">Email</label>
                        <input type="email" name="email" id="email" placeholder="Nhập email..." required>
                    </div>
                </div>

                <div class="form-row two-cols">
    
                    <div class="input-group">
                        <label for="birthday">Ngày sinh</label>
                        <input type="date" name="birthday" id="birthday" required>
                    </div>

                    <div class="input-group select-group">
                        <label for="gender">Giới tính</label>
                        <select name="gender" id="gender" required>
                            <option value="" disabled selected>Chọn giới tính</option>
                            <option value="male">Nam</option>
                            <option value="female">Nữ</option>
                            <option value="other">Khác</option>
                        </select>
                    </div>
                </div>

                <div class="form-row two-cols">
                    <div class="input-group">
                        <label for="password">Mật khẩu</label>
                        <input type="password" name="password" id="password" placeholder="Nhập mật khẩu..." required>
                    </div>
                    <div class="input-group">
                        <label for="confirmPassword">Xác nhận mật khẩu</label>
                        <input type="password" name="repassword" id="confirmPassword" placeholder="Nhập lại mật khẩu..." required>
                    </div>
                </div>

                <button type="submit" class="btn-primary">Đăng Ký</button>

                <div class="notAccount">
                    <p>Đã có tài khoản? <a href="login">Đăng nhập</a></p>
                </div>
            </form>
        </div>
    </main>
</div>

<%@ include file="../include/footer.jsp" %>

