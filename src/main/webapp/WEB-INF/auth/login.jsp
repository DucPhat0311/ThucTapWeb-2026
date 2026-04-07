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
        <%
            String error = (String) request.getAttribute("error");
            String errorUsername = (String) request.getAttribute("errorUsername");
            String errorPassword = (String) request.getAttribute("errorPassword");
            String errorParam = request.getParameter("error");

            if (error == null && errorParam != null) {
                if ("loginError".equals(errorParam)) {
                    error = "Vui lòng đăng nhập bằng tài khoản Admin để truy cập trang này!";
                }
            }

            String errorUsernameValue = errorUsername == null ? "" : errorUsername;
            String errorPasswordValue = errorPassword == null ? "" : errorPassword;
            if (error == null) error = "";

            String username = request.getParameter("username");
            if (username == null) {
                Object usernameAttr = request.getAttribute("username");
                username = usernameAttr == null ? "" : usernameAttr.toString();
            }
        %>

        <div class="login-box">
            <a href="${pageContext.request.contextPath}/home">
                <button class="close-btn"><i class="fa-solid fa-xmark"></i></button>
            </a>

            <h2 class="dangNhap">Đăng nhập</h2>

            <form id="loginForm" action="login" method="post" novalidate>
                <% if (!error.isEmpty()) { %>
                    <div class="error-message"><%=error%></div>
                <% } %>

                <div class="input-group">
                    <label for="username">Email/Tên đăng nhập</label>
                    <input type="text" id="username" name="username"
                           class="<%= !errorUsernameValue.isEmpty() ? "input-invalid" : "" %>"
                           placeholder="Nhập email/Tên tài khoản"
                           value="<%=username%>">
                    <small id="usernameError"
                           class="field-error <%= errorUsernameValue.isEmpty() ? "is-hidden" : "" %>"><%=errorUsernameValue%></small>
                </div>

                <div class="input-group">
                    <label for="password">Mật khẩu</label>
                    <input type="password" id="password" name="password"
                           class="<%= !errorPasswordValue.isEmpty() ? "input-invalid" : "" %>"
                           placeholder="Nhập mật khẩu">
                    <span class="toggle-password" onclick="togglePassword('password','eye')"
                          style="position:absolute; right:18px; top:44px; cursor:pointer;">
                        <i class="fa-solid fa-eye" id="eye" style="color:#6F4E37;"></i>
                    </span>
                    <small id="passwordError"
                           class="field-error <%= errorPasswordValue.isEmpty() ? "is-hidden" : "" %>"><%=errorPasswordValue%></small>
                </div>

                <div class="remember-forgot">
                    <a href="forgetPass">Quên mật khẩu?</a>
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
<script src="${pageContext.request.contextPath}/js/auth/register.js"></script>
<script src="${pageContext.request.contextPath}/js/auth/login.js"></script>
