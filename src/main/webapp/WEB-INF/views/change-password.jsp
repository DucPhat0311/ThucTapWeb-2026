<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đổi mật khẩu - AURA Studio</title>
    <link rel="stylesheet" href="css/views/change-password.css">
    <link rel="stylesheet" href="css/views/shared-profile.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

<!-- ========== HEADER ========== -->
<%@ include file="../include/header.jsp" %>

<!-- ========== ĐỔI MẬT KHẨU ========== -->
<section class="profile-container">
    <div class="profile-sidebar">
        <div class="user-info">
            <div class="avatar">
                <img src="img/avt.jpg" alt="Avatar">
                <button type="button" class="change-avatar-btn">Đổi ảnh</button>
            </div>
            <h3>Nguyễn Văn A</h3>
            <p>Thành viên từ: 01/01/2024</p>
        </div>

        <nav class="profile-menu">
            <ul>
                <li><a href="#"><i class="fas fa-user"></i> Thông tin cá nhân</a></li>
                <li><a href="#"><i class="fas fa-map-marker-alt"></i> Địa chỉ của tôi</a></li>
                <li><a href="#"><i class="fas fa-clipboard-list"></i> Đơn hàng của tôi</a></li>
                <li class="active"><a href="#"><i class="fas fa-lock"></i> Đổi mật khẩu</a></li>
                <li><a href="#"><i class="fa fa-sign-out"></i> Đăng xuất</a></li>
            </ul>
        </nav>
    </div>

    <div class="profile-content">
        <h2>Đổi mật khẩu</h2>

        <form class="profile-form">
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
                <button type="button" class="btn-save">Lưu mật khẩu</button>
            </div>
        </form>

        <p style="color: red; display: none;">Mật khẩu hiện tại không đúng</p>
    </div>
</section>

<!-- ========== FOOTER ========== -->
<%@ include file="../include/footer.jsp" %>

</body>
</html>
