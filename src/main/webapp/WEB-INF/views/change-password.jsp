<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%
    request.setAttribute("pageCss", "views/change-password.css");
    request.setAttribute("pageTitle" , "Đổi mật khẩu");
%>

<%@include file="../include/header.jsp"%>


<!-- ========== ĐỔI MẬT KHẨU ========== -->
<section class="profile-container">
    <div class="profile-sidebar">
        <div class="user-info">
            <div class="avatar">
                <img src="${pageContext.request.contextPath}/img/avt.jpg" alt="Avatar">
                <button class="change-avatar-btn">Đổi ảnh</button>
            </div>
             <h3>${sessionScope.userlogin.fullName}</h3>
            <p>
                Thành viên từ:
                <fmt:formatDate value="${sessionScope.userlogin.createdAtDate}"
                                pattern="dd/MM/yyyy"/>
            </p>
        </div>

        <nav class="profile-menu">
            <ul>
                <li><a href="profile"><i class="fas fa-user"></i> Thông tin cá nhân</a></li>
                <li><a href="dia-chi"><i class="fas fa-map-marker-alt"></i> Địa chỉ của tôi</a></li>
                <li><a href="don-mua"><i class="fas fa-clipboard-list"></i> Đơn hàng của tôi</a></li>
                <li class="active"><a href="doi-mat-khau"><i class="fas fa-lock"></i> Đổi mật khẩu</a></li>
                <li><a href="logout"><i class="fa fa-sign-out"></i> Đăng xuất</a></li>
            </ul>
        </nav>
    </div>

    <div class="profile-content" >
        <h2>Đổi mật khẩu</h2>

        <form class="profile-form" method="post" action="doi-mat-khau">
            <div class="form-row">
                <div class="form-group">
                    <label for="oldpass">Mật khẩu hiện tại</label>
                    <input type="password" id="oldpass" name="oldpass" placeholder="Nhập mật khẩu cũ">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="newpass">Mật khẩu mới</label>
                    <input type="password" id="newpass" name="newpass" placeholder="Nhập mật khẩu mới">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="repass">Nhập lại mật khẩu mới</label>
                    <input type="password" id="repass" name="repass" placeholder="Nhập lại mật khẩu mới">
                </div>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn-save">Lưu mật khẩu</button>
            </div>
        </form>

        <c:if test="${not empty error}">
            <p style="color:red">${error}</p>
        </c:if>

    </div>
</section>

<!-- ========== FOOTER ========== -->
<%@ include file="../include/footer.jsp" %>
