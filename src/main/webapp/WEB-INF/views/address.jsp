<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%
    request.setAttribute("pageCss", "views/address.css");
    request.setAttribute("pageTitle" , "Địa chỉ của tôi");
%>

<%@ include file="../include/header.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/views/address.css">

<!-- ========== NỘI DUNG CHÍNH ========== -->
<div class="address-container">

    <!-- ========== SIDEBAR ========== -->
    <div class="address-sidebar">
        <div class="user-info">
            <div class="avatar">
                <c:set var="avatarPath" value="${empty sessionScope.userlogin.avatarUrl ? 'img/avt.jpg' : sessionScope.userlogin.avatarUrl}" />
                <c:choose>
                    <c:when test="${fn:startsWith(avatarPath, 'http://') or fn:startsWith(avatarPath, 'https://')}">
                        <img src="${avatarPath}" alt="Avatar">
                    </c:when>
                    <c:otherwise>
                        <img src="${pageContext.request.contextPath}/${avatarPath}" alt="Avatar">
                    </c:otherwise>
                </c:choose>
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

    <!-- ========== ADDRESS CONTENT ========== -->
    <div class="address-content">

        <div class="address-header">
            <h2>Địa chỉ của tôi</h2>
            <button class="btn-add-address" id="btnOpenModal">
                <i class="fas fa-plus"></i> Thêm địa chỉ mới
            </button>
        </div>

        <!-- Danh sách địa chỉ -->
        <div class="address-list">

            <c:if test="${empty addressList}">
                <p>Bạn chưa có địa chỉ nào.</p>
            </c:if>

            <c:forEach var="a" items="${addressList}">
                <div class="address-card">

                    <div class="address-header">
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
                                <button type="submit" class="btn-default">
                                    Đặt làm mặc định
                                </button>
                            </form>
                        </c:if>

                        <button
                                type="button"
                                class="btn-edit"
                                onclick="openEditModal(
                                        '${a.id}',
                                        '${a.name}',
                                        '${a.phone}',
                                        '${a.city}',
                                        '${a.district}',
                                        '${a.ward}',
                                        '${a.detailAddress}',
                                    ${a.isDefault}
                                        )">
                            Sửa
                        </button>

                        <form method="post" action="address" style="display:inline">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id" value="${a.id}">
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

<div class="modal-overlay" id="addressModal">
    <div class="modal-content">

        <div class="modal-header">
            <h3>Thêm địa chỉ mới</h3>
            <span class="modal-close" id="btnCloseModal">&times;</span>
        </div>

        <form class="address-form" method="post" action="address">
            <input type="hidden" name="action" value="add">

            <div class="form-row">
                <div class="form-group">
                    <label>Họ và tên người nhận <span class="required">*</span></label>
                    <input type="text" name="name" required>
                </div>

                <div class="form-group">
                    <label>Số điện thoại <span class="required">*</span></label>
                    <input type="tel" name="phone" id="phoneInput" required>
                    <small id="phoneError" class="error-message"></small>
                </div>
            </div>

            <div class="form-row three-cols">
                <div class="form-group">
                    <label>Tỉnh / Thành phố <span class="required">*</span></label>
                    <select name="city" id="citySelect" required>
                        <option value="">-- Chọn --</option>
                        <option value="Hồ Chí Minh">Hồ Chí Minh</option>
                        <option value="Hà Nội">Hà Nội</option>
                        <option value="Bình Dương">Bình Dương</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Quận / Huyện <span class="required">*</span></label>
                    <select name="district" id="districtSelect" required disabled>
                        <option value="">-- Chọn --</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Phường / Xã <span class="required">*</span></label>
                    <select name="ward" id="wardSelect" required disabled>
                        <option value="">-- Chọn --</option>
                    </select>
                </div>
            </div>

            <div class="form-group">
                <label>Địa chỉ chi tiết <span class="required">*</span></label>
                <textarea name="detailAddress" rows="2" placeholder="Số nhà, tên đường..." required></textarea>
            </div>

            <div class="form-group">
                <label class="checkbox-label">
                    <input type="checkbox" name="isDefault">
                    Đặt làm địa chỉ mặc định
                </label>
            </div>

            <div class="form-actions">
                <button type="button" class="btn-cancel" id="btnCancelModal">
                    Hủy
                </button>
                <button type="submit" class="btn-save">
                    Lưu địa chỉ
                </button>
            </div>
        </form>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/views/address.js"></script>
<script src="${pageContext.request.contextPath}/js/views/avatar-upload.js"></script>
<!-- ========== FOOTER ========== -->
<%@ include file="../include/footer.jsp" %>


