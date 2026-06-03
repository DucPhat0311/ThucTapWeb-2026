<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="aura" uri="/WEB-INF/tlds/aura.tld" %>

<%
    request.setAttribute("pageCss", "views/address.css");
    request.setAttribute("pageTitle", "Địa chỉ của tôi");
%>

<%@ include file="../include/header.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/views/address.css">

<div class="profile-container address-container">
    <div class="profile-sidebar address-sidebar">
        <div class="user-info">
            <div class="avatar">
                <c:set var="avatarPath" value="${empty sessionScope.userlogin.avatarUrl ? 'img/avt.jpg' : sessionScope.userlogin.avatarUrl}" />
                <img src="${aura:resolve(pageContext.request.contextPath, '', avatarPath, 'img/avt.jpg')}" alt="Avatar">
                <form class="avatar-upload-form" method="post" action="profile" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="updateAvatar">
                    <input type="hidden" name="redirectTo" value="address">
                    <input type="file"
                           class="js-avatar-input"
                           name="avatarFile"
                           accept=".jpg,.jpeg,.png,.webp,image/jpeg,image/png,image/webp"
                           hidden>
                    <button type="button" class="change-avatar-btn js-avatar-trigger">Đổi ảnh</button>
                </form>
            </div>
            <h3>${empty sessionScope.userlogin.fullName ? sessionScope.userlogin.username : sessionScope.userlogin.fullName}</h3>
            <p>${sessionScope.userlogin.email}</p>
        </div>

        <nav class="profile-menu">
            <ul>
                <li>
                    <a href="profile">
                        <i class="fas fa-user"></i> Thông tin cá nhân
                    </a>
                </li>
                <li class="active">
                    <a href="address">
                        <i class="fas fa-map-marker-alt"></i> Địa chỉ của tôi
                    </a>
                </li>
                <li>
                    <a href="order-user">
                        <i class="fas fa-clipboard-list"></i> Đơn hàng của tôi
                    </a>
                </li>
                <li>
                    <a href="change-password">
                        <i class="fas fa-lock"></i> Đổi mật khẩu
                    </a>
                </li>
                <li>
                    <a href="logout">
                        <i class="fa fa-sign-out"></i> Đăng xuất
                    </a>
                </li>
            </ul>
        </nav>
    </div>

    <div class="profile-content address-content">
        <div class="profile-heading address-page-heading">
            <h2>Địa chỉ của tôi</h2>
            <div class="address-heading-actions">
                <c:if test="${returnToCheckout}">
                    <a href="${pageContext.request.contextPath}/checkout" class="btn-return-checkout">
                        <i class="fas fa-arrow-left"></i> Quay lại thanh toán
                    </a>
                </c:if>
                <button class="btn-add-address" id="btnOpenModal">
                    <i class="fas fa-plus"></i> Thêm địa chỉ mới
                </button>
            </div>
        </div>

        <c:if test="${not empty addressError}">
            <div class="address-alert address-alert-error">
                ${addressError}
            </div>
        </c:if>

        <div class="address-list">
            <c:if test="${empty addressList}">
                <p class="empty-msg">Bạn chưa có địa chỉ nào.</p>
            </c:if>

            <c:forEach var="a" items="${addressList}">
                <div class="address-card">
                    <div class="address-card-header">
                        <strong>${a.name}</strong>
                        <span>${a.phone}</span>

                        <c:if test="${a.isDefault}">
                            <span class="badge-default">Mặc định</span>
                        </c:if>
                    </div>

                    <div class="address-body">
                        ${a.detailAddress}, ${a.ward}, ${a.district}, ${a.city}
                    </div>

                    <div class="address-actions">
                        <c:if test="${!a.isDefault}">
                            <form method="post" action="address" style="display:inline">
                                <input type="hidden" name="action" value="setDefault">
                                <input type="hidden" name="id" value="${a.id}">
                                <c:if test="${returnToCheckout}">
                                    <input type="hidden" name="redirectTo" value="checkout">
                                </c:if>
                                <button type="submit" class="btn-default">
                                    Đặt làm mặc định
                                </button>
                            </form>
                        </c:if>

                        <button
                                type="button"
                                class="btn-edit"
                                data-address-id="${a.id}"
                                data-name="${fn:escapeXml(a.name)}"
                                data-phone="${fn:escapeXml(a.phone)}"
                                data-city="${fn:escapeXml(a.city)}"
                                data-province-code="${a.provinceCode}"
                                data-district="${fn:escapeXml(a.district)}"
                                data-district-code="${a.districtCode}"
                                data-ward="${fn:escapeXml(a.ward)}"
                                data-ward-code="${a.wardCode}"
                                data-detail="${fn:escapeXml(a.detailAddress)}"
                                data-default="${a.isDefault}">
                            Sửa
                        </button>

                        <form method="post" action="address" style="display:inline">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id" value="${a.id}">
                            <c:if test="${returnToCheckout}">
                                <input type="hidden" name="redirectTo" value="checkout">
                            </c:if>
                            <button type="submit" class="btn-delete">
                                Xóa
                            </button>
                        </form>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</div>

<jsp:include page="address-modal.jsp">
    <jsp:param name="formAction" value="address" />
    <jsp:param name="redirectTo" value="${addressRedirectTo}" />
</jsp:include>

<script>
    window.APP_CONTEXT_PATH = "${pageContext.request.contextPath}";
</script>
<script src="${pageContext.request.contextPath}/js/views/address.js"></script>
<script src="${pageContext.request.contextPath}/js/views/avatar-upload.js"></script>
<%@ include file="../include/footer.jsp" %>
