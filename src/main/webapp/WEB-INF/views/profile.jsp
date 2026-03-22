<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thông tin cá nhân</title>
    <link rel="stylesheet" href="css/views/profile.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

<!-- ========== HEADER ========== -->
<%@ include file="../include/header.jsp" %>

<!-- ========== PROFILE ========== -->
<section class="profile-container">
    <div class="profile-sidebar">
        <div class="user-info">
            <div class="avatar">
                <img src="img/avt.jpg" alt="Avatar">
                <button type="button" class="change-avatar-btn">Đổi ảnh</button>
            </div>
        </div>
        <!-- ========== PROFILE MENU ========== -->
        <nav class="profile-menu">
            <ul>
                <li class="active"><a href="#"><i class="fas fa-user"></i> Thông tin cá nhân</a></li>
                <li><a href="#"><i class="fas fa-map-marker-alt"></i> Địa chỉ của tôi</a></li>
                <li><a href="#"><i class="fas fa-clipboard-list"></i> Đơn hàng của tôi</a></li>
                <li><a href="#"><i class="fas fa-lock"></i> Đổi mật khẩu</a></li>
                <li><a href="#"><i class="fa fa-sign-out"></i> Đăng xuất</a></li>
            </ul>
        </nav>
    </div>

    <div class="profile-content">
        <h2>Thông tin cá nhân</h2>

        <form class="profile-form">
            <div class="form-row">
                <div class="form-group">
                    <label for="fullname">Họ và tên</label>
                    <input type="text" id="fullname" name="fullname" value="Nguyễn Văn A" disabled>
                </div>
                <div class="form-group">
                    <label for="phone">Số điện thoại</label>
                    <input type="tel" id="phone" name="phone" value="0123456789" disabled>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" value="nguyenvana@gmail.com" disabled>
                </div>
                <div class="form-group">
                    <label for="birthdayDisplay">Ngày sinh</label>
                    <input type="text" id="birthdayDisplay" value="01-01-2000" disabled>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="address">Địa chỉ</label>
                    <input type="text" id="address" name="address" value="TP. Hồ Chí Minh" disabled>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Giới tính</label>
                    <div class="radio-group">
                        <label><input type="radio" name="gender" checked disabled> Nam</label>
                        <label><input type="radio" name="gender" disabled> Nữ</label>
                        <label><input type="radio" name="gender" disabled> Khác</label>
                    </div>
                </div>
            </div>

            <div class="form-actions">
                <button type="button" class="btn-edit">Sửa</button>
                <button type="button" class="btn-cancel" style="display: none;">Hủy</button>
                <button type="button" class="btn-save" style="display: none;">Lưu thay đổi</button>
            </div>
        </form>
    </div>
</section>

<!-- ========== FOOTER ========== -->
<%@ include file="../include/footer.jsp" %>

</body>
</html>
