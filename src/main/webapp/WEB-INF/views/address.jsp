<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Địa chỉ của tôi - AURA Studio</title>
    <link rel="stylesheet" href="css/views/address.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

<!-- ========== HEADER ========== -->
<%@ include file="../include/header.jsp" %>

<!-- ========== ADDRESS ========== -->
<div class="address-container">

    <!-- ========== SIDEBAR ========== -->
    <div class="address-sidebar">
        <div class="user-info">
            <div class="avatar">
                <img src="img/avt.jpg" alt="Avatar">
                <button type="button" class="change-avatar-btn">Đổi ảnh</button>
            </div>
        </div>

        <nav class="profile-menu">
            <ul>
                <li>
                    <a href="#"><i class="fas fa-user"></i> Thông tin cá nhân</a>
                </li>
                <li class="active">
                    <a href="#"><i class="fas fa-map-marker-alt"></i> Địa chỉ của tôi</a>
                </li>
                <li>
                    <a href="#"><i class="fas fa-clipboard-list"></i> Đơn hàng của tôi</a>
                </li>
                <li>
                    <a href="#"><i class="fas fa-lock"></i> Đổi mật khẩu</a>
                </li>
                <li>
                    <a href="#"><i class="fa fa-sign-out"></i> Đăng xuất</a>
                </li>
            </ul>
        </nav>
    </div>

    <!-- ========== ADDRESS CONTENT ========== -->
    <div class="address-content">

        <div class="address-header">
            <h2>Địa chỉ của tôi</h2>
            <button type="button" class="btn-add-address" id="btnOpenModal">
                <i class="fas fa-plus"></i> Thêm địa chỉ mới
            </button>
        </div>

        <!-- ========== ADDRESS LIST ========== -->
        <div class="address-list">

            <div class="address-card">
                <div class="address-header">
                    <strong>Nguyễn Văn A</strong>
                    <span>0123456789</span>
                    <span class="badge-default">Mặc định</span>
                </div>

                <div class="address-body">
                    123 Nguyễn Trãi, Phường Bến Thành, Quận 1, Hồ Chí Minh
                </div>

                <div class="address-actions">
                    <button type="button" class="btn-edit">Sửa</button>
                    <button type="button" class="btn-delete">Xóa</button>
                </div>
            </div>

            <div class="address-card">
                <div class="address-header">
                    <strong>Trần Thị B</strong>
                    <span>0987654321</span>
                </div>

                <div class="address-body">
                    45 Lê Lợi, Phường Phú Cường, Thủ Dầu Một, Bình Dương
                </div>

                <div class="address-actions">
                    <button type="button" class="btn-default">Đặt làm mặc định</button>
                    <button type="button" class="btn-edit">Sửa</button>
                    <button type="button" class="btn-delete">Xóa</button>
                </div>
            </div>

        </div>
    </div>
</div>

<!-- ========== MODAL THÊM ĐỊA CHỈ ========== -->
<div class="modal-overlay" id="addressModal">
    <div class="modal-content">

        <div class="modal-header">
            <h3>Thêm địa chỉ mới</h3>
            <span class="modal-close" id="btnCloseModal">&times;</span>
        </div>

        <form class="address-form">
            <div class="form-row">
                <div class="form-group">
                    <label>Họ và tên người nhận <span class="required">*</span></label>
                    <input type="text" name="name">
                </div>

                <div class="form-group">
                    <label>Số điện thoại <span class="required">*</span></label>
                    <input type="tel" name="phone" id="phoneInput">
                    <small id="phoneError" class="error-message"></small>
                </div>
            </div>

            <div class="form-row three-cols">
                <div class="form-group">
                    <label>Tỉnh / Thành phố <span class="required">*</span></label>
                    <select name="city" id="citySelect">
                        <option value="">-- Chọn --</option>
                        <option value="Hồ Chí Minh">Hồ Chí Minh</option>
                        <option value="Hà Nội">Hà Nội</option>
                        <option value="Bình Dương">Bình Dương</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Quận / Huyện <span class="required">*</span></label>
                    <select name="district" id="districtSelect">
                        <option value="">-- Chọn --</option>
                        <option value="Quận 1">Quận 1</option>
                        <option value="Quận 3">Quận 3</option>
                        <option value="Thủ Dầu Một">Thủ Dầu Một</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Phường / Xã <span class="required">*</span></label>
                    <select name="ward" id="wardSelect">
                        <option value="">-- Chọn --</option>
                        <option value="Phường Bến Thành">Phường Bến Thành</option>
                        <option value="Phường Võ Thị Sáu">Phường Võ Thị Sáu</option>
                        <option value="Phường Phú Cường">Phường Phú Cường</option>
                    </select>
                </div>
            </div>

            <div class="form-group">
                <label>Địa chỉ chi tiết <span class="required">*</span></label>
                <textarea name="detailAddress" rows="2" placeholder="Số nhà, tên đường..."></textarea>
            </div>

            <div class="form-group">
                <label class="checkbox-label">
                    <input type="checkbox" name="isDefault">
                    Đặt làm địa chỉ mặc định
                </label>
            </div>

            <div class="form-actions">
                <button type="button" class="btn-cancel" id="btnCancelModal">Hủy</button>
                <button type="button" class="btn-save">Lưu địa chỉ</button>
            </div>
        </form>
    </div>
</div>

<!-- ========== FOOTER ========== -->
<%@ include file="../include/footer.jsp" %>

</body>
</html>